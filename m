From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2 01/15] ext4: add a function which extends a group
 without checking parameters
Date: Sun, 30 Oct 2011 21:48:43 +0800
Message-ID: <CAGBYx2aT6wGc1T+ijycua3+tbJo4_pxE2tt2q4c+yDogqNnLhQ@mail.gmail.com>
References: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
	<1314691825-12295-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55640 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424Ab1J3Nso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 09:48:44 -0400
Received: by ggnb1 with SMTP id b1so5040648ggn.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 06:48:43 -0700 (PDT)
In-Reply-To: <1314691825-12295-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ping?

On Tue, Aug 30, 2011 at 4:10 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> This patch added a function named __ext4_group_extend() whose code
> is copied from ext4_group_extend(). =A0__ext4_group_extend() assumes
> the parameter is valid and has been checked by caller.
>
> __ext4_group_extend() will be used by new resize implementation. It
> can also be used by ext4_group_extend(), but this patch series does
> not do this.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/resize.c | =A0 53 ++++++++++++++++++++++++++++++++++++++++=
+++++++++++++
> =A01 files changed, 53 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 707d3f1..5126aac 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -969,6 +969,59 @@ exit_put:
> =A0} /* ext4_group_add */
>
> =A0/*
> + * extend a group without checking assuming that checking has been d=
one.
> + */
> +static int __ext4_group_extend(struct super_block *sb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_fsb=
lk_t o_blocks_count, ext4_grpblk_t add)
> +{
> + =A0 =A0 =A0 struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> + =A0 =A0 =A0 handle_t *handle;
> + =A0 =A0 =A0 int err =3D 0, err2;
> +
> + =A0 =A0 =A0 /* We will update the superblock, one block bitmap, and
> + =A0 =A0 =A0 =A0* one group descriptor via ext4_group_add_blocks().
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 handle =3D ext4_journal_start_sb(sb, 3);
> + =A0 =A0 =A0 if (IS_ERR(handle)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(handle);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "error %d on journal s=
tart", err);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 err =3D ext4_journal_get_write_access(handle, EXT4_SB(s=
b)->s_sbh);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "error %d on journal w=
rite access", err);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handle);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ext4_blocks_count_set(es, o_blocks_count + add);
> + =A0 =A0 =A0 ext4_debug("freeing blocks %llu through %llu\n", o_bloc=
ks_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o_blocks_count + add);
> + =A0 =A0 =A0 /* We add the blocks to the bitmap and set the group ne=
ed init bit */
> + =A0 =A0 =A0 err =3D ext4_group_add_blocks(handle, sb, o_blocks_coun=
t, add);
> + =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
> + =A0 =A0 =A0 ext4_handle_dirty_super(handle, sb);
> + =A0 =A0 =A0 ext4_debug("freed blocks %llu through %llu\n", o_blocks=
_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o_blocks_count + add);
> +exit_journal:
> + =A0 =A0 =A0 err2 =3D ext4_journal_stop(handle);
> + =A0 =A0 =A0 if (err2 && !err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D err2;
> +
> + =A0 =A0 =A0 if (!err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(sb, DEBUG))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "EXT4=
-fs: extended group to %llu "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"blocks\=
n", ext4_blocks_count(es));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 update_backups(sb, EXT4_SB(sb)->s_sbh->=
b_blocknr, (char *)es,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(s=
truct ext4_super_block));
> + =A0 =A0 =A0 }
> +out:
> + =A0 =A0 =A0 return err;
> +}
> +
> +/*
> =A0* Extend the filesystem to the new number of blocks specified. =A0=
This entry
> =A0* point is only used to extend the current filesystem to the end o=
f the last
> =A0* existing group. =A0It can be accessed via ioctl, or by "remount,=
resize=3D<size>"
> --
> 1.7.5.1
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
