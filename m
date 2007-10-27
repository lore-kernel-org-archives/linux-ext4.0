From: akpm@linux-foundation.org
Subject: + iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:45:35 -0700
Message-ID: <200710270745.l9R7jZrN003336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#31: FILE: fs/ext2/ext2.h:127:
+extern struct inode *ext2_iget (struct super_block *, unsigned long);

WARNING: no space between function name and open parenthesis '('
#43: FILE: fs/ext2/inode.c:1188:
+struct inode *ext2_iget (struct super_block *sb, unsigned long ino)

ERROR: "foo * bar" should be "foo *bar"
#50: FILE: fs/ext2/inode.c:1192:
+	struct ext2_inode * raw_inode;

total: 1 errors, 2 warnings, 161 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/inode.c~iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes fs/ext2/inode.c
--- a/fs/ext2/inode.c~iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes
+++ a/fs/ext2/inode.c
@@ -1189,7 +1189,7 @@ struct inode *ext2_iget (struct super_bl
 {
 	struct ext2_inode_info *ei;
 	struct buffer_head * bh;
-	struct ext2_inode * raw_inode;
+	struct ext2_inode *raw_inode;
 	struct inode *inode;
 	long ret = -EIO;
 	int n;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
git-unionfs.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
i386-and-x86_64-randomize-brk-fix.patch
git-perfmon-fill-in-i386-syscall-table.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
