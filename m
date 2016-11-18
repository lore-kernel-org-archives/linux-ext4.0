From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: fix in-superblock mount options processing
Date: Fri, 18 Nov 2016 02:38:41 -0700
Message-ID: <197771C1-1059-4516-B6AC-EA32A5057E66@dilger.ca>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com> <20161118042610.13464-1-tytso@mit.edu> <20161118042610.13464-2-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8222B1B5-5417-475C-A844-4CD685D054EC"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161118042610.13464-2-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_8222B1B5-5417-475C-A844-4CD685D054EC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 17, 2016, at 9:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> Fix a large number of problems with how we handle mount options in the
> superblock.  For one, if the string in the superblock is long enough
> that it is not null terminated, we could run off the end of the string
> and try to interpret superblocks fields as characters.  It's unlikely
> this will cause a security problem, but it could result in an invalid
> parse.  Also, parse_options is destructive to the string, so in some
> cases if there is a comma-separated string, it would be modified in
> the superblock.  (Fortunately it only happens on file systems with a
> 1k block size.)
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
> fs/ext4/super.c | 37 ++++++++++++++++++++++---------------
> 1 file changed, 22 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 12f50ef56fe1..3009c03220d6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3303,7 +3303,7 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	char *orig_data =3D kstrdup(data, GFP_KERNEL);
> 	struct buffer_head *bh;
> 	struct ext4_super_block *es =3D NULL;
> -	struct ext4_sb_info *sbi;
> +	struct ext4_sb_info *sbi =3D kzalloc(sizeof(*sbi), GFP_KERNEL);
> 	ext4_fsblk_t block;
> 	ext4_fsblk_t sb_block =3D get_sb_block(&data);
> 	ext4_fsblk_t logical_sb_block;
> @@ -3321,17 +3321,17 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	int err =3D 0;
> 	unsigned int journal_ioprio =3D DEFAULT_JOURNAL_IOPRIO;
> 	ext4_group_t first_not_zeroed;
> +	char *s_mount_opts =3D =
kzalloc(sizeof(sbi->s_es->s_mount_opts)+1,
> +				   GFP_KERNEL);

This doesn't check if "sbi" is non-NULL before dereferencing it.  While
there isn't really any likelihood for this allocation to fail, I don't
think there is any benefit to moving these allocations to the =
declaration.

> -	sbi =3D kzalloc(sizeof(*sbi), GFP_KERNEL);
> -	if (!sbi)
> -		goto out_free_orig;
> +	if ((data && !orig_data) || !s_mount_opts || !sbi)
> +		goto out_free_base;
>=20
> 	sbi->s_blockgroup_lock =3D
> 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
> -	if (!sbi->s_blockgroup_lock) {
> -		kfree(sbi);
> -		goto out_free_orig;
> -	}
> +	if (!sbi->s_blockgroup_lock)
> +		goto out_free_base;
> +
> 	sb->s_fs_info =3D sbi;
> 	sbi->s_sb =3D sb;
> 	sbi->s_inode_readahead_blks =3D EXT4_DEF_INODE_READAHEAD_BLKS;
> @@ -3477,11 +3477,15 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	 */
> 	sbi->s_li_wait_mult =3D EXT4_DEF_LI_WAIT_MULT;
>=20
> -	if (!parse_options((char *) sbi->s_es->s_mount_opts, sb,
> -			   &journal_devnum, &journal_ioprio, 0)) {
> -		ext4_msg(sb, KERN_WARNING,
> -			 "failed to parse options in superblock: %s",
> -			 sbi->s_es->s_mount_opts);
> +	if (sbi->s_es->s_mount_opts[0]) {
> +		strncpy(s_mount_opts, sbi->s_es->s_mount_opts,
> +			sizeof(sbi->s_es->s_mount_opts));

This could use kstrndup()?  It always allocates an extra byte for the =
NUL.

> +		if (!parse_options(s_mount_opts, sb, &journal_devnum,
> +				   &journal_ioprio, 0)) {
> +			ext4_msg(sb, KERN_WARNING,
> +				 "failed to parse options in superblock: =
%s",
> +				 s_mount_opts);
> +		}
> 	}
> 	sbi->s_def_mount_opt =3D sbi->s_mount_opt;
> 	if (!parse_options((char *) data, sb, &journal_devnum,
> @@ -4162,7 +4166,9 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>=20
> 	if (___ratelimit(&ext4_mount_msg_ratelimit, "EXT4-fs mount"))
> 		ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> -			 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> +			 "Opts: %.*s%s%s", descr,
> +			 sizeof(sbi->s_es->s_mount_opts),
> +			 sbi->s_es->s_mount_opts,

This isn't really needed, since there is always a NUL terminator added
to the string?

> 			 *sbi->s_es->s_mount_opts ? "; " : "", =
orig_data);
>=20
> 	if (es->s_error_count)
> @@ -4241,9 +4247,10 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> out_fail:
> 	sb->s_fs_info =3D NULL;
> 	kfree(sbi->s_blockgroup_lock);
> +out_free_base:
> 	kfree(sbi);
> -out_free_orig:
> 	kfree(orig_data);
> +	kfree(s_mount_opts);
> 	return err ? err : ret;
> }


Cheers, Andreas






--Apple-Mail=_8222B1B5-5417-475C-A844-4CD685D054EC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC7MIXKl2rkXzB/gAQgcjA/+MnUc6TncHV1GLDNKKP/4cQifiUfDoTpL
/yavzvxtzAPRl3E/a8mSjf8KUDfOPX0cfy5nZ2jDqU1rwV0lGz2N8DzrRb3fHxBD
LTzsoYYAdnLb0/ktW02k/sWkG6rMUjHkP5v5K9i4n6DvgiQ3SXsIwUfKF2q4b5UB
aNZWo4iHQxlm/HywJGGRjVk9D0wM5QOsdyuB3Zycg+5/xeFF5S5t9YEGsmj9WztP
iCAc9n2cSnQD5++r35hVtRysAdUlCFYE3k3Tw0dqgk+CzLBeoIvxux+6MdjUBZ/O
/0fsO0WQ/DArrz5iNulM5jzUh3ItJqgRKolGvECp2GBoBI33hZyEJUbYqlpeyvYv
mOg2ryUre1mogar9ZSinqmmeKQGfedgDQkTNCxrc/hwBsKSwTjWN99zmTaGK6drB
r2WYzCpIVsY4XQnfR0m0W26evazMSrnPG+bOni61M+wv/hgUK/Ubr3tz8ybCw4rZ
HCjprPAhOMJZeS9fgpvq5sorN3ypmt+BCFKG3UZrzOdLljAU3GMQcsnoIo84vQwo
8+jZaoNn3uPwAtn6+NB3Nj/94kQSPvUiWoDMb2I/T9Ptlr6CdUrJ9a+4qHYRduMK
jPkNlSSavr5WSmROaQjhd2f26zTrzRoWIy0OQcRmxJUU0qAM+ajbbUWzkWsYNJfR
ckjHiNRdF7A=
=cz2T
-----END PGP SIGNATURE-----

--Apple-Mail=_8222B1B5-5417-475C-A844-4CD685D054EC--
