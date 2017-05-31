From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 12/17] fs: allow __generic_file_fsync to support both flavors of error reporting
Date: Wed, 31 May 2017 08:45:35 -0400
Message-ID: <20170531124540.8782-13-jlayton@redhat.com>
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

For now, we add a FS_WB_ERRSEQ check to know how to handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/libfs.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 1dec90819366..2ae58a252718 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -971,10 +971,18 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 				 int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
-	int err;
-	int ret;
-
-	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	int err, ret;
+	bool use_errseq = inode->i_sb->s_type->fs_flags & FS_WB_ERRSEQ;
+	errseq_t since;
+
+	if (use_errseq) {
+		since = READ_ONCE(file->f_wb_err);
+		err = filemap_write_and_wait_range_since(inode->i_mapping,
+				start, end, since);
+	} else {
+		err = filemap_write_and_wait_range(inode->i_mapping,
+							start, end);
+	}
 	if (err)
 		return err;
 
@@ -988,11 +996,15 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 	err = sync_inode_metadata(inode, 1);
 	if (ret == 0)
 		ret = err;
-
 out:
 	inode_unlock(inode);
-	err = filemap_check_errors(inode->i_mapping);
-	return ret ? ret : err;
+	if (ret == 0) {
+		if (use_errseq)
+			err = filemap_check_wb_err(inode->i_mapping, since);
+		else
+			err = filemap_check_errors(inode->i_mapping);
+	}
+	return ret;
 }
 EXPORT_SYMBOL(__generic_file_fsync);
 
-- 
2.9.4
