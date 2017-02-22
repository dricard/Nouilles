### Noodles

#### Introduction

**Noodles** is an app for pasta lovers who are picky about their noodles, and particularly families where there are pasta lovers. 

The suggested cooking time found on boxes are for the average person, but tastes vary and some like their noodles [Al dente](https://en.wikipedia.org/wiki/Al_dente) while others prefer them well cooked. This also varies from country to country, and so suggested cooking times are influenced by regional preferences. If you have many noodles in your cupboard and want to cook them perfectly every time, it can be hard to remember your own preferences for just the right noodle. 

This is where **Noodles** comes in. It's a list of all your noodles with your preferences for cooking time, and also for the right quantity to cook per person, be it for a full meal or as a side dish. It will also help you choose which noodle to cook by sorting by cooking time for example if you are pressed for time, or by ratings, etc.


#### Basic usage

The basic use is for the user to look at the list of noodles, select one and tap on its row to view the detailed view. She can then select how many people will eat those noodles and the app displays the right quantity to prepare, and then the user can start a noodle timer from the same screen.

Noodles and all their associated data are persisted in CoreData. The number of persons you specified is also persisted in CoreData.

User interface choices, like list sorting order, are persisted in NSUserDefaults.

The apps loads sample noodles if the data store is empty when the app launches, otherwise it will display the data from Coredata.

The user can add noodles with a name and brand, and set her prefered quantity for a full meal or a side dish, the cooking time, and a rating. She can also add a picture of the noodle's box for easy reference.

The app will fetch nutritional information for each noodle from a REST API.

![list View](http://hexaedre.com/apps/noodles/files/stacks-image-224009b.png)

#### List View Functionality

The list view displays:

- a picture of the noodle selected by the user or a placeholder image,
- the name and brand of the noodle,
- a rating displayed as a number of stars from zero to 5 (fractions are possible),
- the quantity to prepare for one person in cups for the selected meal size (see below),
- the cooking time,
- the selected meal size (full meal or side dish) displayed with a circular graphic,
- noodle availability displayed as a square graphic.

When a timer is running for one or more noodles, the noodle's picture is replaced with the timer animation.

When the user selects a noodle, a detailed view is presented.

When the user swipes left on a noodle (row) two actions are presented:

- if a timer is running, the user can pause/start the timer, or cancel the timer,
- if no timer is running, the user can delete the noodle or toggle its availability.

![filter view](http://hexaedre.com/apps/noodles/files/stacks-image-2509e08.png)

#### Filters View Functionality

Which noodles are shown in the list view and how they are sorted can be defined by the user by accessing the filters' viewcontroller (by tapping the menu button on the left side of the navigation bar in the list view). The user can select any one of these sorts options:

- by name,
- by brand,
- by rating (higher ratings to lower ratings),
- by cooking time (shorter cooking time to higher cooking time).

The user can also select which noodle to show with these options:

- all noodles,
- only available noodles,
- only unavailable noodles (to make a grocery list for example),
- those which are marked as main meal,
- those which are marked as side dish.

These preferences (sort and predicate) are persisted in NSUserDefaults.

From this Filters view the user can go back to the list view, or view the 'about page'.

#### About Page

The about page gives credits information about the app, display the copyright and the version number and has a button leading to a support page, and a button to compose an email to ask for support or send a comment.

![detailed view](http://hexaedre.com/apps/noodles/files/stacks-image-ea64bca.png)

#### Detailed View Functionality

The detailed view displays:

- a larger version of the picture (either default or user selected) which can be tapped to add/change the picture,
- the name and brand of the noodle,
- a rating displayed as a number of stars from zero to 5 (fractions are possible),
- the cooking time,
- the prefered meal size (full meal or side dish) displayed with a circular graphic which the use can tap to toggle between the two,
- noodle availability displayed as a square graphic which the user can tap to toggle,
- the number of people eating, which can be increased/decreased by a segmented control placed just below (this number of people is also persisted in Coredata),
- a quantity to prepare expressed in cups which depends on the number of people and the meal size (main or side dish),
- the nutritional information scaled for selected meal size,
- a button to start a timer for that noodle's cooking time.

When the detailed view for a noodle which has no nutritional information is displayed, a REST API request is sent to fetch that information based on the name and brand of the noodles. While the fetch is taking place, a blur effect is placed over the nutritional information section and an activity indicator is shown. If there are errors with the network request, a dialog is displayed to inform the user. Once the information is received, the blur and activity indicator are removed and the information is shown and saved in core data.

From the detailed view, the user can:

- go back to the list view, 
- go to the Edit View which lets the user modify all the noodle information,
- go to the picture view to take a new picture or select one from the album, or
- start a timer which takes the user to the timer view.

![edit view](http://hexaedre.com/apps/noodles/files/stacks-image-09efe31.png)

#### Edit view

The edit view lists all the properties of a noodle in a tableview format. Taping on a row (other than those with switches) opens the change value view which lets the user change the property's value.

#### Change value view

The change value view displays which value is being edited and the current value with corresponding units, an editable field to enter the new value and a cancel and save button. The cancel button (or tapping the back button without saving) discards any change in the value. If the user taps 'save', the value validated, then is changed in the noodle and persisted.

#### Timer view

When a timer is started the timer view is displayed. It shows a timer animation and a numerical value for the minutes and seconds remaining. There is a pause/start button near the numerical value, and a cancel button (a circle with an X). The user can navigate out of this view back to the detailed view (in which case the 'start timer' button will change to 'show timer'), and even back to the list view (in which case the picture will be replaced with a scaled down version of the timer animation).

Multiple timers can be started simultaneously and each is displayed in it's own row in the list view.

When a timer runs out it plays a sound with a short duration. Timers can be stopped by either the pause/start button or the cancel button, in the timer view, or by swiping the row on a noodle with a running timer.

#### Add noodle view

On the list view, tapping the '+' button on the right side of the navigation bar leads to the Add Noodle view.

This view lets the user enter the required information for a new noodle:

- name,
- brand, 
- meal size serving,
- side dish serving,
- cooking time and,
- rating.

In addition this view has a save and cancel button, and, if a camera is available on the device, a scan barcode button. Pressing the 'back' navigation button will check if the data entered has been saved and alert the user if unsaved changes will be lost. The user if offered a choice between discarding the data or continue editing. Pressing the save data will verify that all the fields are filled and do basic validation on the data. If any entry does not pass the validation, a specific error message will be displayed to the user. Of course the user can also select cancel and go back to the list view. Saving will create a new noodle object saved in CoreData. Nutritional information will be fetched the first time a detailed view will be presented.

Once a noodle is added to the list, the app will fetch the nutrutional information from a REST API and will display the scaled nutritional information according to the quantity the user sets as a portion (which will often be different than the reference serving size in the nutritional information).

To test this, select a row in the list of noodles and the app will segue to the detailed view. The nutritional information is listed in the bottom portion of the view. While the data is being fetched that area has a blur applied and an activity indicator is displayed. Once the data is fetched these are removed and the scaled information is displayed.

The user can set a noodle prefered meal size which he usually uses for a noodle, and toggle its 'on hand' status.

To test this, in the detailed view, tap on the circle in the upper right corner to toggle between meal size (full circle) and side dish size (quarter of a circle).

To toggle the 'on hand' status, tap on the square box, which will toggle between 'on hand' (checkmark) or 'unavailable' (red 'x').

To add a picture, in the detailed view, tap the placeholder image to go to imagePicker. The app tests if a camera device is available or not and disable the camera button accordingly.

The list can be sorted according to various user selected criteria, be it name, cooking time, rating, etc. It's also possible to show only available noodles, or only unavailable noodles (to make the groceries list!).

To test this, from the list view, tap the hamberger menu in the top left corner to show the filters VC, select a sort option and a predicate option. These are persisted in NSUserDefaults.

![list view with multiple timers](http://hexaedre.com/apps/noodles/files/stacks-image-ddc108c.png)

It's possible to start more than one timer at a time, and the timers will show in the list view, replacing the image while the timer is running.

In the list view, swiping will offer either a delete or a toggle on hand action if there is no timer, or a play/pause or cancel action if a timer is running.

The app is localized in French in addition to the english version.

When adding a noddle, the user is offered a chance to scan the noodle's barcode to help fill in name and brand.


#### Documentation

The code is well documented. More information can be found on the [project's page](http://hexaedre.com/apps/noodles/).

#### Install

1. Decompress the zip file.
2. Run the project.

#### Swift and Xcode versions

This project is for **Swift version 3.0** and **Xcode version 8.2.1**.

#### More information

More information and screenshots can be found on the [project's page](http://hexaedre.com/apps/noodles/). If you have questions I'd be happy to help. Contact information can be found below or on the project's page.

#### Notes on the code

There is code for accessing two different APIs for the nutritional information. Only one is used in the app at the moment, I'm planning on completing the other and test it to see if there is better information from that API. The app can be used as is without the second API.

There is also an unused UserRating Entity in the Model which is there for a planned (futur) feature which will let a family share data on noodles. Everyone will have access to the same basic data, but each indivudual will be able to rate the noodles and the app will display an average of the ratings. This is unused in the app at this time.

The barcode scanning works but the API used at the moment never returns a match for noodles found where I live. I'm hoping that the tester will have better luck than me. I could remove it but I think it'd be a nice feature and I hope that the second API provides better results. So I left it there for now.

#### License

Noodles is Copyright © 2017 Denis Ricard. All rights reserved.

#### About Me

I'm an iOS developer. You can find my web site at [hexaedre.com](http://hexaedre.com), find me on Twitter under [@hexaedre](http://twitter.com/hexaedre), on GitHub as [dricard](https://github.com/dricard), or [contact me](http://hexaedre.com/contact/).
