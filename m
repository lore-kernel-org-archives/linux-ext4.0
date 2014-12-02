From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/4] ext4: fix potential use after free during resize V2
Date: Tue, 02 Dec 2014 14:12:45 +0300
Message-ID: <874mtel2z6.fsf@openvz.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57552 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaLBLNS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2014 06:13:18 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so16699810wgh.17
        for <linux-ext4@vger.kernel.org>; Tue, 02 Dec 2014 03:13:16 -0800 (PST)
In-Reply-To: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> We need some sort of synchronization while updating ->s_group_desc
> because there are a lot of users which can access old ->s_group_desc
> array after it was released.
This patch supersedes V1 (commit from tytso.git/dev : 6e77765ea74a18a8bbd)
Patch-set was tested via xfstests-bld -c inline_data -g auto, but
w/o metadata_csum feature because it triggers another csum related bug which
should be fixed separately.
>
> changes from V1:
>   - use RCU instead seqcount
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/balloc.c |   12 ++++++++----
>  fs/ext4/resize.c |    6 ++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 83a6f49..2d0a0de 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -282,6 +282,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct s=
uper_block *sb,
>  	unsigned int offset;
>  	ext4_group_t ngroups =3D ext4_get_groups_count(sb);
>  	struct ext4_group_desc *desc;
> +	struct buffer_head *gd_bh;
>  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>=20=20
>  	if (block_group >=3D ngroups) {
> @@ -293,7 +294,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct =
super_block *sb,
>=20=20
>  	group_desc =3D block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
>  	offset =3D block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
> -	if (!sbi->s_group_desc[group_desc]) {
> +	rcu_read_lock();
> +	gd_bh =3D *rcu_dereference(sbi->s_group_desc) + group_desc;
> +	rcu_read_unlock();
> +	if (!gd_bh) {
>  		ext4_error(sb, "Group descriptor not loaded - "
>  			   "block_group =3D %u, group_desc =3D %u, desc =3D %u",
>  			   block_group, group_desc, offset);
> @@ -301,10 +305,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct=
 super_block *sb,
>  	}
>=20=20
>  	desc =3D (struct ext4_group_desc *)(
> -		(__u8 *)sbi->s_group_desc[group_desc]->b_data +
> -		offset * EXT4_DESC_SIZE(sb));
> +		(__u8 *)gd_bh->b_data + offset * EXT4_DESC_SIZE(sb));
>  	if (bh)
> -		*bh =3D sbi->s_group_desc[group_desc];
> +		*bh =3D gd_bh;
> +
>  	return desc;
>  }
>=20=20
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index bf76f40..08c2256 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -854,8 +854,9 @@ static int add_new_gdb(handle_t *handle, struct inode=
 *inode,
>  	memcpy(n_group_desc, o_group_desc,
>  	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
>  	n_group_desc[gdb_num] =3D gdb_bh;
> -	EXT4_SB(sb)->s_group_desc =3D n_group_desc;
>  	EXT4_SB(sb)->s_gdb_count++;
> +	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
> +	synchronize_rcu();
>  	kvfree(o_group_desc);
>=20=20
>  	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
> @@ -907,8 +908,9 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
>  	memcpy(n_group_desc, o_group_desc,
>  	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
>  	n_group_desc[gdb_num] =3D gdb_bh;
> -	EXT4_SB(sb)->s_group_desc =3D n_group_desc;
>  	EXT4_SB(sb)->s_gdb_count++;
> +	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
> +	synchronize_rcu();
>  	kvfree(o_group_desc);
>  	BUFFER_TRACE(gdb_bh, "get_write_access");
>  	err =3D ext4_journal_get_write_access(handle, gdb_bh);
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUfZ6uAAoJELhyPTmIL6kBgIcH+QH3++ED2LvXx0dvXwOylmtc
FcwBe2OeKncevRM5achj0IrKGMPaiuCvItX0/4OHjcwpHfwc/R6SKKktdD0Dj17n
R8KVdZBD4KJ2OLliYUL38JwjokfqGEh6t55xbJgjyEDVQ7sn7dM8+BQFL7XDUrrP
M2nCjPB1KlYGZ+Rz3N8CBriMvGPKmCz6zKMzNGmXZu39T3zKS8OYld6h3ByqKyDc
dotmUzRXXduhq2wDmXiMuCnWri9x9yePSNqCtlxyeL5UAGSaH89c6dlPt+DTECL0
LanlPsBkwytM28qgbliKRkyNNsylb7tzbXe89/gM0TVtdkOoc1/O9I+pkEQLDQk=
=IIKQ
-----END PGP SIGNATURE-----
--=-=-=--
