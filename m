From: akpm@osdl.org
Subject: + ext4-uninline-ext4_get_group_no_and_offset.patch added to -mm tree
Date: Thu, 05 Oct 2006 20:06:04 -0700
Message-ID: <200610060306.k96364ai015247@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62348 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751111AbWJFDGJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 23:06:09 -0400
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext4 uninline ext4_get_group_no_and_offset()

has been added to the -mm tree.  Its filename is

     ext4-uninline-ext4_get_group_no_and_offset.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4 uninline ext4_get_group_no_and_offset()
From: Andrew Morton <akpm@osdl.org>

Way too big to inline.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c        |   18 ++++++++++++++++++
 include/linux/ext4_fs.h |   22 ++--------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-uninline-ext4_get_group_no_and_offset fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-uninline-ext4_get_group_no_and_offset
+++ a/fs/ext4/balloc.c
@@ -25,6 +25,24 @@
  */
 
 /*
+ * Calculate the block group number and offset, given a block number
+ */
+void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
+		unsigned long *blockgrpp, ext4_grpblk_t *offsetp)
+{
+        struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	ext4_grpblk_t offset;
+
+        blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
+        offset = sector_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
+	if (offsetp)
+		*offsetp = offset;
+	if (blockgrpp)
+	        *blockgrpp = blocknr;
+
+}
+
+/*
  * The free blocks are managed by bitmaps.  A file system contains several
  * blocks groups.  Each group contains 1 bitmap block for blocks, 1 bitmap
  * block for inodes, N blocks for the inode table and data blocks.
diff -puN include/linux/ext4_fs.h~ext4-uninline-ext4_get_group_no_and_offset include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~ext4-uninline-ext4_get_group_no_and_offset
+++ a/include/linux/ext4_fs.h
@@ -769,26 +769,8 @@ ext4_group_first_block_no(struct super_b
  */
 #define ERR_BAD_DX_DIR	-75000
 
-/*
- * This function calculate the block group number and offset,
- * given a block number
- */
-
-static inline void ext4_get_group_no_and_offset(struct super_block * sb,
-                                ext4_fsblk_t blocknr, unsigned long* blockgrpp,
-                                ext4_grpblk_t *offsetp)
-{
-        struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	ext4_grpblk_t offset;
-
-        blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-        offset = sector_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
-	if (offsetp)
-		*offsetp = offset;
-	if (blockgrpp)
-	        *blockgrpp = blocknr;
-
-}
+void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
+			unsigned long *blockgrpp, ext4_grpblk_t *offsetp);
 
 /*
  * Function prototypes
_

Patches currently in -mm which might be from akpm@osdl.org are

i386-irqs-build-fix.patch
kauditd_thread-warning-fix.patch
revert-pci-quirk-for-ibm-dock-ii-cardbus-controllers.patch
fix-warn_on--warn_on_once-regression.patch
ext4_blk_type_from_sector_t_to_ulonglong-fix.patch
ext4-uninline-ext4_get_group_no_and_offset.patch
ext4-64-bit-divide-fix.patch
ext4-rename-logic_sb_block.patch
git-acpi.patch
acpi-preserve-correct-battery-state-through-suspend-resume-cycles-tidy.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
git-cifs-fixup.patch
cifs-kconfig-dont-select-connector.patch
w1-kconfig-fix.patch
git-geode-fixup.patch
git-input-fixup.patch
revert-input-make-input_openclose_device-more-robust.patch
libata-return-sense-data-in-hdio_drive_cmd-ioctl-tidy.patch
forcedeth-power-management-support-tidy.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-pcmcia-fixup.patch
git-serial-fixup.patch
pci-optionally-sort-device-lists-breadth-first-tweaks.patch
pci-optionally-sort-device-lists-breadth-first-force-on.patch
git-scsi-target-fixup.patch
git-scsi-target-vs-git-block.patch
xpad-dance-pad-support-tidy.patch
git-watchdog.patch
revert-x86_64-mm-mask-alignment.patch
x86_64-dump_trace-atomicity-fix.patch
spinlock-debug-all-cpu-backtrace.patch
spinlock-debug-all-cpu-backtrace-fix.patch
spinlock-debug-all-cpu-backtrace-fix-2.patch
spinlock-debug-all-cpu-backtrace-fix-3.patch
xfs-rename-uio_read.patch
get-rid-of-zone_table.patch
slab-reduce-numa-text-size-tidy.patch
swap-token-new-scheme-to-preempt-token-tidy.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
add-address_space_operationsbatch_write.patch
add-config_headers_check-option-to-automatically-run-make-headers_check-nobble.patch
kbuild-dont-put-temp-files-in-the-source-tree.patch
grow_buffers-infinite-loop-fix.patch
invalidate_inode_pages2_range-debug.patch
generic-implementatation-of-bug.patch
generic-implementatation-of-bug-fix.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
fs-cache-make-kafs-use-fs-cache-fix.patch
fs-cache-make-kafs-use-fs-cache-vs-streamline-generic_file_-interfaces-and-filemap.patch
nfs-use-local-caching-12-fix.patch
swap_prefetch-vs-zoned-counters.patch
readahead-sysctl-parameters.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-rename-generic_sounding_globalspatch-fix.patch
hpt3xx-rework-rate-filtering-tidy.patch
kevent-core-files-fix.patch
kevent-core-files-s390-hack.patch
kevent-socket-notifications-fix-2.patch
kevent-socket-notifications-fix-4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
jmicron-warning-fix.patch
squash-ipc-warnings.patch
squash-transmeta-warnings.patch
squash-udf-warnings.patch

