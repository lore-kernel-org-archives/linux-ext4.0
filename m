From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] fs/ext4: add missing ext4_resize_end
Date: Fri, 23 Dec 2011 09:14:20 +0800
Message-ID: <CAGBYx2YgN_iqcKOfAwzH_t63us+ECgxcNMEsaRz0j5aoY5tORw@mail.gmail.com>
References: <20111222150057.GA10845@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34512 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab1LWBOV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 20:14:21 -0500
In-Reply-To: <20111222150057.GA10845@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks.

The patch looks good.   I have to update the new resize patch too.

Yongqiang.

On Thu, Dec 22, 2011 at 11:00 PM, Djalal Harouni <tixxdz@opendz.org> wr=
ote:
> Online resize ioctls 'EXT4_IOC_GROUP_EXTEND' and 'EXT4_IOC_GROUP_ADD'
> call ext4_resize_begin() to check permissions and to set the
> EXT4_RESIZING bit lock, they do their work and they must finish with
> ext4_resize_end() which calls clear_bit_unlock() to unlock and to
> avoid -EBUSY errors for the next resize operations.
>
> This patch adds the missing ext4_resize_end() calls on error paths.
>
> Patch tested.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
> =A0fs/ext4/ioctl.c | =A0 28 ++++++++++++++++++----------
> =A01 files changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index a567968..ab25f57 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -182,19 +182,22 @@ setversion_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (get_user(n_blocks_count, (__u32 __u=
ser *)arg))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (get_user(n_blocks_count, (__u32 __u=
ser *)arg)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto group_extend_out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEAT=
URE_RO_COMPAT_BIGALLOC)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Onli=
ne resizing not supported with bigalloc");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto group_extend_out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D mnt_want_write(filp->f_path.mn=
t);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto group_extend_out;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_group_extend(sb, EXT4_SB(=
sb)->s_es, n_blocks_count);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT4_SB(sb)->s_journal) {
> @@ -204,9 +207,10 @@ setversion_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D err2;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mnt_drop_write(filp->f_path.mnt);
> +group_extend_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_resize_end(sb);
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> =A0 =A0 =A0 =A0}
>
> @@ -267,19 +271,22 @@ mext_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (copy_from_user(&input, (struct ext=
4_new_group_input __user *)arg,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
input)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
input))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto group_add_out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEAT=
URE_RO_COMPAT_BIGALLOC)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Onli=
ne resizing not supported with bigalloc");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto group_add_out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D mnt_want_write(filp->f_path.mn=
t);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto group_add_out;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_group_add(sb, &input);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT4_SB(sb)->s_journal) {
> @@ -289,9 +296,10 @@ mext_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D err2;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mnt_drop_write(filp->f_path.mnt);
> +group_add_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_resize_end(sb);
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> =A0 =A0 =A0 =A0}
>
> --
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
