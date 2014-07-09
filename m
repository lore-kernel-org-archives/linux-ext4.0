From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3 v3] journal: use consts instead of 1024 and add helper for journal with 1k blocksize
Date: Wed, 9 Jul 2014 14:33:45 -0600
Message-ID: <8C896C64-232E-4B9F-B3A6-45F5B00F96FA@dilger.ca>
References: <20140709185742.GC10417@birch.djwong.org> <1404934797-31667-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_51CC6AEB-0E63-4B72-8F55-E9E654CF489C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50714 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaGIUdt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 16:33:49 -0400
Received: by mail-pa0-f48.google.com with SMTP id et14so9699050pad.7
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jul 2014 13:33:48 -0700 (PDT)
In-Reply-To: <1404934797-31667-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_51CC6AEB-0E63-4B72-8F55-E9E654CF489C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 9, 2014, at 1:39 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:

> Use EXT2_MIN_BLOCK_SIZE/JFS_MIN_JOURNAL_BLOCKS instead of hardcoded =
1024
> when it is okay, and also add a helper ext2fs_journal_sb_start() that
> will return start of journal sb with special case for fs with 1k block
> size.
>=20
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> v2: missed htonl() (thanks to Andreas Dilger)
> v3: use SUPERBLOCK_OFFSET instead of EXT2_MIN_BLOCK_SIZE (thanks to =
Darrick J.
> Wong)
>=20
> e2fsck/journal.c       |  5 ++---
> lib/ext2fs/ext2fs.h    |  1 +
> lib/ext2fs/mkjournal.c | 28 ++++++++++++++++------------
> misc/tune2fs.c         |  6 +++---
> 4 files changed, 22 insertions(+), 18 deletions(-)
>=20
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index a7b1150..6df0165 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -443,8 +443,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, =
journal_t **ret_journal)
> 	if (ext_journal) {
> 		blk64_t maxlen;
>=20
> -		if (ctx->fs->blocksize =3D=3D 1024)
> -			start =3D 1;
> +		start =3D ext2fs_journal_sb_start(ctx->fs->blocksize) - =
1;
> 		bh =3D getblk(dev_journal, start, ctx->fs->blocksize);
> 		if (!bh) {
> 			retval =3D EXT2_ET_NO_MEMORY;
> @@ -455,7 +454,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, =
journal_t **ret_journal)
> 			brelse(bh);
> 			goto errout;
> 		}
> -		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + 1024,
> +		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + =
SUPERBLOCK_OFFSET,
> 		       sizeof(jsuper));
> 		brelse(bh);
> #ifdef WORDS_BIGENDIAN
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 599c972..a759741 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1498,6 +1498,7 @@ extern errcode_t =
ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks,
> extern errcode_t ext2fs_add_journal_inode2(ext2_filsys fs, blk_t =
num_blocks,
> 					   blk64_t goal, int flags);
> extern int ext2fs_default_journal_size(__u64 num_blocks);
> +extern int ext2fs_journal_sb_start(int blocksize);
>=20
> /* openfs.c */
> extern errcode_t ext2fs_open(const char *name, int flags, int =
superblock,
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 884d9c0..0ad674d 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -49,7 +49,7 @@ errcode_t =
ext2fs_create_journal_superblock(ext2_filsys fs,
> 	errcode_t		retval;
> 	journal_superblock_t	*jsb;
>=20
> -	if (num_blocks < 1024)
> +	if (num_blocks < JFS_MIN_JOURNAL_BLOCKS)
> 		return EXT2_ET_JOURNAL_TOO_SMALL;
>=20
> 	if ((retval =3D ext2fs_get_mem(fs->blocksize, &jsb)))
> @@ -75,10 +75,7 @@ errcode_t =
ext2fs_create_journal_superblock(ext2_filsys fs,
> 	if (fs->super->s_feature_incompat &
> 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
> 		jsb->s_nr_users =3D 0;
> -		if (fs->blocksize =3D=3D 1024)
> -			jsb->s_first =3D htonl(3);
> -		else
> -			jsb->s_first =3D htonl(2);
> +		jsb->s_first =3D =
htonl(ext2fs_journal_sb_start(fs->blocksize) + 1);
> 	}
>=20
> 	*ret_jsb =3D (char *) jsb;
> @@ -430,6 +427,13 @@ int ext2fs_default_journal_size(__u64 num_blocks)
> 	return 32768;
> }
>=20
> +int ext2fs_journal_sb_start(int blocksize)
> +{
> +	if (blocksize =3D=3D EXT2_MIN_BLOCK_SIZE)
> +		return 2;
> +	return 1;
> +}
> +
> /*
>  * This function adds a journal device to a filesystem
>  */
> @@ -437,7 +441,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys =
fs, ext2_filsys journal_dev)
> {
> 	struct stat	st;
> 	errcode_t	retval;
> -	char		buf[1024];
> +	char		buf[SUPERBLOCK_SIZE];
> 	journal_superblock_t	*jsb;
> 	int		start;
> 	__u32		i, nr_users;
> @@ -450,10 +454,9 @@ errcode_t ext2fs_add_journal_device(ext2_filsys =
fs, ext2_filsys journal_dev)
> 		return EXT2_ET_JOURNAL_NOT_BLOCK; /* Must be a block =
device */
>=20
> 	/* Get the journal superblock */
> -	start =3D 1;
> -	if (journal_dev->blocksize =3D=3D 1024)
> -		start++;
> -	if ((retval =3D io_channel_read_blk64(journal_dev->io, start, =
-1024,
> +	start =3D ext2fs_journal_sb_start(journal_dev->blocksize);
> +	if ((retval =3D io_channel_read_blk64(journal_dev->io, start,
> +					    -SUPERBLOCK_SIZE,
> 					    buf)))
> 		return retval;
>=20
> @@ -479,7 +482,8 @@ errcode_t ext2fs_add_journal_device(ext2_filsys =
fs, ext2_filsys journal_dev)
> 	}
>=20
> 	/* Writeback the journal superblock */
> -	if ((retval =3D io_channel_write_blk64(journal_dev->io, start, =
-1024, buf)))
> +	if ((retval =3D io_channel_write_blk64(journal_dev->io, start,
> +					    -SUPERBLOCK_SIZE, buf)))
> 		return retval;
>=20
> 	fs->super->s_journal_inum =3D 0;
> @@ -632,7 +636,7 @@ main(int argc, char **argv)
> 		exit(1);
> 	}
>=20
> -	retval =3D ext2fs_add_journal_inode(fs, 1024, 0);
> +	retval =3D ext2fs_add_journal_inode(fs, JFS_MIN_JOURNAL_BLOCKS, =
0);
> 	if (retval) {
> 		com_err(argv[0], retval, "while adding journal to %s",
> 			device_name);
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index d95cc3d..0e7caf2 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -187,7 +187,7 @@ static int remove_journal_device(ext2_filsys fs)
> {
> 	char		*journal_path;
> 	ext2_filsys	jfs;
> -	char		buf[1024];
> +	char		buf[SUPERBLOCK_SIZE];
> 	journal_superblock_t	*jsb;
> 	int		i, nr_users;
> 	errcode_t	retval;
> @@ -230,7 +230,7 @@ static int remove_journal_device(ext2_filsys fs)
> 	}
>=20
> 	/* Get the journal superblock */
> -	if ((retval =3D io_channel_read_blk64(jfs->io, 1, -1024, buf))) =
{
> +	if ((retval =3D io_channel_read_blk64(jfs->io, 1, =
-SUPERBLOCK_SIZE, buf))) {
> 		com_err(program_name, retval, "%s",
> 			_("while reading journal superblock"));
> 		goto no_valid_journal;
> @@ -261,7 +261,7 @@ static int remove_journal_device(ext2_filsys fs)
> 	jsb->s_nr_users =3D htonl(nr_users);
>=20
> 	/* Write back the journal superblock */
> -	if ((retval =3D io_channel_write_blk64(jfs->io, 1, -1024, buf))) =
{
> +	if ((retval =3D io_channel_write_blk64(jfs->io, 1, =
-SUPERBLOCK_SIZE, buf))) {
> 		com_err(program_name, retval,
> 			"while writing journal superblock.");
> 		goto no_valid_journal;
> --=20
> 2.0.0
>=20


Cheers, Andreas






--Apple-Mail=_51CC6AEB-0E63-4B72-8F55-E9E654CF489C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU72nKXKl2rkXzB/gAQJIiBAArVoqv2SPmgxqNHWoaACNOuUO+aWhlyVF
/4LNwVscGq1INlA1gKS8wDqfNiOtu2EughuziAKzNXRz85VAIJgDi+RIH7bGy1b7
n2/d35iRCMeF/EEdnBeXcJQDNkOdehVXJ/lIyfYqLsmz1tbzO+ffdGnbd5QndUtG
yYJXlMnpCEjY7SfMnBBUhjzX5qHwAZYG1E1TnjDC4Y1YBdfZaXd9Ed30v1FBak5r
mw396770/ZsQsaokTV7S8+fD8j3yyNNrxLGZ0s4099/Nyz6pf4vZsXszweSI/NUo
WbLXPzEfX7LYyUvN5sYbiGtmPGOMfGfo8jM4aS1vCHxj7g91kOeP5LvLfTNH4x0K
YCozkC4VwZOVRVk/w32+3VgLI+89P0fO+ii9XRY2Hl84f3kruaC+zFi6RUV2Z66u
iyDBGcdmNijyZ0sBISSz9THeoha7yTAKW+kyGejD+9J9NOhFCYM3StqFjA8UMqqx
GKu5U1Q6dhPHZnLfC0Pl5Yf9DSOgXdKkbjGLxg2MakAOfQs6yeaguu4VxaHBr3wJ
h5zt5nw98UgRq5oj06du/VHwxIi/YZKIdz3loEIjtKWg9FXeHacKSiwlFp5HmCQl
a7NtYQrgkzBgiyd9QycE3vYsRVvnat7CaUiJPoPbsqzNx15xfGPJVh9XRfRlpIAk
bEfxNQ7M+ZY=
=ewCz
-----END PGP SIGNATURE-----

--Apple-Mail=_51CC6AEB-0E63-4B72-8F55-E9E654CF489C--
