From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 2/8] e2fsprogs: add exclude bitmap support in mkfs
Date: Sun, 23 Oct 2011 15:55:02 +0200
Message-ID: <CAOQ4uxh_z+2Ko9Hbfk9KtX72W4F0AaMqSNOB6YL_5=ALyd7+WQ@mail.gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
	<1319354488-6050-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, amir73il@users.sf.net
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34549 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab1JWNzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 09:55:04 -0400
Received: by wyg36 with SMTP id 36so5365114wyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 06:55:02 -0700 (PDT)
In-Reply-To: <1319354488-6050-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch is missing some "meat".
Some parts of the previous patch should probably belong to this one,
like the patch to lib/ext2fs/alloc_tables.c.
Please keep this in mind for the next post.

Sorry for not noticing this when reviewing in github,
Amir.

On Sun, Oct 23, 2011 at 9:21 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Exclude bitmap is needed by ext4 snapshot. This patch adds
> exclude bitmap support in mkfs.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0misc/mke2fs.c | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 3dcb3b7..2dc28e7 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -828,6 +828,7 @@ static void parse_extended_opts(struct ext2_super=
_block *param,
> =A0static __u32 ok_features[3] =3D {
> =A0 =A0 =A0 =A0/* Compat */
> =A0 =A0 =A0 =A0EXT3_FEATURE_COMPAT_HAS_JOURNAL |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_FEATURE_COMPAT_RESIZE_INODE |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_FEATURE_COMPAT_DIR_INDEX |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_FEATURE_COMPAT_EXT_ATTR,
> --
> 1.7.5.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
