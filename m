From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: cleanup the comment for ext2_export_ops
Date: Tue, 15 May 2012 11:59:56 +0200
Message-ID: <20120515095956.GA22359@quack.suse.cz>
References: <4FB0B0F4.3060908@gmail.com>
 <20120514095525.GD5353@quack.suse.cz>
 <4FB19B96.4010106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab2EOKAR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2012 06:00:17 -0400
Content-Disposition: inline
In-Reply-To: <4FB19B96.4010106@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-05-12 07:56:06, Wang Sheng-Hui wrote:
> On 2012=E5=B9=B405=E6=9C=8814=E6=97=A5 17:55, Jan Kara wrote:
> > On Mon 14-05-12 15:15:00, Wang Sheng-Hui wrote:
> >> ext2_export_ops gets more valued fields, not get_parent only.
> >> Clean up the comment.
> >   Um, I'd just remove the whole comment. It isn't particularly info=
rmative
> > anyway - NULL meaning the default behavior is very common in kernel=
=2E And we
> > really set about half of entries anyway...
> >=20
> > 								Honza
>=20
> Thanks, Honza.
>=20
> Patch regenerated. Please check it.
  OK, thanks for the patch.

								Honza

> >> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> >> ---
> >>  fs/ext2/super.c |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> >> index e1025c7..640b4c6 100644
> >> --- a/fs/ext2/super.c
> >> +++ b/fs/ext2/super.c
> >> @@ -359,7 +359,6 @@ static struct dentry *ext2_fh_to_parent(struct=
 super_block *sb, struct fid *fid,
> >>  /* Yes, most of these are left as NULL!!
> >>   * A NULL value implies the default, which works with ext2-like f=
ile
> >>   * systems, but can be improved upon.
> >> - * Currently only get_parent is required.
> >>   */
> >>  static const struct export_operations ext2_export_ops =3D {
> >>  	.fh_to_dentry =3D ext2_fh_to_dentry,
> >> --=20
> >> 1.7.1
>=20
> From 362925f80bdfb1c105e346f535c5e51c7359b550 Mon Sep 17 00:00:00 200=
1
> From: Wang Sheng-Hui <shhuiw@gmail.com>
> Date: Tue, 15 May 2012 07:53:46 +0800
> Subject: [PATCH] ext2: remove the redundant comment for ext2_export_o=
ps
>=20
> Per Honza, It isn't particularly informative anyway - NULL
> meaning the default behavior is very common in kernel. And we
> really set about half of entries anyway.
>=20
> Remove the whole comment for ext2_export_ops.
>=20
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/ext2/super.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index e1025c7..f9b0f41 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -356,11 +356,6 @@ static struct dentry *ext2_fh_to_parent(struct s=
uper_block *sb, struct fid *fid,
>  				    ext2_nfs_get_inode);
>  }
> =20
> -/* Yes, most of these are left as NULL!!
> - * A NULL value implies the default, which works with ext2-like file
> - * systems, but can be improved upon.
> - * Currently only get_parent is required.
> - */
>  static const struct export_operations ext2_export_ops =3D {
>  	.fh_to_dentry =3D ext2_fh_to_dentry,
>  	.fh_to_parent =3D ext2_fh_to_parent,
> --=20
> 1.7.1
>=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
