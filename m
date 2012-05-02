From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 2 May 2012 19:50:50 GMT
Message-ID: <201205021950.q42JooDk004022@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:52380 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2EBTuu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 15:50:50 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q42JooXk004023
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2012 19:50:50 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #6 from Theodore Tso <tytso@mit.edu>  2012-05-02 19:50:49 ---
As I expected, this is being caused by some application --- it looks like
Chrome's DB thread, is calling fsync() very aggressively.  If you exit your
Chrome browser, it should cause your disk from being used all the time.

I suspect the new kernel and the use of ext4 was just a coincidence.  Since I'm
using the very latest Chrome 19 beta and I'm not seeing this, I'm going to
guess that it's some Chrome extension, or some page which you are visiting that
is causing the large amounts of fsync() activity.

You can get a continuous reading of fsync() activity by enabling the above
tracepoint, and then in a window, running the command "cat
/sys/kernel/debug/tracing/trace_pipe".

If the fsync() activity goes away after you exit the Chrome browser, try
starting up the Chrome browser and then see if you see the heavy fsync()
activity with just a empty browser window before you start opening lots and
lots of tabs.  Also try disabling all of your Chrome extensions, and see if
that quiet things done.

Once you get things quiet, try enabling Chrome extensions one at a time, and
opening various web pages one at a time, and see if you can figure out what
causes the fsync storm.  It may very well be some flash-enabled page --- I run
with FlashControl to take out potential web page malware, or other things that
I don't want (and which can often burn CPU time and hence battery life).

Cheers,

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
