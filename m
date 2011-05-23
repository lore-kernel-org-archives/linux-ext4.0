From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/3] Btrfs: implement our own ->llseek V4
Date: Mon, 23 May 2011 17:43:10 -0400
Message-ID: <1306186991-1905-2-git-send-email-josef@redhat.com>
References: <1306186991-1905-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sunil.mushran@oracle.com, viro@ZenIV.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1EWVne (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 17:43:34 -0400
In-Reply-To: <1306186991-1905-1-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In order to handle SEEK_HOLE/SEEK_DATA we need to implement our own llseek.
Basically for the normal SEEK_*'s we will just defer to the generic helper, and
for SEEK_HOLE/SEEK_DATA we will use our fiemap helper to figure out the nearest
hole or data.  Currently this helper doesn't check for delalloc bytes for
prealloc space, so for now treat prealloc as data until that is fixed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V3->V4:
-Fix everything to pass Sunil's seek test that passes on Solaris
 fs/btrfs/ctree.h |    3 +
 fs/btrfs/file.c  |  148 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 150 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 522a39b..75e3ba6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2475,6 +2475,9 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
 			     u64 end, struct list_head *list);
 /* inode.c */
+struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+					   size_t pg_offset, u64 start, u64 len,
+					   int create);
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
 #if defined(ClearPageFsMisc) && !defined(ClearPageChecked)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd5e82e..15e4719 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1406,8 +1406,154 @@ out:
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
+	u64 orig_start = *offset;
+	u64 len = i_size_read(inode);
+	u64 last_end = 0;
+	int ret = 0;
+
+	lockend = max_t(u64, root->sectorsize, lockend);
+	if (lockend <= lockstart)
+		lockend = lockstart + root->sectorsize;
+
+	len = lockend - lockstart + 1;
+
+	len = max_t(u64, len, root->sectorsize);
+	if (inode->i_size == 0)
+		return -ENXIO;
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
+		if (start <= root->sectorsize)
+			em = btrfs_get_extent_fiemap(inode, NULL, 0, 0,
+						     root->sectorsize, 0);
+		else
+			em = btrfs_get_extent_fiemap(inode, NULL, 0,
+						     start - root->sectorsize,
+						     root->sectorsize, 0);
+		if (IS_ERR(em)) {
+			ret = -ENXIO;
+			goto out;
+		}
+		last_end = em->start + em->len;
+		if (em->block_start == EXTENT_MAP_DELALLOC)
+			last_end = min_t(u64, last_end, inode->i_size);
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
+			if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+				if (last_end <= orig_start) {
+					free_extent_map(em);
+					ret = -ENXIO;
+					break;
+				}
+			}
+
+			if (origin == SEEK_HOLE) {
+				*offset = start;
+				free_extent_map(em);
+				break;
+			}
+		} else {
+			if (origin == SEEK_DATA) {
+				if (em->block_start == EXTENT_MAP_DELALLOC) {
+					if (start >= inode->i_size) {
+						free_extent_map(em);
+						ret = -ENXIO;
+						break;
+					}
+				}
+
+				*offset = start;
+				free_extent_map(em);
+				break;
+			}
+		}
+
+		start = em->start + em->len;
+		last_end = em->start + em->len;
+
+		if (em->block_start == EXTENT_MAP_DELALLOC)
+			last_end = min_t(u64, last_end, inode->i_size);
+
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			free_extent_map(em);
+			ret = -ENXIO;
+			break;
+		}
+		free_extent_map(em);
+		cond_resched();
+	}
+	if (!ret)
+		*offset = min(*offset, inode->i_size);
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

