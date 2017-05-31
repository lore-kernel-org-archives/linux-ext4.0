From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 06/17] fs: adapt sync_file_range to new reporting infrastructure
Date: Wed, 31 May 2017 08:45:29 -0400
Message-ID: <20170531124540.8782-7-jlayton@redhat.com>
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

Since it returns errors in a way similar to fsync, have it use the same
method for returning previously-reported writeback errors.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/sync.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index ec93aac4feb9..819a81526714 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -275,8 +275,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int, fd)
  *
  *
  * SYNC_FILE_RANGE_WAIT_BEFORE and SYNC_FILE_RANGE_WAIT_AFTER will detect any
- * I/O errors or ENOSPC conditions and will return those to the caller, after
- * clearing the EIO and ENOSPC flags in the address_space.
+ * error condition that occurred prior to or after writeback, and will return
+ * that to the caller, while advancing the file's errseq_t cursor. Note that
+ * any errors returned here may have occurred in an area of the file that is
+ * not covered by the given range as most filesystems track writeback errors
+ * on a per-address_space basis
  *
  * It should be noted that none of these operations write out the file's
  * metadata.  So unless the application is strictly performing overwrites of
@@ -343,19 +346,25 @@ SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
 		ret = filemap_fdatawait_range(mapping, offset, endbyte);
 		if (ret < 0)
-			goto out_put;
+			goto out_report;
 	}
 
 	if (flags & SYNC_FILE_RANGE_WRITE) {
 		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
 						 WB_SYNC_NONE);
 		if (ret < 0)
-			goto out_put;
+			goto out_report;
 	}
 
 	if (flags & SYNC_FILE_RANGE_WAIT_AFTER)
 		ret = filemap_fdatawait_range(mapping, offset, endbyte);
 
+out_report:
+	if (mapping->host->i_sb->s_type->fs_flags & FS_WB_ERRSEQ) {
+		int ret2 = filemap_report_wb_err(f.file);
+		if (!ret)
+			ret = ret2;
+	}
 out_put:
 	fdput(f);
 out:
-- 
2.9.4
