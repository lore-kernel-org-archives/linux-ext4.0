From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] misc: fix all the compiler warnings
Date: Fri, 3 Mar 2017 12:46:26 -0700
Message-ID: <64C4A5E7-E740-49D5-99CA-76A39C31D3B2@dilger.ca>
References: <148849323931.17335.16297720312431312922.stgit@birch.djwong.org>
 <148849324544.17335.1546748325217796864.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_19662A76-0BCE-44C7-BCB1-79041C21897B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34887 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbdCCUwF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Mar 2017 15:52:05 -0500
Received: by mail-io0-f193.google.com with SMTP id f103so7987185ioi.2
        for <linux-ext4@vger.kernel.org>; Fri, 03 Mar 2017 12:52:04 -0800 (PST)
In-Reply-To: <148849324544.17335.1546748325217796864.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_19662A76-0BCE-44C7-BCB1-79041C21897B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 2, 2017, at 3:20 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Fix the various compiler warnings that have crept in, and only define
> __bitwise if the system headers haven't already done so.  Linux 4.10
> changes the __bitwise definition so that our redefinition here is
> just different enough that gcc complains.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> debugfs/debugfs.c          |    2 --
> debugfs/xattrs.c           |    5 ++---
> e2fsck/pass2.c             |    2 +-
> lib/ext2fs/ext2_types.h.in |    8 ++++++--
> lib/ext2fs/ext_attr.c      |    2 --
> lib/support/cstring.c      |    6 +++---
> misc/dumpe2fs.c            |   15 ---------------
> 7 files changed, 12 insertions(+), 28 deletions(-)
>=20
>=20
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 1a84cfc..059ddc3 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -1605,9 +1605,7 @@ void do_unlink(int argc, char *argv[])
> void do_copy_inode(int argc, char *argv[])
> {
> 	ext2_ino_t	src_ino, dest_ino;
> -	struct ext2_inode inode;
> 	unsigned char	buf[4096];
> -	int		retval;
>=20
> 	if (common_args_process(argc, argv, 3, 3, "copy_inode",
> 				"<source file> <dest_name>", =
CHECK_FS_RW))
> diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
> index 2443518..9b87d14 100644
> --- a/debugfs/xattrs.c
> +++ b/debugfs/xattrs.c
> @@ -146,7 +146,7 @@ void do_get_xattr(int argc, char **argv)
> 	size_t buflen;
> 	int i;
> 	int print_flags =3D 0;
> -	int handle_flags =3D 0;
> +	unsigned int handle_flags =3D 0;
> 	errcode_t err;
>=20
> 	reset_getopt();
> @@ -241,8 +241,7 @@ void do_set_xattr(int argc, char **argv)
> 	FILE *fp =3D NULL;
> 	char *buf =3D NULL;
> 	size_t buflen;
> -	int print_flags =3D 0;
> -	int handle_flags =3D 0;
> +	unsigned int handle_flags =3D 0;
> 	int i;
> 	errcode_t err;
>=20
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 11c19e8..170878c 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -90,7 +90,7 @@ void e2fsck_pass2(e2fsck_t ctx)
> 	struct ext2_super_block *sb =3D ctx->fs->super;
> 	struct problem_context	pctx;
> 	ext2_filsys 		fs =3D ctx->fs;
> -	char			*buf;
> +	char			*buf =3D NULL;
> #ifdef RESOURCE_TRACK
> 	struct resource_track	rtrack;
> #endif
> diff --git a/lib/ext2fs/ext2_types.h.in b/lib/ext2fs/ext2_types.h.in
> index 07adc64..fb36a5d 100644
> --- a/lib/ext2fs/ext2_types.h.in
> +++ b/lib/ext2fs/ext2_types.h.in
> @@ -173,10 +173,14 @@ typedef long		__s64;
> #define EXT2_ENDIAN_H_
>=20
> #ifdef __CHECKER__
> -#define __bitwise		__attribute__((bitwise))
> +# ifndef __bitwise
> +#  define __bitwise		__attribute__((bitwise))
> +# endif
> #define __force			__attribute__((force))
> #else
> -#define __bitwise
> +# ifndef __bitwise
> +#  define __bitwise
> +# endif
> #define __force
> #endif
>=20
> diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> index ce2f48f..7a9a2d5 100644
> --- a/lib/ext2fs/ext_attr.c
> +++ b/lib/ext2fs/ext_attr.c
> @@ -478,7 +478,6 @@ static errcode_t =
convert_posix_acl_to_disk_buffer(const void *value, size_t size
> 	ext4_acl_header *ext_acl;
> 	size_t s;
> 	void *e;
> -	int err;
>=20
> 	int count;
>=20
> @@ -532,7 +531,6 @@ static errcode_t =
convert_disk_buffer_to_posix_acl(const void *value, size_t size
> 	errcode_t err;
> 	const char *cp;
> 	char *out;
> -	int count;
>=20
> 	if ((!value) ||
> 	    (size < sizeof(ext4_acl_header)) ||
> diff --git a/lib/support/cstring.c b/lib/support/cstring.c
> index 7965e95..57f4522 100644
> --- a/lib/support/cstring.c
> +++ b/lib/support/cstring.c
> @@ -15,12 +15,12 @@
>=20
> int parse_c_string(char *str)
> {
> -	unsigned char *to, *from, ch;
> +	char *to, *from, ch;
> 	int v;
>=20
> 	to =3D from =3D str;
>=20
> -	for (to =3D from =3D (unsigned char *) str;
> +	for (to =3D from =3D (char *) str;
> 	     *from && *from !=3D '"'; to++, from++) {
> 		if (*from =3D=3D '\\') {
> 			ch =3D *(++from);
> @@ -93,7 +93,7 @@ int parse_c_string(char *str)
> 		*to =3D *from;
> 	}
> 	*to =3D '\0';
> -	return to - (unsigned char *) str;
> +	return to - (char *) str;
> }
>=20
> void print_c_string(FILE *f, const char *cp, int len)
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 621840a..395ea9e 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -356,16 +356,6 @@ static void list_bad_blocks(ext2_filsys fs, int =
dump)
> 	ext2fs_badblocks_list_free(bb_list);
> }
>=20
> -static const char *journal_checksum_type_str(__u8 type)
> -{
> -	switch (type) {
> -	case JBD2_CRC32C_CHKSUM:
> -		return "crc32c";
> -	default:
> -		return "unknown";
> -	}
> -}

I'd assume this was meant to be used somewhere?

> -
> static void print_inline_journal_information(ext2_filsys fs)
> {
> 	journal_superblock_t	*jsb;
> @@ -374,8 +364,6 @@ static void =
print_inline_journal_information(ext2_filsys fs)
> 	errcode_t		retval;
> 	ino_t			ino =3D fs->super->s_journal_inum;
> 	char			buf[1024];
> -	__u32			*mask_ptr, mask, m;
> -	int			i, j, size, printed =3D 0;
>=20
> 	if (fs->flags & EXT2_FLAG_IMAGE_FILE)
> 		return;
> @@ -411,10 +399,7 @@ static void print_journal_information(ext2_filsys =
fs)
> {
> 	errcode_t	retval;
> 	char		buf[1024];
> -	char		str[80];
> -	unsigned int	i, j, printed =3D 0;
> 	journal_superblock_t	*jsb;
> -	__u32			*mask_ptr, mask, m;
>=20
> 	/* Get the journal superblock */
> 	if ((retval =3D io_channel_read_blk64(fs->io,
>=20


Cheers, Andreas






--Apple-Mail=_19662A76-0BCE-44C7-BCB1-79041C21897B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYucgSpIg59Q01vtYRAsL1AKDqcGkCtnlz9uckoUTeRTT13YepsACeMsMe
sHfqQ5JMoLRs1cmF2yg3FBU=
=ULCw
-----END PGP SIGNATURE-----

--Apple-Mail=_19662A76-0BCE-44C7-BCB1-79041C21897B--
