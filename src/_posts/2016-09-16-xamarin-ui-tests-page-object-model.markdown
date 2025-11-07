---
layout: post
title:  "Xamarin UI Tests Page Object Model"
date: 2016-09-16 18:52:52 +0000
categories: automated-tests software-engineering xamarin
---

<!-- paragraph -->
<p>This blog post is an overview of how we&nbsp;have used SpecFlow, Xamarin UITest framework and the page object pattern to create an automated test suite for a mobile application running on Android and iOS.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>The application has been developed with Xamarin.IOS and Xamarin.Android using&nbsp;MVVM. The models and view models are all shared between the platforms and view are native. As this was a capability project we did not develop the apps side by side but instead we started with Android and then the iOS development started half way through the project.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>This manner of development threw&nbsp;up a fair amount of problems with the differences between the platforms and naturally the tests had to cater for them without sacrificing the ‘clean code’ aspect. The main challenges (in terms of testing)&nbsp;were in the controls such as Androids ‘Spinner’ and the iOS ‘Picker’. Also date time selectors, checkboxes and radio buttons. There were many development challenges (mainly life-cycle stuff) but that can be covered elsewhere.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p><strong>Walkthrough</strong></p>
<!-- /paragraph -->

<!-- paragraph -->
<p>I believe the easiest way to show this is by doing a walk through from the SpecFlow down to the page object discussing how it has been implemented and some of the key points. I have not included the full code, just the interesting bits and have redacted the project specific info.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>We start with a test case written in Gherkin:</p>
<!-- /paragraph -->

<!-- code -->
<pre><code>Scenario: Submit a snake form with reporting, species, confidence and length
	Given I am not a first time user
	And I am on the snake submit screen
	When I fill in the snake form with the following:
	| Field 	| Value	|
	| reporting	| Adder |
	| species	| Mud |
	| confidence | Certain |
	| length 	| 4	|
	And I click the submit button
	Then the snake 'latitude,longitude,observation' validation errors should be visible
	And the snake 'reporting,species,confidence,length' validation errors are not visible</code></pre>
<!-- /code -->

<!-- paragraph -->
<p>Simple enough, we want to go to the snake form page, fill in half the details and then check that we get the correct validation messages back. In this case we want latitude, longitude and observation errors to display.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>In this example the differences between Android and iOS were:</p>
<!-- /paragraph -->

<!-- list -->
<ul><li>Android displays errors as a toast that disappears after 4 seconds whereas iOS displays a dialog which requires user input.</li><li>The reporting field is a Spinner on Android and a Picker on iOS.</li></ul>
<!-- /list -->

<!-- paragraph -->
<p>These steps are then contained in a steps file, I haven’t included first two (user setup and navigation) as they are shared steps.</p>
<!-- /paragraph -->

<!-- code -->
<pre><code>using System.Linq;
using System.Text;
using TechTalk.SpecFlow;
using Xamarin.UITest;

namespace SnakeApp.UITest.Steps
{
	&#091;Binding]
	public class SnakePageSteps : Steps
	{
		IApp app;
		Platform platform;

		public SnakePageSteps()
		{
			app = FeatureContext.Current.Get&lt;IApp&gt;("App");
			platform = FeatureContext.Current.Get&lt;Platform&gt;("Platform");
		}

		SnakePage snakePage;
		public SnakePage SnakePage
		{
			get
			{
				if (snakePage == null)
					snakePage = new SnakePage(app, platform);

				return snakePage;
			}
		}

		&#091;When(@"I fill in the snake form with the following:")]
		public void WhenIFillInTheSnakeFormWithTheFollowing(Table table)
		{
			foreach (var row in table.Rows)
			{
				SnakePage.SetControlText(row.Values.First(), row.Values.Last());
			}
		}

		&#091;When(@"I click the submit button")]
		public void IClickTheSubmitButton()
		{
			SnakePage.SelectSubmitButton();
		}
		
		&#091;Then(@"the snake '(.*)' validation errors should be visible")]
		public void ThenTheSnakeValidationErrorsShouldBeVisible(string fields)
		{
			SnakePage.CaptureValidationErrors();
			SnakePage.FieldErrorsAreDisplayed(fields.Split(','));
		}

		&#091;Then(@"the snake '(.*)' validation errors are not visible")]
		public void ThenTheSnakeValidationErrorsAreNotVisible(string fields)
		{
			SnakePage.CaptureValidationErrors();
			SnakePage.FieldErrorsAreNotDisplayed(fields.Split(','));
		}
	}
}</code></pre>
<!-- /code -->

<!-- paragraph -->
<p>You can see that the snake page instance is being used by all of the steps and they are performing as little logic as possible. The most they are doing is splitting some strings before calling the method in the model.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>So what does the page object model look like?</p>
<!-- /paragraph -->

<!-- code -->
<pre><code>using System;
using System.Collections.Generic;
using NUnit.Framework;
using Xamarin.UITest;

namespace SnakeApp.UITest.Pages
{
	public abstract class SnakePage
	{
		readonly IApp app;
		readonly Platform platform;

		string reportingSpinner = "reportingSpinner";
		string speciesEditText = "speciesEditText";
		string confidenceSpinner = "confidenceSpinner";
		string lengthEditText = "lengthEditText";
		string textViewStatus = "textViewStatus";
	    string observationEditText = "observationEditText";
		string degreesLatEditText = "degreesLatEditText";
		string minutesLatEditText = "minutesLatEditText";
		string decimalLatEditText = "decimalLatEditText";
		string degreesLongEditText = "degreesLongEditText";
		string minutesLongEditText = "minutesLongEditText";
		string decimalLongEditText = "decimalLongEditText";
		string submitButton = "submitButton";

		public Dictionary&lt;string, string&gt; ValidationErrors = new Dictionary&lt;string, string&gt;()
		{
			{"latitude","'Latitude' all fields must have a value and follow the format 00 00 00."},
			{"longitude","'Longitude' all fields must have a value and follow the format 000 00 00."},
			{"observation","'Observation' should not be empty."},
			{"reporting", "'Reporting' cannot be the default option."},
			{"species", "'Species' should not be empty."},
			{"confidence", "'Confidence' cannot be the default option."},
			{"length", "'Length' should be between 1 and 9999."}
		};

		public Dictionary&lt;string, string&gt; FormControls = new Dictionary&lt;string, string&gt;()
		{

		};

		public string CapturedValidationErrors = string.Empty;

		protected SnakePage(IApp app, Platform platform)
		{
			this.app = app;
			this.platform = platform;

			FormControls.Add("reporting", reportingSpinner);
			FormControls.Add("species", speciesEditText);
			FormControls.Add("confidence", confidenceSpinner);
			FormControls.Add("length", lengthEditText);
			FormControls.Add("observation", observationEditText);
			FormControls.Add("deglat", degreesLatEditText);
			FormControls.Add("minlat", minutesLatEditText);
			FormControls.Add("declat", decimalLatEditText);
			FormControls.Add("deglong", degreesLongEditText);
			FormControls.Add("minlong", minutesLongEditText);
			FormControls.Add("declong", decimalLongEditText);
		}

		public void SetControlText(string field, string textValue)
		{
			if (!FormControls.ContainsKey(field))
			{
				Assert.Fail($"The given control key {field} is not recognised by this form");
			}

			var controlId = FormControls&#091;field];

			if (controlId.Contains("EditText"))
			{
				SetTextValue(controlId, textValue);
			}

			if (controlId.Contains("Spinner"))
			{
				SetSpinnerValue(controlId, textValue);
			}
		}

		public void SetSpinnerValue(string controlId, string option)
		{
			if (platform == Platform.Android)
			{
				app.ScrollTo(controlId);
				app.Tap(c =&gt; c.Marked(controlId));
				app.Tap(c =&gt; c.Marked(option));
			}
			else 
			{
				app.ScrollTo(controlId);
				app.Tap(c =&gt; c.Marked(controlId));

				ScrollToPickerColumn(1, option);
			}
		}

		//This will generally work on a simulator which a larger timeout however may fail. It will work fine on a physical device.
		private void ScrollToPickerColumn(int columnIndex, string marked)
		{
			TimeSpan timeout = TimeSpan.FromSeconds(45);
			app.ScrollDownTo(z =&gt; z.Marked(marked), x =&gt; x.Class("UIPickerTableView").Index(columnIndex), timeout: timeout, strategy: ScrollStrategy.Auto);
			app.Tap(x =&gt; x.Text(marked));
		}

		public void SetTextValue(string controlId, string text)
		{
			var elements = app.Query(c =&gt; c.Marked(controlId));

			if (elements.Length == 0)
				app.ScrollTo(controlId);

			app.Query(c =&gt; c.Marked(controlId).Invoke("setText", string.Empty));
			app.EnterText(c =&gt; c.Marked(controlId), text);
			app.DismissKeyboard();
		}

		public void CaptureValidationErrors()
		{
			if (platform == Platform.iOS)
				return;
			
			if (CapturedValidationErrors != string.Empty)
				return;

			var elements = app.WaitForElement(c =&gt; c.Marked(textViewStatus), $"The {textViewStatus} control is not being displayed/accessible");

			CapturedValidationErrors = elements&#091;0].Text;
		}

		public void FieldErrorsAreDisplayed(string&#091;] displayed)
		{

			foreach (var field in displayed)
			{
				if (!ValidationErrors.ContainsKey(field))
				{
					Assert.Inconclusive($"The given validation key {field} is not recognised by this form");
				}

				if (platform == Platform.Android)
				{
					if (!CapturedValidationErrors.Contains(ValidationErrors&#091;field]))
					{
						Assert.Fail($"The validation errors don't contain the error for key {field}");
					}
				}
				else 
				{
					var elements = app.Query(c =&gt; c.Property("text").Contains(ValidationErrors&#091;field]));

					if (elements.Length == 0)
						Assert.Fail($"The validation errors don't contain the error for key {field}");
				}
			}
		}

		public void FieldErrorsAreNotDisplayed(string&#091;] displayed)
		{
			foreach (var field in displayed)
			{
				if (!ValidationErrors.ContainsKey(field))
				{
					Assert.Inconclusive($"The given validation key {field} is not recognised by this form");
				}

				if (platform == Platform.Android)
				{
					if (CapturedValidationErrors.Contains(ValidationErrors&#091;field]))
					{
						Assert.Fail($"The validation errors contain the error for key {field}");
					}
				}
				else
				{
					var elements = app.Query(c =&gt; c.Property("text").Contains(ValidationErrors&#091;field]));

					if (elements.Length != 0)
						Assert.Fail($"The validation errors contain the error for key {field}");
				}
			}
		}
		
		public void SelectSubmitButton()
		{
			app.ScrollTo(submitButton);
			app.Tap(c =&gt; c.Marked(submitButton));
		}
	}
}</code></pre>
<!-- /code -->

<!-- paragraph -->
<p>For this blog post I have merged the Snake Page and its base class into a single class to display the full code. However methods such as the SetTextValue and SetSpinner value are shared between multiple pages and as such can be in a base model, this can also be said for some of the other methods.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>There are two dictionaries for the form – these are the controls and the validation errors that the form can return. This has been done to allow shorthand at the SpecFlow level but could be considered as introducing a new thing to maintain.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>We have used a naming convention for the text and spinner IDs that has allowed us to use a generic method for setting the control text and then split it down to the different input methods. You can see in the snake page class where we are handing the different controls by simply checking if the platform is Android or iOS and then acting accordingly.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>CaptureValidationErrors is not required by iOS as the validation errors are displayed in a dialog box and therefore stay on the screen indefinitely. On Android we have a set time of four seconds to retrieve the validation messages and then check through them. That means that they have to be stored in a variable. This does make the page object stateful however we only check the validation messages once so that is OK.</p>
<!-- /paragraph -->

<!-- separator -->
<hr />
<!-- /separator -->

<!-- paragraph -->
<p>I hope this has displayed how we have used&nbsp;SpecFlow, Xamarin UITest framework and the page object pattern to test the mobile application whilst keeping a flexible but simple test framework. The page object pattern has allowed us to handle the different platform types and make a maintainable set of page classes.</p>
<!-- /paragraph -->
