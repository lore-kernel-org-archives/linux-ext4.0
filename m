From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert ext3_ioctl() to an unlocked_ioctl
Date: Fri, 18 Jan 2008 00:48:29 +0100
Message-ID: <87wsq89foy.fsf@barad-dur.regala.cx>
References: <1200573450-1246-1-git-send-email-mathieu.segaud@regala.cx>
	<1200573450-1246-2-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:38855
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbYAQXsa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 18:48:30 -0500
In-Reply-To: <1200573450-1246-2-git-send-email-mathieu.segaud@regala.cx> (Mathieu Segaud's message of "Thu\, 17 Jan 2008 13\:37\:29 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vous m'avez dit r=E9cemment :

> --- a/fs/ext3/ioctl.c
> +++ b/fs/ext3/ioctl.c
> @@ -17,12 +17,19 @@
>  #include <linux/smp_lock.h>
>  #include <asm/uaccess.h>
> =20
> -int ext3_ioctl (struct inode * inode, struct file * filp, unsigned i=
nt cmd,
> +long ext3_ioctl(struct file *filp, unsigned int cmd,
>  		unsigned long arg)
>  {
> -	struct ext3_inode_info *ei =3D EXT3_I(inode);
> +	struct ext3_inode_info *ei;
> +	struct inode *inode;
>  	unsigned int flags;
>  	unsigned short rsv_window_size;
> +	long retval =3D 0;
> +
> +	lock_kernel();
> +
> +	inode =3D filp->f_dentry->d_inode;

I guess this should be
        inode =3D filp->f_path.dentry->d_inode;


I will repost a fixed patch
sorry for this one.


> +	ei =3D EXT3_I(inode);
> =20
>  	ext3_debug ("cmd =3D %u, arg =3D %lu\n", cmd, arg);
> =20

--=20
Mathieu
