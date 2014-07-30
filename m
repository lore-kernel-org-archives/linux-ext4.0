From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] filefrag: reserve fields and new extent flags
Date: Wed, 30 Jul 2014 14:32:12 -0600
Message-ID: <8FBB1456-7A9F-4B0C-8FAF-B0832C874035@dilger.ca>
References: <1406751951-23059-1-git-send-email-adilger@dilger.ca> <1406751951-23059-2-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5C18836C-1590-4435-8EAA-5BBA8DC5CE18"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57555 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaG3UcR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 16:32:17 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa1so2162457pad.41
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2014 13:32:16 -0700 (PDT)
In-Reply-To: <1406751951-23059-2-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5C18836C-1590-4435-8EAA-5BBA8DC5CE18
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 30, 2014, at 2:25 PM, Andreas Dilger <adilger@dilger.ca> wrote:

> Reserve the FIEMAP_EXTENT_PHYS_LENGTH flag to indicate that the new
> fe_phys_length field contains valid data.  This is introduced to
> allow different fe_phys_length and fe_logi_length values for
> compressed extents, but it is also valid to set PHYS_LENGTH and set
> fe_phys_length for regular files to simplify userspace codes.  If
> PHYS_LENGTH is not set, then applications should set fe_phys_length
> equal to fe_logi_length, since fe_phys_length is undefined (though
> typically zero).
>=20
> Reserve the FIEMAP_EXTENT_DATA_COMPRESSED flag to allow reporting
> extents with physical length different than logical length.  This
> also sets the FIEMAP_EXTENT_ENCODED flag to indicate that the data
> cannot be accessed directly.
>=20
> Reserve the FIEMAP_EXTENT_NET flag, which indicates that the data
> is on a network filesystem that does not have local storage devices.
> This also sets FIEMAP_EXTENT_ENCODED flag to indicate the data cannot
> be accessed directly.
>=20
> Print out DATA_COMPRESSED and EXTENT_NET flags in filefrag if =
detected.

This patch series is my first cut at filefrag updates to match David's
proposed changes to handle compressed extents in FIEMAP in the kernel.
See http://comments.gmane.org/gmane.comp.file-systems.btrfs/37312 for
the kernel side of things.

This patch series is not quite identical to what the kernel patches
are implementing, but rather how I think it should be implemented.

Feedback/discussion welcome, but I may not reply for a while.

Cheers, Andreas

> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
> lib/ext2fs/fiemap.h |   17 +++++++++++++----
> misc/filefrag.c     |    7 ++++++-
> 2 files changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
> index 895cd0b..30103e2 100644
> --- a/lib/ext2fs/fiemap.h
> +++ b/lib/ext2fs/fiemap.h
> @@ -17,15 +17,17 @@ struct fiemap_extent {
> 	__u64 fe_physical; /* physical offset in bytes for the start
> 			    * of the extent from the beginning of the =
disk */
> 	__u64 fe_length;   /* length in bytes for this extent */
> -	__u64 fe_reserved64[2];
> +	__u64 fe_phys_length; /* physical length in bytes for this =
extent,
> +			       * undefined if DATA_COMPRESSED not set */
> +	__u64 fe_reserved64;
> 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
> 	__u32 fe_reserved[3];
> };
>=20
> struct fiemap {
> -	__u64 fm_start;		/* logical offset (inclusive) at
> +	__u64 fm_start;		/* logical offset in bytes (inclusive) =
at
> 				 * which to start mapping (in) */
> -	__u64 fm_length;	/* logical length of mapping which
> +	__u64 fm_length;	/* logical length in bytes of mapping =
which
> 				 * userspace wants (in) */
> 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request =
(in/out) */
> 	__u32 fm_mapped_extents;/* number of extents that were mapped =
(out) */
> @@ -51,8 +53,13 @@ struct fiemap {
> 						    * Sets =
EXTENT_UNKNOWN. */
> #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be =
read
> 						    * while fs is =
unmounted */
> +#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010 /* Physical length of =
extent
> +						    * in fe_phys_length =
valid */
> +#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is =
compressed by fs.
> +						    * Sets =
EXTENT_ENCODED and
> +						    * PHYS_LENGTH. */
> #define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted =
by fs.
> -						    * Sets =
EXTENT_NO_BYPASS. */
> +						    * Sets =
EXTENT_ENCODED. */
> #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may =
not be
> 						    * block aligned. */
> #define FIEMAP_EXTENT_DATA_INLINE	0x00000200 /* Data mixed with =
metadata.
> @@ -66,5 +73,7 @@ struct fiemap {
> 						    * merged for =
efficiency. */
> #define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with =
other
> 						    * files. */
> +#define FIEMAP_EXTENT_NET		0x80000000 /* Data stored =
remotely.
> +						    * Sets =
EXTENT_ENCODED. */
>=20
> #endif /* _LINUX_FIEMAP_H */
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index d71bf43..7bd100c 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -164,6 +164,8 @@ static void print_extent_info(struct fiemap_extent =
*fm_extent, int cur_ex,
> 	print_flag(&fe_flags, FIEMAP_EXTENT_UNKNOWN, flags, =
"unknown_loc,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_DELALLOC, flags, =
"delalloc,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_ENCODED, flags, "encoded,");
> +	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_COMPRESSED, flags,
> +								=
"compressed,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_ENCRYPTED, =
flags,"encrypted,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_NOT_ALIGNED, flags, =
"not_aligned,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_INLINE, flags, =
"inline,");
> @@ -171,7 +173,10 @@ static void print_extent_info(struct =
fiemap_extent *fm_extent, int cur_ex,
> 	print_flag(&fe_flags, FIEMAP_EXTENT_UNWRITTEN, flags, =
"unwritten,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_MERGED, flags, "merged,");
> 	print_flag(&fe_flags, FIEMAP_EXTENT_SHARED, flags, "shared,");
> -	/* print any unknown flags as hex values */
> +	print_flag(&fe_flags, FIEMAP_EXTENT_NET, flags, "net,");
> +
> +	/* Print unknown flags in hex format.  Known flags are already
> +	 * printed above and will have their bit cleared from =
"fe_flags". */
> 	for (mask =3D 1; fe_flags !=3D 0 && mask !=3D 0; mask <<=3D 1) {
> 		char hex[6];
>=20
> --=20
> 1.7.3.4
>=20


Cheers, Andreas






--Apple-Mail=_5C18836C-1590-4435-8EAA-5BBA8DC5CE18
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9lWTHKl2rkXzB/gAQIfGBAAsBPgU0ZTKYHICvBaidci1t+8voL6oTby
qqwT8dcFeJlN4CenkZrj4bD/BNVjEmeSVpkvlEnC+cncF70K5kdBjRye3Q9/yhBY
PnQRJOgE1Tq1CN3Smcss6E3SqYVL97pVjtrxwBMT+vl9SU4esKkQkEBf1/Jcpeaz
V5K3nePty4nDCdvUQGg1CpUDsHyNz24ZgMB2yOTm6l6qClwvBy60rf+W7tYEnetJ
ei9CWv+56mrx8RLB7zW2q88obHqGs0Gmm6FNEqfwO844OI8hP5kHmJoqikYGOmWT
1WlKxGEfgAQBgda7R9JeabIQX+5PySC0XGf6Kyo050AOeCijEy3OCU6CywgYZv+0
aJ4/hb+zsZJZVLaXiLFfhqpTPeM2Xi5BwDXEm5WJ/imECtqv3SkjnVMaPnmL4I0e
vWIWG84PzFr/tQ62MB4d911LjtOBMNJHB20SWOH5ZK6gsqQUWA5ZVp5q+AzOOjVn
TOt+Q6Fl+TkH/Vy3vLKRCZIs3gW+uSlKuVnDRaaze3eUVNPRbsb/bSUyKwxFnRae
dSmBM2zKDiErwA+MlyTDxkDbA6R/ahIsG3EqJW3gVSSjx5ctWkplJrERlRjWhOi/
OTaW4au6YzX7mCXFiPB3HeSIo6Ir8DMASE/FucBXKFADJJQNba9W8kHSIJRIgvEG
z/eAGQxDEN0=
=itpF
-----END PGP SIGNATURE-----

--Apple-Mail=_5C18836C-1590-4435-8EAA-5BBA8DC5CE18--
