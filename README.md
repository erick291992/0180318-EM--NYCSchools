# 0180318-EM--NYCSchools

App Services<br>
**GooglePlaces** to get an image from a given address<br>
link - https://developers.google.com/places/ios-api/photos#attributions<br>
**GoogleGeocodingAPI** to get placeId which is needed fot by the GooglePlaces to get the image<br>
link - https://developers.google.com/maps/documentation/geocoding/intro<br>
**Alomofire** to make network request to School api and Google Geocoding API<br>
link - https://github.com/Alamofire/Alamofire<br>

# Note
**GooglePhotoPicker** does not return results for the addresses of the schools provided by the API<br>
it only works with the google headquarters address for now. <br>
To test if image works with googles address then don't pass an address to the<br>
*getFirstPhotoForPlace* function in **SchoolsViewController**
