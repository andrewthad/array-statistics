{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE NamedFieldPuns #-}

module Statistics.Array.Types
  ( AscList(..)
  , fromArray
  , unsafeFromAscendingArray
  , fromList
  , unsafeFromAscendingList
  , Quartiles(..)
  ) where

import Data.Primitive.Contiguous (Contiguous, Element)

import qualified Data.Primitive.Contiguous as Arr
import qualified Data.Primitive.Sort as Arr


-- | A non-empty list with data in ascending order.
--
-- I am keeping the implementation under-the-hood, as there are certainly better
-- ways to represent this data than an actual linked list.
newtype AscList arr e = AscList (arr e)

fromArray :: (Contiguous arr, Element arr e, Ord e) => arr e -> Maybe (AscList arr e)
fromArray xs
  | Arr.null xs = Nothing
  | otherwise = Just . AscList . Arr.sort $ xs

-- | Unsafe because if the input array is empty or not sorted ascending, functions
-- operating on the resulting 'AscList' may (will) produce incorrect results.
unsafeFromAscendingArray :: (Contiguous arr, Element arr e) => arr e -> AscList arr e
unsafeFromAscendingArray = AscList

fromList :: forall arr e.
  (Contiguous arr, Element arr e, Ord e) => [e] -> Maybe (AscList arr e)
fromList xs
  | null xs = Nothing
  | otherwise = Just . AscList . Arr.sort . Arr.fromList $ xs -- WARNING inefficent, but hey... you're using lists, scrub

-- | Unsafe because if the input list is empty or not sorted ascending, functions
-- operating on the resulting 'AscList' may (will) produce incorrect results.
unsafeFromAscendingList :: forall arr e.
  (Contiguous arr, Element arr e) => [e] -> AscList arr e
unsafeFromAscendingList = AscList . Arr.fromList

data Quartiles a = Quartiles
  { q1 :: a
  , q2 :: a
  , q3 :: a
  }
  deriving (Show, Eq)
