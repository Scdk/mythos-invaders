;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname mythos) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define PROPORTION 0.06)
(define RESOLUTION (* 256 PROPORTION))
(define CENTER (make-posn (/ RESOLUTION 2) (/ RESOLUTION 2)))
(define MAX-HEALTH 8)
(define EMPTY empty-image)

;A Mythos has two frames and the position of the center and represents the enemies
(define-struct mythos [frame1 frame2 center])

;A Monster has a number, a type and a position
(define-struct monster [number type pos life])

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
                        pos
                        life])

;The player has one frame and the position of the center
(define-struct player [frame center pos life])

;The background has one frame, the width and height and the position of the center
(define-struct background [frame size center])

;The shoot has one frame, the width and height and the position of the center
(define-struct shoot [frame size center pos life])

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
(define DEAD-MONSTER (make-mythos EMPTY EMPTY CENTER))

;The background model is defined, using make-struct
(define SCENE (make-background (scale PROPORTION (bitmap "sprites/Background2.png"))
                               (make-posn (* (image-width (bitmap "sprites/Background2.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Background2.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Background2.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Background2.png")) PROPORTION) 2))))

;The player model is defined, using make-struct
(define NECRONOMICON (make-player (scale PROPORTION (bitmap "sprites/Necronomicon.png"))
                                  (make-posn (/ (* (image-width (bitmap "sprites/Necronomicon.png")) PROPORTION) 2)
                                             (/ (* (image-height (bitmap "sprites/Necronomicon.png")) PROPORTION) 2))
                                  (make-posn (posn-x (background-center SCENE)) (- (posn-y (background-size SCENE)) RESOLUTION))
                                  1))

;The barrier model is defined, using make-struct
(define HOLY-WATER-1 (make-barrier (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-1.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-2.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-3.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-4.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-5.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-6.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-7.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-8.png"))
                                 CENTER
                                 (make-posn 0 (posn-y (background-size SCENE)))
                                 MAX-HEALTH))
(define HOLY-WATER-2 (make-barrier (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-1.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-2.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-3.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-4.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-5.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-6.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-7.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-8.png"))
                                 CENTER
                                 (make-posn (posn-x (background-center SCENE)) (posn-y (background-size SCENE)))
                                 MAX-HEALTH))
(define HOLY-WATER-3 (make-barrier (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-1.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-2.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-3.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-4.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-5.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-6.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-7.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-8.png"))
                                 CENTER
                                 (make-posn (posn-x (background-size SCENE)) (posn-y (background-size SCENE)))
                                 MAX-HEALTH))
(define BARRIERS-LIST (list HOLY-WATER-1 HOLY-WATER-2 HOLY-WATER-3))

;The shoot model is defined, using make-struct
(define PLAYER-SHOOT (make-shoot (scale PROPORTION (bitmap "sprites/Tiro.png"))
                               (make-posn (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION) 2))
                               (make-posn 0 0)
                               0))
(define ENEMY-SHOOT-1 (make-shoot (scale PROPORTION (bitmap "sprites/Shoot2.png"))
                               (make-posn (* (image-width (bitmap "sprites/Shoot2.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Shoot2.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Shoot2.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Shoot2.png")) PROPORTION) 2))
                               (make-posn 0 0)
                               0))
(define ENEMY-SHOOT-2 (make-shoot (scale PROPORTION (bitmap "sprites/Shoot2.png"))
                               (make-posn (* (image-width (bitmap "sprites/Shoot2.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Shoot2.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Shoot2.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Shoot2.png")) PROPORTION) 2))
                               (make-posn 0 0)
                               0))
(define ENEMY-SHOOT-3 (make-shoot (scale PROPORTION (bitmap "sprites/Shoot2.png"))
                               (make-posn (* (image-width (bitmap "sprites/Shoot2.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Shoot2.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Shoot2.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Shoot2.png")) PROPORTION) 2))
                               (make-posn 0 0)
                               0))

;Function to define initial position
;Number -> Posn
;(define (initial-posn number))
(define (initial-posn number)
  (make-posn (+ (* 2 RESOLUTION) (posn-x CENTER) (* 2 (remainder number 6) RESOLUTION))
             (+ (* 2 RESOLUTION) (posn-y CENTER) (* 2 (quotient number 6) (+ (posn-y CENTER) (* 64 PROPORTION))))))

;All the monsters are defined
(define MONSTER-1-1 (make-monster 0 NYARLATHOTEP (initial-posn 0) 1))
(define MONSTER-1-2 (make-monster 1 NYARLATHOTEP (initial-posn 1) 1))
(define MONSTER-1-3 (make-monster 2 NYARLATHOTEP (initial-posn 2) 1))
(define MONSTER-1-4 (make-monster 3 NYARLATHOTEP (initial-posn 3) 1))
(define MONSTER-1-5 (make-monster 4 NYARLATHOTEP (initial-posn 4) 1))
(define MONSTER-1-6 (make-monster 5 NYARLATHOTEP (initial-posn 5) 1))
(define MONSTER-2-1 (make-monster 6 DAGON (initial-posn 6) 1))
(define MONSTER-2-2 (make-monster 7 DAGON (initial-posn 7) 1))
(define MONSTER-2-3 (make-monster 8 DAGON (initial-posn 8) 1))
(define MONSTER-2-4 (make-monster 9 DAGON (initial-posn 9) 1))
(define MONSTER-2-5 (make-monster 10 DAGON (initial-posn 10) 1))
(define MONSTER-2-6 (make-monster 11 DAGON (initial-posn 11) 1))
(define MONSTER-3-1 (make-monster 12 SHUB-NIGGURATH (initial-posn 12) 1))
(define MONSTER-3-2 (make-monster 13 SHUB-NIGGURATH (initial-posn 13) 1))
(define MONSTER-3-3 (make-monster 14 SHUB-NIGGURATH (initial-posn 14) 1))
(define MONSTER-3-4 (make-monster 15 SHUB-NIGGURATH (initial-posn 15) 1))
(define MONSTER-3-5 (make-monster 16 SHUB-NIGGURATH (initial-posn 16) 1))
(define MONSTER-3-6 (make-monster 17 SHUB-NIGGURATH (initial-posn 17) 1))
(define MONSTER-4-1 (make-monster 18 KASSOGHTA (initial-posn 18) 1))
(define MONSTER-4-2 (make-monster 19 KASSOGHTA (initial-posn 19) 1))
(define MONSTER-4-3 (make-monster 20 KASSOGHTA (initial-posn 20) 1))
(define MONSTER-4-4 (make-monster 21 KASSOGHTA (initial-posn 21) 1))
(define MONSTER-4-5 (make-monster 22 KASSOGHTA (initial-posn 22) 1))
(define MONSTER-4-6 (make-monster 23 KASSOGHTA (initial-posn 23) 1))
(define MONSTER-5-1 (make-monster 24 BROWN-JENKIN (initial-posn 24) 1))
(define MONSTER-5-2 (make-monster 25 BROWN-JENKIN (initial-posn 25) 1))
(define MONSTER-5-3 (make-monster 26 BROWN-JENKIN (initial-posn 26) 1))
(define MONSTER-5-4 (make-monster 27 BROWN-JENKIN (initial-posn 27) 1))
(define MONSTER-5-5 (make-monster 28 BROWN-JENKIN (initial-posn 28) 1))
(define MONSTER-5-6 (make-monster 29 BROWN-JENKIN (initial-posn 29) 1))
(define BOSS (make-monster 30 CTHULHU (make-posn (posn-x CENTER) RESOLUTION) 1))
(define DEAD (make-monster 31 DEAD-MONSTER (make-posn (posn-x CENTER) 0) 1))
(define MONSTERS-LIST (list MONSTER-1-1 MONSTER-1-2 MONSTER-1-3 MONSTER-1-4 MONSTER-1-5 MONSTER-1-6
                            MONSTER-2-1 MONSTER-2-2 MONSTER-2-3 MONSTER-2-4 MONSTER-2-5 MONSTER-2-6
                            MONSTER-3-1 MONSTER-3-2 MONSTER-3-3 MONSTER-3-4 MONSTER-3-5 MONSTER-3-6
                            MONSTER-4-1 MONSTER-4-2 MONSTER-4-3 MONSTER-4-4 MONSTER-4-5 MONSTER-4-6
                            MONSTER-5-1 MONSTER-5-2 MONSTER-5-3 MONSTER-5-4 MONSTER-5-5 MONSTER-5-6
                            BOSS))

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
  (map (λ (monster) (shoot-hit? shoot monster)) list))

;WorldState Mythos Image -> Image
;Renders a mythos
(define (render-single-monster ws monster img)
  (overlay/offset (if (= (monster-life monster) 0) EMPTY
                       (if (zero? (remainder ws 2))
                           (mythos-frame1 (monster-type monster))
                           (mythos-frame2 (monster-type monster))))
                  (- (posn-x (background-center SCENE)) (posn-x (monster-pos monster)))
                  (- (posn-y (background-center SCENE)) (posn-y (monster-pos monster)))
                  img))

;List WorldState -> Image
;Renders all mythos
(define (render-all-monsters list ws)
  (if (empty? list)
      (render-single-monster ws DEAD (background-frame SCENE))
      (render-single-monster ws (car list) (render-all-monsters (cdr list) ws))))

;Barrier -> Image
;Renders a barrier
(define (render-single-barrier barrier img)
  (overlay/offset (cond
                    ([equal? (barrier-life barrier) 8] (barrier-frame8 barrier))
                    ([equal? (barrier-life barrier) 7] (barrier-frame7 barrier))
                    ([equal? (barrier-life barrier) 6] (barrier-frame6 barrier))
                    ([equal? (barrier-life barrier) 5] (barrier-frame5 barrier))
                    ([equal? (barrier-life barrier) 4] (barrier-frame4 barrier))
                    ([equal? (barrier-life barrier) 3] (barrier-frame3 barrier))
                    ([equal? (barrier-life barrier) 2] (barrier-frame2 barrier))
                    ([equal? (barrier-life barrier) 1] (barrier-frame1 barrier))
                    (else EMPTY))
                  (- (posn-x (background-center SCENE)) (posn-x (barrier-pos barrier)))
                  (- (posn-y (background-center SCENE)) (posn-y (barrier-pos barrier)))
                  img))

;List -> Image
;Renders all barriers
(define (render-all-barriers list img)
  (overlay (apply overlay (map (λ (barrier) (render-single-barrier barrier empty-image)) list))
           img))

;Image -> Image
;Renders the player
(define (render-player img)
  (overlay/offset (if (zero? (player-life NECRONOMICON)) EMPTY (player-frame NECRONOMICON))
                  (- (posn-x (background-center SCENE)) (posn-x (player-pos NECRONOMICON)))
                  (- (posn-y (background-center SCENE)) (posn-y (player-pos NECRONOMICON)))
                  img))

;WorldState -> Image
;Renders the player and the mythos
(define (render-player-enemy ws)
   (render-player (render-all-monsters MONSTERS-LIST ws)))

;WorldState -> Image
;Renders the player, the mythos and the barriers
(define (render-player-enemy-barrier ws)
   (render-all-barriers BARRIERS-LIST (render-player (render-all-monsters MONSTERS-LIST ws))))

;Shoot -> Image
;Renders a shoot
(define (render-shoot shoot img)
  (overlay/offset (if (zero? (shoot-life shoot)) EMPTY (shoot-frame shoot))
                  (- (posn-x (background-center SCENE)) (posn-x (shoot-pos shoot)))
                  (- (posn-y (background-center SCENE)) (posn-y (shoot-pos shoot)))
                  img))

;WorldState -> Image
;Renders the player, the mythos, the barriers and the shoots
(define (render-player-enemy-barrier-shoot ws)
  (render-shoot ENEMY-SHOOT-1
                (render-shoot ENEMY-SHOOT-2
                              (render-shoot ENEMY-SHOOT-3
                                            (render-shoot PLAYER-SHOOT
                                                          (render-all-barriers BARRIERS-LIST
                                                                               (render-player
                                                                               (render-all-monsters MONSTERS-LIST ws))))))))