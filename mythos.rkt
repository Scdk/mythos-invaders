;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname mythos) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define PROPORTION 0.2)
(define RESOLUTION 256)
(define CENTER (make-posn (/ (* RESOLUTION PROPORTION) 2) (/ (* RESOLUTION PROPORTION) 2)))
(define MAX-HEALTH 8)
(define EMPTY (empty-scene (* RESOLUTION PROPORTION) (* RESOLUTION PROPORTION)))

;;Data Structures

;A Mythos has two frames and the position of the center and represents the enemies
(define-struct mythos [frame1 frame2 center pos])

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
                             CENTER
                             (make-posn 0 0)))
(define BROWN-JENKIN (make-mythos (scale PROPORTION (bitmap "sprites/Brown Jenkin-1.png"))
                             (scale PROPORTION (bitmap "sprites/Brown Jenkin-2.png"))
                             CENTER
                             (make-posn 0 0)))
(define DAGON (make-mythos (scale PROPORTION (bitmap "sprites/Dagon-1.png"))
                             (scale PROPORTION (bitmap "sprites/Dagon-2.png"))
                             CENTER
                             (make-posn 0 0)))
(define KASSOGHTA (make-mythos (scale PROPORTION (bitmap "sprites/Kassoghta-1.png"))
                             (scale PROPORTION (bitmap "sprites/Kassoghta-2.png"))
                             CENTER
                             (make-posn 0 0)))
(define NYARLATHOTEP (make-mythos (scale PROPORTION (bitmap "sprites/Nyarlathotep-1.png"))
                             (scale PROPORTION (bitmap "sprites/Nyarlathotep-2.png"))
                             CENTER
                             (make-posn 0 0)))
(define SHUB-NIGGURATH (make-mythos (scale PROPORTION (bitmap "sprites/Shub-Niggurath-1.png"))
                             (scale PROPORTION (bitmap "sprites/Shub-Niggurath-2.png"))
                             CENTER
                             (make-posn 0 0)))

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

;Shoot, Mythos -> Boolean
;Given a Shoot, test if some monster was hit
;(define (shoot-hit? shoot monster)
(define (shoot-hit? shoot monster)
  (and (<= (- (posn-x (mythos-pos monster)) (posn-x (mythos-center monster)))
               (posn-x (shoot-pos shoot))
               (+ (posn-x (mythos-pos monster)) (posn-x (mythos-center monster))))
           (<= (- (posn-y (mythos-pos monster)) (posn-y (mythos-center monster)))
               (posn-y (shoot-pos shoot))
               (+ (posn-y (mythos-pos monster)) (posn-y (mythos-center monster))))))

;Shoot, Mythos-List -> Boolean-List
;Given a Shoot, returns a list with the monsters who have died
(define (died-monsters-after-shoot shoot list)
  (map (λ (list) (shoot-hit? shoot list)) list))

;Mythos -> Image
;Renders the mythos
(define (render-mythos mythos)
  (place-image (mythos-frame1 mythos) (posn-x (mythos-pos mythos)) (posn-y (mythos-pos mythos)) (background-frame SCENE)))