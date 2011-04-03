From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Sun, 3 Apr 2011 03:43:58 GMT
Message-ID: <201104030343.p333hwd5003652@demeter2.kernel.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35232 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1DCDn7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 23:43:59 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p333hwRN003653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 3 Apr 2011 03:43:58 GMT
In-Reply-To: <bug-32482-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482





--- Comment #8 from Theodore Tso <tytso@mit.edu>  2011-04-03 03:43:57 ---
This message will get reset if you use the e2fsck from e2fsprogs
1.41.13 or later.  I recommend using e2fsprogs 1.41.14.

You can translate the "initial error" and "last error" time stamps in
the kernel messages here:

kernel: EXT4-fs (sda10): error count: 5
kernel: EXT4-fs (sda10): initial error at 1301325048:
htree_dirblock_to_tree:586: inode 260099: block 1056737
kernel: EXT4-fs (sda10): last error at 1301325083: htree_dirblock_to_tree:586:
inode 260099: block 1056737

via the date command:

% date --date=@1301325048
Mon Mar 28 11:10:48 EDT 2011

% date --date=@1301325083
Mon Mar 28 11:11:23 EDT 2011

(We use seconds since the epoch because we don't want to put time zone
conversion routines in the kernel.)

In any case, it's not a big deal, and you can fix this easily by
upgrading to a newer version of e2fsprogs.

                            - Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
