From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH] debugfs: cleanup in do_show_debugfs_params
Date: Mon, 16 Apr 2012 22:21:05 +0800
Message-ID: <CADxeRw=byZRehhPYLikEtdBHRAxeu_cN_9iPy_MPVOF8hGdrTg@mail.gmail.com>
References: <1334583686-4571-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2DPOVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 10:21:07 -0400
Received: by bkcik5 with SMTP id ik5so3688688bkc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 07:21:05 -0700 (PDT)
In-Reply-To: <1334583686-4571-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng Liu,

      What dose this mean, you use printf and not use stdout?


Reviewed-By Steven Liu <LiuQi@zecloud.cn>

2012/4/16 Zheng Liu <gnehzuil.liu@gmail.com>:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> Remove 'out' variable and replace fprintf with printf.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> =A0debugfs/debugfs.c | =A0 =A06 ++----
> =A01 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 590468d..99281ac 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -1973,12 +1973,10 @@ void do_rmdir(int argc, char *argv[])
> =A0void do_show_debugfs_params(int argc EXT2FS_ATTR((unused)),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *argv[] E=
XT2FS_ATTR((unused)))
> =A0{
> - =A0 =A0 =A0 FILE *out =3D stdout;
> -
> =A0 =A0 =A0 =A0if (current_fs)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(out, "Open mode: read-%s\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("Open mode: read-%s\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current_fs->flags & EX=
T2_FLAG_RW ? "write" : "only");
> - =A0 =A0 =A0 fprintf(out, "Filesystem in use: %s\n",
> + =A0 =A0 =A0 printf("Filesystem in use: %s\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current_fs ? current_fs->device_name :=
 "--none--");
> =A0}
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
