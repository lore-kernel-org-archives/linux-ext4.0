From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v5 0/10] fs: Introduce new
 flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Date: Tue, 25 Feb 2014 14:16:01 +1100
Message-ID: <20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H"
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk,
	bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
	mtk.manpages@gmail.com, lczerner@redhat.com,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140224005710.GH4317@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 24 Feb 2014 11:57:10 +1100 Dave Chinner <david@fromorbit.com> wrote:
>
> > Namjae Jeon (10):
> >   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
> >   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>=20
> I've pushed these to the following branch:
>=20
> 	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range
>=20
> And so they'll be in tomorrow's linux-next tree.
>=20
> >   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>=20
> I've left this one alone for the ext4 guys to sort out.

So presumably that xfs tree branch is now completely stable and so Ted
could just merge that branch into the ext4 tree as well and put the ext4
part on top of that in his tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDAr1AAoJEMDTa8Ir7ZwVwWwP+gPZe8NtKPGNcImOr5glL63z
MIQUFgD8gf+GbRAMHjpS8YqejSSu4+9p0j3pemP3EbbQqkh2QimPCdkJXcVvj5E8
XeRlSxEEkQcozkgs137OcFGZikt0iduOh5AOJj4lf4pwfK8mcsfN1upCBO0626vu
JHHobnwqw7rVCI4YBiJ3wf2ApG5jeiUJFpRnQW65J85gHWlg3dUYkaFVBYN3QMEJ
MP2XD7xRhnq0Q9whKsKPv3awX4YtdUEkQg0gr3akiWV9ANL3XKpv46AvDnWaNIyI
J4zXZ/tGDo9bGYR4lbKyTbAVB9lxQBaGY+U527EpjeJAdweHImftoX/bE21bfs5R
97k3QSF4jUdaIeK6ho4O4/t3Xdf0FYsSo8ZXxhKN+HRssKelEbH2VieJKmVRMYwW
a3EztVYukCZ+AWrjopWtO/Ng4sYrzU/gDU2WyDonO85Tda31i6DVui4ppeix6SI/
wFu4NLkR33tkjKc6oY9+4uaxUzddq7xVeLdJQ0nmNvZOYRgDDZ861u5KREeVMGB5
9gU/4M0EB+kf89AHRmiToPaYWw6BPpowkz/39uvtBJCOusO9xzaF3lOZDYZ42FyU
noyUSzrpemZJpmTzgUowa2+WIWA5HecDqzCGBD5xHRrYWpeVNH6t5AuA+g607yWB
Pfl6QASOJRvSWjYO6aQh
=2fKf
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H--
