From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 05/27] btrfs:
	btrfs_wait_tree_block_writeback can be void return
Date: Tue,  9 May 2017 11:49:08 -0400
Message-ID: <20170509154930.29524-6-jlayton@redhat.com>
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

Nothing checks its return value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/disk-io.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eb1ee7b6f532..8c479bd5534a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1222,10 +1222,10 @@ int btrfs_write_tree_block(struct extent_buffer *buf)
 					buf->start + buf->len - 1);
 }
 
-int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
+void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
 {
-	return filemap_fdatawait_range(buf->pages[0]->mapping,
-				       buf->start, buf->start + buf->len - 1);
+	filemap_fdatawait_range(buf->pages[0]->mapping,
+			        buf->start, buf->start + buf->len - 1);
 }
 
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 2e0ec29bfd69..9cc87835abb5 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -127,7 +127,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			extent_submit_bio_hook_t *submit_bio_done);
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
 int btrfs_write_tree_block(struct extent_buffer *buf);
-int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
+void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
-- 
2.9.3
