From: akpm@linux-foundation.org
Subject: - ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:03 -0800
Message-ID: <200802272217.m1RMH3uh000781@imap1.linux-foundation.org>
To: hifumi.hisashi@oss.ntt.co.jp, jack@suse.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760887AbYB0WVG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2008 17:21:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: fdatasync should skip metadata writeout when overwriting
has been removed from the -mm tree.  Its filename was
     ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fdatasync should skip metadata writeout when overwriting
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

Currently fdatasync is identical to fsync in ext3.

I think fdatasync should skip journal flush in data=ordered and
data=writeback mode when it overwrites to already-instantiated blocks on
HDD.  When I_DIRTY_DATASYNC flag is not set, fdatasync should skip journal
writeout because this indicates only atime or/and mtime updates.

Following patch is the same approach of ext2's fsync code(ext2_sync_file).

I did a performance test using the sysbench.

#sysbench --num-threads=128 --max-requests=50000 --test=fileio --file-total-size=128G
--file-test-mode=rndwr --file-fsync-mode=fdatasync run

The result on ext3 was:

	-2.6.24
	Operations performed:  0 Read, 50080 Write, 59600 Other = 109680 Total
	Read 0b  Written 782.5Mb  Total transferred 782.5Mb  (12.116Mb/sec)
	  775.45 Requests/sec executed

	Test execution summary:
	    total time:                          64.5814s
	    total number of events:              50080
	    total time taken by event execution: 3713.9836
	    per-request statistics:
	         min:                            0.0000s
	         avg:                            0.0742s
	         max:                            0.9375s
	         approx.  95 percentile:         0.2901s

	Threads fairness:
	    events (avg/stddev):           391.2500/23.26
	    execution time (avg/stddev):   29.0155/1.99

	-2.6.24-patched
	Operations performed:  0 Read, 50009 Write, 61596 Other = 111605 Total
	Read 0b  Written 781.39Mb  Total transferred 781.39Mb  (16.419Mb/sec)
	1050.83 Requests/sec executed

	Test execution summary:
	    total time:                          47.5900s
	    total number of events:              50009
	    total time taken by event execution: 2934.5768
	    per-request statistics:
 	         min:                            0.0000s
	         avg:                            0.0587s
 	         max:                            0.8938s
	         approx.  95 percentile:         0.1993s

	Threads fairness:
	    events (avg/stddev):           390.6953/22.64
	    execution time (avg/stddev):   22.9264/1.17

Filesystem I/O throughput was improved.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/fsync.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ext4/fsync.c~ext4-fdatasync-should-skip-metadata-writeout-when-overwriting fs/ext4/fsync.c
--- a/fs/ext4/fsync.c~ext4-fdatasync-should-skip-metadata-writeout-when-overwriting
+++ a/fs/ext4/fsync.c
@@ -72,6 +72,9 @@ int ext4_sync_file(struct file * file, s
 		goto out;
 	}
 
+        if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+                goto out;
+
 	/*
 	 * The VFS has written the file data.  If the inode is unaltered
 	 * then we need not start a commit.
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
