From: akpm@linux-foundation.org
Subject: - vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:12 -0700
Message-ID: <200804162255.m3GMtCal011094@imap1.linux-foundation.org>
To: jack@suse.cz, davej@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759243AbYDPXBu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     vfs: fix possible deadlock in ext2, ext3, ext4 when using xattrs
has been removed from the -mm tree.  Its filename was
     vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix possible deadlock in ext2, ext3, ext4 when using xattrs
From: Jan Kara <jack@suse.cz>

mb_cache_entry_alloc() was allocating cache entries with GFP_KERNEL.  But
filesystems are calling this function while holding xattr_sem so possible
recursion into the fs violates locking ordering of xattr_sem and transaction
start / i_mutex for ext2-4.  Change mb_cache_entry_alloc() so that filesystems
can specify desired gfp mask and use GFP_NOFS from all of them.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Dave Jones <davej@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/xattr.c         |    2 +-
 fs/ext3/xattr.c         |    2 +-
 fs/ext4/xattr.c         |    2 +-
 fs/mbcache.c            |    4 ++--
 include/linux/mbcache.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ext2/xattr.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs
+++ a/fs/ext2/xattr.c
@@ -835,7 +835,7 @@ ext2_xattr_cache_insert(struct buffer_he
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext2_xattr_cache);
+	ce = mb_cache_entry_alloc(ext2_xattr_cache, GFP_NOFS);
 	if (!ce)
 		return -ENOMEM;
 	error = mb_cache_entry_insert(ce, bh->b_bdev, bh->b_blocknr, &hash);
diff -puN fs/ext3/xattr.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs
+++ a/fs/ext3/xattr.c
@@ -1126,7 +1126,7 @@ ext3_xattr_cache_insert(struct buffer_he
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext3_xattr_cache);
+	ce = mb_cache_entry_alloc(ext3_xattr_cache, GFP_NOFS);
 	if (!ce) {
 		ea_bdebug(bh, "out of memory");
 		return;
diff -puN fs/ext4/xattr.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs
+++ a/fs/ext4/xattr.c
@@ -1386,7 +1386,7 @@ ext4_xattr_cache_insert(struct buffer_he
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext4_xattr_cache);
+	ce = mb_cache_entry_alloc(ext4_xattr_cache, GFP_NOFS);
 	if (!ce) {
 		ea_bdebug(bh, "out of memory");
 		return;
diff -puN fs/mbcache.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs fs/mbcache.c
--- a/fs/mbcache.c~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs
+++ a/fs/mbcache.c
@@ -399,11 +399,11 @@ mb_cache_destroy(struct mb_cache *cache)
  * if no more memory was available.
  */
 struct mb_cache_entry *
-mb_cache_entry_alloc(struct mb_cache *cache)
+mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 {
 	struct mb_cache_entry *ce;
 
-	ce = kmem_cache_alloc(cache->c_entry_cache, GFP_KERNEL);
+	ce = kmem_cache_alloc(cache->c_entry_cache, gfp_flags);
 	if (ce) {
 		atomic_inc(&cache->c_entry_count);
 		INIT_LIST_HEAD(&ce->e_lru_list);
diff -puN include/linux/mbcache.h~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs include/linux/mbcache.h
--- a/include/linux/mbcache.h~vfs-fix-possible-deadlock-in-ext2-ext3-ext4-when-using-xattrs
+++ a/include/linux/mbcache.h
@@ -34,7 +34,7 @@ void mb_cache_destroy(struct mb_cache *)
 
 /* Functions on cache entries */
 
-struct mb_cache_entry *mb_cache_entry_alloc(struct mb_cache *);
+struct mb_cache_entry *mb_cache_entry_alloc(struct mb_cache *, gfp_t);
 int mb_cache_entry_insert(struct mb_cache_entry *, struct block_device *,
 			  sector_t, unsigned int[]);
 void mb_cache_entry_release(struct mb_cache_entry *);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
git-dvb.patch
git-udf.patch
git-ocfs2.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext3-fix-update-of-mtime-and-ctime-on-rename.patch
ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext3-fix-mount-messages-when-quota-disabled.patch
reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-use-get-put_unaligned_-helpers.patch

