From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/37] e2fsck: insert a missing dirent tail for checksums
 if possible
Date: Mon, 5 May 2014 16:16:45 -0700
Message-ID: <20140505231645.GL8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231341.31890.18777.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021452160.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39606 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaEEXQv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 19:16:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021452160.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 02:54:08PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:13:41 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 12/37] e2fsck: insert a missing dirent tail for che=
cksums if
> >     possible
> >=20
> > If e2fsck is writing a block of directory entries to disk, it shoul=
d
> > adjust the dirents to add the dirent tail if one is missing.  It's =
not
> > a big deal if there's no space to do this since rehash (pass 3A) wi=
ll
> > reconstruct directories for us.  However, we may as well avoid
> > unnecessary work.
>=20
> I am sorry for the stupid questions, but in what case can be the
> dirent tail missing ? It's not immediately obvious to me.

Primarily the "dirent tail missing" case happens if the user runs tune2=
fs to
add checksums to a FS and it encounters a directory block that doesn't =
have
enough space to store the directory block checksum field.  When this ha=
ppens,
tune2fs advises the user to run e2fsck -D to rebuild the directories.  =
The -D
switch isn't strictly necessary.

The particular sub-case that this patch tries to capture is where the u=
ser
ignores the "e2fsck -D" request, deletes entries out of the dir block, =
and some
time later runs e2fsck.  In that case, we can skip a full rebuild and j=
ust fix
the block.

--D
>=20
> Thanks!
> -Lukas
>=20
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  e2fsck/pass2.c |   40 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >=20
> >=20
> > diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> > index 5488c73..95f51b7 100644
> > --- a/e2fsck/pass2.c
> > +++ b/e2fsck/pass2.c
> > @@ -739,6 +739,41 @@ static int is_last_entry(ext2_filsys fs, int i=
nline_data_size,
> >  		return (offset < fs->blocksize - csum_size);
> >  }
> > =20
> > +static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
> > +{
> > +	struct ext2_dir_entry *d;
> > +	void *top;
> > +	struct ext2_dir_entry_tail *t;
> > +	unsigned int rec_len;
> > +
> > +	d =3D dirbuf;
> > +	top =3D EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
> > +
> > +	rec_len =3D d->rec_len;
> > +	while (rec_len && !(rec_len & 0x3)) {
> > +		d =3D (struct ext2_dir_entry *)(((char *)d) + rec_len);
> > +		if (((void *)d) + d->rec_len >=3D top)
> > +			break;
> > +		rec_len =3D d->rec_len;
> > +	}
> > +
> > +	if (d !=3D top) {
> > +		size_t min_size =3D EXT2_DIR_REC_LEN(
> > +				ext2fs_dirent_name_len(dirbuf));
> > +		if (min_size > d->rec_len - sizeof(struct ext2_dir_entry_tail))
> > +			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
> > +		d->rec_len -=3D sizeof(struct ext2_dir_entry_tail);
> > +	}
> > +
> > +	t =3D (struct ext2_dir_entry_tail *)top;
> > +	if (t->det_reserved_zero1 ||
> > +	    t->det_rec_len !=3D sizeof(struct ext2_dir_entry_tail) ||
> > +	    t->det_reserved_name_len !=3D EXT2_DIR_NAME_LEN_CSUM)
> > +		ext2fs_initialize_dirent_tail(fs, t);
> > +
> > +	return 0;
> > +}
> > +
> >  static int check_dir_block(ext2_filsys fs,
> >  			   struct ext2_db_entry2 *db,
> >  			   void *priv_data)
> > @@ -1275,8 +1310,13 @@ skip_checksum:
> >  		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> >  				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
> >  		    is_leaf &&
> > +		    !inline_data_size &&
> >  		    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf))
> > +		{
> > +			if (insert_dirent_tail(fs, buf) =3D=3D 0)
> > +				goto write_and_fix;
> >  			e2fsck_rehash_dir_later(ctx, ino);
> > +		}
> > =20
> >  write_and_fix:
> >  		if (e2fsck_dir_will_be_rehashed(ctx, ino))
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
