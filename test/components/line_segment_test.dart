import 'package:turf/src/line_segment.dart';
import 'package:test/test.dart';
import 'package:turf/helpers.dart';

main() {
  Feature<MultiLineString> multiline = Feature<MultiLineString>(
    geometry: MultiLineString(
      coordinates: [
        [
          Position.of([5, 5]),
          Position.of([6, 6]),
          Position.of([9, 9])
        ],
        [
          Position.of([7, 7]),
          Position.of([8, 8]),
        ],
      ],
    ),
  );

  Feature<MultiPoint> multiPoint = Feature<MultiPoint>(
      geometry: MultiPoint(
    coordinates: [
      Position.of([0, 0]),
      Position.of([1, 1]),
    ],
  ));

  MultiPoint multiPoint1 = MultiPoint(coordinates: []);

  LineString lineString = LineString(
    coordinates: [Position(1, 1), Position(2, 2), Position(3, 3)],
  );

  Feature<GeometryCollection> geomCollection1 = Feature<GeometryCollection>(
    geometry: GeometryCollection(
      geometries: [
        multiPoint1, // should throw
        lineString
      ],
    ),
  );
  test("lineSegment -- GeometryColletion", () {
    // Multipoint gets ignored
    expect(() => lineSegment(multiPoint1), throwsA(isA<Exception>()));

    // Feature<MultiPoint> passed to lineSegment produces and empty FeatureCollection<LineString>
    FeatureCollection<LineString> results = lineSegment(multiPoint);
    expect(results.features.isEmpty, true);

    // LineString with multiple coordinates passed to the lineSegment will
    // produce a FeatureCollection<LineString> with segmented LineStrings
    var lineStringResult = lineSegment(lineString);
    expect(lineStringResult.features.length, 2);
    expect(lineStringResult.features.first.geometry!.coordinates[0],
        Position(1, 1));

    // A more complex object
    var geomCollectionResult = lineSegment(geomCollection1);
    expect(geomCollectionResult.features.length, 2);

    // MultiLines
    var multiLineResults = lineSegment(multiline);
    expect(multiLineResults.features.length, 3);
  });
}