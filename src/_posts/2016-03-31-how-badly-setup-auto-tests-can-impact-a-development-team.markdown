---
layout: post
title:  "How badly setup Auto Tests can impact a development team"
date: 2016-03-31 18:44:26 +0000
categories: automated-tests culture software-engineering
---

<!-- paragraph -->
<p>I have just finished the final sprint with a team and for the past few days have been trying to fix some of the failing auto tests, of which there have been many.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>The tests are not failing because of the program code but because of a performance impact when running on the test server. On our fast Dev machines all the tests run easily and quickly – run them on what I imagine is a VM and the program goes to a snail pace. This means that the tests are trying to access resources before they have been created or before they are visible. As such they begin to fail.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>The immediate impact on the development team that I have observed is that a rota exists for running and then re-running and if needed further re-running the auto tests; and after that, running the further failing tests locally to see if it’s an actual bug or not. With the tests taking over three hours to run it’s costing a developer&nbsp;<strong>at least</strong>&nbsp;one hour a day – but really it’s closer to two or three if they have to run auto tests locally.</p>
<!-- /paragraph -->

<!-- quote -->
<blockquote><p>Over six sprints of two weeks each this has easily cost the development team 60 to 120 hours<strong>.</strong></p></blockquote>
<!-- /quote -->

<!-- paragraph -->
<p>That’s quite a lot of time for something that shouldn’t have been a problem. The fault lies is many places – I believe that the writers of the tests should have taken more care, especially when it became apparent that there were performance issues. I also believe that the PO/Management should have allocated more time to actually fixing the tests rather than creating a rota.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>Now the majority of these tests were inherited from the previous sprints concerning this project and as such it’s not really the current developers fault that they were so bad. There should have been a task in sprint 0 to actually setup the auto tests and ensure they were all running properly and stable.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>Through the development it became clear that we could not trust in the auto tests and therefore they became a hindrance rather than a useful tool.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>From the 30 – 40 tests that failed every day myself and another developer have got that down to about six and are hopeful that some final changes will make them more robust. We have certainly not spent over 120 hours, or 60 – perhaps around 12 hours to get it to this point.</p>
<!-- /paragraph -->
