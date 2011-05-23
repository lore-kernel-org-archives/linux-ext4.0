From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH -v2] ext4: use truncate_setsize() unconditionally
Date: Mon, 23 May 2011 13:22:38 -0700
Message-ID: <BANLkTi=hQa_y27yF5A431+eBmSjbK4nJGQ@mail.gmail.com>
References: <BANLkTi=0NSws0GV4hP5KPPqvp4bxOSEbaQ@mail.gmail.com>
	<1306178341-17632-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:60396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169Ab1EWUWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 16:22:42 -0400
Received: from kpbe17.cbf.corp.google.com (kpbe17.cbf.corp.google.com [172.25.105.81])
	by smtp-out.google.com with ESMTP id p4NKMeG0027077
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 13:22:41 -0700
Received: from gyf1 (gyf1.prod.google.com [10.243.50.65])
	by kpbe17.cbf.corp.google.com with ESMTP id p4NKLuRv011466
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 13:22:39 -0700
Received: by gyf1 with SMTP id 1so2418810gyf.6
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 13:22:39 -0700 (PDT)
In-Reply-To: <1306178341-17632-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 23, 2011 at 12:19 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> In commit c8d46e41 (ext4: Add flag to files with blocks intentionally
> past EOF), if the EOFBLOCKS_FL flag is set, we call ext4_truncate()
> before calling vmtruncate(). =A0This caused any allocated but unwritt=
en
> blocks created by calling fallocate() with the FALLOC_FL_KEEP_SIZE
> flag to be dropped. =A0This was done to make to make sure that
> EOFBLOCKS_FL would not be cleared while still leaving blocks past
> i_size allocated. =A0This was not necessary, since ext4_truncate()
> guarantees that blocks past i_size will be dropped, even in the case
> where truncate() has increased i_size before calling ext4_truncate().
>
> So fix this by removing the EOFBLOCKS_FL special case treatment in
> ext4_setattr(). =A0In addition, use truncate_setsize() followed by a
> call to ext4_truncate() instead of using vmtruncate(). =A0This is mor=
e
> efficient since it skips the call to inode_newsize_ok(), which has
> been checked already by inode_change_ok(). =A0This is also in a win i=
n
> the case where EOFBLOCKS_FL is set since it avoids calling
> ext4_truncate() twice.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0Jiayingz pointed out that in the case where we fallocate 12k, writ=
e 4k, and
> =A0then truncate to 4k, we should discard the excess fallocate'd bloc=
ks. =A0So if
> =A0attr->ia_size =3D=3D inode.i_size, we can skip the truncate_setsiz=
e() call, but
> =A0if the EOFBLOCKS_FL flag is set, we should still call ext4_truncat=
e().
>
> =A0fs/ext4/inode.c | =A0 16 ++++++++--------
> =A01 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index df3fb20..2e95819 100644
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
> @@ -5398,14 +5397,15 @@ int ext4_setattr(struct dentry *dentry, struc=
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
> - =A0 =A0 =A0 if ((attr->ia_valid & ATTR_SIZE) &&
> - =A0 =A0 =A0 =A0 =A0 attr->ia_size !=3D i_size_read(inode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D vmtruncate(inode, attr->ia_size)=
;
> + =A0 =A0 =A0 if (attr->ia_valid & ATTR_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (attr->ia_size !=3D i_size_read(inod=
e)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 truncate_setsize(inode,=
 attr->ia_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (ext4_test_inode_flag(inode, =
EXT4_INODE_EOFBLOCKS))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (!rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0setattr_copy(inode, attr);
> --
> 1.7.3.1
lgtm.

Jiaying

>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
