-- Language extensions {{{
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UnicodeSyntax #-}
-- }}}

-- Imports {{{
import Data.Functor
import Data.Monoid

import System.Console.CmdTheLine
import System.Environment

import Visitor.Parallel.Adapter.Network
import Visitor.Parallel.Main
import Visitor.Utils.WordSum

import Visitor.Examples.Queens
-- }}}

main =
    mainForExploreTree
        driver
        (getBoardSize <$> required (flip (pos 0) (posInfo
            {   posName = "BOARD_SIZE"
            ,   posDoc = "board size"
            }
        ) Nothing))
        (defTI { termDoc = "count the number of n-queens solutions for a given board size" })
        (\_ (RunOutcome _ termination_reason) → do
            case termination_reason of
                Aborted _ → error "search aborted"
                Completed (WordSum count) → print count
                Failure message → error $ "error: " ++ message
        )
        nqueensCount
