From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix accidental flag aliasing in ext4_map_blocks flags
Date: Tue, 2 Sep 2014 13:01:54 -0600
Message-ID: <A71E6FF0-16EC-4747-89E4-F9574A89FF89@dilger.ca>
References: <1409515240-9451-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5F35E030-BFE4-4D52-9A05-3AFB99400F19"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37962 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBTAe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Sep 2014 15:00:34 -0400
Received: by mail-pa0-f51.google.com with SMTP id rd3so15310633pab.24
        for <linux-ext4@vger.kernel.org>; Tue, 02 Sep 2014 12:00:33 -0700 (PDT)
In-Reply-To: <1409515240-9451-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5F35E030-BFE4-4D52-9A05-3AFB99400F19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Aug 31, 2014, at 2:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Commit b8a8684502a0f introduced an accidental flag aliasing between
> EXT4_EX_NOCACHE and EXT4_GET_BLOCKS_CONVERT_UNWRITTEN.
> 
> Fortunately, this didn't introduce any untorward side effects --- we
> got lucky.  Nevertheless, fix this and leave a warning to hopefully
> avoid this from happening in the future.

Why not move EXT4_EX_*CACHE flags to the end of the range (e.g. 0x8000
and 0x4000) to minimize potential conflicts in the future?

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/ext4.h | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cf3ad75..550b4f9 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -569,6 +569,7 @@ enum {
> #define EXT4_GET_BLOCKS_NO_PUT_HOLE		0x0200
> 	/* Convert written extents to unwritten */
> #define EXT4_GET_BLOCKS_CONVERT_UNWRITTEN	0x0400
> +/* DO NOT ASSIGN ADDITIONAL FLAG VALUES WITHOUT ADJUSTING THE FLAGS BELOW

It might be useful here to mention the EXT4_EX_* flags explicitly?
In my experience, time and incremental changes will make it less
clear what "FLAGS BELOW" means...

Cheers, Andreas

> /*
>  * The bit position of these flags must not overlap with any of the
> @@ -579,8 +580,8 @@ enum {
>  * caching the extents when reading from the extent tree while a
>  * truncate or punch hole operation is in progress.
>  */
> -#define EXT4_EX_NOCACHE				0x0400
> -#define EXT4_EX_FORCE_CACHE			0x0800
> +#define EXT4_EX_NOCACHE				0x0800
> +#define EXT4_EX_FORCE_CACHE			0x1000
> 
> /*
>  * Flags used by ext4_free_blocks
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_5F35E030-BFE4-4D52-9A05-3AFB99400F19
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVAYUI3Kl2rkXzB/gAQJdcBAAlmgOa9/3Hh4miSnA39tWfUn3fyO3qcfM
U4H3UnnwUdbl9b2BEBPSObDxMt/+AaGfPzA2nMEeKN/0z0tIC1rbd3KeJuAp5o/e
P1KuJr7NzsrlhH8HjMVy6AjSuuecTNQnd9cvSQ8p/XjnIEzv3G3fJ9tFCsA6kIyI
Ol3/0MgVTv7bA8DVJ15l3QQD7CSkFqHexNCezOGJg+2DLvq9uR16KKYkvCgr/jYf
4TyFA0oKh6uiewXc0fvTLUEDiJ6VFi5ckHzGprw0/Ac8zr7/0oJqjaWtWzXcXojV
GLXWunuzFJzWfyly/kMKA0w7ikAWl+0NEgkMt8HfHgYTf6Z3P5k5sjdWd31qWpoj
d080VIUFcpnewmfpE9+VGBVkQ50DdMTwkiZbVIw6QPv5RVEQjcXu62Ln6OIzkhDO
7Qv84bi3SRRQPliGkR02gOBMPaJIy4xWAK+Koc9xZVKb32YjIb6pMXi/FCYHgArp
x6Qw2pQFEbcg7XpixCT7bU0Z44/4SRfkAlolLizm8MKrszM+duVl8qOqXbeM9R+b
diMn4UlzAzET/uX+MWNrCnDh9ZC3hSzqNEAjE/XsZQ7O7sB0X9O0KzIBKQa0umUl
U62b542UnPZvYG4siix/rpXo3d9P9g3+vBH6EWu4QSE2qfTvkRNpPLH5HZb46Vb/
xXYcVsTb2IY=
=ChfS
-----END PGP SIGNATURE-----

--Apple-Mail=_5F35E030-BFE4-4D52-9A05-3AFB99400F19--
