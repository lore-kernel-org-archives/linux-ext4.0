From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 09:46:12 -0800 (PST)
Message-ID: <20090305174612.46122108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbZCERqp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 12:46:45 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25HkC4k010195
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 09:46:13 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #2 from ddi@dubex.dk  2009-03-05 09:46 -------
It continually spews messages in syslog while it's powered on, but that's not
exactly "reproduction" I guess.

Tried to find the inode in question with debugfs, it said that this particular
inode does not belong to any file - maybe because the inode contains filesystem
metadata, not file data?  Anyhow, no useful output - probably in no small part
because I have no clue what I'm doing with debugfs ;-)

New kernel: Okay, upgraded to the latest available Ubuntu Server kernel.  Had
to yank the power; the sync would never finish (vmstat says it synced about
1kB/s).  Looks like the filesystem is also super-slow for some reason.

(Possible that a logging daemon was putting error messages in the buffer cache
while the sync got farther and farther behind trying to sync those, not sure. 
Did kill all loggers at one point, but didn't help much.  Hmm.)

It came up with the new kernel, did a fsck, which finished off with "fsck died
with exit status 1".

Will try e2image in a moment..


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
