From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 09/17] block: convert to errseq_t based writeback error tracking
Date: Wed, 31 May 2017 08:45:32 -0400
Message-ID: <20170531124540.8782-10-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fairly straightforward conversion. In fsync, just use the file->f_wb_err
value as a "since" value. At the end, call filemap_report_wb_err to
advance the cursor in it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/block_dev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4d62fe771587..0d5f849e2a18 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -622,11 +622,13 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *bd_inode = bdev_file_inode(filp);
 	struct block_device *bdev = I_BDEV(bd_inode);
-	int error;
+	int error, wberr;
+	errseq_t since = READ_ONCE(filp->f_wb_err);
 	
-	error = filemap_write_and_wait_range(filp->f_mapping, start, end);
+	error = filemap_write_and_wait_range_since(filp->f_mapping, start,
+							end, since);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * There is no need to serialise calls to blkdev_issue_flush with
@@ -637,6 +639,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	if (error == -EOPNOTSUPP)
 		error = 0;
 
+out:
+	wberr = filemap_report_wb_err(filp);
+	if (!error)
+		error = wberr;
 	return error;
 }
 EXPORT_SYMBOL(blkdev_fsync);
@@ -801,6 +807,7 @@ static struct file_system_type bd_type = {
 	.name		= "bdev",
 	.mount		= bd_mount,
 	.kill_sb	= kill_anon_super,
+	.fs_flags	= FS_WB_ERRSEQ,
 };
 
 struct super_block *blockdev_superblock __read_mostly;
-- 
2.9.4
