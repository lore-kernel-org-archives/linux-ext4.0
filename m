From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sat, 2 Jan 2010 16:47:36 GMT
Message-ID: <201001021647.o02Glabe016417@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60257 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0ABQrh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jan 2010 11:47:37 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o02GlaeS016418
	for <linux-ext4@vger.kernel.org>; Sat, 2 Jan 2010 16:47:36 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2010-01-02 16:47:35 ---
OK, so that's not technically a regression as far as what the kernel bugzilla
field is concerned.

>... my HDD led keeps flashing continuously which certainly means some disk
>activity. Should I attach a video showing this abnormality on kernel 2.6.32.2
>on runlevel 1 with no application running except bash and this application?

What would be much more useful would be to install blktrace, and then attach
the output of "btrace /dev/sdXX" while this application is running.

When I do the test, I am seeing some excess write barriers which we can
optimize away:

254,3    0     1148    31.613064584 10904  Q  WB [test]
254,3    0     1149    31.664270330 10904  Q  WB [test]
254,3    0     1150    31.715259078 10904  Q  WB [test]
254,3    0     1151    31.772662156 10904  Q  WB [test]
254,3    0     1152    31.827932269 10904  Q  WB [test]
254,3    0     1153    31.883122551 10904  Q  WB [test]

but that's not a disaster.   (If there is no pending writes from other
applications, this won't cause any extra hard drive activity.)

I'd like to confirm whether you are seeing anything more, since at least for me
on my system, empty write barriers don't cause the hard drive activity light to
go on.   Maybe it does for your system, though.  I'd like to confirm this since
because if it's just a matter of extra (unnecessary) write barriers, we would
prioritize this as a much lower priority bug to tackle than if there's
something else going on.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
