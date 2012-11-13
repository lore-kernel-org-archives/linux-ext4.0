From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Tue, 13 Nov 2012 22:19:11 +0800
Message-ID: <20121113141911.GA7472@X61>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com>
 <1352794923-28555-1-git-send-email-lczerner@redhat.com>
 <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com>
 <alpine.LFD.2.00.1211131304030.3577@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, zab@redhat.com,
	dmonakhov@openvz.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56050 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KMOTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 09:19:24 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so5049162pad.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 06:19:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211131304030.3577@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Luk=C3=A1=C5=A1,

On Tue, Nov 13, 2012 at 01:07:03PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 13 Nov 2012, Peng Tao wrote:
>=20
> > Date: Tue, 13 Nov 2012 19:34:41 +0800
> > From: Peng Tao <bergwolf@gmail.com>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, zab@redhat.com,
> >     dmonakhov@openvz.org
> > Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
> >=20
> > On Tue, Nov 13, 2012 at 4:22 PM, Lukas Czerner <lczerner@redhat.com=
> wrote:
> > > Currently ext4_ext_walk_space() only takes i_data_sem for read wh=
en
> > > searching for the extent at given block with ext4_ext_find_extent=
().
> > > Then it drops the lock and the extent tree can be changed at will=
=2E
> > > However later on we're searching for the 'next' extent, but the e=
xtent
> > > tree might already have changed, so the information might not be
> > > accurate.
> > >
> > > In fact we can hit BUG_ON(end <=3D start) if the extent got inser=
ted into
> > > the tree after the one we found and before the block we were sear=
ching
> > > for. This has been reproduced by running xfstests 225 in loop on =
s390x
> > > architecture, but theoretically we could hit this on any other
> > > architecture as well, but probably not as often.
> > >
> > > Fix this by extending the critical section to include
> > > ext4_ext_next_allocated_block() as well. It means that if there a=
re any
> > > operation going on on the particular inode, the fiemap will retur=
n
> > > inaccurate data. However this will also fix the concerns about st=
arving
> > > writers to the extent tree, because we will put and reacquire the
> > > semaphore with every iteration. This will not be particularly fas=
t, but
> > > fiemap is not critical operation.
> > >
> > > However we also need to limit the access to the extent structure =
to the
> > > critical section, because outside of it the content can change. S=
o we
> > > remove extent and next block parameters from ext4_ext_fiemap_cb()
> > > function and pass just flags instead.
> > >
> > > Also we have to move path reinitialization inside the critical se=
ction.
> > >
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > ---
> > > v3: reworked
> > >
> > >  fs/ext4/ext4_extents.h |    5 ++---
> > >  fs/ext4/extents.c      |   40 +++++++++++++++++++++-------------=
------
> > >  2 files changed, 23 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> > > index cb1b2c9..356ad9f 100644
> > > --- a/fs/ext4/ext4_extents.h
> > > +++ b/fs/ext4/ext4_extents.h
> > > @@ -149,9 +149,8 @@ struct ext4_ext_path {
> > >   * positive retcode - signal for ext4_ext_walk_space(), see belo=
w
> > >   * callback must return valid extent (passed or newly created)
> > >   */
> > > -typedef int (*ext_prepare_callback)(struct inode *, ext4_lblk_t,
> > > -                                       struct ext4_ext_cache *,
> > > -                                       struct ext4_extent *, voi=
d *);
> > > +typedef int (*ext_prepare_callback)(struct inode *, struct ext4_=
ext_cache *,
> > > +                                   unsigned int, void *);
> > >
> > >  #define EXT_CONTINUE   0
> > >  #define EXT_BREAK      1
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index 7011ac9..c097acf 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -1968,7 +1968,8 @@ static int ext4_ext_walk_space(struct inode=
 *inode, ext4_lblk_t block,
> > >         struct ext4_extent *ex;
> > >         ext4_lblk_t next, start =3D 0, end =3D 0;
> > >         ext4_lblk_t last =3D block + num;
> > > -       int depth, exists, err =3D 0;
> > > +       int exists, depth =3D 0, err =3D 0;
> > > +       unsigned int flags =3D 0;
> > >
> > >         BUG_ON(func =3D=3D NULL);
> > >         BUG_ON(inode =3D=3D NULL);
> > > @@ -1977,9 +1978,16 @@ static int ext4_ext_walk_space(struct inod=
e *inode, ext4_lblk_t block,
> > >                 num =3D last - block;
> > >                 /* find extent for this block */
> > >                 down_read(&EXT4_I(inode)->i_data_sem);
> > > +
> > > +               if (path && ext_depth(inode) !=3D depth) {
> > > +                       /* depth was changed. we have to realloc =
path */
> > > +                       kfree(path);
> > > +                       path =3D NULL;
> > > +               }
> > > +
> > >                 path =3D ext4_ext_find_extent(inode, block, path)=
;
> > > -               up_read(&EXT4_I(inode)->i_data_sem);
> > >                 if (IS_ERR(path)) {
> > > +                       up_read(&EXT4_I(inode)->i_data_sem);
> > >                         err =3D PTR_ERR(path);
> > >                         path =3D NULL;
> > >                         break;
> > > @@ -1987,6 +1995,7 @@ static int ext4_ext_walk_space(struct inode=
 *inode, ext4_lblk_t block,
> > >
> > >                 depth =3D ext_depth(inode);
> > >                 if (unlikely(path[depth].p_hdr =3D=3D NULL)) {
> > > +                       up_read(&EXT4_I(inode)->i_data_sem);
> > >                         EXT4_ERROR_INODE(inode, "path[%d].p_hdr =3D=
=3D NULL", depth);
> > >                         err =3D -EIO;
> > >                         break;
> > > @@ -2037,14 +2046,21 @@ static int ext4_ext_walk_space(struct ino=
de *inode, ext4_lblk_t block,
> > >                         cbex.ec_block =3D le32_to_cpu(ex->ee_bloc=
k);
> > >                         cbex.ec_len =3D ext4_ext_get_actual_len(e=
x);
> > >                         cbex.ec_start =3D ext4_ext_pblock(ex);
> > > +                       if (ext4_ext_is_uninitialized(ex))
> > > +                               flags |=3D FIEMAP_EXTENT_UNWRITTE=
N;
> > >                 }
> > > +               up_read(&EXT4_I(inode)->i_data_sem);
> > >
> > >                 if (unlikely(cbex.ec_len =3D=3D 0)) {
> > >                         EXT4_ERROR_INODE(inode, "cbex.ec_len =3D=3D=
 0");
> > >                         err =3D -EIO;
> > >                         break;
> > >                 }
> > > -               err =3D func(inode, next, &cbex, ex, cbdata);
> > > +
> > > +               if (next =3D=3D EXT_MAX_BLOCKS)
> > > +                       flags |=3D FIEMAP_EXTENT_LAST;
> > > +
> > > +               err =3D func(inode, &cbex, flags, cbdata);
> > You may want to include func() in the critical section as well, to =
fix
> > the cp data corruption reported by Roger Niva. It looks to be the s=
ame
> > race.
>=20
> That's not a good idea. As already mentioned by Zach Brown
> ext4_ext_fiemap_cb() is doing all kinds of things including possibly
> taking i_data_sem.=20
Execpt that the race is real. If a page is written back between
ext4_ext_find_extent() and ext4_ext_fiemap_cb(), find_get_pages_tag()
cannot find the dirty page and thus ext4_fiemap returns hole for the
corresponding blocks, even if it is written by application before.

As a result, cp(1) that relies on FIEMAP will write zero for the
corresponding block and cause data corruption.

The deadlock mentioned by Zach Brown can be fixed by simply switching
to GFP_NOFS.

> Moreover even if we do that, after we drop the
> semaphore and return data to the user it might no longer be valid
> anyway in the case there is any IO going on on the file.
The race is different from concurrent user space writers. It is similar
to the original bug fixed by commit 6d9c85e, ext4_fiemap reporting
incorrect file mapping for ranges where pages are written back between
ext4_ext_find_extent() and ext4_ext_fiemap_cb().

Thanks,
Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
