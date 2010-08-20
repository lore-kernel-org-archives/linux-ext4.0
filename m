From: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Subject: [PATCH] resizefs: fix if ext4 already >16TB resize will fail issue
Date: Fri, 20 Aug 2010 14:39:34 +0800
Message-ID: <AANLkTi=WY0ow0vKoY7d7598mKiN-+4qsUp5aCYwHoCpM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39544 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HTGjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Aug 2010 02:39:55 -0400
Received: by vws3 with SMTP id 3so2716226vws.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Aug 2010 23:39:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When make >16TB ext4, mkfs.ext4 will add EXT4_FEATURE_INCOMPAT_64BIT fe=
ature.
But when resize, it didn't enable EXT2_FLAG_64BITS flag.
This will cause some size calculated wrong.
So this patch enable EXT2_FLAG_64BITS flag base on
EXT4_FEATURE_INCOMPAT_64BIT feature, and fix some size overflow code.
This patch let >16TB ext4 can offline resize successfully.

Thanks.

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index a0269c7..0b34b3e 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -181,6 +181,9 @@ errcode_t ext2fs_open2(const char *name, const
char *io_options,
=A0=A0=A0 }
=A0=A0=A0 retval =3D io_channel_read_blk(fs->io, superblock, -SUPERBLOC=
K_SIZE,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fs->super)=
;
+=A0=A0 if (EXT4_FEATURE_INCOMPAT_64BIT & fs->super->s_feature_incompat=
) {
+=A0=A0=A0=A0=A0=A0 fs->flags |=3D EXT2_FLAG_64BITS;
+=A0=A0 }
=A0=A0=A0 if (retval)
=A0=A0=A0=A0=A0=A0=A0 goto cleanup;
=A0=A0=A0 if (fs->orig_super)
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 064c4c4..b451c1d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -198,8 +198,8 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs=
)
=A0=A0=A0=A0=A0=A0=A0 if (!(ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_U=
NINIT)))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;

-=A0=A0=A0=A0=A0=A0 blk =3D (g * fs->super->s_blocks_per_group) +
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fs->super->s_first_data_block;
+=A0=A0=A0=A0=A0=A0 blk =3D ((blk64_t)g * (blk64_t)fs->super->s_blocks_=
per_group) +
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (blk64_t)fs->super->s_first_data_block;

=A0=A0=A0=A0=A0=A0=A0 ext2fs_super_and_bgd_loc2(fs, g, &super_blk,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &old_de=
sc_blk, &new_desc_blk, 0);
@@ -294,7 +294,7 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsy=
s old_fs,
=A0=A0=A0 blk64_t=A0=A0=A0=A0 overhead =3D 0;
=A0=A0=A0 blk64_t=A0=A0=A0=A0 rem;
=A0=A0=A0 blk64_t=A0=A0=A0=A0 blk, group_block;
-=A0=A0 ext2_ino_t=A0 real_end;
+=A0=A0 __u64=A0=A0=A0=A0=A0=A0 real_end;
=A0=A0=A0 blk64_t=A0=A0=A0=A0 adj, old_numblocks, numblocks, adjblocks;
=A0=A0=A0 unsigned long=A0=A0 i, j, old_desc_blocks, max_group;
=A0=A0=A0 unsigned int=A0=A0=A0 meta_bg, meta_bg_size;
@@ -381,9 +381,9 @@ retry:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
s->inode_map);
=A0=A0=A0 if (retval) goto errout;

-=A0=A0 real_end =3D ((EXT2_BLOCKS_PER_GROUP(fs->super)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * fs->group_desc_count)) - 1 +
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fs->super->s_first_data_=
block;
+=A0=A0 real_end =3D ((__u64)(EXT2_BLOCKS_PER_GROUP(fs->super)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * (__u64)fs->group_desc_count)) - 1U=
LL +
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (__u64)fs->super->s_firs=
t_data_block;
=A0=A0=A0 retval =3D ext2fs_resize_block_bitmap2(ext2fs_blocks_count(fs=
->super)-1,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r=
eal_end, fs->block_map);
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
