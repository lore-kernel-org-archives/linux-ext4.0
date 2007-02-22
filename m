From: akpm@linux-foundation.org
Subject: + ext-ea-block-reference-count-racing-fix-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 20:32:45 -0800
Message-ID: <200702220432.l1M4Wjx5004479@shell0.pdx.osdl.net>
Cc: akpm@linux-foundation.org, agruen@suse.de, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXBVEcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Feb 2007 23:32:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext-ea-block-reference-count-racing-fix-fix
has been added to the -mm tree.  Its filename is
     ext-ea-block-reference-count-racing-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext-ea-block-reference-count-racing-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/xattr.c~ext-ea-block-reference-count-racing-fix-fix fs/ext3/xattr.c
diff -puN fs/ext4/xattr.c~ext-ea-block-reference-count-racing-fix-fix fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~ext-ea-block-reference-count-racing-fix-fix
+++ a/fs/ext4/xattr.c
@@ -721,7 +721,7 @@ ext4_xattr_block_set(handle_t *handle, s
 			int offset = (char *)s->here - bs->bh->b_data;
 
 			unlock_buffer(bs->bh);
-			journal_release_buffer(handle, bs->bh);
+			jbd2_journal_release_buffer(handle, bs->bh);
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
