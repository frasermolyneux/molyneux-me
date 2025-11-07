---
layout: post
title:  "Behaviour Driven Development for Mobile Apps"
date: 2016-12-08 18:56:46 +0000
categories: automated-tests culture software-engineering
---

<!-- paragraph -->
<p>Geert Van Der Cruijsen gave a &nbsp;Xamarin University guest lecture that I attended on behavior driven development (BDD) for mobile applications.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>His website is&nbsp;<a href="https://web.archive.org/web/20170929203905/http://mobilefirstcloudfirst.net/">http://mobilefirstcloudfirst.net/</a>&nbsp;and he has some great Xamarin blog posts (not all about automated testing). Geert is a technical expert and architect on mobile and cloud working as a lead consultant in the Netherlands. He is also a Xamarin University training partner.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>The lecture started by going over what BDD is and why we use it. Geert explained that BDD has come about because of the following problem:</p>
<!-- /paragraph -->

<!-- quote -->
<blockquote><p>The product owner speaks in plain text; the developer speaks in code and the tester speaks in test plans.</p><p>The business guy has a great idea that will change the world and make a load of money. He needs a way to express this as requirements and communicate it to the developers without misunderstanding.</p></blockquote>
<!-- /quote -->

<!-- paragraph -->
<p>With each party speaking in their own language there is a cost to the translation which causes the requirements to blur and the end result is not necessarily what the customer wants, as such:</p>
<!-- /paragraph -->

<!-- quote -->
<blockquote><p>We need one ubiquitous language between all the parties which helps build a clear specification. This is where BDD&nbsp;comes in, If the PO can write a requirement and that wording&nbsp;exists in both the specification and the solution itself there is less room for miscommunication. Also the code itself should reflect the business terminology through domain driven development.</p></blockquote>
<!-- /quote -->

<!-- paragraph -->
<p>BDD tries to create a communication flow between the business and the developers (+testers). Requirements are&nbsp;split into (small) specific scenarios that the business can write in a well-known form that the developer knows and is directly translatable into the software features – this leads to improved understanding.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p><strong>Enter: SpecFlow, NUnit, Gherkin, Xamarin.UITest, Xamarin Test Cloud</strong></p>
<!-- /paragraph -->

<!-- paragraph -->
<p>Geert introduced the above technologies and then focused on some of the specifics of implementing this process into a Xamarin mobile application and why. He gave the statistic that 26% of application downloads are abandoned after the first use and as such:</p>
<!-- /paragraph -->

<!-- quote -->
<blockquote><p>Mobile application quality is very important and the applications can be very complex. Having the application right the first time is very important.</p></blockquote>
<!-- /quote -->

<!-- paragraph -->
<p>He then walked through a demo Xamarin application and added some SpecFlow tests around its functionality and displayed running the tests on the Xamarin Test Cloud.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>All in all the lecture was mainly about the benefits of BDD for the business and the customer and less on the implementation but it was an interesting talk and has highlighted two things to me:</p>
<!-- /paragraph -->

<!-- list -->
<ul><li>Without input from the business on the content of the acceptance tests then they may not satisfy the customer requirements.</li><li>Domain driven design is very important for acceptance tests to be easily understood and implemented by developers as there is less translation required. If a feature is called ‘Updates basket’ on the UI and by the business then it should be called that in the code.</li></ul>
<!-- /list -->

<!-- paragraph -->
<p><strong>Question Time<br></strong>During the mobile application development that I have done we hit a couple of testing challenges and I posed one of the bigger ones to Geert as a question to see what his advice would be to tackle it:</p>
<!-- /paragraph -->

<!-- paragraph -->
<p><strong>Question:&nbsp;</strong>Given the Xamarin Test Cloud can take a huge amount of time to run tests, how would you manage running &nbsp;tests for an application with a large number of them.<br><strong>Answer:</strong>&nbsp;He suggested the running of a few ‘core’ tests on the test cloud on a regular basis and running the full suite perhaps weekly. Also running them often locally. (This is how we managed it on our project which is good).</p>
<!-- /paragraph -->
