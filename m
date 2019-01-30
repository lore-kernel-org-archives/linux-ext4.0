Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1487CC169C4
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 03:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B10E920989
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 03:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="ZWMV6pU/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfA3DBI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:01:08 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32830 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbfA3DBH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 22:01:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id z11so9709351pgu.0
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 19:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=4NvFRUns+GF3mJh8htfT1ecScFz0Eom9Of98XLiEceY=;
        b=ZWMV6pU/Bmxn99ENXO8du4KEe8FTNhKHM3khsYnEcTJfhQSGLtn35Grp2aLJR/SJ2v
         xPP8WnzKtdh6dt0bfqzSakiUWICVkVo7MDfNI/Sw7PXcZk3SymWh00/7IuwZ62ArmBid
         BX0oJPMzn4NSY++P9pHYtUgwQhEQ4EHoRIGCQfw1CJLiMR9lDrTNWdSo4hZvfRoF+MIe
         se8cRgbJQs0i687JI2JgTCk42hA9AAuyDXnwRxQKgVIbSjPlTappUDDOEAShVM7Sq4hn
         wGWGmQ/mYjGz8SMPyFopzeNfyeW8exIXsp3gvOXHNq3UTBcZsOV9CY7XS+9kxPKboBKG
         TH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=4NvFRUns+GF3mJh8htfT1ecScFz0Eom9Of98XLiEceY=;
        b=JQpZcEi5ERoq3PsQkIghpdLjVKuW+gpIphOhe43NvddbNhW1l9pvW3y8ptQe9zm4NU
         e2b/agH17wCzWbTQFVmQvFuEhV5w2MPHkpzRTr3uUtzqswMayyA0QNisUH/T1k7lMea4
         eCbo0EnTw/tUcMEHKNR6s5LSH4vVLeGyIApU2+J6N3C2W9unEpJ4nEbf/KK9i0YeLHoj
         XaInKtSUCVPY9TwLYzTAdojsy+sJ8jmcj/PTuu73uh7DhPfaQMbEq0Zcj4yIT1BFe6Ee
         EJ/QJEjwAWKqNwzkYDeF09Yu+LkCdfGuQ1xUQMZhwy7yVAlXEZqeJrvFCm0wQqtoVRgZ
         2Xwg==
X-Gm-Message-State: AJcUuke5wVMpsI56a8vD59FeRBus+JPBKErG25yOCJL/tQRviTXxflv4
        9Y65k9GcpNwQI1k0M8JJ3UA6gQ==
X-Google-Smtp-Source: ALg8bN6YUAzU7hDLUuhETU6jaMojDLnq5E90srn4rN1r1P72+oYIISLAvZ/23t267OcOEjoRhoDvvw==
X-Received: by 2002:a63:6cc:: with SMTP id 195mr26143684pgg.401.1548817266614;
        Tue, 29 Jan 2019 19:01:06 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54? ([2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54])
        by smtp.gmail.com with ESMTPSA id o1sm197228pgn.63.2019.01.29.19.01.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 19:01:04 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <BDB26C76-310F-4925-BE41-034D62B2797B@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_518C01EE-D4D3-49EB-B727-660A010E6807";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v7 1/4] ext2fs: opening filesystem code refactoring
Date:   Tue, 29 Jan 2019 20:01:03 -0700
In-Reply-To: <20190129175134.26652-2-c17828@cray.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20190129175134.26652-1-c17828@cray.com>
 <20190129175134.26652-2-c17828@cray.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_518C01EE-D4D3-49EB-B727-660A010E6807
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 29, 2019, at 10:51 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> There are similar opening filesystem code in different utilities.
>=20
> The patch moves improved handling from try_open_fs()
> into ext2fs_open(). This function make one of the action
> based on parameters:
> 1) open filesystem with given superblock, superblock size
> 2) open filesystem with given superblock, but try to
> find right block size
>=20
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/unix.c       | 28 +++-------------------------
> lib/ext2fs/openfs.c | 39 +++++++++++++++++++++++++++++++++++----
> misc/dumpe2fs.c     | 17 ++---------------
> 3 files changed, 40 insertions(+), 44 deletions(-)
>=20
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 5b3552ec..ddcf52a4 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1151,31 +1151,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int =
flags, io_manager io_ptr,
> 			     ext2_filsys *ret_fs)
> {
> 	errcode_t retval;
> -
> -	*ret_fs =3D NULL;
> -	if (ctx->superblock && ctx->blocksize) {
> -		retval =3D ext2fs_open2(ctx->filesystem_name, =
ctx->io_options,
> -				      flags, ctx->superblock, =
ctx->blocksize,
> -				      io_ptr, ret_fs);
> -	} else if (ctx->superblock) {
> -		int blocksize;
> -		for (blocksize =3D EXT2_MIN_BLOCK_SIZE;
> -		     blocksize <=3D EXT2_MAX_BLOCK_SIZE; blocksize *=3D =
2) {
> -			if (*ret_fs) {
> -				ext2fs_free(*ret_fs);
> -				*ret_fs =3D NULL;
> -			}
> -			retval =3D ext2fs_open2(ctx->filesystem_name,
> -					      ctx->io_options, flags,
> -					      ctx->superblock, =
blocksize,
> -					      io_ptr, ret_fs);
> -			if (!retval)
> -				break;
> -		}
> -	} else
> -		retval =3D ext2fs_open2(ctx->filesystem_name, =
ctx->io_options,
> -				      flags, 0, 0, io_ptr, ret_fs);
> -
> +	retval =3D ext2fs_open2(ctx->filesystem_name, ctx->io_options,
> +			   flags, ctx->superblock, ctx->blocksize,
> +			   io_ptr, ret_fs);
> 	if (retval =3D=3D 0) {
> 		(*ret_fs)->priv_data =3D ctx;
> 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 85d73e2a..16d36200 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -114,10 +114,10 @@ static void block_sha_map_free_entry(void *data)
>  *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
>  *				filesystems)
>  */
> -errcode_t ext2fs_open2(const char *name, const char *io_options,
> -		       int flags, int superblock,
> -		       unsigned int block_size, io_manager manager,
> -		       ext2_filsys *ret_fs)
> +static errcode_t __ext2fs_open2(const char *name, const char =
*io_options,
> +				int flags, int superblock,
> +				unsigned int block_size, io_manager =
manager,
> +				ext2_filsys *ret_fs)
> {
> 	ext2_filsys	fs;
> 	errcode_t	retval;
> @@ -515,6 +515,37 @@ cleanup:
> 	return retval;
> }
>=20
> +errcode_t ext2fs_open2(const char *name, const char *io_options,
> +		       int flags, int superblock,
> +		       unsigned int block_size, io_manager manager,
> +		       ext2_filsys *ret_fs)
> +{
> +	errcode_t retval;
> +
> +	*ret_fs =3D NULL;
> +	if (superblock && block_size) {
> +		retval =3D __ext2fs_open2(name, io_options,
> +				      flags, superblock, block_size,
> +				      manager, ret_fs);
> +	} else {
> +		int size;
> +
> +		for (size =3D EXT2_MIN_BLOCK_SIZE;
> +		     size <=3D EXT2_MAX_BLOCK_SIZE; size *=3D 2) {
> +			if (*ret_fs) {
> +				ext2fs_free(*ret_fs);
> +				*ret_fs =3D NULL;
> +			}
> +			retval =3D __ext2fs_open2(name, io_options, =
flags,
> +						superblock, size,
> +						manager, ret_fs);
> +			if (!retval)
> +				break;
> +		}
> +	}
> +	return retval;
> +}
> +
> /*
>  * Set/get the filesystem data I/O channel.
>  *
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 384ce925..183e2f6f 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -667,21 +667,8 @@ int main (int argc, char ** argv)
> 	if (image_dump)
> 		flags |=3D EXT2_FLAG_IMAGE_FILE;
> try_open_again:
> -	if (use_superblock && !use_blocksize) {
> -		for (use_blocksize =3D EXT2_MIN_BLOCK_SIZE;
> -		     use_blocksize <=3D EXT2_MAX_BLOCK_SIZE;
> -		     use_blocksize *=3D 2) {
> -			retval =3D ext2fs_open (device_name, flags,
> -					      use_superblock,
> -					      use_blocksize, =
unix_io_manager,
> -					      &fs);
> -			if (!retval)
> -				break;
> -		}
> -	} else {
> -		retval =3D ext2fs_open(device_name, flags, =
use_superblock,
> -				     use_blocksize, unix_io_manager, =
&fs);
> -	}
> +	retval =3D ext2fs_open2(device_name, 0, flags, use_superblock,
> +			      use_blocksize, unix_io_manager, &fs);
> 	flags |=3D EXT2_FLAG_IGNORE_CSUM_ERRORS;
> 	if (retval && !retval_csum) {
> 		retval_csum =3D retval;
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_518C01EE-D4D3-49EB-B727-660A010E6807
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxRE28ACgkQcqXauRfM
H+DE6A//fQU/hHNd7+BLGC0SlTlosmT6mez8k3H77fL+Q4a6D6azIh3hI5VZ6A9w
FN5Q7ZABUKa6Q3Ei9lYuLtBt9rALZFNwIB3G3y17qxXWThEUBjXyZUn2f6/bBR2A
632Q61ClkJw8HYUz7AQqJSmiendMjL2SPWYi9wlnqCA3i788hqGF/1p60NjqFwZZ
d1/8IPhVGH2X/GT+nffQ3m2Ka9D3oyByZwAUEw2FsmOb7gn4Ls8Si1QMN80fVE4Y
DGcRTQQyY2/edpoIxjG+OEyFe1DgSkVMNnrfLAkqy86ioXO/gV05gsFVc3bw7n5n
tN47+IHVULQ88WU8n/qIOFtBfJ0eRqaclQLlNjw4rtolmbR3i8ohm7moNAPIY3w5
TJVLCgcmBLfHH1R7TFYzzyQC61b51yW/ZRzXpXDJAfoIPXSzO2LDbCYh1MMs8oyo
nDhj/O0hX5WoS4LueA0JP13imqbwjmaK3GWW9J0DHvwZ+Q0mx1/Ni2Vs/mJ31cZN
J2V0bl8BsSjkYF6E8a/VAkDjJ4Rn8WOzQL4PHZWuYGDGXFsFHnI8Z9tBGZDjdyw2
T6+jCQwhSW2vXyynsspyedAyPrMkp1b5ag+JMyhHGNHUN5e27QMlnz80FlzPvUCz
zPUEfclTOBD7u8P1g00XCcB0IV10CR9gE2fJRA5od0mkd7Nw6D0=
=56Yu
-----END PGP SIGNATURE-----

--Apple-Mail=_518C01EE-D4D3-49EB-B727-660A010E6807--
