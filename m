From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] ext3,4:fdatasync should skip metadata
  writeout when overwriting
Date: Thu, 07 Feb 2008 15:45:07 +0900
Message-ID: <6.0.0.20.2.20080207154342.03ac7a08@172.19.0.2>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
 <20071115185919.7df4cda9.akpm@linux-foundation.org>
 <6.0.0.20.2.20080204181941.03f60eb0@172.19.0.2>
 <20080206162231.GA23382@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	adilger@sun.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080206162231.GA23382@atrey.karlin.mff.cuni.cz>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
 <20071115185919.7df4cda9.akpm@linux-foundation.org>
 <6.0.0.20.2.20080204181941.03f60eb0@172.19.0.2>
 <20080206162231.GA23382@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>  Yes, the patch looks fine. You can add
>Acked-by: Jan Kara <jack@suse.cz>
>  if you wish.
>								Honza

Thank you for your comment.
Please merge my patch.

Thanks.

[PATCH] ext3,4:fdatasync should skip metadata writeout when overwriting

Currently fdatasync is identical to fsync in ext3,4.
I think fdatasync should skip journal flush in data=ordered and data=writeback mode
when it overwrites to already-instantiated blocks on HDD.
When I_DIRTY_DATASYNC flag is not set, fdatasync should skip journal writeout
because this indicates only atime or/and mtime updates.  

Following patch is the same approach of ext2's fsync code(ext2_sync_file).

I did a performance test using the sysbench.

#sysbench --num-threads=128 --max-requests=50000 --test=fileio --file-total-size=128G 
--file-test-mode=rndwr --file-fsync-mode=fdatasync run

The result was:

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

diff -Nrup linux-2.6.24.org/fs/ext3/fsync.c linux-2.6.24/fs/ext3/fsync.c
--- linux-2.6.24.org/fs/ext3/fsync.c	2008-01-25 07:58:37.000000000 +0900
+++ linux-2.6.24/fs/ext3/fsync.c	2008-02-04 12:42:42.000000000 +0900
@@ -72,6 +72,9 @@ int ext3_sync_file(struct file * file, s
 		goto out;
 	}
 
+	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+		goto out;
+
 	/*
 	* The VFS has written the file data.  If the inode is unaltered
 	* then we need not start a commit.
diff -Nrup linux-2.6.24.org/fs/ext4/fsync.c linux-2.6.24/fs/ext4/fsync.c
--- linux-2.6.24.org/fs/ext4/fsync.c	2008-01-25 07:58:37.000000000 +0900
+++ linux-2.6.24/fs/ext4/fsync.c	2008-02-04 12:43:37.000000000 +0900
@@ -72,6 +72,9 @@ int ext4_sync_file(struct file * file, s
 		goto out;
 	}
 
+        if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+                goto out;
+
 	/*
 	* The VFS has written the file data.  If the inode is unaltered
 	* then we need not start a commit.

