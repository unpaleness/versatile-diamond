module VersatileDiamond
  module Patches

    module RichArray
      refine Array do
        # Removes one item from array
        # @param [Object] item some item from array
        # @yeild [Object] if passed instead of item then finds index of item
        # @return [Object] removed object
        def delete_one(item = nil, &block)
          index = item && !block_given? ?
            index(item) :
            (block_given? ? index(&block) : (raise ArgumentError))

          delete_at(index || size)
        end

        # Groups the items by passed block
        # @yield [Object] for each item from which the grouping value will be gotten
        # @return [Array] the list of grouped arrays
        def groups(&block)
          group_by(&block).values
        end

        # Gets not unique items of array
        # @return [Array] the not unique items of original sequence
        def not_uniq
          select { |item| count(item) > 1 }.uniq
        end
      end
    end

  end
end
