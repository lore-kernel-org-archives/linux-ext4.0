From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v7 16/22] block: convert to errseq_t based writeback error tracking
Date: Fri, 16 Jun 2017 15:34:21 -0400
Message-ID: <20170616193427.13955-17-jlayton@redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
	Eryu Guan <eguan@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
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
In-Reply-To: <20170616193427.13955-1-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

This is a very minimal conversion to errseq_t based error tracking
for raw block device access.

Only real change that is strictly required is that we must
unconditionally call filemap_report_wb_err in blkdev_fsync.
That ensures that the file's errseq_t is always advanced to
the latest value in the mapping.

Note that there are internal callers that call sync_blockdev
and the like that are not affected by this. They'll continue
to use the AS_EIO/AS_ENOSPC flags for error reporting like
they always have for now.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/block_dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index dc839f8f0ba5..9e8e13b097ef 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -625,11 +625,11 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *bd_inode = bdev_file_inode(filp);
 	struct block_device *bdev = I_BDEV(bd_inode);
-	int error;
+	int error, wberr;
 	
 	error = filemap_write_and_wait_range(filp->f_mapping, start, end);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * There is no need to serialise calls to blkdev_issue_flush with
@@ -640,6 +640,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	if (error == -EOPNOTSUPP)
 		error = 0;
 
+out:
+	wberr = filemap_report_wb_err(filp);
+	if (!error)
+		error = wberr;
 	return error;
 }
 EXPORT_SYMBOL(blkdev_fsync);
-- 
2.13.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
