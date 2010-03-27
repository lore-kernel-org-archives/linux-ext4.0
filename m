From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize: check s_log_groups_per_flex before accessing flex
 groups
Date: Sat, 27 Mar 2010 14:32:16 -0500
Message-ID: <4BAE5D40.5050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alessandro Polverini <alex@nibbles.it>,
	Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab0C0Tc2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Mar 2010 15:32:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for kernel.org bug:

#13549, Kernel oops while online resizing of an ext4 filesystem

if groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
and every other access to this first tests s_log_groups_per_flex;
same thing needs to happen in resize or we'll wander off into
a null pointer.

Thanks to Christoph Biedl, who came up with the trivial testcase:

# truncate --size 128M fsfile
# mkfs.ext3 -F fsfile
# tune2fs -O extents,uninit_bg,dir_index,flex_bg,huge_file,dir_nlink,extra_isize fsfile
# e2fsck -yDf -C0 fsfile
# truncate --size 132M fsfile
# losetup /dev/loop0 fsfile
# mount /dev/loop0 mnt
# resize2fs -p /dev/loop0


Reported-by: Alessandro Polverini <alex@nibbles.it>
Test-case-by: Christoph Biedl  <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

Index: linux-2.6/fs/ext4/resize.c
===================================================================
--- linux-2.6.orig/fs/ext4/resize.c
+++ linux-2.6/fs/ext4/resize.c
@@ -930,7 +930,8 @@ int ext4_group_add(struct super_block *s
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, input->group);
 		atomic_add(input->free_blocks_count,

