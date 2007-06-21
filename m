From: Dmitry Monakhov <dmonakhov@sw.ru>
Subject: Re: delayed allocatiou result in Oops
Date: Thu, 21 Jun 2007 08:50:58 +0400
Message-ID: <20070621045058.GG20172@localhost.sw.ru>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com> <20070616081426.GB14349@localhost.sw.ru> <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com> <46778186.9030306@clusterfs.com> <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com> <4678E20D.6060108@clusterfs.com> <1182383170.22978.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:32323 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXFUEuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 00:50:16 -0400
Content-Disposition: inline
In-Reply-To: <1182383170.22978.11.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 16:46 =D0=A1=D1=80=D0=B4 20 =D0=98=D1=8E=D0=BD     , Mingming Cao wr=
ote:
> On Wed, 2007-06-20 at 12:15 +0400, Alex Tomas wrote:
> > Mingming Cao wrote:
> > > Hmm, PageMappedToDisk is probably not sufficient enough for pages=
ize!
> > > =3Dblocksize. Is that the reason we need page->private to pass th=
e
> > > request?
> >=20
> > PageMappedToDisk isn't enough in that case, definitely. bh is the w=
ay
> > to track state of each block (this is what i'm implementing now), b=
ut
> > I think current nobh version (per-page flags are used) is valuable.
> >=20
> > > That's good to know, thanks for the update. So probably above err=
or case
> > > handling will be addressed in the new version?=20
> >=20
> > well, you actually can move that SetPagePrivate() few lines above
> > (Dmitriy already tested this).
>=20
> Like this?
Of course not, we may set page private bit only if=20
space was successfully reserved by ext4_wb_reserve_space_page().
So patch looks like this:
diff --git a/fs/ext4/writeback.c b/fs/ext4/writeback.c
index 3e669d6..84e5029 100644
--- a/fs/ext4/writeback.c
+++ b/fs/ext4/writeback.c
@@ -904,9 +904,6 @@ int ext4_wb_commit_write(struct file *file, struct =
page *page,
 	wb_debug("commit page %lu (%u-%u) for inode %lu\n",
 			page->index, from, to, inode->i_ino);
=20
-	/* mark page private so that we get
-	 * called to invalidate/release page */
-	SetPagePrivate(page);
=20
 	if (!PageBooked(page) && !PageMappedToDisk(page)) {
 		/* ->prepare_write() observed that block for this
@@ -918,6 +915,9 @@ int ext4_wb_commit_write(struct file *file, struct =
page *page,
 		if (err)
 			return err;
 	}
+	/* mark page private so that we get
+	 * called to invalidate/release page */
+	SetPagePrivate(page);
=20
 	/* ok. block for this page is allocated already or it has
 	 * been reserved succesfully. so, user may use it */
--=20
1.5.2
>=20
> Index: linux-2.6.22-rc5/fs/ext4/writeback.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.22-rc5.orig/fs/ext4/writeback.c	2007-06-20 16:41:26.000=
000000 -0700
> +++ linux-2.6.22-rc5/fs/ext4/writeback.c	2007-06-20 16:44:10.00000000=
0 -0700
> @@ -918,16 +918,16 @@ int ext4_wb_commit_write(struct file *fi
>  	wb_debug("commit page %lu (%u-%u) for inode %lu\n",
>  			page->index, from, to, inode->i_ino);
> =20
> -	/* mark page private so that we get
> -	 * called to invalidate/release page */
> -	SetPagePrivate(page);
> -
>  	if (!PageBooked(page) && !PageMappedToDisk(page)) {
>  		/* ->prepare_write() observed that block for this
>  		 * page hasn't been allocated yet. there fore it
>  		 * asked to reserve block for later allocation */
>  		BUG_ON(page->private =3D=3D 0);
>  		page->private =3D 0;
> +		/* mark page private so that we get
> +		 * called to invalidate/release page */
> +		SetPagePrivate(page);
> +
>  		err =3D ext4_wb_reserve_space_page(page, 1);
>  		if (err)
>  			return err;
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
