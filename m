Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE9DC169C4
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 03:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A93B020989
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 03:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="V+thjOE5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfA3DHC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:07:02 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37612 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbfA3DHB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 22:07:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id y126so10714593pfb.4
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 19:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=95vhoGtG5CBxhy937IH8bdn4sAr1loHp5/BOnkMuPno=;
        b=V+thjOE5jN+l4u1x6QuSRSqfMYaL7oJCg2rEMMMgPlbyS8/wJDLLGm7kpDMC977yWf
         u0qGOGpXs9D2gdqMcLiMqQzdz/kfPx+x+KFr+o4U3B4Y1ZyjdAzisr5FC0d3O7SLVlcL
         YCLftKmx9W2GJryEtnG4TRmzMkqdBgT7sFhFheBUwN+7K/R9HseOuKPjEzF1RhD+gglR
         j70uCiEhJkCfPUeyQH/NKSd9JPYRnEL8WzDbK+37sh7Og2areszjw//Lw6CPI0WFeiBI
         pVftTjQwTIgtEpMcTJyWN5nj/dhQARVG48LGTiaZ6X/kem+ylcizRwo4TVUDXOxQYuMV
         /KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=95vhoGtG5CBxhy937IH8bdn4sAr1loHp5/BOnkMuPno=;
        b=NSwoCtD7XDI8s/Mlp6QPKfGJqtJCUFcpDD8IUhOlcf7ga8b0NU+oqzQFEFrjoVQfmK
         0Ph6ESJ+rvBDZorjTs1aOQqFI6R+O22UmK+gnkhjmwjubz20MmrnuPiANoR/HF5s5zAJ
         fXyRnPh5C1eRxCYm2BLMuxWCXx8TeqMHIL8/Y3Q+uaSDUWcCiiFTrbCuPLgPI8z1X1NY
         Sp9u+6zkhLJWvrjWNh2x6upKWXx7eSjSRh41KcJI1gJa/7lozAwiNgOMFNPfKUFOgJno
         DYEBMh5iA4CKesye/+P8C/0qV0YTJO6CDX3pFzesFIn1hKf5oXZxquhWKOcTDgzOnAR0
         w7Ig==
X-Gm-Message-State: AJcUukf0VaszonScJyqS+dfALvnEbBFTwwJUMD6/lO/MDoltzICdMX0p
        XDlseVAp+mSTsU8q66yeIlY1dgSnl28=
X-Google-Smtp-Source: ALg8bN4zrPoxs+Z8w5FblzsEl1OtaArHUKOE0YHzlQ23yCXGe3PuhEUIvCFupsClQr2wOLyKxHn/SA==
X-Received: by 2002:a62:1a91:: with SMTP id a139mr29789252pfa.64.1548817620711;
        Tue, 29 Jan 2019 19:07:00 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54? ([2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54])
        by smtp.gmail.com with ESMTPSA id d18sm259452pfj.47.2019.01.29.19.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 19:07:00 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <7B615222-18AC-4006-8565-717F10FCAEF5@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DD7030A3-A6F1-408B-AEBE-CD86616DB23A";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v7 2/4] e2image: add -b and -B options to use supperblock
 backup
Date:   Tue, 29 Jan 2019 20:06:58 -0700
In-Reply-To: <20190129175134.26652-3-c17828@cray.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20190129175134.26652-1-c17828@cray.com>
 <20190129175134.26652-3-c17828@cray.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_DD7030A3-A6F1-408B-AEBE-CD86616DB23A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jan 29, 2019, at 10:51 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> e2image has no ability to use superblock backup to copy metadata.
> This feature can be useful if someone wants to make partition
> image and fix it using e2fsck utility.
>=20
> New -b option allows to pass superblock number, like e2fsck utility =
does.
> e2image doesn't change primary superblock and store it as is, so
> it can be fixed using e2fsck latter. Option -B allows setting
> superblock size.
>=20
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> misc/e2image.8.in | 33 +++++++++++++++++++++++++++++++++
> misc/e2image.c    | 43 +++++++++++++++++++++++++++++++++++++------
> 2 files changed, 70 insertions(+), 6 deletions(-)
>=20
> diff --git a/misc/e2image.8.in b/misc/e2image.8.in
> index a7bfdf24..bbbb57ae 100644
> --- a/misc/e2image.8.in
> +++ b/misc/e2image.8.in
> @@ -12,6 +12,15 @@ e2image \- Save critical ext2/ext3/ext4 filesystem =
metadata to a file
> ]
> [
> .B \-f
> +.B \-b
> +.I superblock
> +]
> +[
> +.B \-B
> +.I blocksize
> +]
> +[
> +.B \-fr
> ]
> .I device
> .I image-file
> @@ -167,6 +176,22 @@ the
> option will prevent analysis of problems related to hash-tree indexed
> directories.
> .PP
> +Option
> +.B \-b
> +.I superblock
> +can be used to get image from partition with broken primary =
superblock.
> +The partition is copied as-is including broken primary superblock.
> +.PP
> +Option
> +.B \-B
> +.I blocksize
> +can be used to set superblock block size. Normally, e2fsck will =
search
> +for the superblock at various different block sizes in an attempt to =
find
> +the appropriate blocksize. This search can be fooled in some cases.  =
This
> +option forces e2fsck to only try locating the superblock at a =
particular
> +blocksize. If the superblock is not found, e2fsck will terminate with =
a
> +fatal error.
> +.PP
> Note that this will work even if you substitute "/dev/hda1" for =
another raw
> disk image, or QCOW2 image previously created by
> .BR e2image .
> @@ -217,6 +242,14 @@ This can be useful to write a qcow2 image =
containing all data to a
> sparse image file where it can be loop mounted, or to a disk =
partition.
> Note that this may not work with qcow2 images not generated by =
e2image.
> .PP
> +Options
> +.B \-b
> +.I superblock
> +and
> +.B \-B
> +.I blocksize
> +can be used same way as for raw images.
> +.PP
> .SH INCLUDING DATA
> Normally
> .B e2image
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 9e21d0db..3c881fee 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -104,7 +104,8 @@ static int get_bits_from_size(size_t size)
>=20
> static void usage(void)
> {
> -	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -f ] device =
image-file\n"),
> +	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -f ] [ -b superblock ] [ =
-B blocksize]"
> +			  "[ -fr ] device image-file\n"),
> 		program_name);
> 	fprintf(stderr, _("       %s -I device image-file\n"), =
program_name);
> 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] =
"
> @@ -1267,7 +1268,8 @@ static void =
output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
> 	free_qcow2_image(img);
> }
>=20
> -static void write_raw_image_file(ext2_filsys fs, int fd, int type, =
int flags)
> +static void write_raw_image_file(ext2_filsys fs, int fd, int type, =
int flags,
> +				 blk64_t superblock)
> {
> 	struct process_block_struct	pb;
> 	struct ext2_inode		inode;
> @@ -1295,6 +1297,22 @@ static void write_raw_image_file(ext2_filsys =
fs, int fd, int type, int flags)
> 		}
> 	}
>=20
> +	if (superblock) {
> +		int j;
> +
> +		ext2fs_mark_block_bitmap2(meta_block_map, superblock);
> +		meta_blocks_count++;
> +
> +		/*
> +		 * Mark the backup superblock descriptors
> +		 */
> +		for (j =3D 0; j < fs->desc_blocks; j++) {
> +			ext2fs_mark_block_bitmap2(meta_block_map,
> +			ext2fs_descriptor_block_loc2(fs, superblock, =
j));
> +		}
> +		meta_blocks_count +=3D fs->desc_blocks;
> +	}
> +
> 	mark_table_blocks(fs);
> 	if (show_progress)
> 		fprintf(stderr, "%s", _("Scanning inodes...\n"));
> @@ -1474,6 +1492,8 @@ int main (int argc, char ** argv)
> 	int ignore_rw_mount =3D 0;
> 	int check =3D 0;
> 	struct stat st;
> +	blk64_t superblock =3D 0;
> +	int blocksize =3D 0;
>=20
> #ifdef ENABLE_NLS
> 	setlocale(LC_MESSAGES, "");
> @@ -1487,8 +1507,14 @@ int main (int argc, char ** argv)
> 	if (argc && *argv)
> 		program_name =3D *argv;
> 	add_error_table(&et_ext2_error_table);
> -	while ((c =3D getopt(argc, argv, "nrsIQafo:O:pc")) !=3D EOF)
> +	while ((c =3D getopt(argc, argv, "b:B:nrsIQafo:O:pc")) !=3D EOF)
> 		switch (c) {
> +		case 'b':
> +			superblock =3D strtoull(optarg, NULL, 0);
> +			break;
> +		case 'B':
> +			blocksize =3D strtoul(optarg, NULL, 0);
> +			break;
> 		case 'I':
> 			flags |=3D E2IMAGE_INSTALL_FLAG;
> 			break;
> @@ -1540,6 +1566,11 @@ int main (int argc, char ** argv)
> 						 "with raw or QCOW2 =
images."));
> 		exit(1);
> 	}
> +	if (superblock && !img_type) {
> +		com_err(program_name, 0, "%s", _("-b option can only be =
used "
> +						 "with raw or QCOW2 =
images."));
> +		exit(1);
> +	}
> 	if ((source_offset || dest_offset) && img_type !=3D E2IMAGE_RAW) =
{
> 		com_err(program_name, 0, "%s",
> 			_("Offsets are only allowed with raw images."));
> @@ -1590,8 +1621,8 @@ int main (int argc, char ** argv)
> 		}
> 	}
> 	sprintf(offset_opt, "offset=3D%llu", source_offset);
> -	retval =3D ext2fs_open2(device_name, offset_opt, open_flag, 0, =
0,
> -			      unix_io_manager, &fs);
> +	retval =3D ext2fs_open2(device_name, offset_opt, open_flag,
> +			      superblock, blocksize, unix_io_manager, =
&fs);
>         if (retval) {
> 		com_err (program_name, retval, _("while trying to open =
%s"),
> 			 device_name);
> @@ -1681,7 +1712,7 @@ skip_device:
> 		exit(1);
> 	}
> 	if (img_type)
> -		write_raw_image_file(fs, fd, img_type, flags);
> +		write_raw_image_file(fs, fd, img_type, flags, =
superblock);
> 	else
> 		write_image_file(fs, fd);
>=20
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_DD7030A3-A6F1-408B-AEBE-CD86616DB23A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxRFNIACgkQcqXauRfM
H+DViBAAhjOktUABjCBYmT0JFJ7fUQa+HbPtCHPchvA4yaKOxmr1PoIvFG2RBFca
qI5uUInODHeUCJRwqcvzkR25nWNRm5rldsWkqqpi9Pta9Z6Ya697WBvE1kfD8sUX
0NoIf6o+ZfFEG2CB6dPPf2ouae3YgrW1lcH0OKb/N4NZpmQ0WEojx3yYCwXNG3QY
WQpCKgaSy0pvk8cIPlTMGUxCIIvv7AuQITVUjq2y0rfzMyLZWHQuq5AaR9XVBhRO
ackgSI4OjjJcwrwLlIwIB3pCAHCcxKj/JzyqZNgVXmh++5V/KiFoAmgsmplq+eL4
GfIUwPDAPnlwuKD4Sd0KP8uxY4xSqqS2k/wElxHltNYcdIVbAk1KSXRKusKBzTaW
uxU+KMq5dX5/C1AAYUS1abgPhxxGYDwcXlye6I20Eg/nG/9Ftg0WxbODNWO/liNB
/c/h0ZZwEwlkYApxbEBFaSZSpTYvFd5AsBpuUUVC9hhYsgvlWMOR2h9fgrm/UZHw
I5GrwNOR4R+3meVvoy5FdfiXuvlaBUYjUmNrf/+NAl2cbaxx4PbsKL+2UCrFt3fL
aTcYVX4/+vwsMT2XNtk6KYU98uF+e3pMpqqqeYtLJu7piERc6m7fq+kqaIePP5w4
lFnBh7V6G4laf3gnuaKM+dyIr25Esy7y/Rttqobva9KpBWOQP7s=
=DilD
-----END PGP SIGNATURE-----

--Apple-Mail=_DD7030A3-A6F1-408B-AEBE-CD86616DB23A--
