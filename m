From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 10:46:36 +0800
Message-ID: <BANLkTimFTLfQL0RUfyaghpT=pHp7HUYEPQ@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52715 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1ERCqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 22:46:37 -0400
Received: by vxi39 with SMTP id 39so813578vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 19:46:37 -0700 (PDT)
In-Reply-To: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 6:59 AM, Jiaying Zhang <jiayingz@google.com> wr=
ote:
> There is a bug in commit c8d46e41 "ext4: Add flag to files with block=
s
> intentionally past EOF" that if we fallocate a file with FALLOC_FL_KE=
EP_SIZE
> flag and then ftruncate the file to a size larger than the file's i_s=
ize,
> any allocated but unwritten blocks will be freed but the file size is=
 set
> to the size that ftruncate specifies.
>
> Here is a simple test to reproduce the problem:
> =A01. fallocate a 12k size file with KEEP_SIZE flag
> =A02. write the first 4k
> =A03. ftruncate the file to 8k
> Then 'ls -l' shows that the i_size of the file becomes 8k but debugfs
> shows the file has only the first written block left.
>
> Below is the proposed patch to fix the bug:
>
> ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr().
>
> Change ext4_setattr() to use vmtruncate(inode, attr->ia_size) instead
> of ext4_truncate(inode) when it needs to truncate an inode so that
> if the inode has EXT4_EOFBLOCKS_FL flag set and we are trying to trun=
cate
> to a size larger than the inode's i_size, we will only truncate the b=
locks
> beyond the specified truncate size instead of all of blocks beyond i_=
size.
>
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3424e82..3bfad57 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5347,8 +5347,11 @@ int ext4_setattr(struct dentry *dentry, struct=
 iattr *attr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ext4_truncate will clear the flag *=
/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ext4_test_inode_flag(inode, EXT4_I=
NODE_EOFBLOCKS)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ext4_test_inode_flag(inode, EXT4_I=
NODE_EOFBLOCKS))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D vmtruncate(inode=
, attr->ia_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto er=
r_out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
Hi there,
It seems that the error handling has problems.  1)We should handle
error as the below code does. or 2) we can add a OR condition to the
if statement below so that it can handle case here.  I prefer the 2nd
solution.  it looks like:
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ext4_truncate will clear the flag *=
/
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ext4_test_inode_flag(inode, EXT4_INO=
DE_EOFBLOCKS)))
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);

-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size !=3D i_size_read(inode))
+	if (((attr->ia_valid & ATTR_SIZE) &&
+	    attr->ia_size !=3D i_size_read(inode)) ||
+          ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
		rc =3D vmtruncate(inode, attr->ia_size);

Yongqiang.
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if ((attr->ia_valid & ATTR_SIZE) &&


> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
