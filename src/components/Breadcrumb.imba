export tag Breadcrumb
  prop boxes
  def setActive index
    boxes.splice index + 1, boxes:length - index + 1
  def render
    <self>
      <nav.breadcrumb attr:aria-label="breadcrumbs">
        <ul>
          for box, index in boxes
            <li><a :tap.setActive(index)> box:name