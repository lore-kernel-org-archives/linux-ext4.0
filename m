From: akpm@linux-foundation.org
Subject: - bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:39 -0800
Message-ID: <200802012230.m11MUduu001924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: ak@suse.de, linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     BKL-removal: remove incorrect comment refering to lock_kernel() from jbd/jbd2
has been removed from the -mm tree.  Its filename was
     bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BKL-removal: remove incorrect comment refering to lock_kernel() from jbd/jbd2
From: Andi Kleen <ak@suse.de>

None of the callers of this function does actually take the BKL as far as I
can see.  So remove the comment refering to the BKL.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/recovery.c  |    2 +-
 fs/jbd2/recovery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/jbd/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2 fs/jbd/recovery.c
--- a/fs/jbd/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2
+++ a/fs/jbd/recovery.c
@@ -354,7 +354,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
diff -puN fs/jbd2/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2 fs/jbd2/recovery.c
--- a/fs/jbd2/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2
+++ a/fs/jbd2/recovery.c
@@ -397,7 +397,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-jfs.patch
git-ocfs2.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
modules-handle-symbols-that-have-a-zero-value.patch
allow-executables-larger-than-2gb.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
remove-aout-interpreter-support-in-elf-loader.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
