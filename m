From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v1 4/4] Add inherit flags for project quota
Date: Sat, 12 Dec 2015 04:13:29 -0700
Message-ID: <0B73D69E-7BA4-47AE-8094-C9AB78AED569@dilger.ca>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com> <1446046933-26571-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_80D18837-83AB-444B-89B4-B86BE8B79A09"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33512 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbLLLNf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2015 06:13:35 -0500
Received: by iouu10 with SMTP id u10so154310517iou.0
        for <linux-ext4@vger.kernel.org>; Sat, 12 Dec 2015 03:13:35 -0800 (PST)
In-Reply-To: <1446046933-26571-5-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_80D18837-83AB-444B-89B4-B86BE8B79A09
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 28, 2015, at 9:42 AM, Li Xi <pkuelelixi@gmail.com> wrote:
>=20
> This patch add EXT4_PROJINHERIT_FL to enable inherit feature
> for project quota.
>=20
> Signed-off-by: Li Xi <lixi@ddn.com>
> Change-Id: I61491333eabcc33ccc09fa1ed5f8ffe4c4220e57
> ---
> lib/e2p/pf.c         |    1 +
> lib/ext2fs/ext2_fs.h |    5 +++--
> misc/chattr.c        |    3 ++-
> 3 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
> index 8961727..27421a6 100644
> --- a/lib/e2p/pf.c
> +++ b/lib/e2p/pf.c
> @@ -46,6 +46,7 @@ static struct flags_name flags_array[] =3D {
> 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
> 	{ FS_NOCOW_FL, "C", "No_COW" },
> 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
> +	{ EXT4_PROJINHERIT_FL, "P", "Project_Iherit" },
> 	{ 0, NULL, NULL }
> };
>=20
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 036e6ad..4e46f22 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -327,10 +327,11 @@ struct ext2_dx_tail {
> #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being =
deleted */
> #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot =
shrink has completed */
> #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline =
data */
> +#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with =
parents projid */
> #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 =
lib */
>=20
> -#define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags =
*/
> -#define EXT2_FL_USER_MODIFIABLE		0x004B80FF /* User =
modifiable flags */
> +#define EXT2_FL_USER_VISIBLE		0x204BDFFF /* User visible flags =
*/
> +#define EXT2_FL_USER_MODIFIABLE		0x204B80FF /* User =
modifiable flags */
>=20
> /*
>  * ioctl commands
> diff --git a/misc/chattr.c b/misc/chattr.c
> index e55d693..40069c9 100644
> --- a/misc/chattr.c
> +++ b/misc/chattr.c
> @@ -83,7 +83,7 @@ static unsigned long sf;
> static void usage(void)
> {
> 	fprintf(stderr,
> -		_("Usage: %s [-RVf] [-+=3DaAcCdDeijsStTu] [-v version] =
files...\n"),
> +		_("Usage: %s [-RVf] [-+=3DaAcCdDeijPsStTu] [-v version] =
files...\n"),
> 		program_name);
> 	exit(1);
> }
> @@ -103,6 +103,7 @@ static const struct flags_char flags_array[] =3D {
> 	{ EXT4_EXTENTS_FL, 'e'},
> 	{ EXT2_IMMUTABLE_FL, 'i' },
> 	{ EXT3_JOURNAL_DATA_FL, 'j' },
> +	{ EXT4_PROJINHERIT_FL, 'P' },
> 	{ EXT2_SECRM_FL, 's' },
> 	{ EXT2_UNRM_FL, 'u' },
> 	{ EXT2_NOTAIL_FL, 't' },

How does one set the actual project ID on an inode?  I'd have thought =
that
"chattr" and "lsattr -P" could change and list the project ID on an =
inode,
since regular "stat" and "ls" will not do this today.  I don't think it =
is OK
to require xfsprogs to be installed to be able to set these fields, =
though
chattr and lsattr should use the same ioctl() values FS_IOC_FSSETXATTR =
and
FS_IOC_FSGETXATTR as the xfsprogs utils do.

Cheers, Andreas






--Apple-Mail=_80D18837-83AB-444B-89B4-B86BE8B79A09
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmwBWXKl2rkXzB/gAQiE/A/9EOeROlogsGi37oftiEXhd97RWb5hm/Kk
FA9s3b8+EumB0uosBM0G16sGISo81M2H10sjWi/mB85tybedHNfxYOuFsrG7WzNh
gvsCWAiJ447D325I1bNsnaG6LrN/tHYAOqsvgydZDrtBbY5+/CHv3vj2Qpu8vlWD
7aZw6wnc8bdwmmigsL5qG3m63GPZEFNwMmJdIYqs9m01USTMqB0CfZXlJrc8sFX9
xJ5npd0rNKkh0WPiYxdG2zJogQhS5RiTsRBmZmdgn767RpQ50sYFpO91+alX0/T3
6bonMrT5dzGiBgVMXakQIwrp1nb2tlvqvUuthBH4Nk0G8p1J5VBYcN9j4s99MSsS
X9aeDpuVoLYu86eNEW/K6RRLQdqZXussyqQTyztbCyjFr/v0a8CKg3hLxumvwYji
1mPEA8E5+HsfArjSGZNMqkoKPNAJbaMgn6NRQ+ub17XSYwbkdEK92wSNTG3zTktb
DBp1XOyPr62ncqDvfn1Gv9VAiYUbB3vKDUCCpdfUdVnamKGCMiaHtRJUoTia39zJ
oYuKIiSGuLJixp6Qewjl0tQVdqcL3fPKxHrkQeDOny1H6LaB6rROCwlkxfUdL76I
JRAOMDMATVIdFsOxC73HuzpmvRAtrJI1dBR8i2khhO4ckC65CO98phQ5Wm4465kM
MY90SPd+8+Y=
=y3OB
-----END PGP SIGNATURE-----

--Apple-Mail=_80D18837-83AB-444B-89B4-B86BE8B79A09--
