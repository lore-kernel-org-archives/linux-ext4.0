From: akpm@osdl.org
Subject: - ext4-uninline-ext4_get_group_no_and_offset.patch removed from -mm tree
Date: Wed, 11 Oct 2006 17:04:31 -0700
Message-ID: <200610120004.k9C04V2Q008070@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60586 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030326AbWJLAUc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 20:20:32 -0400
To: akpm@osdl.org, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext4 uninline ext4_get_group_no_and_offset()

has been removed from the -mm tree.  Its filename is

     ext4-uninline-ext4_get_group_no_and_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
revert-pci-quirk-for-ibm-dock-ii-cardbus-controllers.patch
git-acpi.patch
i386-acpi-build-fix.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
git-cifs-fixup.patch
cifs-kconfig-dont-select-connector.patch
git-dvb-build-fix.patch
w1-kconfig-fix.patch
git-geode-fixup.patch
git-gfs2.patch
git-infiniband.patch
git-input-fixup.patch
git-libata-all.patch
mtd-maps-support-for-bios-flash-chips-on-intel-esb2-southbridge.patch
git-netdev-all.patch
libphy-dont-do-that.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-pcmcia-fixup.patch
git-serial-fixup.patch
git-scsi-target-fixup.patch
git-scsi-target-vs-git-block.patch
fix-gregkh-usb-usbatm-fix-tiny-race.patch
xpad-dance-pad-support.patch
git-watchdog.patch
x86_64-dump_trace-atomicity-fix.patch
spinlock-debug-all-cpu-backtrace.patch
spinlock-debug-all-cpu-backtrace-fix.patch
spinlock-debug-all-cpu-backtrace-fix-2.patch
spinlock-debug-all-cpu-backtrace-fix-3.patch
xfs-rename-uio_read.patch
touchkit-ps-2-touchscreen-driver-regs-fix.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
add-address_space_operationsbatch_write.patch
add-config_headers_check-option-to-automatically-run-make-headers_check-nobble.patch
kbuild-dont-put-temp-files-in-the-source-tree.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
bug-test-1.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
fs-cache-provide-a-filesystem-specific-syncable-page-bit-ext4.patch
fs-cache-make-kafs-use-fs-cache-fix.patch
fs-cache-make-kafs-use-fs-cache-vs-streamline-generic_file_-interfaces-and-filemap.patch
nfs-use-local-caching-12-fix.patch
fs-cache-cachefiles-a-cache-that-backs-onto-a-mounted-filesystem-log2-fix.patch
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
gtod-persistent-clock-support-i386.patch
hrtimers-state-tracking.patch
clockevents-drivers-for-i386.patch
gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
kevent-core-files-fix.patch
kevent-core-files-s390-hack.patch
kevent-socket-notifications-fix-2.patch
kevent-socket-notifications-fix-4.patch
kevent-timer-notifications-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
jmicron-warning-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

