;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname mythos) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define PROPORTION 0.1)
(define RESOLUTION (* 256 PROPORTION))
(define CENTER (make-posn (/ RESOLUTION 2) (/ RESOLUTION 2)))
(define MAX-HEALTH 8)
(define EMPTY (empty-scene RESOLUTION RESOLUTION))

;;Data Structures

;A Mythos has two frames and the position of the center and represents the enemies
(define-struct mythos [frame1 frame2 center])

;A Monster has a number, a type and a position
(define-struct monster [number type pos])

;A Barrier has eight frames and the position of the center
(define-struct barrier [frame1
                        frame2
                        frame3
                        frame4
                        frame5
                        frame6
                        frame7
                        frame8
                        center
                        pos])

;The player has one frame and the position of the center
(define-struct player [frame center pos])

;The background has one frame, the width and height and the position of the center
(define-struct background [frame size center])

;The shoot has one frame, the width and height and the position of the center
(define-struct shoot [frame size center pos])

;Each model type of monster is defined, using make-struct
(define CTHULHU (make-mythos (scale PROPORTION (bitmap "sprites/Cthulhu-1.png"))
                             (scale PROPORTION (bitmap "sprites/Cthulhu-2.png"))
                             CENTER))
(define BROWN-JENKIN (make-mythos (scale PROPORTION (bitmap "sprites/Brown Jenkin-1.png"))
                             (scale PROPORTION (bitmap "sprites/Brown Jenkin-2.png"))
                             CENTER))
(define DAGON (make-mythos (scale PROPORTION (bitmap "sprites/Dagon-1.png"))
                             (scale PROPORTION (bitmap "sprites/Dagon-2.png"))
                             CENTER))
(define KASSOGHTA (make-mythos (scale PROPORTION (bitmap "sprites/Kassoghta-1.png"))
                             (scale PROPORTION (bitmap "sprites/Kassoghta-2.png"))
                             CENTER))
(define NYARLATHOTEP (make-mythos (scale PROPORTION (bitmap "sprites/Nyarlathotep-1.png"))
                             (scale PROPORTION (bitmap "sprites/Nyarlathotep-2.png"))
                             CENTER))
(define SHUB-NIGGURATH (make-mythos (scale PROPORTION (bitmap "sprites/Shub-Niggurath-1.png"))
                             (scale PROPORTION (bitmap "sprites/Shub-Niggurath-2.png"))
                             CENTER))

;The barrier model is defined, using make-struct
(define HOLY-WATER (make-barrier (scale PROPORTION (bitmap "sprites/Agua Benta-1.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-2.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-3.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-4.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-5.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-6.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-7.png"))
                                 (scale PROPORTION (bitmap "sprites/Agua Benta-8.png"))
                                 CENTER
                                 (make-posn 0 0)))

;The player model is defined, using make-struct
(define NECRONOMICON (make-player (scale PROPORTION (bitmap "sprites/Necronomicon.png"))
                                  (make-posn (/ (* (image-width (bitmap "sprites/Necronomicon.png")) PROPORTION) 2)
                                             (/ (* (image-height (bitmap "sprites/Necronomicon.png")) PROPORTION) 2))
                                  (make-posn 0 0)))

;The background model is defined, using make-struct
(define SCENE (make-background (scale PROPORTION (bitmap "sprites/Background2.png"))
                               (make-posn (* (image-width (bitmap "sprites/Background2.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Background2.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Background2.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Background2.png")) PROPORTION) 2))))

;The shoot model is defined, using make-struct
(define PROJECTILE (make-shoot (scale PROPORTION (bitmap "sprites/Tiro.png"))
                               (make-posn (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION) 2))
                               (make-posn 0 0)))

;Function to define initial position
;Number -> Posn
;(define (initial-posn number))
(define (initial-posn number)
  (make-posn (+ (* 2 RESOLUTION) (posn-x CENTER) (* 2 (/ number 6) RESOLUTION))
             (+ (* 2 RESOLUTION) (posn-y CENTER) (* 2 (remainder number 6) RESOLUTION))))

;All the monsters are defined
(define MONSTER-1-1 (make-monster 0 NYARLATHOTEP (initial-posn 0)))
(define MONSTER-1-2 (make-monster 1 NYARLATHOTEP (initial-posn 1)))
(define MONSTER-1-3 (make-monster 2 NYARLATHOTEP (initial-posn 2)))
(define MONSTER-1-4 (make-monster 3 NYARLATHOTEP (initial-posn 3)))
(define MONSTER-1-5 (make-monster 4 NYARLATHOTEP (initial-posn 4)))
(define MONSTER-1-6 (make-monster 5 NYARLATHOTEP (initial-posn 5)))

;Key, Player -> Shoot
;Given a key and a player, test if the key pressed is space
(define (test-shoot key player)
  (if (key? key "space") (place-shoot player) 0))

;Shoot, Mythos -> Boolean
;Given a Shoot, test if some monster was hit
;(define (shoot-hit? shoot monster)
(define (shoot-hit? shoot monster)
  (and (<= (- (posn-x (monster-pos monster)) (posn-x (mythos-center (monster-type monster))))
               (posn-x (shoot-pos shoot))
               (+ (posn-x (monster-pos monster)) (posn-x (mythos-center (monster-type monster)))))
           (<= (- (posn-y (monster-pos monster)) (posn-y (mythos-center (monster-type monster))))
               (posn-y (shoot-pos shoot))
               (+ (posn-y (monster-pos monster)) (posn-y (mythos-center (monster-type monster)))))))

;Shoot, Mythos-List -> Boolean-List
;Given a Shoot, returns a list with the monsters who have died
(define (died-monsters-after-shoot shoot list)
  (map (λ (list) (shoot-hit? shoot list)) list))

;Mythos Image -> Image
;Renders the mythos
(define (render-single-monster monster img)
  (overlay/offset (mythos-frame1 (monster-type monster))
                  (- (posn-x (monster-pos monster)) (posn-x (background-center SCENE)))
                  (- (posn-y (monster-pos monster)) (posn-y (background-center SCENE)))
                  img))