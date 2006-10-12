From: akpm@osdl.org
Subject: - ext4-64-bit-divide-fix.patch removed from -mm tree
Date: Wed, 11 Oct 2006 17:04:33 -0700
Message-ID: <200610120004.k9C04XIP008073@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:65450 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030326AbWJLAUf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 20:20:35 -0400
To: akpm@osdl.org, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext4 64 bit divide fix

has been removed from the -mm tree.  Its filename is

     ext4-64-bit-divide-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4 64 bit divide fix
From: Andrew Morton <akpm@osdl.org>

With CONFIG_LBD=n, sector_div() expands to a plain old divide.  But ext4 is
_not_ passing in a sector_t as the first argument, so...

fs/built-in.o: In function `ext4_get_group_no_and_offset':
fs/ext4/balloc.c:39: undefined reference to `__umoddi3'
fs/ext4/balloc.c:41: undefined reference to `__udivdi3'
fs/built-in.o: In function `find_group_orlov':
fs/ext4/ialloc.c:278: undefined reference to `__udivdi3'
fs/built-in.o: In function `ext4_fill_super':
fs/ext4/super.c:1488: undefined reference to `__udivdi3'
fs/ext4/super.c:1488: undefined reference to `__umoddi3'
fs/ext4/super.c:1594: undefined reference to `__udivdi3'
fs/ext4/super.c:1601: undefined reference to `__umoddi3'

Fix that up by calling do_div() directly.

Also cast the arg to u64.  do_div() is only defined on u64, and ext4_fsblk_t
is supposed to be opaque.

Note especially the changes to find_group_orlov().  It was attempting to do

	do_div(int, unsigned long long);

which is royally screwed up.  Switched it to plain old divide.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |    2 +-
 fs/ext4/ialloc.c |    6 +++---
 fs/ext4/super.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-64-bit-divide-fix fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-64-bit-divide-fix
+++ a/fs/ext4/balloc.c
@@ -34,7 +34,7 @@ void ext4_get_group_no_and_offset(struct
 	ext4_grpblk_t offset;
 
         blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-        offset = sector_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
+	offset = do_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
 	if (offsetp)
 		*offsetp = offset;
 	if (blockgrpp)
diff -puN fs/ext4/ialloc.c~ext4-64-bit-divide-fix fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~ext4-64-bit-divide-fix
+++ a/fs/ext4/ialloc.c
@@ -275,7 +275,7 @@ static int find_group_orlov(struct super
 	avefreei = freei / ngroups;
 	freeb = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	avefreeb = freeb;
-	sector_div(avefreeb, ngroups);
+	do_div(avefreeb, ngroups);
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
 	if ((parent == sb->s_root->d_inode) ||
@@ -305,14 +305,14 @@ static int find_group_orlov(struct super
 	}
 
 	blocks_per_dir = ext4_blocks_count(es) - freeb;
-	sector_div(blocks_per_dir, ndirs);
+	do_div(blocks_per_dir, ndirs);
 
 	max_dirs = ndirs / ngroups + inodes_per_group / 16;
 	min_inodes = avefreei - inodes_per_group / 4;
 	min_blocks = avefreeb - EXT4_BLOCKS_PER_GROUP(sb) / 4;
 
 	max_debt = EXT4_BLOCKS_PER_GROUP(sb);
-	sector_div(max_debt, max(blocks_per_dir, (ext4_fsblk_t)BLOCK_COST));
+	max_debt /= max_t(int, blocks_per_dir, BLOCK_COST);
 	if (max_debt * INODE_COST > inodes_per_group)
 		max_debt = inodes_per_group / INODE_COST;
 	if (max_debt > 255)
diff -puN fs/ext4/super.c~ext4-64-bit-divide-fix fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-64-bit-divide-fix
+++ a/fs/ext4/super.c
@@ -1485,7 +1485,7 @@ static int ext4_fill_super (struct super
 	 */
 	if (blocksize != EXT4_MIN_BLOCK_SIZE) {
 		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = sector_div(logic_sb_block, blocksize);
+		offset = do_div(logic_sb_block, blocksize);
 	} else {
 		logic_sb_block = sb_block;
 	}
@@ -1591,7 +1591,7 @@ static int ext4_fill_super (struct super
 		brelse (bh);
 		sb_set_blocksize(sb, blocksize);
 		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = sector_div(logic_sb_block, blocksize);
+		offset = do_div(logic_sb_block, blocksize);
 		bh = sb_bread(sb, logic_sb_block);
 		if (!bh) {
 			printk(KERN_ERR
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

