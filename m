From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] resize: Do not fail if EXT4_IOC_RESIZE_FS ioctl doesn't exist
Date: Mon, 17 Oct 2011 09:29:42 +0800
Message-ID: <CAGBYx2ac38XzfwUONx+cKwW+fwV4msAFxBE3q6EE+97aeoHUSg@mail.gmail.com>
References: <1318607374-17246-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43247 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1JQB3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Oct 2011 21:29:43 -0400
Received: by ggnb1 with SMTP id b1so1791771ggn.19
        for <linux-ext4@vger.kernel.org>; Sun, 16 Oct 2011 18:29:43 -0700 (PDT)
In-Reply-To: <1318607374-17246-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 14, 2011 at 11:49 PM, Lukas Czerner <lczerner@redhat.com> w=
rote:
> Commit 9f6ba888f027ba4daf57ac61a11a6dce98e42347 added support for new
> online resize ioctl EXT4_IOC_RESIZE_FS. It is also trying to avoid
> failure when this ioctl() is not supported by the kernel however
> it is checking wrong error code (EINVAL).
>
> When the ioctl does not exist, errno is set to ENOTTY, so we should
> check for that, rather than EINVAL which means that ioctl arguments
> are not valid. So change the code to check for ENOTTY and allow
> resize2fs to try to use the old approach. Also add some comments.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>
> Btw I can not find the new kernel code anywhere. It is not in Linus t=
ree,
> it also is not in the github ext4 master, nor dev tree. Where it is t=
hen ?
> The problem is that the recent released e2fsprogs are broken for all
> kernels. To be more specific, resize2fs is broken for all kernels.
>
>
> =A0resize/online.c | =A0 =A07 ++++++-
> =A01 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/resize/online.c b/resize/online.c
> index 77290c2..1a77839 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -72,7 +72,12 @@ errcode_t online_resize_fs(ext2_filsys fs, const c=
har *mtpt,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (errno !=3D EINVAL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If kernel does not support EXT4_IO=
C_RESIZE_FS, use the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* old online resize. Note that the o=
ld approach does not
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* handle >32 bit file systems
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
Great comment !
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (errno !=3D ENOTTY) {
In my working tree, it has been ENOTTY but there is no comment.  And I
found EINVAL was introduced in commit
200569608fc6e33f6546(https://github.com/tytso/e2fsprogs/commit/20056960=
8fc6e33f6546c17999f14fb5dbb0b9b5)
to fix some bugs and reason is listed.


Yongqiang.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (errno =3D=3D EPERM=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0com_er=
r(program_name, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_("Per=
mission denied to resize filesystem"));
> --
> 1.7.4.4
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
