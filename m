From: akpm@linux-foundation.org
Subject: [patch 267/307] ext3: fdatasync should skip metadata writeout when overwriting
Date: Mon, 28 Apr 2008 02:16:05 -0700
Message-ID: <200804280916.m3S9G5kd019121@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hifumi.hisashi@oss.ntt.co.jp,
	jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932991AbYD1JVW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:21:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

 fs/ext3/fsync.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ext3/fsync.c~ext3-fdatasync-should-skip-metadata-writeout-when-overwriting fs/ext3/fsync.c
--- a/fs/ext3/fsync.c~ext3-fdatasync-should-skip-metadata-writeout-when-overwriting
+++ a/fs/ext3/fsync.c
@@ -72,6 +72,9 @@ int ext3_sync_file(struct file * file, s
 		goto out;
 	}
 
+	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+		goto out;
+
 	/*
 	 * The VFS has written the file data.  If the inode is unaltered
 	 * then we need not start a commit.
_
