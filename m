From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Check superblock mapped prior to committing
Date: Fri, 29 Jun 2018 22:36:06 -0600
Message-ID: <A869A023-8695-48CC-B577-DAA1C75837C3@dilger.ca>
References: <1530300995-25583-1-git-send-email-jonathan.derrick@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E8FFBE7E-1B06-4D58-8BBF-BAE19556F898";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jon Derrick <jonathan.derrick@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530300995-25583-1-git-send-email-jonathan.derrick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E8FFBE7E-1B06-4D58-8BBF-BAE19556F898
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 29, 2018, at 1:36 PM, Jon Derrick <jonathan.derrick@intel.com> =
wrote:
>=20
> This patch attempts to close a hole leading to a BUG seen with hot
> removals during writes [1].
>=20
> A block device (NVME namespace in this test case) is formatted to EXT4
> without partitions. It's mounted and write I/O is run to a file, then
> the device is hot removed from the slot. The superblock attempts to be
> written to the drive which is no longer present.
>=20
> The typical chain of events leading to the BUG:
> ext4_commit_super()
>  __sync_dirty_buffer()
>    submit_bh()
>      submit_bh_wbc()
>        BUG_ON(!buffer_mapped(bh));
>=20
> This fix checks for the superblock's buffer head being mapped prior to
> syncing.
>=20
> [1] https://www.spinics.net/lists/linux-ext4/msg56527.html
>=20
> Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
> ---
> fs/ext4/super.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0c4c220..ee33233 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4736,6 +4736,14 @@ static int ext4_commit_super(struct super_block =
*sb, int sync)
>=20
> 	if (!sbh || block_device_ejected(sb))
> 		return error;
> +
> +	/*
> +	 * The superblock bh should be mapped, but it might not be if =
the
> +	 * device was hot-removed. Not much we can do but fail the I/O.
> +	 */
> +	if (!buffer_mapped(sbh))
> +		return error;

This still looks a bit racy, based on the stack trace you posted.
There is already a "block_device_ejected()" check a line above,
which makes me think that the PCI device removal should be handled
like an ejected device, so that it is also handled elsewhere.

Even so, the check here in ext4_commit_super() can pass, and the
PCI card can be removed on the next instruction and still trigger
the BUG_ON().

That said, this is probably still an improvement on the existing
situation.

Cheers, Andreas






--Apple-Mail=_E8FFBE7E-1B06-4D58-8BBF-BAE19556F898
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAls3CLYACgkQcqXauRfM
H+B1IQ/+Ivh2zNIIOCJEilXbgCSnYxWDUwDWUEX8I3q1FuDqoRC80U5Di2sx2ibK
pfAF5a61IJMvinjW5VlnxIzDtc+kq//aZT/5ddLOSvY161+JHF1AysVjQIGZWEBS
5dFpOGarmjZa3HfDjDkcNGwBdolB1SSE1W8GX8V8Zlk/R8aUqHOQitYusmUQHNbf
ZG6EQmZuuN0ydEyOZCnUbDm2ab9YIDQtxzhvIBqfTLSdXOhwMVnL0ftJqaiFiEn4
yt4dXo3sZEWxpAGWYmnZK+Pjwxyc6xvqAd1YlnchDZxsKlkICvicliU19NzCaVIe
2GTi5kQ84dYNtTpSsoOhOYGNfyUpE6QegF5NdL2+1o4vnqYoC7c1rMxrMVBBiGJl
lazFrGvnZSFTKMt0Aqy4Ytt15w0XPZmaY17TOge4/xCCXZhZzMFv4OWav50qL4Ye
ppkzTWTNFKZ1GYjYmgmmYtaHyjwaSys2O3wvws/sU+RHn768MFdjfL7vDXHAxMby
MWY9M8n2PUIi7o6Am8m7aBGpwJF8d3oJGcUt40K5UMoJFalnGqHCy4vKMEEa1JdM
HHqLtw3lgKml4zhSfZqY7T4/NHd4KMGuv9a6hcuppIRhCFW9qlWy74X9aU5PTNyX
kKK9vW+LtgSiHjMR04IpcwvUPwEhQbV8x0NvuQFi5pw8pTeOCXE=
=9q8V
-----END PGP SIGNATURE-----

--Apple-Mail=_E8FFBE7E-1B06-4D58-8BBF-BAE19556F898--
