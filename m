From: jlayton@kernel.org
Subject: [PATCH v8 16/18] ext4: use errseq_t based error handling for reporting data writeback errors
Date: Thu, 29 Jun 2017 09:19:52 -0400
Message-ID: <20170629131954.28733-17-jlayton@kernel.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
	Eryu Guan <eguan@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Liu Bo <bo.li.liu@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	tytso@mit.edu,
	axboe@kernel.dk,
	mawilcox@microsoft.com,
	ross.zwisler@linux.intel.com,
	corbet@lwn.net,
	Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>,
	David Sterba <dsterba@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170629131954.28733-1-jlayton@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Add a call to filemap_report_wb_err at the end of ext4_sync_file. This
will ensure that we check and advance the errseq_t in the file, which
allows us to track and report errors on all open fds when they occur.

Note that metadata writeback errors are not yet reported on all fds at
this point. That will be added in a later patch.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext4/fsync.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 9d549608fd30..d7cf0934c71c 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -100,8 +100,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
-	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
-		return -EIO;
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb)))) {
+		ret = -EIO;
+		goto out;
+	}
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -124,9 +126,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
-	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	ret = file_write_and_wait_range(file, start, end);
 	if (ret)
-		return ret;
+		goto out;
+
 	/*
 	 * data=writeback,ordered:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
@@ -152,7 +155,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		needs_barrier = true;
 	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier) {
-	issue_flush:
+issue_flush:
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
 			ret = err;
-- 
2.13.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
