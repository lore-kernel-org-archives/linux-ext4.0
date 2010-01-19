From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 19 Jan 2010 21:56:13 GMT
Message-ID: <201001192156.o0JLuDIi026451@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39729 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0ASV4N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2010 16:56:13 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0JLuDTO026452
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 21:56:13 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #6 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-01-19 21:56:12 ---
>So the first thing I notice is the fact that you have the nodelalloc mount
>option enabled.   Any particular reason why you did that?  

This was required due to an error in 2.6.30.  It is possible that
it is no longer needed. I will check.

It is not really feasible to revert to ext3 other than going back to
RHEL5 which is what has been done.  One of the main purposes of using
FC11 was ext4.  fsck under ext3 is about 8 hours, under ext4 about
9 minutes.  And, ext4 has other well-advertised advantages.

>Another thing to try is to do some instrumentation using iostat to see what the
>system is doing, before, during, and after the sync command.

I have tried this to some extent.  It is not too easy when response
is extremely slow.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
