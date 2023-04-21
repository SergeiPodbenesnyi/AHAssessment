# AHAssessment
iOS Application for Albert Heijn assessment

This app uses RijksMuseum API : https://data.rijksmuseum.nl/object-metadata/api/
to present some data in collection view and details view.

The first request fills the ArtTypes collection.
Every art type is a separate section in collection.
The first three sections fills up during first iteration.

The amount of art objects in each section it 10. This is hardcoded in request for type.
If art object cannot be created due to missing url or broken data,
or if there are no data for type you would notice lesser elements in section.

Then while scrolling, elements for next sections are downloading.

## TODO

### Major
- Visualization of loading process on first appearance of CollectionView
- Improve Unit Tests
- Data layer for CollectionView for proper data handling
- Remove "Magic" numbers and strings from code. Put them into constants
- Add method descriptions
- Documentation for logic

### Minor
- SwiftLint and codestyle
- Check urls while creating structs
- Improve pagination
- Design
- Remove code duplication
