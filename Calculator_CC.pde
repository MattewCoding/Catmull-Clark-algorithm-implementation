import java.util.Arrays;

/**
 * Methods specifically to implement the Catmull Clark algorithm
 */

public Point newPointCalc(Shape s, Point p, int ithPoint){
  ArrayList<ArrayList<Integer>> pointsUsed = s.getPointsUsed();
  ArrayList<Face> faces = s.getFaces();
  
  // Find the faces that have the point in the parameter
  ArrayList<Integer> facesWithPoint = new ArrayList<Integer>();
  for(int i = 0; i < pointsUsed.size(); i++){
    ArrayList<Integer> sidePoints = pointsUsed.get(i);
    if(sidePoints.contains(ithPoint)){
      facesWithPoint.add(i);
    }
  }
  
  int n = facesWithPoint.size();
  ArrayList<Point> facePoints = new ArrayList<Point>();
  ArrayList<Point> edgeMidpoints = new ArrayList<Point>();
  
  // Finding the average of the face centers and the average of the midPoint of the vertexes
  for(int i = 0; i < n; i++){
    Face fI = faces.get(i);
    facePoints.add(faceCenter(fI));
    
    for(int j = i+1; j < n; j++){
      Face fJ = faces.get(j);
      ArrayList<Point> aIJ = findCommonEdgePoints(fI, fJ);
      
      edgeMidpoints.add(averageOfPoints(aIJ));
    }
  }
  Point faceAvg = averageOfPoints(facePoints);
  Point edgeAvg = averageOfPoints(edgeMidpoints);
  
  Point res = new Point();
  try{
    res = dividePoint(addPoints(addPoints(faceAvg, multiplyPoint(2, edgeAvg)), multiplyPoint(n-3, p)), (float)n);
  } catch(ArithmeticException ae){
    print("In facesWithPoint function: " + ae);
    exit();
  }

  return res;
}

/**
 * Calculates the edge point between two faces
 *
 * @param f1   The first face.
 * @param f2   The second face.
 * @return The calculated edge point.
 */
public Point edgeCalc(Face f1, Face f2) throws RuntimeException{
  Point avg1 = faceCenter(f1), avg2 = faceCenter(f2);
  return edgeCalc(f1, f2, avg1, avg2);
}

/**
 * Find the point that is in the center of the face
 */
public Point faceCenter(Face f){
   return averageOfPoints(f.getPoints());
}
