From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 06/27] fs: check for writeback errors
	after syncing out buffers in generic_file_fsync
Date: Tue,  9 May 2017 11:49:09 -0400
Message-ID: <20170509154930.29524-7-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, mawilcox@microsoft.com, neilb@suse.de,
	corbet@lwn.net, josef@toxicpanda.com, dhowells@redhat.com,
	clm@fb.com, bo.li.liu@oracle.com, viro@zeniv.linux.org.uk,
	jack@suse.com, akpm@linux-foundation.org,
	ross.zwisler@linux.intel.com, hubcap@omnibond.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, cluster-devel@redhat.com,
	linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	linux-block@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

ext2 currently does a test+clear of the AS_EIO flag, which is
is problematic for some coming changes.

What we really need to do instead is call filemap_check_errors
in __generic_file_fsync after syncing out the buffers. That
will be sufficient for this case, and help other callers detect
these errors properly as well.

With that, we don't need to twiddle it in ext2.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/file.c | 2 +-
 fs/libfs.c     | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index b21891a6bfca..ed00e7ae0ef3 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -177,7 +177,7 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
 	ret = generic_file_fsync(file, start, end, datasync);
-	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
+	if (ret == -EIO) {
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
 			   "detected IO error when writing metadata buffers");
diff --git a/fs/libfs.c b/fs/libfs.c
index a8b62e5d43a9..efd23040ab25 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -991,7 +991,8 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 
 out:
 	inode_unlock(inode);
-	return ret;
+	err = filemap_check_errors(inode->i_mapping);
+	return ret ? ret : err;
 }
 EXPORT_SYMBOL(__generic_file_fsync);
 
-- 
2.9.3
