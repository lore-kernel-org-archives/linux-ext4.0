From: akpm@linux-foundation.org
Subject: - ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:29:12 -0700
Message-ID: <200710192329.l9JNTCXi025800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch

This patch was dropped because it was folded into ext2-avoid-rec_len-overflow-with-64kb-block-size.patch

------------------------------------------------------
Subject: ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "(foo*)" should be "(foo *)"
#58: FILE: fs/ext2/dir.c:225:
+       return (ext2_dirent *)((char*)p +

ERROR: "(foo*)" should be "(foo *)"
#115: FILE: fs/ext2/dir.c:572:
+       unsigned to = ((char*)dir - kaddr) +

total: 2 errors, 0 warnings, 123 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext2/dir.c~ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes
+++ a/fs/ext2/dir.c
@@ -222,7 +222,7 @@ static inline int ext2_match (int len, c
  */
 static inline ext2_dirent *ext2_next_entry(ext2_dirent *p)
 {
-	return (ext2_dirent *)((char*)p +
+	return (ext2_dirent *)((char *)p +
 			ext2_rec_len_from_disk(p->rec_len));
 }
 
@@ -569,7 +569,7 @@ int ext2_delete_entry (struct ext2_dir_e
 	struct inode *inode = mapping->host;
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(ext2_chunk_size(inode)-1);
-	unsigned to = ((char*)dir - kaddr) +
+	unsigned to = ((char *)dir - kaddr) +
 				ext2_rec_len_from_disk(dir->rec_len);
 	loff_t pos;
 	ext2_dirent * pde = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
