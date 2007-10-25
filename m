From: "Theodore Ts'o" <tytso@mit.edu>
Subject: 2.6.24-rc1-ext4-1 patchset released
Date: Thu, 25 Oct 2007 15:44:54 -0400
Message-ID: <E1Il8dS-00038s-6m@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54894 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbXJYTpS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 15:45:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I've just released 2.6.24-rc1-ext4-1.  It removes patches accepted by
Linus and adds a number of cleanup patches.  It also adds support for
storing i_blocks in units of filesystem blocks instead of 512 byte
sectors to eliminate one stupid (and easy to fix) large file scalability
limit.

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.24-rc1-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=summary

and

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.24-rc1-ext4-
1

						- Ted

Pulled into mainline:
-jbd_slab_cleanup.patch
-jbd2_slab_cleanup.patch
-jbd_jbd_kmalloc_cleanup.patch
-jbd2_jbd_kmalloc_cleanup.patch
-jbd2-ext4-cleanups-convert-to-kzalloc.patch
-jbd_to_jbd2_naming_cleanups.patch
-jbd2-fix-commit-code-to-properly-abort-journal.patch
-jbd2-debug-code-cleanup.patch
-remove-obsolete-fragments.patch
-remove-ifdef-config_ext4_index.patch 
-uninitialized-block-groups.patch
-fix-sparse-warnings.patch
-flex_bg-kernel-support-v2.patch

New patches:
+ext4_large_blocksize_support.patch
+ext4_rec_len_overflow_with_64kblk_fix-v2.patch
+large-file-blocktype.patch
+ext4_grpnum_t.patch
+ext4_grpnum_t_int_fix.patch
+ext4-cleanup.patch
+ext4-cleanup-2.patch
+ext4-cleanup-3.patch
+ext4-cleanup-4.patch
+48-bit-i_blocks.patch
+large-file.patch
+ext2_fix_max_size.patch
+ext3_fix_max_size.patch
+ext4_sync_group_desciptor_with_e2fsprogs.patch
+ext4-Return-after-ext4_error-in-case-of-failures.patch
+ext4_grpnumt-mballoc-fix.patch
+mballoc-compilebench-fix.patch
