From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/31] libext2fs: Fix ext2fs_open2() truncation of the
 superblock parameter
Date: Mon, 7 Oct 2013 11:42:47 -0700
Message-ID: <20131007184247.GC6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012812.28415.49840.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310071626420.7011@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3JGSm7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Oct 2013 14:42:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310071626420.7011@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:30:39PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 30 Sep 2013, Darrick J. Wong wrote:
>=20
> > Date: Mon, 30 Sep 2013 18:28:12 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 14/31] libext2fs: Fix ext2fs_open2() truncation of =
the
> >     superblock parameter
> >=20
> > Since it's possible for very large filesystems to store backup supe=
rblocks at
> > very large (> 2^32) block numbers, we need to be able to handle the=
 case of a
> > caller directing us to read one of these high-numbered backups.
>=20
> I do not think this is enough, because in ext2fs_open2() or rather
> ext2fs_open3() as you rename it we read the superblock block with
> io_channel_read_blk() which takes unsigned long as a block number
> rather than io_channel_read_blk64().
>=20
> Having a simple test for this particular case might be useful.

Good catch!  I've updated the patch.

--D
>=20
> Thanks!
> -Lukas
>=20
>=20
>=20
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  debugfs/debugfs.c   |    4 ++--
> >  e2fsck/journal.c    |    6 +++---
> >  e2fsck/unix.c       |    8 ++++----
> >  lib/ext2fs/ext2fs.h |    4 ++++
> >  lib/ext2fs/openfs.c |   13 +++++++++++--
> >  misc/dumpe2fs.c     |    4 ++--
> >  6 files changed, 26 insertions(+), 13 deletions(-)
> >=20
> >=20
> > diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> > index 2660218..da44ce4 100644
> > --- a/debugfs/debugfs.c
> > +++ b/debugfs/debugfs.c
> > @@ -80,8 +80,8 @@ static void open_filesystem(char *device, int ope=
n_flags, blk64_t superblock,
> >  	if (catastrophic)
> >  		open_flags |=3D EXT2_FLAG_SKIP_MMP;
> > =20
> > -	retval =3D ext2fs_open(device, open_flags, superblock, blocksize,
> > -			     unix_io_manager, &current_fs);
> > +	retval =3D ext2fs_open3(device, NULL, open_flags, superblock, blo=
cksize,
> > +			      unix_io_manager, &current_fs);
> >  	if (retval) {
> >  		com_err(device, retval, "while opening filesystem");
> >  		current_fs =3D NULL;
> > diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> > index 2509303..af35a38 100644
> > --- a/e2fsck/journal.c
> > +++ b/e2fsck/journal.c
> > @@ -967,9 +967,9 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
> > =20
> >  	ext2fs_mmp_stop(ctx->fs);
> >  	ext2fs_free(ctx->fs);
> > -	retval =3D ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
> > -			     ctx->superblock, blocksize, io_ptr,
> > -			     &ctx->fs);
> > +	retval =3D ext2fs_open3(ctx->filesystem_name, NULL, EXT2_FLAG_RW,
> > +			      ctx->superblock, blocksize, io_ptr,
> > +			      &ctx->fs);
> >  	if (retval) {
> >  		com_err(ctx->program_name, retval,
> >  			_("while trying to re-open %s"),
> > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > index 0546653..fb41ca0 100644
> > --- a/e2fsck/unix.c
> > +++ b/e2fsck/unix.c
> > @@ -1040,7 +1040,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, in=
t flags, io_manager io_ptr,
> > =20
> >  	*ret_fs =3D NULL;
> >  	if (ctx->superblock && ctx->blocksize) {
> > -		retval =3D ext2fs_open2(ctx->filesystem_name, ctx->io_options,
> > +		retval =3D ext2fs_open3(ctx->filesystem_name, ctx->io_options,
> >  				      flags, ctx->superblock, ctx->blocksize,
> >  				      io_ptr, ret_fs);
> >  	} else if (ctx->superblock) {
> > @@ -1051,7 +1051,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, in=
t flags, io_manager io_ptr,
> >  				ext2fs_free(*ret_fs);
> >  				*ret_fs =3D NULL;
> >  			}
> > -			retval =3D ext2fs_open2(ctx->filesystem_name,
> > +			retval =3D ext2fs_open3(ctx->filesystem_name,
> >  					      ctx->io_options, flags,
> >  					      ctx->superblock, blocksize,
> >  					      io_ptr, ret_fs);
> > @@ -1059,7 +1059,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, in=
t flags, io_manager io_ptr,
> >  				break;
> >  		}
> >  	} else
> > -		retval =3D ext2fs_open2(ctx->filesystem_name, ctx->io_options,
> > +		retval =3D ext2fs_open3(ctx->filesystem_name, ctx->io_options,
> >  				      flags, 0, 0, io_ptr, ret_fs);
> > =20
> >  	if (retval =3D=3D 0)
> > @@ -1375,7 +1375,7 @@ failure:
> >  	 * don't need to update the mount count and last checked
> >  	 * fields in the backup superblock (the kernel doesn't update
> >  	 * the backup superblocks anyway).  With newer versions of the
> > -	 * library this flag is set by ext2fs_open2(), but we set this
> > +	 * library this flag is set by ext2fs_open3(), but we set this
> >  	 * here just to be sure.  (No, we don't support e2fsck running
> >  	 * with some other libext2fs than the one that it was shipped
> >  	 * with, but just in case....)
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index c37e00b..d5d8d03 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -1437,6 +1437,10 @@ extern errcode_t ext2fs_open2(const char *na=
me, const char *io_options,
> >  			      int flags, int superblock,
> >  			      unsigned int block_size, io_manager manager,
> >  			      ext2_filsys *ret_fs);
> > +extern errcode_t ext2fs_open3(const char *name, const char *io_opt=
ions,
> > +			      int flags, blk64_t superblock,
> > +			      unsigned int block_size, io_manager manager,
> > +			      ext2_filsys *ret_fs);
> >  extern blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs,
> >  					blk64_t group_block, dgrp_t i);
> >  extern blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t gro=
up_block,
> > diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> > index 89117f4..3c0bf14 100644
> > --- a/lib/ext2fs/openfs.c
> > +++ b/lib/ext2fs/openfs.c
> > @@ -76,6 +76,15 @@ errcode_t ext2fs_open(const char *name, int flag=
s, int superblock,
> >  			    manager, ret_fs);
> >  }
> > =20
> > +errcode_t ext2fs_open2(const char *name, const char *io_options,
> > +		       int flags, int superblock,
> > +		       unsigned int block_size, io_manager manager,
> > +		       ext2_filsys *ret_fs)
> > +{
> > +	return ext2fs_open3(name, io_options, flags, superblock, block_si=
ze,
> > +			    manager, ret_fs);
> > +}
> > +
> >  /*
> >   *  Note: if superblock is non-zero, block-size must also be non-z=
ero.
> >   * 	Superblock and block_size can be zero to use the default size.
> > @@ -90,8 +99,8 @@ errcode_t ext2fs_open(const char *name, int flags=
, int superblock,
> >   *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
> >   *				filesystems)
> >   */
> > -errcode_t ext2fs_open2(const char *name, const char *io_options,
> > -		       int flags, int superblock,
> > +errcode_t ext2fs_open3(const char *name, const char *io_options,
> > +		       int flags, blk64_t superblock,
> >  		       unsigned int block_size, io_manager manager,
> >  		       ext2_filsys *ret_fs)
> >  {
> > diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> > index ae70f70..b139977 100644
> > --- a/misc/dumpe2fs.c
> > +++ b/misc/dumpe2fs.c
> > @@ -611,7 +611,7 @@ int main (int argc, char ** argv)
> >  		for (use_blocksize =3D EXT2_MIN_BLOCK_SIZE;
> >  		     use_blocksize <=3D EXT2_MAX_BLOCK_SIZE;
> >  		     use_blocksize *=3D 2) {
> > -			retval =3D ext2fs_open (device_name, flags,
> > +			retval =3D ext2fs_open3(device_name, NULL, flags,
> >  					      use_superblock,
> >  					      use_blocksize, unix_io_manager,
> >  					      &fs);
> > @@ -619,7 +619,7 @@ int main (int argc, char ** argv)
> >  				break;
> >  		}
> >  	} else
> > -		retval =3D ext2fs_open (device_name, flags, use_superblock,
> > +		retval =3D ext2fs_open3(device_name, NULL, flags, use_superblock=
,
> >  				      use_blocksize, unix_io_manager, &fs);
> >  	if (retval) {
> >  		com_err (program_name, retval, _("while trying to open %s"),
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
