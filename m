From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sat, 23 Apr 2011 19:31:47 GMT
Message-ID: <201104231931.p3NJVlMU015469@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39317 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab1DWTbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 15:31:48 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3NJVl8B015470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 19:31:47 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #67 from Theodore Tso <tytso@mit.edu>  2011-04-23 19:31:45 ---
Just because *I* don't like desktops that initiate I/O at random times when I
don't request doesn't mean that other users shouldn't use it.  It's just that
if we're talking about making a reliable test case, it's much better if it
doesn't depend on random I/O initiated by a desktop.  The test case should do
whatever I/O is needed, so that it is complete reproducible, even by people who
don't necessarily use the same desktop as you.

Thinking about this some more, *very* recently (as in the most recent merge
window) there have been some hanges recently to avoid deadlock in ext3/4 on
when freezing and unfreezing file systems for snapshots, and that code path is
also used on suspend/resume.  Those changes came in way after 2.6.36-rc1, so
yes, if they are also causing some issues with 2.6.39-rc2+ systems, it's very
likely that there are different bugs involved.   Which is why I insist on
getting full and accurate OOPS logs, so we can see if they are different
crashes that happen to have apparently the same symptoms caused by the same
event (i.e. USB keys getting rudely yanked out of the system).

By the way, for years and years and years USB disks just didn't work at all
across suspend/reusmes.  Which is why I have scripts into my suspend/resume
framework to automatically unmount removeable disks at suspend-time....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
