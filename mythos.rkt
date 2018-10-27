;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname mythos) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/universe)
(require 2htdp/image)
                 
(define PROPORTION 0.125)
(define RESOLUTION (* 256 PROPORTION))
(define CENTER (make-posn (/ RESOLUTION 2) (/ RESOLUTION 2)))
(define MAX-HEALTH 8)
(define EMPTY empty-image)
(define EMPTY-BKG (scale PROPORTION (bitmap "sprites/Empty-Background.png")))
(define PLAYER-MOVEMENT (* 40 PROPORTION))
(define PLAYER-LOWER-LIMIT (* RESOLUTION 3))
(define PLAYER-HIGHER-LIMIT (* RESOLUTION 12))
(define MENU (scale PROPORTION (bitmap "sprites/Title-Screen.png")))
(define SCORE 0)
(define BIT-8-RED (make-color 82 16 0))
(define DEATH-FRAME (scale PROPORTION (bitmap "sprites/Death.png")))
(define GAME-OVER #f)
(define RENDER-DEATH-FRAME -1)

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
(define DEAD-MONSTER (make-mythos empty-image empty-image CENTER))

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

;The barriers are defined, using make-struct
(define HOLY-WATER-1 (make-barrier (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-1.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-2.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-3.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-4.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-5.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-6.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-7.png"))
                                 (scale (* 1.25 PROPORTION) (bitmap "sprites/Agua Benta-8.png"))
                                 CENTER
                                 (make-posn PLAYER-LOWER-LIMIT (- (posn-y (background-size SCENE)) (* 3.5 RESOLUTION)))
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
                                 (make-posn (posn-x (background-center SCENE)) (- (posn-y (background-size SCENE)) (* 3.5 RESOLUTION)))
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
                                 (make-posn PLAYER-HIGHER-LIMIT (- (posn-y (background-size SCENE)) (* 3.5 RESOLUTION)))
                                 MAX-HEALTH))
(define BARRIERS-LIST (list HOLY-WATER-1 HOLY-WATER-2 HOLY-WATER-3))

;The shoots are defined, using make-struct
(define PLAYER-SHOOT-1 (make-shoot (scale PROPORTION (bitmap "sprites/Tiro.png"))
                               (make-posn (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION) 2))
                               (make-posn 0 0)
                               0))
(define PLAYER-SHOOT-2 (make-shoot (scale PROPORTION (bitmap "sprites/Tiro.png"))
                               (make-posn (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION)
                                          (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION))
                               (make-posn (/ (* (image-width (bitmap "sprites/Tiro.png")) PROPORTION) 2)
                                          (/ (* (image-height (bitmap "sprites/Tiro.png")) PROPORTION) 2))
                               (make-posn 0 0)
                               0))
(define PLAYER-SHOOT-3 (make-shoot (scale PROPORTION (bitmap "sprites/Tiro.png"))
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
(define PLAYER-SHOOTS (list PLAYER-SHOOT-1 PLAYER-SHOOT-2 PLAYER-SHOOT-3))
(define ENEMY-SHOOTS (list ENEMY-SHOOT-1 ENEMY-SHOOT-2 ENEMY-SHOOT-3))

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
(define BOSS (make-monster 30 CTHULHU (make-posn (posn-x CENTER) RESOLUTION) 0))
(define DEAD (make-monster 31 DEAD-MONSTER (make-posn (posn-x CENTER) 0) 1))
(define MONSTERS-LIST (list MONSTER-1-1 MONSTER-1-2 MONSTER-1-3 MONSTER-1-4 MONSTER-1-5 MONSTER-1-6
                            MONSTER-2-1 MONSTER-2-2 MONSTER-2-3 MONSTER-2-4 MONSTER-2-5 MONSTER-2-6
                            MONSTER-3-1 MONSTER-3-2 MONSTER-3-3 MONSTER-3-4 MONSTER-3-5 MONSTER-3-6
                            MONSTER-4-1 MONSTER-4-2 MONSTER-4-3 MONSTER-4-4 MONSTER-4-5 MONSTER-4-6
                            MONSTER-5-1 MONSTER-5-2 MONSTER-5-3 MONSTER-5-4 MONSTER-5-5 MONSTER-5-6
                            BOSS))
(define SHOOTING-MONSTERS (list MONSTER-5-1 MONSTER-5-2 MONSTER-5-3 MONSTER-5-4 MONSTER-5-5 MONSTER-5-6))

;Key, Player -> Number
;Given a WorldState and a key, test what key it is, if it is space calls test-space, if not calls move-player
(define (test-key ws key)
  (cond
    [(key=? key " ") (test-space ws)]
    [else (move-player ws key)]))

;Key, WorldState -> Number
;Given the WorldState, checks if the game is paused, if it is, it begins the game, if not the player shoots
(define (test-space ws)
  (cond
    [(equal? ws 0) (add1 ws)]
    [(= ws -1) (begin (set! GAME-OVER #t) ws)]
    [else (cond
            [(equal? (shoot-life PLAYER-SHOOT-1) 0) (begin
                                                      (set-shoot-life! PLAYER-SHOOT-1 1)
                                                      (set-shoot-pos! PLAYER-SHOOT-1 (make-posn (posn-x (player-pos NECRONOMICON))
                                                                                                (posn-y (player-pos NECRONOMICON)))) ws)]
            [(equal? (shoot-life PLAYER-SHOOT-2) 0) (begin
                                                      (set-shoot-life! PLAYER-SHOOT-2  1)
                                                      (set-shoot-pos! PLAYER-SHOOT-2 (make-posn (posn-x (player-pos NECRONOMICON))
                                                                                                (posn-y (player-pos NECRONOMICON)))) ws)]
            [(equal? (shoot-life PLAYER-SHOOT-3) 0) (begin
                                                      (set-shoot-life! PLAYER-SHOOT-3  1)
                                                      (set-shoot-pos! PLAYER-SHOOT-3 (make-posn (posn-x (player-pos NECRONOMICON))
                                                                                                (posn-y (player-pos NECRONOMICON)))) ws)]
            [else ws])]))

;Key -> Number
;Given WorldState and key, checks if the key is left or right and move the player according
(define (move-player ws key)
  (cond
        [(key=? key "left")
         (if (< PLAYER-LOWER-LIMIT (posn-x (player-pos NECRONOMICON)))
             (begin
               (set-player-pos! NECRONOMICON (make-posn (- (posn-x (player-pos NECRONOMICON)) PLAYER-MOVEMENT) (posn-y (player-pos NECRONOMICON))))
               ws)
             ws)]
        [(key=? key "right")
         (if (< (posn-x (player-pos NECRONOMICON)) PLAYER-HIGHER-LIMIT)
             (begin
               (set-player-pos! NECRONOMICON (make-posn (+ (posn-x (player-pos NECRONOMICON)) PLAYER-MOVEMENT) (posn-y (player-pos NECRONOMICON))))
               ws)
             ws)]
        [else ws]))

;WorldState -> WorldState
(define (monster-shoot ws)
  (if (zero? (remainder ws 2))
      (let ([monster (list-ref SHOOTING-MONSTERS (random 6))])
        (if (= (monster-number monster) 31)
            ws
            (cond
              [(equal? (shoot-life ENEMY-SHOOT-1) 0) (begin
                                                       (set-shoot-life! ENEMY-SHOOT-1  1)
                                                       (set-shoot-pos! ENEMY-SHOOT-1 (make-posn (posn-x (monster-pos monster))
                                                                                                (posn-y (monster-pos monster))))ws)]
              [(equal? (shoot-life ENEMY-SHOOT-2) 0) (begin
                                                       (set-shoot-life! ENEMY-SHOOT-2  1)
                                                       (set-shoot-pos! ENEMY-SHOOT-2 (make-posn (posn-x (monster-pos monster))
                                                                                                (posn-y (monster-pos monster))))ws)]
              [(equal? (shoot-life ENEMY-SHOOT-3) 0) (begin
                                                       (set-shoot-life! ENEMY-SHOOT-3  1)
                                                       (set-shoot-pos! ENEMY-SHOOT-3 (make-posn (posn-x (monster-pos monster))
                                                                                                (posn-y (monster-pos monster))))ws)]
              [else ws])))
      ws))

;WorldState Mythos Image -> Image
;Renders a mythos
(define (render-single-monster ws monster img)
  (overlay/offset (if (= (monster-life monster) 0) EMPTY
                       (if (> (remainder ws 20) 9)
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

;Barrier-List Image -> Image
;Auxiliar function for render barrier
(define (render-barrier-aux list img)
  (if (empty? list)
      img
      (place-image (cond
                     ([equal? (barrier-life (car list)) 8] (barrier-frame8 (car list)))
                     ([equal? (barrier-life (car list)) 7] (barrier-frame7 (car list)))
                     ([equal? (barrier-life (car list)) 6] (barrier-frame6 (car list)))
                     ([equal? (barrier-life (car list)) 5] (barrier-frame5 (car list)))
                     ([equal? (barrier-life (car list)) 4] (barrier-frame4 (car list)))
                     ([equal? (barrier-life (car list)) 3] (barrier-frame3 (car list)))
                     ([equal? (barrier-life (car list)) 2] (barrier-frame2 (car list)))
                     ([equal? (barrier-life (car list)) 1] (barrier-frame1 (car list)))
                     (else EMPTY))
                   (posn-x (barrier-pos (car list)))
                   (posn-y (barrier-pos (car list)))
                   (render-barrier-aux (cdr list) img))))

;List -> Image
;Renders all barriers
(define (render-all-barriers img)
  (render-barrier-aux BARRIERS-LIST img))

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

;Shoot-List Image -> Image
;Auxiliar function for render shoot
(define (render-shoot-aux list img)
    (if (empty? list)
        img
        (place-image (if (zero? (shoot-life (car list))) EMPTY (shoot-frame (car list)))
                     (posn-x (shoot-pos (car list)))
                     (posn-y (shoot-pos (car list)))
                     (render-shoot-aux (cdr list) img))))

;Shoot -> Image
;Renders a shoot
(define (render-all-shoots img)
  (render-shoot-aux (append PLAYER-SHOOTS ENEMY-SHOOTS) img))

;WorldState -> Image
;Renders the player, the mythos, the barriers and the shoots
(define (render-player-enemy-barrier-shoot ws)
  (render-all-shoots (render-all-barriers (render-player (render-all-monsters MONSTERS-LIST ws)))))

;WorldState -> Image
;Renders all, including the score
(define (render ws)
  (if (zero? ws) MENU 
      (if (zero? (monster-life BOSS))
          (overlay/offset (text (number->string SCORE) (* 1.25 RESOLUTION) BIT-8-RED)
                          (- (posn-x (background-center SCENE)) (+ RESOLUTION
                                                                   (/ (image-width (text (number->string SCORE)
                                                                                         (* 1.25 RESOLUTION) "White")) 2)))
                          (- (posn-y (background-center SCENE)) RESOLUTION)
                          (render-player-enemy-barrier-shoot ws))
          (render-player-enemy-barrier-shoot ws))))

;WorldState -> Image
;Render the death frame
(define (render-all ws)
  (if (= ws -1)
      (overlay (overlay/align/offset "middle" "middle"
                                     (text "GAME OVER" (* 1.25 RESOLUTION) BIT-8-RED)
                                     0 (* 2 RESOLUTION)
                                     (text (number->string SCORE) (* 1.25 RESOLUTION) BIT-8-RED))
               EMPTY-BKG)
      (if (> RENDER-DEATH-FRAME -1)
          (begin0
            (render-death-frame ws (list-ref MONSTERS-LIST RENDER-DEATH-FRAME))
            (set! RENDER-DEATH-FRAME -1))
          (render ws))))

;Monster -> Image
;Renders the death of a monster
(define (render-death-frame ws monster)
  (place-image DEATH-FRAME
               (posn-x (monster-pos monster))
               (posn-y (monster-pos monster))
               (render ws)))

;Number -> Void
;Set the score value to given number
(define (scoreboard number)
        (set! SCORE (+ SCORE number)))

;Number -> Number
;Given a number of a monster, returns the equivalent score
(define (monster-score number)
        (cond
          [(<= 0 number 5) (scoreboard 40)]
          [(<= 6 number 17) (scoreboard 20)]
          [(<= 18 number 29) (scoreboard 10)]))

;Monster -> Void
;Adds a new monster to the shooting list
(define (add-new-shooting-monster monster-bottom)
  (cond
    ([< (monster-number monster-bottom) 6]
     (set! SHOOTING-MONSTERS (append SHOOTING-MONSTERS (cons DEAD empty))))
    ([zero? (monster-life (list-ref MONSTERS-LIST (- (monster-number monster-bottom) 6)))]
     (add-new-shooting-monster (list-ref MONSTERS-LIST (- (monster-number monster-bottom) 6))))
    (else (set! SHOOTING-MONSTERS (append SHOOTING-MONSTERS (cons (list-ref MONSTERS-LIST (- (monster-number monster-bottom) 6)) empty))))))

;Monster -> Void
;Remove monster from list if was hit
(define (remove-monster-from-shooting-list monster)
  (if (empty? (filter (λ (monster-a) (equal? monster monster-a)) SHOOTING-MONSTERS))
      (void)
      (begin
        (set! SHOOTING-MONSTERS (remove monster SHOOTING-MONSTERS))
        (add-new-shooting-monster monster)))) ; <------------------------------------------------------------------------------------------------------ CORRIGIR, MONSTROS MORTOS ESTÃO ATIRANDO

;WorldState, Shoot, Monster -> Void
;Auxiliar function for monster hit 
(define (shoot-hit-monster-aux ws shoot monster)
  (if (zero? (shoot-life shoot))
      (void)
      (if (zero? (monster-life monster))
          (void)
          (if (and
               (<= (- (posn-x (monster-pos monster)) (posn-x (mythos-center (monster-type monster))))
                   (posn-x (shoot-pos shoot))
                   (+ (posn-x (monster-pos monster)) (posn-x (mythos-center (monster-type monster)))))
               (<= (- (posn-y (monster-pos monster)) (posn-y (mythos-center (monster-type monster))))
                   (posn-y (shoot-pos shoot))
                   (+ (posn-y (monster-pos monster)) (posn-y (mythos-center (monster-type monster))))))
              (begin
                (set! RENDER-DEATH-FRAME (monster-number monster))
                (set-shoot-life! shoot 0)
                (set-monster-life! monster 0)
                (monster-score (monster-number monster))
                (remove-monster-from-shooting-list monster))
              (out-of-bounds shoot)))))

;Shoot, Mythos -> Void
;Given a Shoot, test if some monster was hit
(define (shoot-hit-monster ws shoot monster-list)
  (map (λ (monster) (shoot-hit-monster-aux ws shoot monster)) monster-list))

;Shoot, Player -> Boolean
;Given a Shoot, test if the player was hit
(define (shoot-hit-player ws shoot player)
  (if (zero? (shoot-life shoot))
      #f
      (if (and
           (<= (- (posn-x (player-pos player)) (posn-x (player-center player)))
               (posn-x (shoot-pos shoot))
               (+ (posn-x (player-pos player)) (posn-x (player-center player))))
           (<= (- (posn-y (player-pos player)) (posn-y (player-center player)))
               (posn-y (shoot-pos shoot))
               (+ (posn-y (player-pos player)) (posn-y (player-center player)))))
          #t
          (begin
            (out-of-bounds shoot)
            #f))))

;Shoot -> Void
;Set the shoot life to 0 if out of bounds
(define (out-of-bounds shoot)
  (if (or (< (posn-y (shoot-pos shoot)) 0)
          (> (posn-y (shoot-pos shoot)) (posn-y (background-size SCENE))))
      (set-shoot-life! shoot 0)
      (void)))

;Shoot, Mythos-List -> Void
;Given a Shoot, returns a list with the monsters who have died
(define (shoot-hit ws target)
  (if (player? target)
      (ormap (λ (shoot) (shoot-hit-player  ws shoot  target)) ENEMY-SHOOTS)
      (map (λ (shoot) (shoot-hit-monster ws shoot target)) PLAYER-SHOOTS)))

;Shoot Barrier -> Void
(define (shoot-hit-barrier-aux shoot barrier)
  (if (and (and (and
            (<= (- (posn-x (barrier-pos barrier)) (posn-x (barrier-center barrier)))
                (posn-x (shoot-pos shoot))
                (+ (posn-x (barrier-pos barrier)) (posn-x (barrier-center barrier))))
            (<= (- (posn-y (barrier-pos barrier)) (posn-y (barrier-center barrier)))
                (posn-y (shoot-pos shoot))
                (+ (posn-y (barrier-pos barrier)) (posn-y (barrier-center barrier)))))
           (> (shoot-life shoot) 0)) (> (barrier-life barrier) 0))
      (begin
        (set-barrier-life! barrier (sub1 (barrier-life barrier)))
        (set-shoot-life! shoot 0))
      (void)))

;Void -> Void
;Receives a Shoot calls the function that sees if every barrier was hit
(define (shoot-hit-barrier)
  (map (λ (shoot)
         (begin
           (shoot-hit-barrier-aux shoot HOLY-WATER-1)
           (shoot-hit-barrier-aux shoot HOLY-WATER-2)
           (shoot-hit-barrier-aux shoot HOLY-WATER-3)))
       (append PLAYER-SHOOTS ENEMY-SHOOTS)))

;Number Shoot -> Void
;Sets the position of the shoots
(define (move-shoots-aux y-move shoot)
  (if (zero? (shoot-life shoot))
      (void)
      (set-shoot-pos! shoot (make-posn (posn-x (shoot-pos shoot)) (+ (posn-y (shoot-pos shoot)) y-move)))))

;Number Shoot-List -> Void
;Moves all the shoots
(define (move-shoots y-move list)
  (map (λ (shoot) (move-shoots-aux y-move shoot)) list))

;WorldState -> WorldState
;At every tick, this function calls others functions and increments the worldstate
(define (tock ws)
  (cond
    ((= -1 ws) ws)
    ((zero? ws) ws)
    (else (begin
            (monster-shoot ws)
            (move-shoots (- 0 (* 40 PROPORTION)) PLAYER-SHOOTS)
            (move-shoots      (* 40 PROPORTION)  ENEMY-SHOOTS)
            (shoot-hit-barrier)
            (shoot-hit ws MONSTERS-LIST)
            (if (shoot-hit ws NECRONOMICON) -1 (add1 ws))))))

;WorldState -> Boolean
;End Game
(define (game-over? ws)
  GAME-OVER)

(define (main ws)
  (big-bang ws
    (on-tick tock)
    (to-draw render-all)
    (on-key test-key)
    (stop-when game-over?)))

(main 0)