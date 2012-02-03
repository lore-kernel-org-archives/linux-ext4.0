From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: fix resize when resizing within single group
Date: Fri, 3 Feb 2012 19:13:21 +0800
Message-ID: <CAGBYx2Y-q6h20450hHZwV1X9rOA+UqQfB3eKpifbGkcJai6zJw@mail.gmail.com>
References: <1328173555-26452-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Milan Broz <mbroz@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44086 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab2BCLNV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Feb 2012 06:13:21 -0500
Received: by obcva7 with SMTP id va7so4089927obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 03 Feb 2012 03:13:21 -0800 (PST)
In-Reply-To: <1328173555-26452-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks!  The patch looks good to me.

On Thu, Feb 2, 2012 at 5:05 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> When resizing file system in the way that the new size of the file
> system is still in the same group (no new groups are added), then we =
can
> hit a BUG_ON in ext4_alloc_group_tables()
>
> BUG_ON(flex_gd->count =3D=3D 0 || group_data =3D=3D NULL);
>
> because flex_gd->count is zero. The reason is the missing check for s=
uch
> case, so the code always extend the last group fully and then attempt=
 to
> add more groups, but at that time n_blocks_count is actually smaller
> than o_blocks_count.
>
> It can be easily reproduced like this:
>
> mkfs.ext4 -b 4096 /dev/sda 30M
> mount /dev/sda /mnt/test
> resize2fs /dev/sda 50M
>
> Fix this by checking whether the resize happens within the singe grou=
p
> and only add that many blocks into the last group to satisfy user
> request. Then o_blocks_count =3D=3D n_blocks_count and the resize wil=
l exit
> successfully without and attempt to add more groups into the fs.
>
> Also fix mixing together block number and blocks count which might be
> confusing and can easily lead to off-by-one errors (but it is actuall=
y
> not the case here since the two occurrence of this mix-up will cancel
> each other).
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Milan Broz <mbroz@redhat.com>
> ---
> =A0fs/ext4/resize.c | =A0 14 ++++++++------
> =A01 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index f9d948f..3fed79d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1582,7 +1582,7 @@ int ext4_resize_fs(struct super_block *sb, ext4=
_fsblk_t n_blocks_count)
> =A0 =A0 =A0 =A0ext4_fsblk_t o_blocks_count;
> =A0 =A0 =A0 =A0ext4_group_t o_group;
> =A0 =A0 =A0 =A0ext4_group_t n_group;
> - =A0 =A0 =A0 ext4_grpblk_t offset;
> + =A0 =A0 =A0 ext4_grpblk_t offset, add;
> =A0 =A0 =A0 =A0unsigned long n_desc_blocks;
> =A0 =A0 =A0 =A0unsigned long o_desc_blocks;
> =A0 =A0 =A0 =A0unsigned long desc_blocks;
> @@ -1605,7 +1605,7 @@ int ext4_resize_fs(struct super_block *sb, ext4=
_fsblk_t n_blocks_count)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &=
n_group, &offset);
> - =A0 =A0 =A0 ext4_get_group_no_and_offset(sb, o_blocks_count, &o_gro=
up, &offset);
> + =A0 =A0 =A0 ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o=
_group, &offset);
>
> =A0 =A0 =A0 =A0n_desc_blocks =3D (n_group + EXT4_DESC_PER_BLOCK(sb)) =
/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_DESC_PER_BLOCK(sb=
);
> @@ -1634,10 +1634,12 @@ int ext4_resize_fs(struct super_block *sb, ex=
t4_fsblk_t n_blocks_count)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0brelse(bh);
>
> - =A0 =A0 =A0 if (offset !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* extend the last group */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_grpblk_t add;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add =3D EXT4_BLOCKS_PER_GROUP(sb) - off=
set;
> + =A0 =A0 =A0 /* extend the last group */
> + =A0 =A0 =A0 if (n_group =3D=3D o_group)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add =3D n_blocks_count - o_blocks_count=
;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add =3D EXT4_BLOCKS_PER_GROUP(sb) - (of=
fset + 1);
> + =A0 =A0 =A0 if (add > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_group_extend_no_check(sb,=
 o_blocks_count, add);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> --
> 1.7.4.4
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
