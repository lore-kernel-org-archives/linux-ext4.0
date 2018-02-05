From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: quota problems with e2fsck -p?
Date: Mon, 5 Feb 2018 14:46:06 -0800
Message-ID: <20180205224606.GB4838@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbeBEWqK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Feb 2018 17:46:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

So I was test-driving my e2scrub patches the other night and saw this:

systemd[1]: Starting Online ext4 Metadata Check for /dev/sub3_raid/storage...
e2scrub@-dev-sub3_raid-storage[9332]:   Logical volume "storage.e2scrub" created.
e2scrub@-dev-sub3_raid-storage[9332]: sub3-raid-fs: Clearing orphaned inode 6950133 (uid=1021, gid=1021, mode=040700, size=4096)
e2scrub@-dev-sub3_raid-storage[9332]: sub3-raid-fs: Clearing orphaned inode 6952084 (uid=1021, gid=1021, mode=0100600, size=8388608)
e2scrub@-dev-sub3_raid-storage[9332]: sub3-raid-fs: clean, 6835947/121307136 files, 338587593/485198848 blocks
e2scrub@-dev-sub3_raid-storage[9332]: e2fsck 1.43.9~WIP-2018-02-03 (3-Feb-2018)
e2scrub@-dev-sub3_raid-storage[9332]: Pass 1: Checking inodes, blocks, and sizes
e2scrub@-dev-sub3_raid-storage[9332]: Pass 2: Checking directory structure
e2scrub@-dev-sub3_raid-storage[9332]: Pass 3: Checking directory connectivity
e2scrub@-dev-sub3_raid-storage[9332]: Pass 4: Checking reference counts
e2scrub@-dev-sub3_raid-storage[9332]: Pass 5: Checking group summary information
e2scrub@-dev-sub3_raid-storage[9332]: [QUOTA WARNING] Usage inconsistent for ID 1021:actual (618773123072, 4395080) != expected (618781515776, 4395082)
e2scrub@-dev-sub3_raid-storage[9332]: Update quota info for quota type 0? yes
e2scrub@-dev-sub3_raid-storage[9332]: [QUOTA WARNING] Usage inconsistent for ID 1021:actual (613615316992, 4507364) != expected (613623709696, 4507366)
e2scrub@-dev-sub3_raid-storage[9332]: Update quota info for quota type 1? yes
e2scrub@-dev-sub3_raid-storage[9332]: sub3-raid-fs: ***** FILE SYSTEM WAS MODIFIED *****
e2scrub@-dev-sub3_raid-storage[9332]: sub3-raid-fs: 6835947/121307136 files (0.9% non-contiguous), 338587593/485198848 blocks
e2scrub@-dev-sub3_raid-storage[9332]: Scrub of /dev/sub3_raid/storage FAILED due to invalid snapshot.
e2scrub@-dev-sub3_raid-storage[9332]:   Logical volume "storage.e2scrub" successfully removed
systemd[1]: e2scrub@-dev-sub3_raid-storage.service: Main process exited, code=exited, status=1/FAILURE
systemd[1]: Failed to start Online ext4 Metadata Check for /dev/sub3_raid/storage.
systemd[1]: e2scrub@-dev-sub3_raid-storage.service: Unit entered failed state.
systemd[1]: e2scrub@-dev-sub3_raid-storage.service: Triggering OnFailure= dependencies.
systemd[1]: e2scrub@-dev-sub3_raid-storage.service: Failed with result 'exit-code'.

It looks like all we have to do trigger the QUOTA WARNING is enable
quota, write a file, unlink the file (without closing it), snapshot the
fs, and then run e2fsck -p followed by e2fsck -fn on the snapshot.

Note that first we run e2fsck to preen the filesystem, then we run it again to
see if it spots any corruption.  The first run finds two orphaned inodes and
zaps them, but because of -p it's a short run and we don't update the quota
information.  As a result, the second run triggers on the quota information
being wrong and the whole job fails.

The orphan inode processing occurs as part of check_super_block ->
release_orphan_inodes prior to pass 1, which means that we've not set up any
quota context nor read the quota data in from disk.  Given that we don't end
up checking the quota accounting at all in a preening run, I'm a little
hesitant to just plumb in code to fetch the quota info, update the info when
we recover orphans, and then write the quota info back out.  But that does
seem to be what this situation requires.

So, I punt to the list instead -- is that crazy?

--Darrick
