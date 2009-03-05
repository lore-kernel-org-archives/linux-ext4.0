From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 10:13:18 -0800 (PST)
Message-ID: <20090305181318.EDC1A108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbZCESNs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 13:13:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25IDJlw012511
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 10:13:20 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #4 from tytso@mit.edu  2009-03-05 10:13 -------
The error messages you are seeing are the result of the filesystem being
corrupted.  The kernel will continue to printk those messages until the
filesystem is fixed.   The fact that the fsck died with exit status 1 probably
means you need to upgrade to e2fsprogs 1.41.4 (1.41.3 and earlier e2fsck had a
bug that would be triggered by certain types of corruption).

Are you willing to try a newer kernel?   This looks familiar and I think it's
fixed in the latest 2.6.29-rc7 kernel.  I'll need to go back and figure out
which bug fix this is most likely related to, and check whether it's been
backported to the 2.6.27.y stable series.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
