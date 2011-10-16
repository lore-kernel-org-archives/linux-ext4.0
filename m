From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] resize: Do not fail if EXT4_IOC_RESIZE_FS ioctl doesn't exist
Date: Sun, 16 Oct 2011 09:31:47 +0200
Message-ID: <CAOQ4uxj1cz4Kp24orbskngqnn2TwV88s=HSDRa-AcapFGHaNEA@mail.gmail.com>
References: <1318607374-17246-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
To: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53579 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1JPHbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Oct 2011 03:31:49 -0400
Received: by wwe6 with SMTP id 6so744097wwe.1
        for <linux-ext4@vger.kernel.org>; Sun, 16 Oct 2011 00:31:47 -0700 (PDT)
In-Reply-To: <1318607374-17246-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 14, 2011 at 5:49 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
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

AFAIK, the latest version of the patches is here:
https://github.com/YANGYongqiang/ext4-patch-queue

and I suppose Ted should have it in patchworks as well.

Ted,

Are you planning to merge new online resize for 3.2?

Thanks,
Amir.



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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (errno !=3D ENOTTY) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (errno =3D=3D EPERM=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0com_er=
r(program_name, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_("Per=
mission denied to resize filesystem"));
> --
> 1.7.4.4
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
