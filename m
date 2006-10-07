From: akpm@osdl.org
Subject: + ext4-64-bit-divide-fix-fix.patch added to -mm tree
Date: Fri, 06 Oct 2006 20:19:42 -0700
Message-ID: <200610070319.k973Jgr4022943@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:26313 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932693AbWJGDTo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 23:19:44 -0400
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled

     ext4-64-bit-divide-fix-fix

has been added to the -mm tree.  Its filename is

     ext4-64-bit-divide-fix-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4-64-bit-divide-fix-fix
From: Andrew Morton <akpm@osdl.org>

The first arg to do_div() must be an lvalue.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-64-bit-divide-fix-fix fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-64-bit-divide-fix-fix
+++ a/fs/ext4/balloc.c
@@ -30,16 +30,17 @@
 void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 		unsigned long *blockgrpp, ext4_grpblk_t *offsetp)
 {
-        struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	ext4_grpblk_t offset;
+	u64 b;
 
-        blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-	offset = do_div((u64)blocknr, EXT4_BLOCKS_PER_GROUP(sb));
+	blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
+	b = blocknr;
+	offset = do_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
 	if (offsetp)
 		*offsetp = offset;
 	if (blockgrpp)
-	        *blockgrpp = blocknr;
-
+		*blockgrpp = b;
 }
 
 /*
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
revert-pci-quirk-for-ibm-dock-ii-cardbus-controllers.patch
ext4_blk_type_from_sector_t_to_ulonglong-fix.patch
ext4-uninline-ext4_get_group_no_and_offset.patch
ext4-64-bit-divide-fix.patch
ext4-64-bit-divide-fix-fix.patch
ext4-rename-logic_sb_block.patch
ext4-whitespace-cleanups.patch
git-acpi.patch
acpi-preserve-correct-battery-state-through-suspend-resume-cycles-tidy.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
git-cifs-fixup.patch
cifs-kconfig-dont-select-connector.patch
w1-kconfig-fix.patch
git-dvb-build-fix.patch
git-geode-fixup.patch
git-gfs2.patch
git-input-fixup.patch
libata-return-sense-data-in-hdio_drive_cmd-ioctl-tidy.patch
git-netdev-all.patch
libphy-dont-do-that.patch
forcedeth-power-management-support-tidy.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-pcmcia-fixup.patch
git-serial-fixup.patch
pci-optionally-sort-device-lists-breadth-first-tweaks.patch
pci-optionally-sort-device-lists-breadth-first-force-on.patch
git-scsi-target-fixup.patch
git-scsi-target-vs-git-block.patch
revert-gregkh-usb-usb-ehci-hcd-split-scan_periodic-to-reuse-code-for-spanned-completions.patch
xpad-dance-pad-support-tidy.patch
git-watchdog.patch
x86_64-dump_trace-atomicity-fix.patch
spinlock-debug-all-cpu-backtrace.patch
spinlock-debug-all-cpu-backtrace-fix.patch
spinlock-debug-all-cpu-backtrace-fix-2.patch
spinlock-debug-all-cpu-backtrace-fix-3.patch
xfs-rename-uio_read.patch
touchkit-ps-2-touchscreen-driver-regs-fix.patch
direct-io-sync-and-invalidate-file-region-when-falling-back-to-buffered-write-fixes.patch
get-rid-of-zone_table.patch
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
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
generic-implementatation-of-bug.patch
generic-implementatation-of-bug-fix.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
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

