module.exports = function(Item) {
  Item.afterRemote('prototype.__create__reviews', function (ctx, remoteMethodOutput, next) {
    var itemId = remoteMethodOutput.itemId;

    console.log("calculating new rating for item: " + itemId);

    var searchQuery = {include: {relation: 'reviews'}};

    Item.findById(itemId, searchQuery, function findItemReviewRatings(err, findResult) {
      var reviewArray = findResult.reviews();
      var reviewCount = reviewArray.length;
      var ratingSum = 0;

      for (var i = 0; i < reviewCount; i++) {
        ratingSum += reviewArray[i].rating;
      }

      var updatedRating = Math.round((ratingSum / reviewCount) * 100) / 100;

      console.log("new calculated rating: " + updatedRating);

      findResult.updateAttribute("rating", updatedRating, function (err) {
        if (!err) {
          console.log("item rating successfully updated");
        } else {
          console.log("error updating rating for item: " + err);
        }
      });
      next();
    });
  });
};
