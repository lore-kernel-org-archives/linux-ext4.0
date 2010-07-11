From: shenghui <crosslonelyover@gmail.com>
Subject: Re: [PATCH & RESEND] avoid NULL deference in ext2_xattr_get
Date: Sun, 11 Jul 2010 16:31:35 +0800
Message-ID: <AANLkTinjdTVM-Xqfszyi8KBe-aD-2I-jcvDFFtz9seD3@mail.gmail.com>
References: <201007111016021569718@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: kernel-janitors <kernel-janitors@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	error27 <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50893 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0GKIbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Jul 2010 04:31:37 -0400
In-Reply-To: <201007111016021569718@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/7/11 crosslonelyover <crosslonelyover@gmail.com>:
> Hi Dan Carpenter,
>
> =C2=A0 =C2=A0 Thanks for your instructions. I regenerated the patch.
> Please check it.
>
> From 3149865e0d118b939c27659a4e4c884eaa6b3a4c Mon Sep 17 00:00:00 200=
1
> From: Wang Sheng-Hui <crosslonelyover@gmail.com>
> Date: Sat, 10 Jul 2010 22:07:37 -0400
> Subject: [PATCH] avoid NULL deference in ext2_xattr_get
>
>
> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> ---
> =C2=A0fs/ext2/xattr.c | =C2=A0 =C2=A05 +++--
> =C2=A01 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..81ec1c6 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int name_in=
dex, const char *name,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char *end;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int error;
>
> + =C2=A0 =C2=A0 =C2=A0 if (name =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ea_idebug(inode, "name=3D%d.%s, buffer=3D%=
p, buffer_size=3D%ld",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name_in=
dex, name, buffer, (long)buffer_size);
>
> - =C2=A0 =C2=A0 =C2=A0 if (name =3D=3D NULL)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0down_read(&EXT2_I(inode)->xattr_sem);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D -ENODATA;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!EXT2_I(inode)->i_file_acl)
> --
> 1.7.1.1
>
>
>

Please ignore this patch. Just for gmail format check.
Thanks for David Beal's explanation!

--=20


Thanks and Best Regards,
shenghui
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
