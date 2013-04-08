{- | additional parameters: none

A version with RAND instead of RANDI sounds very different! The noise quality is brighter.
-}
module PitchedDrum2 where

import Csound.Base
import PitchedDrum1(notes)

envOsc :: Tab -> Tab -> Cps -> Sig
envOsc env wave cps = once env * oscBy wave cps

baseInstr :: (D, D, D, D, D) -> SE Sig
baseInstr (amp7, fq1, amp2, amp4, fq5) = do
    r <- rand (kr amp7)
    return $ mean $ zipWith (*) [r, kr amp4, kr amp2] $ 
        zipWith3 envOsc [f52, f52, f51] [f11, f13, f12] (fmap kr [fq5, fq1, fq1])  
    where f51 = guardPoint $ eexps [4096, 1]
          f52 = guardPoint $ eexps [256, 1]  

          f11 = sine
          f12 = partials [10]  
          f13 = partials [10, 16, 22, 23]  

instr :: (D, D) -> SE Sig
instr (amp, cps) = baseInstr (amp, cps, 0.8 * amp, 0.1 * cps, 0.3 * amp)

res = sco instr notes

main = writeCsd "tmp.csd" res


