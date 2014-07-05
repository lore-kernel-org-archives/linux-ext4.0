From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Sat, 05 Jul 2014 13:53:34 +0000
Message-ID: <bug-42723-13602-T20dyiQ9x1@https.bugzilla.kernel.org/>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaGENxh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 09:53:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8DB39203EB
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jul 2014 13:53:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BA98C202A1
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jul 2014 13:53:34 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

--- Comment #19 from Theodore Tso <tytso@mit.edu> ---
The EXT4-fs error reported by "ext4_mb_generate_buddy" simply means that there
is an inconsistency between the block allocation bitmap and the number of free
blocks reported in a particular block group descriptor.   An e2fsck should fix
this.

There are some people who are reporting that it is showing up more frequently
in 3.15, but the problem is there can be multiple causes of this inconsistency.
 It can be caused by a hardware problem; it can be caused by flash devices that
don't handle power failures gracefully; etc, etc.

If you can reliably reproduce it, and it doesn't reliably reproduce on an older
kernel, then it becomes interesting.

As far as "error count" message, this simply means that an EXT4-fs error has
been reported since the last time the file system was checked using e2fsck.  It
will be displayed once every 24 hours, so that system administrators hopefully
get the hinit and get their file system repaired before they lose catastrophic
amounts of data.  The format is confusing, and we will be trying to make the
error messages more clear.  In particular "initial error at 1404174299" will
probably need to get changed to something like "first error since e2fsck
happened at time 1404174299", which is the number of seconds since January 1,
1970 --- since the kernel doesn't have time zone information.  You can convert
that into a human readable time stamp as follows:

% date -d @1404174299
Mon Jun 30 20:24:59 EDT 2014

The "error count" message will get cleared by e2fsck, so long as you are using
a version of e2fsck newer than 1.41.13, released in December 2010.  People who
upgrade their kernels without upgrading e2fsck can get into a situation where
they continuously get the error count message even though they have gotten
their file system checked.  But if you are using that ancient version of
e2fsprogs, you **really** want to upgrade to a newer version, just because of
the huge number of bugs fixed in the last 3.5 years.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
