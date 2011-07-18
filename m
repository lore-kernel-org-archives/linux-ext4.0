From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 12/12] ext4: simplify parameters of reserve_backup_gdb()
Date: Mon, 18 Jul 2011 10:12:19 +0300
Message-ID: <CAOQ4uxjkyAqYJ=i9d7hKcBp6PKbPtm3tfx-HinsaKz1+yN7aFA@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-13-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, aedilger@gmail.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33623 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1GRHMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 03:12:21 -0400
Received: by wyg8 with SMTP id 8so1869428wyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 00:12:19 -0700 (PDT)
In-Reply-To: <1310957555-15617-13-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 5:52 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> reserve_backup_gdb() only needs the no. of a group, there is no need =
to pass
> a pointer to struct ext4_new_group_data to it.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Acked-by: Amir Goldstein" <amir73il@users.sf.net>
=46or All 12 patches.

> ---
> =A0fs/ext4/resize.c | =A0 12 +++++++-----
> =A01 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 52d0426..3e790ad 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -556,7 +556,7 @@ exit_bh:
> =A0* backup GDT blocks are stored in their reserved primary GDT block=
=2E
> =A0*/
> =A0static int reserve_backup_gdb(handle_t *handle, struct inode *inod=
e,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4=
_new_group_data *input)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_=
t group)
> =A0{
> =A0 =A0 =A0 =A0struct super_block *sb =3D inode->i_sb;
> =A0 =A0 =A0 =A0int reserved_gdb =3Dle16_to_cpu(EXT4_SB(sb)->s_es->s_r=
eserved_gdt_blocks);
> @@ -627,7 +627,7 @@ static int reserve_backup_gdb(handle_t *handle, s=
truct inode *inode,
> =A0 =A0 =A0 =A0 * Finally we can add each of the reserved backup GDT =
blocks from
> =A0 =A0 =A0 =A0 * the new group to its reserved primary GDT block.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 blk =3D input->group * EXT4_BLOCKS_PER_GROUP(sb);
> + =A0 =A0 =A0 blk =3D group * EXT4_BLOCKS_PER_GROUP(sb);
> =A0 =A0 =A0 =A0for (i =3D 0; i < reserved_gdb; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int err2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data =3D (__le32 *)primary[i]->b_data;
> @@ -841,9 +841,11 @@ int ext4_group_add(struct super_block *sb, struc=
t ext4_new_group_data *input)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((err =3D ext4_journal_get_write_ac=
cess(handle, primary)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto exit_journal;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (reserved_gdb && ext4_bg_num_gdb(sb,=
 input->group) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (err =3D reserve_backup_gdb(han=
dle, inode, input)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (reserved_gdb && ext4_bg_num_gdb(sb,=
 input->group)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D reserve_backup_=
gdb(handle, inode, input->group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ex=
it_journal;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D add_new_gdb(handle, inode, inp=
ut->group);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
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
