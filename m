From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: fsck.ext4 returning false positives
Date: Wed, 27 Feb 2013 15:16:22 -0600
Message-ID: <20130227211622.GF31803@atlantis.cc.ndsu.nodak.edu>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atlantis.cc.ndsu.NoDak.edu ([134.129.106.24]:60375 "EHLO
	atlantis.cc.ndsu.nodak.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3B0Vr5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 16:47:57 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have a semi-large NFS file server (in terms of storage) that is
responsible for delivering storage to our Learning Management System (LMS).
About 6 months ago, we ran into file system corruption on said server
(at the time, we were using ext3).  After fixing the corruption, I decided
it would be a good idea to run a weekly fsck on the large file system in
hopes of heading off a situation where the file system gets re-mounted
read-only due to corruption.

The file system in question is 1.8TB in size, which took a _very_ long time
to check when using ext3 (thus the move to ext4).  Taking the system down
weekly to run a file system check was not feasible, so I used lvm/dm to
take a read-write snapshot of the volume.  I could then run fsck on the
snapshot volume without taking the system down.  I made sure to mount the
snap volume before running fsck so that the journal could do recovery.  The
steps I'm using are as follows:

- Snapshot volume (read-write)
- Mount snap volume (replay journal)
- Umount snap volume
- Run fsck on snap volume
- Remove snap volume

I migrated the file system to ext4 in December 2012 by copying the files
from the old file system to the new one (I didn't go the "upgrade" route).
I continued performing the weekly file system checks after migrating to
ext4 and starting seeing strange behavior when running fsck on a snapshot
volume.  Here is the output from this mornings fsck:

e2fsck 1.42.6 (21-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (133413770, counted=133413835).
Fix? no

Free inodes count wrong (118244509, counted=118244510).
Fix? no

/dev/sanvg2/bbcontent_snap: 2554723/120799232 files (0.5% non-contiguous),
349770870/483184640 blocks

This is the 3rd time fsck has indicated problems with the free block and inode
counts since migrating to ext4 in December 2012.  And each time I take the
server down to umount and fsck the file system, nothing is fixed or found
wrong with the file system.  I ran the check again this morning (with an updated
e2fsprogs) and got the same results:

e2fsck 1.42.7 (21-Jan-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (133197192, counted=133197331).
Fix? no

Free inodes count wrong (118242252, counted=118242254).
Fix? no

/dev/sanvg2/bbcontent_snap: 2556980/120799232 files (0.5% non-contiguous),
349987448/483184640 blocks

I'm not sure what's to blame for this problem. Any help would be
appreciated.  Server is running the following:

RHEL 5.9 x86_64
Kernel 3.4.29
e2fsprogs 1.42.7

Storage stack has the following:

[MD RAID1] -> [LVM - 2 LVs] -> [EXT4]

Thanks in advance,

Bryan
