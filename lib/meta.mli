module type S =
sig
  type 'a t

  val ( <$> ) : ('a, 'b) Bijection.texn -> 'a t -> 'b t
  val ( <*> ) : 'a t -> 'b t -> ('a * 'b) t
  val ( <|> ) : 'a t -> 'a t -> 'a t

  val ( *> )  : unit t -> 'a t -> 'a t
  val ( <* )  : 'a t -> unit t -> 'a t

  val ( $> )  : unit t -> (unit, 'a) Bijection.texn -> 'a t
  val ( <$ )  : 'a t -> (unit, 'a) Bijection.texn -> unit t

  val fix     : ('a t -> 'a t) -> 'a t
  val nop     : unit t
  val fail    : string -> 'a t
  val pure    : compare:('a -> 'a -> int) -> 'a -> 'a t
  val skip    : 'a t -> unit t
  val take    : int -> string t
  val char    : char t

  val satisfy : (char -> bool) -> char t
  val string  : string -> string t

  val while0  : (char -> bool) -> string t
  val while1  : (char -> bool) -> string t
  val bwhile0 : (char -> bool) -> Encoder.bigstring t
  val bwhile1 : (char -> bool) -> Encoder.bigstring t

  module Option:
  sig
    val (<$>) : ('a, 'b) Bijection.topt -> 'a t -> 'b t
    val ( $>) : unit t -> (unit, 'a) Bijection.topt -> 'a t
    val (<$ ) : 'a t -> (unit, 'a) Bijection.topt -> unit t
  end
end

module type T =
sig
  include S

  val sequence: 'a t list -> 'a list t
  val choice: 'a t list -> 'a t
  val option: 'a t -> 'a option t
  val between: unit t -> unit t -> 'a t -> 'a t

  val count: int -> 'a t -> 'a list t
  val rep0: 'a t -> 'a list t
  val rep1: 'a t -> 'a list t
  val sep_by0: sep:unit t -> 'a t -> 'a list t
  val sep_by1: sep:unit t -> 'a t -> 'a list t
  val end_by1: sep:unit t -> 'a t -> 'a list t
  val sep_end_by0: sep:unit t -> 'a t -> 'a list t
  val sep_end_by1: sep:unit t -> 'a t -> 'a list t

  val lower: char t
  val upper: char t
  val alpha: char t
  val digit: char t
end

module Make (S: S): T with type 'a t = 'a S.t
