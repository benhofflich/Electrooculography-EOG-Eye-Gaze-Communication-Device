function c = color(boxes,coord,boxsize)
    %param(boxes,coord)
    %boxes = [hBoxes vBoxes]: 1x2 array containing number of vertical and 
    %horizontal boxes in grid
    %coord: 1x2 vector [x y]
        %for 3x3
        %x = -1(left),0(middle),1(right)
        %y = -1(top),0(middle),1(bottom)
    
    if nargin < 1
        boxes = [3 3];
    end

    hBoxes = boxes(1);
    vBoxes = boxes(2);
    
    if nargin < 3
        boxsize = [33 33];
    end
    
    c = ones(boxes(2)*((boxsize(2)+1)-1),(boxes(1)*((boxsize(1)+1)-1)),3);
    boxwidth = boxsize(1);
    boxheight = boxsize(2);
    
    %Creates Borders
    for i = 1:hBoxes-1
        c(:,i*boxwidth + i,:) = 0;
    end
    for j = 1:vBoxes-1
        c(j*boxheight + j,:,:) = 0;
    end
    
    if nargin < 2
        image(c)
        return %clears grid
    end
    
    x = coord(1);
    y = coord(2);
    
    hBoxInt = [];
    vBoxInt = [];
    
    for hInt = 1:hBoxes
        int = ((hInt-1)*boxwidth+hInt):(hInt*boxwidth+(hInt-1));
        hBoxInt(hInt,1:length(int)) = int;
    end
    for vInt = 1:vBoxes
        int = ((vInt-1)*boxheight+vInt):(vInt*boxheight+(vInt-1));
        vBoxInt(vInt,1:length(int)) = int;
    end
    
    boxX = [];
    boxY = [];
    
    for h = -((hBoxes-1)/2):(hBoxes-1)/2
        if x == h
            boxX = hBoxInt(1+h+(hBoxes-1)/2,:);
        end
    end
    for v = -((vBoxes-1)/2):(vBoxes-1)/2
        if y == v
            boxY = vBoxInt(1+v+(vBoxes-1)/2,:);
        end
    end
    c(boxY,boxX,1) = 1;
    c(boxY,boxX,2) = 0.5;
    c(boxY,boxX,3) = 0.5;
    image(c)
    axis('tight')
    axis('equal')
    return
end
    
    