From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert ext4_ioctl to an unlocked_ioctl
Date: Fri, 18 Jan 2008 00:50:01 +0100
Message-ID: <87sl0w9fme.fsf@barad-dur.regala.cx>
References: <1200573450-1246-1-git-send-email-mathieu.segaud@regala.cx>
	<1200573450-1246-2-git-send-email-mathieu.segaud@regala.cx>
	<1200573450-1246-3-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:38858
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYAQXuD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 18:50:03 -0500
In-Reply-To: <1200573450-1246-3-git-send-email-mathieu.segaud@regala.cx> (Mathieu Segaud's message of "Thu\, 17 Jan 2008 13\:37\:30 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vous m'avez dit r=E9cemment :

as well for this one,

> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -17,12 +17,18 @@
>  #include <linux/smp_lock.h>
>  #include <asm/uaccess.h>
> =20
> -int ext4_ioctl (struct inode * inode, struct file * filp, unsigned i=
nt cmd,
> -		unsigned long arg)
> +long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long a=
rg)
>  {
> -	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	struct ext4_inode_info *ei;
> +	struct inode *inode;
>  	unsigned int flags;
>  	unsigned short rsv_window_size;
> +	long retval =3D 0;
> +
> +	lock_kernel();
> +
> +	inode =3D filp->f_dentry->d_inode;

this should be inode =3D filp->f_path.dentry->d_inode;

I will update this one too, sorry for this one as well :-)

--=20
Mathieu
