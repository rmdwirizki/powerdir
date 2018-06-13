import {Store} from '../global/Store.imba'

export tag ItemBox
  prop index
  prop box

  def isLast 
    return @index == Store:boxes:length - 1