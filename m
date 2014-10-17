From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Fri, 17 Oct 2014 16:10:37 +0000
Message-ID: <bug-86471-13602-j8BGLrBaa5@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35100 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaJQQKk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Oct 2014 12:10:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0455D2021A
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2014 16:10:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 832DD2020E
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2014 16:10:37 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=86471

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
The mballoc_debug is only debugging the block allocator, which I suspect is not
the source of the slow down.   It might be better to use blktrace so we can see
what sort of I/O requests are being sent when mysql is shut down.

Does the performance go back to an acceptable level some time after the mysql
daemon is shut down?  It might be that mysql is simply writing out a lot of
things at shutdown, and this is causing the eMMC device to be slowed down due
to competing I/O traffic sent to it.

Another tool that is useful for monitoring write performance is to use "iostat
-x 1".  This will show you how much I/O is being done by the whole system, as
well as seeing if there is any backlog on the I/O request queues.

Your using dd to measure write performance is much like complaining that a
single car that is trying to get from point A to point B during rush hour is
taking a long time.   That does not necessarily mean that the highway is
defective!  It could be that there is simply a lot of competing traffic (i.e.,
other cars, aka other write requests from other processes on the system) which
is slowing down the traffic on the system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
