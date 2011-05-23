From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Mon, 23 May 2011 11:30:29 -0700
Message-ID: <BANLkTi=0NSws0GV4hP5KPPqvp4bxOSEbaQ@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
	<20110522235625.GC10009@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:8909 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1EWSai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 14:30:38 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id p4NIUUTd000705
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 11:30:36 -0700
Received: from gwb20 (gwb20.prod.google.com [10.200.2.20])
	by wpaz1.hot.corp.google.com with ESMTP id p4NITe2x017751
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 11:30:29 -0700
Received: by gwb20 with SMTP id 20so2251128gwb.3
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 11:30:29 -0700 (PDT)
In-Reply-To: <20110522235625.GC10009@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Sun, May 22, 2011 at 4:56 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Here's a cleaner way of fixing the problem. =A0vmtruncate() is now
> deprecated, so I'm using truncate_setsize() instead; in addition, I
> avoid calling ext4_truncate() twice in the case where EOFBLOCKS_FL.
> Since ext4_truncate() is a very heavyweight function, which requires
> manipulating the orphan list and taking i_data_sem, avoiding a double
> call of ext4_truncate() is a big win.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> commit bb5eabd2de1e9dfdeeac822174fba17f2d2a7f2b
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Sun May 22 19:45:01 2011 -0400
>
> =A0 =A0ext4: use truncate_setsize() unconditionally
>
> =A0 =A0In commit c8d46e41 (ext4: Add flag to files with blocks intent=
ionally
> =A0 =A0past EOF), if the EOFBLOCKS_FL flag is set, we call ext4_trunc=
ate()
> =A0 =A0before calling vmtruncate(). =A0This caused any allocated but =
unwritten
> =A0 =A0blocks created by calling fallocate() with the FALLOC_FL_KEEP_=
SIZE
> =A0 =A0flag to be dropped. =A0This was done to make to make sure that
> =A0 =A0EOFBLOCKS_FL would not be cleared while still leaving blocks p=
ast
> =A0 =A0i_size allocated. =A0This was not necessary, since ext4_trunca=
te()
> =A0 =A0guarantees that blocks past i_size will be dropped, even in th=
e case
> =A0 =A0where truncate() has increased i_size before calling ext4_trun=
cate().
>
> =A0 =A0So fix this by removing the EOFBLOCKS_FL special case treatmen=
t in
> =A0 =A0ext4_setattr(). =A0In addition, use truncate_setsize() followe=
d by a
> =A0 =A0call to ext4_truncate() instead of using vmtruncate(). =A0This=
 is more
> =A0 =A0efficient since it skips the call to inode_newsize_ok(), which=
 has
> =A0 =A0been checked already by inode_change_ok(). =A0This is also in =
a win in
> =A0 =A0the case where EOFBLOCKS_FL is set since it avoids calling
> =A0 =A0ext4_truncate() twice.
>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index df3fb20..4ca8411 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5363,8 +5363,7 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
>
> =A0 =A0 =A0 =A0if (S_ISREG(inode->i_mode) &&
> =A0 =A0 =A0 =A0 =A0 =A0attr->ia_valid & ATTR_SIZE &&
> - =A0 =A0 =A0 =A0 =A0 (attr->ia_size < inode->i_size ||
> - =A0 =A0 =A0 =A0 =A0 =A0(ext4_test_inode_flag(inode, EXT4_INODE_EOFB=
LOCKS)))) {
> + =A0 =A0 =A0 =A0 =A0 (attr->ia_size < inode->i_size)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle_t *handle;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 3=
);
> @@ -5398,14 +5397,13 @@ int ext4_setattr(struct dentry *dentry, struc=
t iattr *attr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto e=
rr_out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ext4_truncate will clear the flag */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ext4_test_inode_flag(inode, EXT4_I=
NODE_EOFBLOCKS)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if ((attr->ia_valid & ATTR_SIZE) &&
> - =A0 =A0 =A0 =A0 =A0 attr->ia_size !=3D i_size_read(inode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D vmtruncate(inode, attr->ia_size)=
;
> + =A0 =A0 =A0 =A0 =A0 attr->ia_size !=3D i_size_read(inode)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 truncate_setsize(inode, attr->ia_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> + =A0 =A0 =A0 }
I think your patch doesn't cover the case when we fallocate with
KEEP_SIZE a 12k file, write 4k, and then truncate the file to 4k.
In this case, attr->ia_size is equal to i_size but we still want to
free any allocated but unwritten blocks during truncate.

Jiaying
>
> =A0 =A0 =A0 =A0if (!rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0setattr_copy(inode, attr);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
