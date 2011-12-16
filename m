From: Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH v2 4/7] VFS: Rename and refactor
 writeback_inodes_sb_if_idle
Date: Fri, 16 Dec 2011 12:48:13 -0800
Message-ID: <1324068493.6652.69.camel@fourier>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	 <1323367477-21685-5-git-send-email-kamal@canonical.com>
	 <4EE6C7AD.3020907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-qqvlbFS0BdWQeiIbhGty"
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EE6C7AD.3020907@cn.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-qqvlbFS0BdWQeiIbhGty
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-12-13 at 11:34 +0800, Miao Xie wrote:
> On thu, 8 Dec 2011 10:04:34 -0800, Kamal Mostafa wrote:
> >  /**
> > - * writeback_inodes_sb_if_idle	-	start writeback if none underway
> > + * try_to_writeback_inodes_sb_nr	-	start writeback if none underway
> >   * @sb: the superblock
> >   * @nr: the number of pages to write
> >   *
> >   * Invoke writeback_inodes_sb if no writeback is currently underway.
> >   * Returns 1 if writeback was started, 0 if not.
> >   */
> > -int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
> > +int try_to_writeback_inodes_sb_nr(struct super_block *sb,
> >  				   unsigned long nr,
> >  				   enum wb_reason reason)
> >  {
> >  	if (!writeback_in_progress(sb->s_bdi)) {
> >  		down_read(&sb->s_umount);
> > -		writeback_inodes_sb_nr(sb, nr, reason);
> > +		if (nr =3D=3D 0)
> > +			writeback_inodes_sb(sb, reason);
> > +		else
> > +			writeback_inodes_sb_nr(sb, nr, reason);
> >  		up_read(&sb->s_umount);
> >  		return 1;
> >  	} else
> >  		return 0;
>=20
> The comment said "Returns 1 if writeback was started", so if writeback_in=
_progress()
> return true, I think this function also should return 1.

My interpretation of that comment is that it will return 1 only if this
call results in a new writeback being started (not if a writeback was
already in progress).

This patch [4/7] intentionally does not introduce any functional
changes.

> BTW: Does anyone know when this patchset will be merged into the main tre=
e?

I also eagerly await the merge of this patch set.

 -Kamal


--=-qqvlbFS0BdWQeiIbhGty
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJO666NAAoJEOf3EFVUCeQimq4P/AqtbY6gx1zB4K61FAJlTmAf
sO9wrDoTAEoed0K55GYXGsMfW1m+1GYJnmxwQWp/PjkErMYw+6Jm+JxDfhIazvdk
T1Dus3ZDSCBqbFhru0gKDBM24B1mT45tVLRhwuk3URuUj0GEinhratqkvjJokC28
o9V9jxd8/zEFoehwfQgrbIdr4RoWM3Pfvx5thNb9mOvvGal1KnIjraclKgCiBtlT
2u5AVGvFYrNjTGah/ylk2ish4bQt7QqEgWZUwQmGxFbJC3G4torysAcE7Rv/pGFE
nIuTPf4xcXKX1FD6IVNgGAEGeQy/LZRec2udrycpFo3ZfZ1fx1pUNhOh5Wn0gxsl
yvuuCyOcUFKk4r9Mj29Lh/G/Z8dToazY0a0+PTTm3WZ+SxGi49z8/9ZL39Wr3SSO
6OEvTxvUF2SBE/4YPfWLZ5r8czCuwamN3bb5wF2HuNXdO+0dPRuBcUu8jBXdEbkF
n9Md4NX7Vrr4qi5f25BzFr46tHhk51TeZbswk1OIA6Q4BeTgxTm6RyCVqftfnWiC
6RGpymm7m1zMepZvMXqJTeYvYM2ltUv8x4jrY7RPknkxYoy1n7FOevNTFp7VXNND
7sN5Qk4JR9vFEcov2B1bD+oa59a+1FjCBuQqcul5kHpaGgZf4+7YklyyrJeiUBmY
wDOD2sI82RFBMA+1gMrK
=km/7
-----END PGP SIGNATURE-----

--=-qqvlbFS0BdWQeiIbhGty--

