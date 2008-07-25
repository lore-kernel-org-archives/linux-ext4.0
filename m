From: akpm@linux-foundation.org
Subject: - jbd-unexport-journal_update_superblock.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:44 -0700
Message-ID: <200807252256.m6PMuixp003113@imap1.linux-foundation.org>
To: bunk@kernel.org, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309AbYGYXGg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: unexport journal_update_superblock
has been removed from the -mm tree.  Its filename was
     jbd-unexport-journal_update_superblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: unexport journal_update_superblock
From: Adrian Bunk <bunk@kernel.org>

Remove the unused EXPORT_SYMBOL(journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/jbd/journal.c~jbd-unexport-journal_update_superblock fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-unexport-journal_update_superblock
+++ a/fs/jbd/journal.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(journal_set_features);
 EXPORT_SYMBOL(journal_create);
 EXPORT_SYMBOL(journal_load);
 EXPORT_SYMBOL(journal_destroy);
-EXPORT_SYMBOL(journal_update_superblock);
 EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

