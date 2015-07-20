# Different ways to use AJAX for iterating through results
Our problem was we had results coming back that were of different classes. Terms and Reports. We wanted a way to display them in a list, but style them differently.

## Rendering Partials from the controller
Our first solution was to use partials and then iterate through the partials in the view layer, parsing which type was which and using partial names to define which styling they got. This had the benifits of being able to keep the ruby objects: `result.name` `result.definition`. The problem was that the rendering for just over 10 items takes around 2 seconds on local machine. Simply too slow.

Our main search bar can be anywhere you want to call your ajax from and display results to.
```haml
// app/views/search/main_search_bar.html.haml
%input#mainsearchbar{:placeholder => "Terms and Reports", :type => "text"}
#search_results

```
```ruby
# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def search_terms
    @results = Report.search(
      params[:query],
      index_name: [Report.searchkick_index.name, Term.searchkick_index.name],
      fields: ['name^10', 'description', 'definition']
    )
    # if you don't have a search feature, you can simply substitute for 
    # `@results = Term.all` as the principle is the same
    render partial: "search_results", locals: { results: @results || [] }, layout: false
  end
end

```
We create a 'main' search result partial that iterates over the array and renders the correct partial based on the individual item's class name.
```haml
// app/views/search/_search_results.html.haml
// main search result
- results.each do |result|
    = render partial: "#{result.class.to_s.downcase}_partial_search", locals: { result: result }, layout: false

```
```haml
// app/views/search/_term_search_results.html.haml
// individual term result
%h3= result.name
= result.definition

```
```haml
// app/views/search/_report_search_results.html.haml
// individual report result
%h2= result.name
= result.description

```

Then in our javascript we were calling ajax with a simple `.load` function and appending the result on top of our results page
```javascript
$(document).ready(function(){
  // The user types in the input box, and on 'enter' sends the search ajax request.
  // The 'enter' feature is not important. Whenever you fire the AJAX call is up to you. We're using a simple `.load` function but, you could explicitly define things with `.get` or even the full `$.ajax`
  $('#mainsearchbar').bind("keypress",function(e){
    if(e.keyCode == 13){
      send_search_request_for_all()
    }
  });
  // Simple `.load` function down to the search controller
  function send_search_request_for_all(){
    search_val = $('#mainsearchbar').val()
    // .load( url to go, then functions to run when complete )
    // Because our partials are handling everything for rendering, we just want the AJAX to send the request and append it to the div '#search_results'
    $('#search_results').load('/search/search_terms/' + search_val)
  }
});

```

## Manually writing json in the controller
After we determined that rendering partials was too slow, we decided to switch gears and render JSON in the controller and insert this json directly into the DOM. We first tried writing the JSON by hand:
```ruby
# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def search_all
    @results = Report.search(
      params[:query],
      index_name: [Report.searchkick_index.name, Term.searchkick_index.name],
      fields: ['name^10', 'description', 'definition']
    )
    render json: @results.map { |r| [r.name, r['definition'] || r['description']] }
  end
end

```
## Second method to write json in controller
Then we found the `as_json` helper method.
```ruby
# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def search_all
    @results = Report.search(
      params[:query],
      index_name: [Report.searchkick_index.name, Term.searchkick_index.name],
      fields: ['name^10', 'description', 'definition']
    )
    render json: @results.as_json(only: [:name, :definition, :description])
  end
end

```

## Using Ajax to directly insert into DOM
The eventual solution to writing to the DOM with jquery started with the `as_json` solution from above
```ruby
# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def search_all
    @results = Report.search(
      params[:query],
      index_name: [Report.searchkick_index.name, Term.searchkick_index.name],
      fields: ['name^10', 'description', 'definition']
    )
    render json: @results.as_json(only: [:name, :definition, :description])
  end
end

```
Which renders JSON that looks like this. Keep in mind, this is basically an array of hashes.
```json
[
    {
        "term": {
            "name": "awesome term",
            "definition": "<p>asdfkjhasdlkjfhasd</p>",
            "id": "1f501c19-f0ed-4b8e-a957-6207db72fd77"
        }
    },
    {
        "report": {
            "name": "report awesome",
            "description": null,
            "id": "c6fc08cb-8af4-486a-b40f-5183a3c2d3d7"
        }
    },
    {
        "report": {
            "name": "Algonquin",
            "description": "the report is pretty awesome",
            "id": "0d0681bc-c957-4407-bc75-2bd103dddfe1"
        }
    },
    {
        "term": {
            "name": "brooklyn",
            "definition": "i dont know if you know this or not, but its pretty awesome",
            "id": "e2985ca4-9a05-4a5d-b779-b01d5994a0bf"
        }
    },
    {
        "report": {
            "name": "newer report",
            "description": "<p>Numerous studies have shown that this report is 'awesome.'</p>",
            "id": "01a62175-45a2-4ee3-956c-dff2a5e7bc32"
        }
    }
]
```
In our javascript
```javascript
// app/assets/javascripts/search.js
$(document).ready(function(){
  $('#mainsearchbar').bind("keypress",function(e){
    if(e.keyCode == 13){
      send_search_request_for_all()
    }
  });
});
  function send_search_request_for_all(){
    search_val = $('#mainsearchbar').val() // grab the search input
    $('#search_results').empty(); // clear whatever was in the search results from the previous query
    $.get('/search/search_all/' + search_val + '.json', function(data) {
      
      for (var i = 0; i < data.length; i++) { // loop through the json's hash objects as Javascript doesn't have a simple `.each` function like ruby does
        var ind_result = data[i];
        if (Object.keys(ind_result) == 'term') { // There are a lot of strange(to a ruby dev) keywords thrown around here. This one grabs the first key and checks whether the hash is a `term` or `report`
            var html = '<div class="searchResult termSearchResult">' + // this defines the html as a string, parses the json objects and saves the string as a variable `html`
              '<div class="result_header">' +
                '<div class="result_icon result_icon_term"></div>' +
                '<h1 class="result_title">' + 
                  '<a class="do_highlight res_title" href="../' + 
                    Object.keys(ind_result) + 's/'+ ind_result[Object.keys(ind_result)].name + '">' +
                    ind_result[Object.keys(ind_result)].name +
                  '</a>' +
                '</h1>' +
              '</div>' +
              '<div class="do_highlight result_body">' +
                ind_result['term'].definition +
              '</div>' +
            '</div>'
        } 
        else {
          var html = '<div class="searchResult reportSearchResult">' +
            '<div class="result_header">' +
              '<div class="result_icon result_icon_report"></div>' +
              '<h1 class="result_title">' + 
                '<a class="do_highlight res_title" href="../' + 
                  Object.keys(ind_result) + 's/'+ ind_result[Object.keys(ind_result)].name + '">' +
                  ind_result[Object.keys(ind_result)].name +
                '</a>' +
              '</h1>' +
            '</div>' +
            '<div class="do_highlight result_body">' +
              ind_result['report'].description +
            '</div>' +
          '</div>'
        }
          $('#search_results').append(html); // appends the `html` dom string for each json hash object
      }
    }, "json" );
  }
});
```