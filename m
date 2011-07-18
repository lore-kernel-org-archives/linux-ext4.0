From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
Date: Mon, 18 Jul 2011 09:48:52 +0300
Message-ID: <CAOQ4uxjq-10_yZFhP1A=N6tTbdotVsyLm5=_GSK+UwpyS0GL0w@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-6-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33305 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1GRGsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:48:53 -0400
Received: by wyg8 with SMTP id 8so1860514wyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 23:48:52 -0700 (PDT)
In-Reply-To: <1310957555-15617-6-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 5:52 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> This patch lets ext4_group_add_blocks() return an error code if it fa=
ils,
> so that upper functions can handle error correctly.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A02 +-
> =A0fs/ext4/mballoc.c | =A0 19 +++++++++++++------
> =A0fs/ext4/resize.c =A0| =A0 10 +++++++---
> =A03 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bbe81db..da7ab48 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1799,7 +1799,7 @@ extern void ext4_free_blocks(handle_t *handle, =
struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long=
 count, int flags);
> =A0extern int ext4_mb_add_groupinfo(struct super_block *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_group_t i, struct ext4_group_desc=
 *desc);
> -extern void ext4_group_add_blocks(handle_t *handle, struct super_blo=
ck *sb,
> +extern int ext4_group_add_blocks(handle_t *handle, struct super_bloc=
k *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_f=
sblk_t block, unsigned long count);
> =A0extern int ext4_trim_fs(struct super_block *, struct fstrim_range =
*);
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ea80c0b..33c41e6 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4664,7 +4664,7 @@ error_return:
> =A0*
> =A0* This marks the blocks as free in the bitmap and buddy.
> =A0*/
> -void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> +int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t block, u=
nsigned long count)
> =A0{
> =A0 =A0 =A0 =A0struct buffer_head *bitmap_bh =3D NULL;
> @@ -4685,15 +4685,21 @@ void ext4_group_add_blocks(handle_t *handle, =
struct super_block *sb,
> =A0 =A0 =A0 =A0 * Check to see if we are freeing blocks across a grou=
p
> =A0 =A0 =A0 =A0 * boundary.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
> + =A0 =A0 =A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "too much blocks added=
 to group %u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0bitmap_bh =3D ext4_read_block_bitmap(sb, block_group);
> =A0 =A0 =A0 =A0if (!bitmap_bh)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;

Any reason you are skipping the goto in the 2 error cases above and
missing the ext4_std_error()?

> +
> =A0 =A0 =A0 =A0desc =3D ext4_get_group_desc(sb, block_group, &gd_bh);
> - =A0 =A0 =A0 if (!desc)
> + =A0 =A0 =A0 if (!desc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_return;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (in_range(ext4_block_bitmap(sb, desc), block, count=
) ||
> =A0 =A0 =A0 =A0 =A0 =A0in_range(ext4_inode_bitmap(sb, desc), block, c=
ount) ||
> @@ -4703,6 +4709,7 @@ void ext4_group_add_blocks(handle_t *handle, st=
ruct super_block *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_error(sb, "Adding blocks in syste=
m zones - "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Block =3D %llu, =
count =3D %lu",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block, count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_return;
> =A0 =A0 =A0 =A0}
>
> @@ -4771,7 +4778,7 @@ void ext4_group_add_blocks(handle_t *handle, st=
ruct super_block *sb,
> =A0error_return:
> =A0 =A0 =A0 =A0brelse(bitmap_bh);
> =A0 =A0 =A0 =A0ext4_std_error(sb, err);
> - =A0 =A0 =A0 return;
> + =A0 =A0 =A0 return err;
> =A0}
>
> =A0/**
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 374fd1c..2e63376 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -990,7 +990,7 @@ int ext4_group_extend(struct super_block *sb, str=
uct ext4_super_block *es,
> =A0 =A0 =A0 =A0ext4_grpblk_t add;
> =A0 =A0 =A0 =A0struct buffer_head *bh;
> =A0 =A0 =A0 =A0handle_t *handle;
> - =A0 =A0 =A0 int err;
> + =A0 =A0 =A0 int err, err2;
> =A0 =A0 =A0 =A0ext4_group_t group;
>
> =A0 =A0 =A0 =A0o_blocks_count =3D ext4_blocks_count(es);
> @@ -1066,11 +1066,15 @@ int ext4_group_extend(struct super_block *sb,=
 struct ext4_super_block *es,
> =A0 =A0 =A0 =A0ext4_debug("freeing blocks %llu through %llu\n", o_blo=
cks_count,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 o_blocks_count + add);
> =A0 =A0 =A0 =A0/* We add the blocks to the bitmap and set the group n=
eed init bit */
> - =A0 =A0 =A0 ext4_group_add_blocks(handle, sb, o_blocks_count, add);
> + =A0 =A0 =A0 err =3D ext4_group_add_blocks(handle, sb, o_blocks_coun=
t, add);
> =A0 =A0 =A0 =A0ext4_handle_dirty_super(handle, sb);
> =A0 =A0 =A0 =A0ext4_debug("freed blocks %llu through %llu\n", o_block=
s_count,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 o_blocks_count + add);
> - =A0 =A0 =A0 if ((err =3D ext4_journal_stop(handle)))
> + =A0 =A0 =A0 err2 =3D ext4_journal_stop(handle);
> + =A0 =A0 =A0 if (!err && err2)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D err2;
> +
> + =A0 =A0 =A0 if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto exit_put;
>
> =A0 =A0 =A0 =A0if (test_opt(sb, DEBUG))
> --
> 1.7.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
