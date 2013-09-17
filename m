From: Jan Kara <jack@suse.cz>
Subject: Re: fix the ext4_read_inline_dir return value
Date: Tue, 17 Sep 2013 19:38:30 +0200
Message-ID: <20130917173830.GC16938@quack.suse.cz>
References: <CAAFszuWi7u_-eYFBB=hvWqfZBcZBhneVK8m6JZhzd9Hakh8oiA@mail.gmail.com>
 <20130917162916.GA16938@quack.suse.cz>
 <CAAFszuWdFeyc7EZBbfnegmE_64eyE-PE3MRBYfTdnv0gYSgm4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Robin Dong <sanbai@taobao.com>,
	"tm@tao.ma" <tm@tao.ma>, "lewis.liulei" <lewis.liulei@huawei.com>,
	pamirs <pamirs@163.com>
To: Boxi Liu <boxi10liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab3IQRie (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Sep 2013 13:38:34 -0400
Content-Disposition: inline
In-Reply-To: <CAAFszuWdFeyc7EZBbfnegmE_64eyE-PE3MRBYfTdnv0gYSgm4g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-09-13 01:30:36, Boxi Liu wrote:
> Thanks to point the that,I will fix it.
  You have added the Signed-off-by line but whitespace is still damaged=
=2E
You really have to add the patch as an attachment to the email when usi=
ng
gmail.  Also please send patches as separate emails not as a reply to s=
ome
email.  That way maintainer (Ted Tso in this case) is much less likely =
to
miss the patch. Thanks.

								Honza
>=20
> ext4: fix the ext4_read_inline_dir return value
>=20
> In ext4_read_inlne_dir,the return value is the return
> of ext4_read_inline_data len.But in no inline_data case,
> the return value is 0,it's inconsistent.So fix the return
> value of ext4_read_inline_dir.
>=20
> Signed-off-by: BoxiLiu <lewis.liulei@huawei.com>
> ---
>  fs/ext4/inline.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index d9ecbf1..c3efb65 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1442,6 +1442,7 @@ int ext4_read_inline_dir(struct file *file,
>   if (ret < 0)
>   goto out;
>=20
> + ret =3D 0;
>   sb =3D inode->i_sb;
>   parent_ino =3D le32_to_cpu(((struct ext4_dir_entry_2 *)dir_buf)->in=
ode);
>   offset =3D ctx->pos;
> --=20
>=20
> 2013/9/18 Jan Kara <jack@suse.cz>:
> > On Tue 17-09-13 23:08:51, Boxi Liu wrote:
> >> hi=EF=BC=8C
> >> there may be a bug in ext4_read_inline_dir() function with inline_=
data feature.
> >> when I recursion call a sys_old_readdir to read a direntry's
> >> sub_dentry,I find that the ext4_read_inline_dir return the len of =
the
> >> inline_data ,but in the no inline_data case,it will return 0.It is
> >> inconsistent.
> >> So I try to make a patch to fix it.
> >   The patch is fine, thanks for finding the bug. But please read
> > Documentation/SubmittingPatches about how your patch should be form=
atted.
> > In particular your patch has damaged whitespace (tabs converted to =
spaces).
> > Gmail does this - you have to send the patch as an attachment to av=
oid this
> > when using gmail.  Also your patch misses Signed-off-by line.
> >
> >                                                                 Hon=
za
> >>
> >> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> >> index d9ecbf1..3ea39cd 100644
> >> --- a/fs/ext4/inline.c
> >> +++ b/fs/ext4/inline.c
> >> @@ -1441,7 +1441,7 @@ int ext4_read_inline_dir(struct file *file,
> >>   up_read(&EXT4_I(inode)->xattr_sem);
> >>   if (ret < 0)
> >>   goto out;
> >> -
> >> +   ret =3D 0;
> >>   sb =3D inode->i_sb;
> >>   parent_ino =3D le32_to_cpu(((struct ext4_dir_entry_2 *)dir_buf)-=
>inode);
> >>   offset =3D ctx->pos;
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
