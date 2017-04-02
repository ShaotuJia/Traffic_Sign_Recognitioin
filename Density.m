%This function is to find the intensity density of sign in boundingbox

function density = Density(blob)

height = blob.BoundingBox(4);
width = blob.BoundingBox(3);

BoxArea = height * width;

Area = blob.Area;

density = Area/BoxArea;

end