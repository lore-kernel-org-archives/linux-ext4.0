From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/3 v3] Btrfs: implement our own ->llseek
Date: Thu,  5 May 2011 16:16:57 -0400
Message-ID: <1304626619-1588-2-git-send-email-josef@redhat.com>
References: <1304626619-1588-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	viro@ZenIV.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1304626619-1588-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In order to handle SEEK_HOLE/SEEK_DATA we need to implement our own llseek.
Basically for the normal SEEK_*'s we will just defer to the generic helper, and
for SEEK_HOLE/SEEK_DATA we will use our fiemap helper to figure out the nearest
hole or data.  Currently this helper doesn't check for delalloc bytes for
prealloc space, so for now treat prealloc as data until that is fixed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
v2->v3: added a cond_resched() to the while loop
 fs/btrfs/ctree.h |    3 +
 fs/btrfs/file.c  |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 131 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d5f043e..d2991c8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2474,6 +2474,9 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
 			     u64 end, struct list_head *list);
 /* inode.c */
+struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+					   size_t pg_offset, u64 start, u64 len,
+					   int create);
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
 #if defined(ClearPageFsMisc) && !defined(ClearPageChecked)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd5e82e..3a1e401 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1406,8 +1406,135 @@ out:
 	return ret;
 }
 
+static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map *em;
+	struct extent_state *cached_state = NULL;
+	u64 lockstart = *offset;
+	u64 lockend = i_size_read(inode);
+	u64 start = *offset;
+	u64 len = i_size_read(inode);
+	u64 last_end = 0;
+	int ret = 0;
+
+	lockend = max_t(u64, BTRFS_I(inode)->root->sectorsize, lockend);
+	len = lockend;
+
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
+			 &cached_state, GFP_NOFS);
+
+	/*
+	 * Delalloc is such a pain.  If we have a hole and we have pending
+	 * delalloc for a portion of the hole we will get back a hole that
+	 * exists for the entire range since it hasn't been actually written
+	 * yet.  So to take care of this case we need to look for an extent just
+	 * before the position we want in case there is outstanding delalloc
+	 * going on here.
+	 */
+	if (origin == SEEK_HOLE && start != 0) {
+		if (start < root->sectorsize)
+			em = btrfs_get_extent_fiemap(inode, NULL, 0, 0,
+						     start, 0);
+		else
+			em = btrfs_get_extent_fiemap(inode, NULL, 0,
+						     start - root->sectorsize,
+						     root->sectorsize, 0);
+		if (IS_ERR(em)) {
+			ret = -ENXIO;
+			goto out;
+		}
+		last_end = em->start + em->len;
+		free_extent_map(em);
+	}
+
+	while (1) {
+		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
+		if (IS_ERR(em)) {
+			ret = -ENXIO;
+			break;
+		}
+
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			if (origin == SEEK_HOLE) {
+				u64 new_offset = max(em->start, start);
+				/*
+				 * If we are in the middle of a hole then move
+				 * to the next one, unless the previous range we
+				 * found ended here, which means we have a
+				 * delalloc range that is going to convert part
+				 * of this hole into data.
+				 */
+				if (new_offset == em->start ||
+				    (new_offset > em->start &&
+				     new_offset == last_end)) {
+					*offset = new_offset;
+					free_extent_map(em);
+					break;
+				}
+			}
+		} else {
+			if (origin == SEEK_DATA) {
+				if (em->start == start) {
+					*offset = em->start;
+					free_extent_map(em);
+					break;
+				}
+			}
+		}
+		start = em->start + em->len;
+		last_end = em->start + em->len;
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			free_extent_map(em);
+			ret = -ENXIO;
+			break;
+		}
+		free_extent_map(em);
+		cond_resched();
+	}
+out:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			     &cached_state, GFP_NOFS);
+	return ret;
+}
+
+static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	int ret;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+	case SEEK_CUR:
+		offset = generic_file_llseek_unlocked(file, offset, origin);
+		goto out;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		ret = find_desired_extent(inode, &offset, origin);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
+	}
+
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
+		return -EINVAL;
+	if (offset > inode->i_sb->s_maxbytes)
+		return -EINVAL;
+
+	/* Special lock needed here? */
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+out:
+	mutex_unlock(&inode->i_mutex);
+	return offset;
+}
+
 const struct file_operations btrfs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= btrfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read       = generic_file_aio_read,
-- 
1.7.2.3
