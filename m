From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 2/4] e2image: add -b option to use supperblock backup
Date: Mon, 20 Nov 2017 12:45:47 -0700
Message-ID: <D7D92AC4-6A51-4BF5-8445-3EE487AEB382@dilger.ca>
References: <20171116135546.9991-1-artem.blagodarenko@gmail.com>
 <20171116135546.9991-3-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8B152761-0F00-47A5-B8D2-D10EA75262F8";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:38234 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752279AbdKTTpd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Nov 2017 14:45:33 -0500
Received: by mail-it0-f68.google.com with SMTP id n134so13156013itg.3
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 11:45:33 -0800 (PST)
In-Reply-To: <20171116135546.9991-3-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8B152761-0F00-47A5-B8D2-D10EA75262F8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 16, 2017, at 6:55 AM, Artem Blagodarenko =
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
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> lib/ext2fs/ext2fs.h |  4 ----
> misc/e2image.c      | 44 ++++++++++++++++++++++++++++++++++++++------
> 2 files changed, 38 insertions(+), 10 deletions(-)
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index c394ec80..6774e32c 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1588,10 +1588,6 @@ extern errcode_t ext2fs_open2(const char *name, =
const char *io_options,
> 			      int flags, int superblock,
> 			      unsigned int block_size, io_manager =
manager,
> 			      ext2_filsys *ret_fs);
> -extern errcode_t ext2fs_try_open_fs(char *filesystem_name, char =
*io_options,
> -			     blk64_t superblock, int blocksize, int =
flags,
> -			     io_manager io_ptr, ext2_filsys *ret_fs);
> -

This should be part of the previous patch.

> /*
>  * The dgrp_t argument to these two functions is not actually a group =
number
>  * but a block number offset within a group table!  Convert with the =
formula
> diff --git a/misc/e2image.c b/misc/e2image.c
> index be001f0f..756a1dbc 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -104,7 +104,8 @@ static int get_bits_from_size(size_t size)
>=20
> static void usage(void)
> {
> -	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -fr ] device =
image-file\n"),
> +	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -b superblock ] [ -B =
blocksize]"
> +			  "[ -fr ] device image-file\n"),
> 		program_name);
> 	fprintf(stderr, _("       %s -I device image-file\n"), =
program_name);
> 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] =
"
> @@ -1256,7 +1257,8 @@ static void =
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
> @@ -1284,6 +1286,22 @@ static void write_raw_image_file(ext2_filsys =
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
> @@ -1463,6 +1481,8 @@ int main (int argc, char ** argv)
> 	int ignore_rw_mount =3D 0;
> 	int check =3D 0;
> 	struct stat st;
> +	blk64_t superblock =3D 0;
> +	int blocksize =3D 0;
>=20
> #ifdef ENABLE_NLS
> 	setlocale(LC_MESSAGES, "");
> @@ -1476,7 +1496,7 @@ int main (int argc, char ** argv)
> 	if (argc && *argv)
> 		program_name =3D *argv;
> 	add_error_table(&et_ext2_error_table);
> -	while ((c =3D getopt(argc, argv, "nrsIQafo:O:pc")) !=3D EOF)
> +	while ((c =3D getopt(argc, argv, "nrsIQafo:O:pcb:B:")) !=3D EOF)

Options should preferably be in alphabetical order.  Even if the others
are not, at least these could be added at the start.

> @@ -1515,6 +1535,12 @@ int main (int argc, char ** argv)
> 		case 'c':
> 			check =3D 1;
> 			break;
> +		case 'b':
> +			superblock =3D strtoull(optarg, NULL, 0);
> +			break;
> +		case 'B':
> +			blocksize =3D strtoul(optarg, NULL, 0);
> +			break;

These should also be listed first.

Looks good otherwise.

Cheers, Andreas






--Apple-Mail=_8B152761-0F00-47A5-B8D2-D10EA75262F8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaEzDspIg59Q01vtYRArYdAJ4xXRzmpevz8TZahAbsMfaRSvA92wCfR2ey
iUIB78B89WhLw5US8cu0b5Y=
=3Iat
-----END PGP SIGNATURE-----

--Apple-Mail=_8B152761-0F00-47A5-B8D2-D10EA75262F8--
