From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 04/12] ext4: rename ext4_add_groupblocks() to ext4_group_add_blocks()
Date: Mon, 18 Jul 2011 09:32:01 +0300
Message-ID: <CAOQ4uxgW10cGUJBeS=mVYH5Mj-Pj2YujKgbTsJR29mBinJroTw@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-5-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1GRGcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:32:03 -0400
Received: by wyg8 with SMTP id 8so1854672wyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 23:32:02 -0700 (PDT)
In-Reply-To: <1310957555-15617-5-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 5:52 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> This patch renamed ext4_add_groupblocks() to ext4_group_add_blocks().

What is the reason for the rename?

>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A02 +-
> =A0fs/ext4/mballoc.c | =A0 =A04 ++--
> =A0fs/ext4/resize.c =A0| =A0 =A02 +-
> =A03 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bb0f776..bbe81db 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1799,7 +1799,7 @@ extern void ext4_free_blocks(handle_t *handle, =
struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long=
 count, int flags);
> =A0extern int ext4_mb_add_groupinfo(struct super_block *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_group_t i, struct ext4_group_desc=
 *desc);
> -extern void ext4_add_groupblocks(handle_t *handle, struct super_bloc=
k *sb,
> +extern void ext4_group_add_blocks(handle_t *handle, struct super_blo=
ck *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_f=
sblk_t block, unsigned long count);
> =A0extern int ext4_trim_fs(struct super_block *, struct fstrim_range =
*);
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index b97a2d2..ea80c0b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4656,7 +4656,7 @@ error_return:
> =A0}
>
> =A0/**
> - * ext4_add_groupblocks() -- Add given blocks to an existing group
> + * ext4_group_add_blocks() -- Add given blocks to an existing group
> =A0* @handle: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle to this t=
ransaction
> =A0* @sb: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0super block
> =A0* @block: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start physcial b=
lock to add to the block group
> @@ -4664,7 +4664,7 @@ error_return:
> =A0*
> =A0* This marks the blocks as free in the bitmap and buddy.
> =A0*/
> -void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
> +void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t block, u=
nsigned long count)
> =A0{
> =A0 =A0 =A0 =A0struct buffer_head *bitmap_bh =3D NULL;
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 33ab40d..374fd1c 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1066,7 +1066,7 @@ int ext4_group_extend(struct super_block *sb, s=
truct ext4_super_block *es,
> =A0 =A0 =A0 =A0ext4_debug("freeing blocks %llu through %llu\n", o_blo=
cks_count,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 o_blocks_count + add);
> =A0 =A0 =A0 =A0/* We add the blocks to the bitmap and set the group n=
eed init bit */
> - =A0 =A0 =A0 ext4_add_groupblocks(handle, sb, o_blocks_count, add);
> + =A0 =A0 =A0 ext4_group_add_blocks(handle, sb, o_blocks_count, add);
> =A0 =A0 =A0 =A0ext4_handle_dirty_super(handle, sb);
> =A0 =A0 =A0 =A0ext4_debug("freed blocks %llu through %llu\n", o_block=
s_count,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 o_blocks_count + add);
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
