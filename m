From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: improve smp scalability for inode generation
Date: Thu, 19 Oct 2017 05:50:15 -0600
Message-ID: <00F078D1-39E9-4F16-8B5B-6952645846E5@dilger.ca>
References: <8760bcpdc8.fsf@openvz.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_4DC8544E-A927-4ED3-A7D6-3BF5528CE7BD";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:46302 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdJSLuX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Oct 2017 07:50:23 -0400
Received: by mail-it0-f67.google.com with SMTP id f187so9867089itb.1
        for <linux-ext4@vger.kernel.org>; Thu, 19 Oct 2017 04:50:23 -0700 (PDT)
In-Reply-To: <8760bcpdc8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4DC8544E-A927-4ED3-A7D6-3BF5528CE7BD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 18, 2017, at 11:36 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
>=20
>=20
> ->s_next_generation is protected by s_next_gen_lock but it usage
> pattern is very primitive and can be replaced with atomic_ops
>=20
> This significantly improve creation/unlink scenario on SMP systems,
> for example lat_fs_create_unlink test [1] on x2 E5-2680 (32vcpu) =
system
> shows ~20% improvement.
> | nr_tsk | wo/ patch | w/ patch |
> |--------+-----------+----------|
> |      1 |       137 |      140 |
> |      2 |       224 |      233 |
> |      4 |       356 |      372 |
> |      8 |       439 |      519 |
> |     16 |       443 |      585 |
> |     32 |       598 |      695 |
> |     64 |       559 |      707 |
> |    128 |       385 |      437 |

Strictly speaking, we don't need a single global value for i_generation.
These are per-inode values, and just need to be relatively unique =
compared
to previous values for each inode.  There are also potential security
benefits from not having sequential i_generation numbers, since that =
makes
NFS file handle guessing a lot harder.

You could just increment the previous i_generation value for that inode
(if the old inode was read from disk), or generate a random number (also
likely to be CPU expensive and risk collisions), or use a per-CPU =
counter
(with some way to ensure threads allocating/freeing inodes on different
cores do not allocate the same generation in close proximity), like:

        cpuid =3D smp_processor_id();
        i_generation =3D sb->s_generation[cpuid] | cpuid;
        sb->s_generation[cpuid] +=3D num_possible_cpus();

or whatever is fastest.  The above doesn't even need {get,put}_cpu(),
since it doesn't matter if there is a race in the update.

Since the locking of this one field shows up at a macro level, it would
be interesting if you took out the assignment completely, to see if this
shows further improvements, which would indicate we can still come up =
with
a better solution than the atomic you have proposed here.

Cheers, Andreas

> Footnotes:
> =
[1]https://github.com/dmonakhov/lmbench/blob/master/src/lat_fs_create_unli=
nk.c
>=20
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> fs/ext4/ext4.h   | 3 +--
> fs/ext4/ialloc.c | 4 +---
> fs/ext4/ioctl.c  | 6 ++----
> fs/ext4/super.c  | 8 ++++----
> 4 files changed, 8 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index e2abe01..6be1aa8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1392,8 +1392,7 @@ struct ext4_sb_info {
> 	int s_first_ino;
> 	unsigned int s_inode_readahead_blks;
> 	unsigned int s_inode_goal;
> -	spinlock_t s_next_gen_lock;
> -	u32 s_next_generation;
> +	atomic_t s_next_generation;
> 	u32 s_hash_seed[4];
> 	int s_def_hash_version;
> 	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not =
*/
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index ee82302..d12dabc 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1138,9 +1138,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> 			   inode->i_ino);
> 		goto out;
> 	}
> -	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation =3D sbi->s_next_generation++;
> -	spin_unlock(&sbi->s_next_gen_lock);
> +	inode->i_generation =3D =
atomic_inc_return(&sbi->s_next_generation);
>=20
> 	/* Precompute checksum seed for inode metadata */
> 	if (ext4_has_metadata_csum(sb)) {
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index afb66d4..7d8b1a5 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -157,10 +157,8 @@ static long swap_inode_boot_loader(struct =
super_block *sb,
>=20
> 	inode->i_ctime =3D inode_bl->i_ctime =3D current_time(inode);
>=20
> -	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation =3D sbi->s_next_generation++;
> -	inode_bl->i_generation =3D sbi->s_next_generation++;
> -	spin_unlock(&sbi->s_next_gen_lock);
> +	inode_bl->i_generation =3D atomic_add_return(2, =
&sbi->s_next_generation);
> +	inode->i_generation =3D inode_bl->i_generation -1;
>=20
> 	ext4_discard_preallocations(inode);
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b104096..bfc6d2e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3419,7 +3419,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	int err =3D 0;
> 	unsigned int journal_ioprio =3D DEFAULT_JOURNAL_IOPRIO;
> 	ext4_group_t first_not_zeroed;
> -
> +	u32 igen;
> +
> 	if ((data && !orig_data) || !sbi)
> 		goto out_free_base;
>=20
> @@ -3977,9 +3978,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	}
>=20
> 	sbi->s_gdb_count =3D db_count;
> -	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
> -	spin_lock_init(&sbi->s_next_gen_lock);
> -
> +	get_random_bytes(&igen, sizeof(u32));
> +	atomic_set(&sbi->s_next_generation, igen);
> 	setup_timer(&sbi->s_err_report, print_daily_error_info,
> 		(unsigned long) sb);
>=20
> --
> 1.8.3.1
>=20
>=20


Cheers, Andreas






--Apple-Mail=_4DC8544E-A927-4ED3-A7D6-3BF5528CE7BD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ6JF5pIg59Q01vtYRAt1FAKCrWajizBboYhLtZqRUUC4oSlpOeQCglxoV
f2dw7iriDLk1Z1XPqshZkXU=
=VjNg
-----END PGP SIGNATURE-----

--Apple-Mail=_4DC8544E-A927-4ED3-A7D6-3BF5528CE7BD--
