From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: s_first_meta_bg treatment incompatibility between kernel and e2fsprogs
Date: Wed, 11 Nov 2009 13:09:00 +0100
Message-ID: <4AFAA95C.5000304@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:38770 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZKKMHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2009 07:07:35 -0500
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 6D23B4B0088
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2009 13:07:34 +0100 (CET)
Received: from [192.168.103.118] (lan31-6-82-230-26-21.fbx.proxad.net [82.230.26.21])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 6EC334B01A3
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2009 13:07:32 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have taken a look at META_BG feature and think there is some
incoherency between kernel and e2fsprogs about s_first_meta_bg handling.

When considering initialisation of unitialised block bitmaps for groups 
before first meta group one:
- kernel considers that descriptors blocks occupy 
EXT4_SB(sb)->s_gdb_count blocks (see ext4_bg_num_gdb_nometa at 
balloc.c:764 that is indirectly called from ext4_init_block_bitmap), 
s_gdb_count being the number of blocks to store all descriptors 
(computed from super.c).
- e2fsprogs considers that descriptors blocks occupy s_first_meta_bg
(see ext2fs_reserve_super_and_bgd at alloc_sb.c:55-68).

The difference of behaviour is wrong as e2fsck will certainly complain 
there is a bitmap marked unused when it should be if the bitmap was 
initialised by kernel and number of descriptors blocks is lower than 
s_first_meta_bg or reverse if number of descriptors blocks is higher 
than s_first_meta_bg.

So, the kernel behaviour seems to be wrong in the META_BG case when 
s_first_meta_bg is not 0: ext4_bg_num_gdb returns either 1 (META_BG 
feature present and group being one of the meta group) or s_gdb_count 
(META_BG feature not present or group being one before first meta 
group). As s_gdb_count is number of blocks for all groups, I think it 
should returns either 1 (META_BG present and group being one of the meta 
group) or s_first_meta_bg (META_BG present and group being one before 
first meta group) or s_gdb_count (META_BG not set).

I see also that the resize2fs does not handle the s_first_meta_bg flag 
in case a filesystem is shrunk such as number of descriptor blocks goes 
below s_first_meta_bg. To what I looked, it does not seem to be a 
problem (apart from the problem in kernel described above), but I did 
not perform a complete check about that. At least there is some blocks 
still allocated when there is no more need for that (but e2fsck does not 
complain as it uses also the s_first_meta_bg value). I do not know if it 
is desired behaviour. In case the s_first_meta_bg is lowered and blocks 
freed, it will certainly be better to add a check into e2fsck to check 
that s_first_meta_bg is coherent with number of descriptor blocks 
(s_first_meta_bg <= fs->desc_blocks).

If you want to perform some tests on that, I modified tune2fs to allow 
setting the META_BG flag on a filesystem that does not have it with 
setting s_first_meta_bg to the current number of blocks for descriptors 
(it is how I understand META_BG/s_first_meta_group should be used).

Regards,

Damien

*** misc/tune2fs.old    2009-11-11 12:20:33.698192912 +0100
--- misc/tune2fs.c      2009-11-11 11:38:20.265333248 +0100
***************
*** 121,126 ****
--- 121,127 ----
                 EXT2_FEATURE_COMPAT_DIR_INDEX,
         /* Incompat */
         EXT2_FEATURE_INCOMPAT_FILETYPE |
+         EXT2_FEATURE_INCOMPAT_META_BG |
                 EXT3_FEATURE_INCOMPAT_EXTENTS |
                 EXT4_FEATURE_INCOMPAT_FLEX_BG,
         /* R/O compat */
***************
*** 418,423 ****
--- 419,440 ----
                 }
         }

+   if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_META_BG)) {
+     if (mount_flags & EXT2_MF_MOUNTED) {
+       fputs(_("The meta_bg feature may only be "
+         "set when the filesystem is\n"
+         "unmounted.\n"), stderr);
+       exit(1);
+     }
+     if (sb->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) {
+       fputs(_("The meta_bg feature cannot be "
+         "set when the resize_inode is\n"
+         "set.\n"), stderr);
+       exit(1);
+     }
+     sb->s_first_meta_bg = fs->desc_blocks;
+   }
+
         if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
                             EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
                 if ((mount_flags & EXT2_MF_MOUNTED) &&


