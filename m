From: akpm@osdl.org
Subject: - ext4-rename-logic_sb_block.patch removed from -mm tree
Date: Wed, 11 Oct 2006 17:04:35 -0700
Message-ID: <200610120004.k9C04ZAM008076@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61866 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030489AbWJLAUd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 20:20:33 -0400
To: akpm@osdl.org, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext4: rename logic_sb_block

has been removed from the -mm tree.  Its filename is

     ext4-rename-logic_sb_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: rename logic_sb_block
From: Andrew Morton <akpm@osdl.org>

I assume this means "logical sb block".  So call it that.

I still don't understand the name though.  A block is a block.  What's
different about this one?

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/super.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN fs/ext4/super.c~ext4-rename-logic_sb_block fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-rename-logic_sb_block
+++ a/fs/ext4/super.c
@@ -1423,8 +1423,7 @@ static loff_t ext4_max_size(int bits)
 }
 
 static ext4_fsblk_t descriptor_loc(struct super_block *sb,
-				    ext4_fsblk_t logic_sb_block,
-				    int nr)
+				ext4_fsblk_t logical_sb_block, int nr)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long bg, first_meta_bg;
@@ -1434,7 +1433,7 @@ static ext4_fsblk_t descriptor_loc(struc
 
 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
 	    nr < first_meta_bg)
-		return (logic_sb_block + nr + 1);
+		return logical_sb_block + nr + 1;
 	bg = sbi->s_desc_per_block * nr;
 	if (ext4_bg_has_super(sb, bg))
 		has_super = 1;
@@ -1449,7 +1448,7 @@ static int ext4_fill_super (struct super
 	struct ext4_sb_info *sbi;
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
-	ext4_fsblk_t logic_sb_block;
+	ext4_fsblk_t logical_sb_block;
 	unsigned long offset = 0;
 	unsigned int journal_inum = 0;
 	unsigned long journal_devnum = 0;
@@ -1484,13 +1483,13 @@ static int ext4_fill_super (struct super
 	 * block sizes.  We need to calculate the offset from buffer start.
 	 */
 	if (blocksize != EXT4_MIN_BLOCK_SIZE) {
-		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logic_sb_block, blocksize);
+		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
+		offset = do_div(logical_sb_block, blocksize);
 	} else {
-		logic_sb_block = sb_block;
+		logical_sb_block = sb_block;
 	}
 
-	if (!(bh = sb_bread(sb, logic_sb_block))) {
+	if (!(bh = sb_bread(sb, logical_sb_block))) {
 		printk (KERN_ERR "EXT4-fs: unable to read superblock\n");
 		goto out_fail;
 	}
@@ -1590,9 +1589,9 @@ static int ext4_fill_super (struct super
 
 		brelse (bh);
 		sb_set_blocksize(sb, blocksize);
-		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logic_sb_block, blocksize);
-		bh = sb_bread(sb, logic_sb_block);
+		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
+		offset = do_div(logical_sb_block, blocksize);
+		bh = sb_bread(sb, logical_sb_block);
 		if (!bh) {
 			printk(KERN_ERR
 			       "EXT4-fs: Can't read superblock on 2nd try.\n");
@@ -1711,7 +1710,7 @@ static int ext4_fill_super (struct super
 	bgl_lock_init(&sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
-		block = descriptor_loc(sb, logic_sb_block, i);
+		block = descriptor_loc(sb, logical_sb_block, i);
 		sbi->s_group_desc[i] = sb_bread(sb, block);
 		if (!sbi->s_group_desc[i]) {
 			printk (KERN_ERR "EXT4-fs: "
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

