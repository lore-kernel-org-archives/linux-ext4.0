From: akpm@linux-foundation.org
Subject: - bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:36 -0800
Message-ID: <200802070030.m170UHuE007374@imap1.linux-foundation.org>
To: ak@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933893AbYBGAoO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 19:44:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


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
Cc: Theodore Ts'o <tytso@mit.edu>
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
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
git-xfs.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
allow-executables-larger-than-2gb.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
remove-aout-interpreter-support-in-elf-loader.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
