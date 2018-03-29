From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: limit xattr size to INT_MAX
Date: Thu, 29 Mar 2018 15:54:19 -0600
Message-ID: <D9ED9D91-AF96-4861-B840-CAD910FCA640@dilger.ca>
References: <20180329194125.GC3790@thunk.org>
 <20180329214639.29881-1-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_611C4168-8C3C-4A1E-A635-24DA903B463C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        ebiggers3@gmail.com, wen.xu@gatech.edu, ebiggers@google.com,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180329214639.29881-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_611C4168-8C3C-4A1E-A635-24DA903B463C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2018, at 3:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> ext4 isn't validating the sizes of xattrs.  This is problematic
> because ->e_value_size is a u32, but ext4_xattr_get() returns an int.
> A very large size is misinterpreted as an error code, which
> ext4_get_acl() translates into a bogus ERR_PTR() for which IS_ERR()
> returns false, causing a crash.
>=20
> Fix this by validating that all xattrs are <=3D INT_MAX bytes.  Also =
add
> explicit checks in ext4_xattr_block_get() and ext4_xattr_ibody_get()
> just in case the xattr block is corrupted in memory.
>=20
> This issue has been assigned CVE-2018-1095.
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D199185
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1560793
>=20
> Reported-by: Wen Xu <wen.xu@gatech.edu>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Cc: stable@vger.kernel.org
> ---
> fs/ext4/xattr.c | 11 +++++++++--
> 1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 63656dbafdc4..fea1108c3bea 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -201,6 +201,9 @@ ext4_xattr_check_entries(struct ext4_xattr_entry =
*entry, void *end,
> 			u32 size =3D le32_to_cpu(entry->e_value_size);
> 			void *value;
>=20
> +			if (size > INT_MAX)
> +				return -EFSCORRUPTED;
> +
> 			/*
> 			 * The value cannot overlap the names, and the =
value
> 			 * with padding cannot extend beyond 'end'.  =
Check both
> @@ -523,8 +526,10 @@ ext4_xattr_block_get(struct inode *inode, int =
name_index, const char *name,
> 	if (error)
> 		goto cleanup;
> 	size =3D le32_to_cpu(entry->e_value_size);
> +	error =3D -ERANGE;
> +	if (unlikely(size > INT_MAX))
> +		goto cleanup;
> 	if (buffer) {
> -		error =3D -ERANGE;
> 		if (size > buffer_size)
> 			goto cleanup;
> 		if (entry->e_value_inum) {
> @@ -572,8 +577,10 @@ ext4_xattr_ibody_get(struct inode *inode, int =
name_index, const char *name,
> 	if (error)
> 		goto cleanup;
> 	size =3D le32_to_cpu(entry->e_value_size);
> +	error =3D -ERANGE;
> +	if (unlikely(size > INT_MAX))
> +		goto cleanup;
> 	if (buffer) {
> -		error =3D -ERANGE;
> 		if (size > buffer_size)
> 			goto cleanup;
> 		if (entry->e_value_inum) {
> --
> 2.16.1.72.g5be1f00a9a
>=20


Cheers, Andreas






--Apple-Mail=_611C4168-8C3C-4A1E-A635-24DA903B463C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlq9YIsACgkQcqXauRfM
H+BDPg/+I+3QB2hDYLiL3SFtKZUBbLEWPRntqwjWJxxluNTNTj5m6ToR8oGGg1P9
30LL36Juze22SD9PKXdQiherQxmFUpyOHFPd6PGeYaIjiVAc3RgjTjcMxDHFKGW2
MMTn0yeUIcaOxHZYu2aXY8UwAojR9qwBKe1dt2wLSoN7qrSltVtQg+fmSOsbZVas
vF6GCnXD7MwKLDiHCDqwOHdyEhVIF0siYbUqy0pYYazlQcs3qPM+Poi9Hay3Ozpv
i2nw4yOJPn8026fpCl3+NLAgZU7lxJ9KX3Jeds7qvTLqQL0aWTMp1R3OJtTWURVN
1QyYFfULOz3O3yEM1FGhbH8Xui+hD+Kt5faYy0sFa+9melUqKqKM1xrZ6q2+sKZU
XJIrGE8I82xU1H6OIDBTBW+4afb3/icqvM9r3ble0ZyCs4T4G7B8ufmq2NHNbwqa
30f0TNPcWYr+zAl6CIA2P1Dr/+hW7SaS0F5AQC9crOYw9MRIAUarXt1cWkmOgmbn
0TFe0PpdVrLHoTTB9rrOMbl+GYqKCuMNE9F3UqMdCRP3JP9rmJuB44BjAKLVdMo6
74HQ3zmuSYrVi9EH+wv6LVfJSm0KwLhlyl785rrUkpu9pygfgkAAjf6FrYz/Rwdj
CaSxGkzahp3jtmsjtCcdinGPHmaJaOnNLa+yqsP2t/1rAVbCfXw=
=p6N0
-----END PGP SIGNATURE-----

--Apple-Mail=_611C4168-8C3C-4A1E-A635-24DA903B463C--
