From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Fri,  6 Mar 2009 12:21:20 -0800 (PST)
Message-ID: <20090306202120.BF7D1108041@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZCFUVn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 15:21:43 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n26KLLrG023146
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 12:21:22 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #11 from sandeen@redhat.com  2009-03-06 12:21 -------
Ok, at least w/ e2fsprogs-1.41.4 the fs doesn't look too bad:

# e2fsck -fn sdb1.e2i 
e2fsck 1.41.4 (27-Jan-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (102518871, counted=100960243).
Fix? no

Free inodes count wrong (90170045, counted=90170006).
Fix? no


LargeData: ********** WARNING: Filesystem still has errors **********

LargeData: 7491/90177536 files (39.4% non-contiguous), 258164220/360683091
blocks

the inode in question:

debuge4fs:  ncheck 2621457
Inode   Pathname
2621457 /mysql/0004_rldb/fw1log20090302.MYI

is pretty fragmented:

# filefrag mysql/0004_rldb/fw1log20090302.MYI
File is stored in extents format
mysql/0004_rldb/fw1log20090302.MYI: 5820 extents found

There is a really large number of indirect (i.e. extent index) blocks in that
file:

# debugfs -c sdb1.e2i -R "stat <2621457>" | sed -e "s/, /\n/g" | grep IND | wc
-l
debugfs 1.41.4 (27-Jan-2009)
sdb1.e2i: catastrophic mode - not reading inode or group bitmaps
2730

I would still try my patch.

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
