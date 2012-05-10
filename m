From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] ext4: teach resize report old blocks count correctly
Date: Thu, 10 May 2012 21:15:41 +0800
Message-ID: <CAGBYx2ZzJqcWHRoN1mhHAK+8K2v20ojULBRfmv3w26=mHSVb1w@mail.gmail.com>
References: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org, dsd@laptop.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46123 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2EJNPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 May 2012 09:15:42 -0400
Received: by qadb17 with SMTP id b17so289596qad.19
        for <linux-ext4@vger.kernel.org>; Thu, 10 May 2012 06:15:41 -0700 (PDT)
In-Reply-To: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ping?

The 2nd patch of the series fixes a bug which I meet again when
testing 64bit feature.


Yongqiang.

On Wed, Feb 1, 2012 at 11:01 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> o_blocks_count should not be changed, becasuse it is used later when
> reporting old blocks count in debug mode.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/resize.c | =A0 =A03 +--
> =A01 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 59fa0be..601fea1 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1654,8 +1654,7 @@ int ext4_resize_fs(struct super_block *sb, ext4=
_fsblk_t n_blocks_count)
> =A0 =A0 =A0 =A0 =A0 =A0es->s_log_groups_per_flex)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flexbg_size =3D 1 << es->s_log_groups_=
per_flex;
>
> - =A0 =A0 =A0 o_blocks_count =3D ext4_blocks_count(es);
> - =A0 =A0 =A0 if (o_blocks_count =3D=3D n_blocks_count)
> + =A0 =A0 =A0 if (ext4_blocks_count(es) =3D=3D n_blocks_count)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> =A0 =A0 =A0 =A0flex_gd =3D alloc_flex_gd(flexbg_size);
> --
> 1.7.5.1
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
