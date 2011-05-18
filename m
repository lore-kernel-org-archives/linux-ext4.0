From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 10:56:42 +0800
Message-ID: <BANLkTi==v=ShDNzhWHEAFcpzC9uKC63FBg@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54676 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab1ERC4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 22:56:43 -0400
Received: by vws1 with SMTP id 1so811304vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 19:56:42 -0700 (PDT)
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
> =A0 =A0 =A0 =A0}
Another question, does vmtruncate() write zeros to blocks beyond old
EOF?  I had a rough look and could not find the code doing this, maybe
due to my density.

Yongqiang.
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
