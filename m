From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/4] e2image: add -b option to use supperblock backup
Date: Wed, 5 Jul 2017 11:06:47 -0600
Message-ID: <E1C0F30A-997C-474D-A1B4-C13B4A345607@dilger.ca>
References: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
 <1498496326-76684-3-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FB90B93B-5D96-4EC3-8020-5F7C749F183E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33809 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751703AbdGERFh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 13:05:37 -0400
Received: by mail-it0-f68.google.com with SMTP id o202so14772023itc.1
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 10:05:36 -0700 (PDT)
In-Reply-To: <1498496326-76684-3-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FB90B93B-5D96-4EC3-8020-5F7C749F183E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jun 26, 2017, at 10:58 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> e2image has no ability to use superblock backup to copy metadata.
> This feature can be useful if someone wants to make partition
> image and fix it using e2fsck utility.
>=20
> New -b option allows to pass superblock number, like e2fsck utility =
do.
> e2image doesn't change primary superblock and store is as is, so
> it can be fixed using e2fsck latter.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

One comment/question below.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> misc/e2image.c |   38 ++++++++++++++++++++++++++++++++------
> 1 files changed, 32 insertions(+), 6 deletions(-)
>=20
> diff --git a/misc/e2image.c b/misc/e2image.c
> index e0c3188..acc27d1 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -103,7 +103,8 @@ static int get_bits_from_size(size_t size)
>=20
> static void usage(void)
> {
> -	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -fr ] device =
image-file\n"),
> +	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -b superblock ] "
> +			  "[ -fr ] device image-file\n"),

Does this also need to accept the "-B blocksize" option?  That said, =
this is
definitely an improvement.

> 		program_name);
> 	fprintf(stderr, _("       %s -I device image-file\n"), =
program_name);
> 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] =
"
> @@ -1255,7 +1256,7 @@ static void =
output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
> 	free_qcow2_image(img);
> }
>=20
> -static void write_raw_image_file(ext2_filsys fs, int fd, int type, =
int flags)
> +static void write_raw_image_file(ext2_filsys fs, int fd, int type, =
int flags, blk64_t superblock)
> {
> 	struct process_block_struct	pb;
> 	struct ext2_inode		inode;
> @@ -1283,6 +1284,22 @@ static void write_raw_image_file(ext2_filsys =
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
> @@ -1462,6 +1479,7 @@ int main (int argc, char ** argv)
> 	int ignore_rw_mount =3D 0;
> 	int check =3D 0;
> 	struct stat st;
> +	blk64_t superblock =3D 0;
>=20
> #ifdef ENABLE_NLS
> 	setlocale(LC_MESSAGES, "");
> @@ -1475,7 +1493,7 @@ int main (int argc, char ** argv)
> 	if (argc && *argv)
> 		program_name =3D *argv;
> 	add_error_table(&et_ext2_error_table);
> -	while ((c =3D getopt(argc, argv, "nrsIQafo:O:pc")) !=3D EOF)
> +	while ((c =3D getopt(argc, argv, "nrsIQafo:O:pcb:")) !=3D EOF)
> 		switch (c) {
> 		case 'I':
> 			flags |=3D E2IMAGE_INSTALL_FLAG;
> @@ -1514,6 +1532,9 @@ int main (int argc, char ** argv)
> 		case 'c':
> 			check =3D 1;
> 			break;
> +		case 'b':
> +			superblock =3D strtoull(optarg, NULL, 0);
> +			break;
> 		default:
> 			usage();
> 		}
> @@ -1528,6 +1549,11 @@ int main (int argc, char ** argv)
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
> @@ -1578,8 +1604,8 @@ int main (int argc, char ** argv)
> 		}
> 	}
> 	sprintf(offset_opt, "offset=3D%llu", source_offset);
> -	retval =3D ext2fs_open2(device_name, offset_opt, open_flag, 0, =
0,
> -			      unix_io_manager, &fs);
> +	retval =3D ext2fs_try_open_fs(device_name, offset_opt, =
superblock, 0,
> +				    open_flag, unix_io_manager, &fs);
>         if (retval) {
> 		com_err (program_name, retval, _("while trying to open =
%s"),
> 			 device_name);
> @@ -1664,7 +1690,7 @@ skip_device:
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
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_FB90B93B-5D96-4EC3-8020-5F7C749F183E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXRynpIg59Q01vtYRAoQ+AJ4vI7PoCa8yafYllx5NcE50/je+rACfQm36
cbxqxBq3PJvFpIrb6j5GiO4=
=ppJZ
-----END PGP SIGNATURE-----

--Apple-Mail=_FB90B93B-5D96-4EC3-8020-5F7C749F183E--
