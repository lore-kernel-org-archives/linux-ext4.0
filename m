From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] debugfs: cleanup in do_show_debugfs_params
Date: Mon, 16 Apr 2012 22:41:11 +0800
Message-ID: <20120416144111.GA4827@gmail.com>
References: <1334583686-4571-1-git-send-email-wenqing.lz@taobao.com>
 <CADxeRw=byZRehhPYLikEtdBHRAxeu_cN_9iPy_MPVOF8hGdrTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Steven Liu <lingjiujianke@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52531 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab2DPOeq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 10:34:46 -0400
Received: by dake40 with SMTP id e40so6999034dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 07:34:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CADxeRw=byZRehhPYLikEtdBHRAxeu_cN_9iPy_MPVOF8hGdrTg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 16, 2012 at 10:21:05PM +0800, Steven Liu wrote:
> Hi Zheng Liu,
>=20
>       What dose this mean, you use printf and not use stdout?

printf() is the same as fprintf(stdout, ...).  So I just remove 'out'
variable.  Am I missing something?

Regards,
Zheng

>=20
>=20
> Reviewed-By Steven Liu <LiuQi@zecloud.cn>
>=20
> 2012/4/16 Zheng Liu <gnehzuil.liu@gmail.com>:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >
> > Remove 'out' variable and replace fprintf with printf.
> >
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> > =C2=A0debugfs/debugfs.c | =C2=A0 =C2=A06 ++----
> > =C2=A01 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> > index 590468d..99281ac 100644
> > --- a/debugfs/debugfs.c
> > +++ b/debugfs/debugfs.c
> > @@ -1973,12 +1973,10 @@ void do_rmdir(int argc, char *argv[])
> > =C2=A0void do_show_debugfs_params(int argc EXT2FS_ATTR((unused)),
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *argv[] EXT2FS_ATTR((unused)))
> > =C2=A0{
> > - =C2=A0 =C2=A0 =C2=A0 FILE *out =3D stdout;
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (current_fs)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(out, "Op=
en mode: read-%s\n",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf("Open mod=
e: read-%s\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0current_fs->flags & EXT2_FLAG_RW ? "write" : "only");
> > - =C2=A0 =C2=A0 =C2=A0 fprintf(out, "Filesystem in use: %s\n",
> > + =C2=A0 =C2=A0 =C2=A0 printf("Filesystem in use: %s\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0current_fs ?=
 current_fs->device_name : "--none--");
> > =C2=A0}
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
