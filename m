From: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Subject: Re: [PATCH] resize2fs: fix computation of the real end of the bitmap
 to be 64-bit
Date: Sun, 9 Jan 2011 18:26:32 +0800
Message-ID: <AANLkTik2GZvQB+tpinU=5pEjXwnOZXD1Z0=0KMYG+95G@mail.gmail.com>
References: <1294436381-6413-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44877 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1AIK04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Jan 2011 05:26:56 -0500
Received: by vws16 with SMTP id 16so7789710vws.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Jan 2011 02:26:55 -0800 (PST)
In-Reply-To: <1294436381-6413-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

=A0 In function fix_uninit_block_bitmaps(ext2_filsys fs), also have
overflow issue.
I've send this patch before.
http://www.spinics.net/lists/linux-ext4/msg20570.html

Maybe this patch can help you to avoid another overflow bug.

Yours sincerely,
Hsuan-Ting.

2011/1/8 Theodore Ts'o <tytso@mit.edu>
>
> real_end had been previously declared with a bogus type, which is why
> this was missed earlier.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0resize/resize2fs.c | =A0 =A08 ++++----
> =A01 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 55e5512..216a626 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -294,7 +294,7 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_fil=
sys old_fs,
> =A0 =A0 =A0 =A0blk64_t =A0 =A0 =A0 =A0 overhead =3D 0;
> =A0 =A0 =A0 =A0blk64_t =A0 =A0 =A0 =A0 rem;
> =A0 =A0 =A0 =A0blk64_t =A0 =A0 =A0 =A0 blk, group_block;
> - =A0 =A0 =A0 ext2_ino_t =A0 =A0 =A0real_end;
> + =A0 =A0 =A0 blk64_t =A0 =A0 =A0 =A0 real_end;
> =A0 =A0 =A0 =A0blk64_t =A0 =A0 =A0 =A0 adj, old_numblocks, numblocks,=
 adjblocks;
> =A0 =A0 =A0 =A0unsigned long =A0 i, j, old_desc_blocks, max_group;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0meta_bg, meta_bg_size;
> @@ -381,9 +381,9 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0fs->inode_map);
> =A0 =A0 =A0 =A0if (retval) goto errout;
>
> - =A0 =A0 =A0 real_end =3D ((EXT2_BLOCKS_PER_GROUP(fs->super)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fs->group_desc_count)) - 1=
 +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->super->s=
_first_data_block;
> + =A0 =A0 =A0 real_end =3D (((blk64_t) EXT2_BLOCKS_PER_GROUP(fs->supe=
r) *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->group_desc_count)) - 1 +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->super->s_first_data_block;
> =A0 =A0 =A0 =A0retval =3D ext2fs_resize_block_bitmap2(ext2fs_blocks_c=
ount(fs->super)-1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0real_end, fs->block_map);
>
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
