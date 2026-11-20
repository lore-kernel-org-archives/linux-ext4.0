Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795144993;
	b=MiwM5oxqXopt3mVGxJMj1ASvFii5x2gSdAs3ui2XOmWrwaG/4hcZyAwpnSzht8LfXPQE
	 7LN65CMq64TNVKJVWGvJ8rq5oV1ZeJyshwKZQ0y0HsHe3W8TEN62NyjRqtkJy1sYWtYG7
	 Vx26yL/yX5QwTi5TYgXXDqcwbGmBIGofRsgQLDjLaWR+FkB+ppvNjsy86oyFAF4AgRS4G
	 Vs5BRK/yI6pFuzlSG46KdUGm4iDPYJJU6IzURVpeTOuT0BWRxBnmsGSvNQ4bU0fxSY18q
	 xyKRKO614+p619laqdVUWPIfSNXhEWaU5fngcKWJxnjPPzak0l5LcXeiiJC5KHttXDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795144993;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wbzlaBeGmc7sLO1Yzfhmnx2syQeijGdran4XCn1fiQU=;
	b=V0MhVDn3lDlPbfFrSvBPIAFXkQB5nTIFZ0wnWSj2VYDdIZra4Pg9O38P3aqc9JITgWhw
	 U7Uc+Co/hHZswUyDGug/d9luKmvVqdkCjMnSNl/ecrhMhxgawVKuxIEAwJWrmsNI9mEFV
	 hUcM5l3uY2PHEdymp35rQoODfghqjdI7/5J/uvCiM4I6tlOS2aS+aA90I/Jx1G8xc7bSU
	 FEoP9mxT2ICWcipKBS1LBGA+OmxEVikJLE8oB0PeavEGl2NW6wwmXvqRGCrALy0UJ/lJh
	 rCmhUi5LlGOBYef/7V96VzPSbTdSY+x63qfsDIQ+pOHImVkNmfZXMSjW4Wng7xbbqbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JSuIZaPp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4961606A330
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 03:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JSuIZaPp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1216A1F000CF;
	Fri, 20 Nov 2026 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795144993;
	bh=wbzlaBeGmc7sLO1Yzfhmnx2syQeijGdran4XCn1fiQU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JSuIZaPpzPjq8sGqvWo65o6G0oupe953aOB3p2bQfUV+5GfJI80m88HgQLsRWBAJk
	 XKun4UNaMMxOE9i2dxhVumJAXTBJs+Do4Y24K4OHtvhVTMRhn8WmyplqNGCXA40djQ
	 f4zhd4XEGRD6SVk9CGPLXWNaBUN6p7sHhcej/GRTYC3B23MtAxS8lglKeQlO2VFVZ7
	 VgOF3ieJ/nN7useLfdKbEwCL06BvwJSS7IYFARimDnNRr3hSFU7qKdg3/stEoLvOYx
	 Az5qH5JnjICtCY7JeAJxMbXniwY8fDFKJJNCvvZ6rrwjtM5ELFHuceVxyf32hctEGv
	 BqCsTaO053iTg==
Message-ID: <sashiko-outbox-224402@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] ext4: reject impossible group free cluster
 counts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261120025459.70290-3-zhaogongyi@bytedance.com>
References: <20261120025459.70290-3-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 03:23:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext4: missing superblock checks in
  ext4_validate_replayed_metadata()
--

commit 74564af214213946c8db9db48f043911b396d215
Author: Zhao Gongyi <zhaogongyi@bytedance.com>

ext4: reject impossible group free cluster counts

This commit rejects group descriptor free cluster counts that exceed a
group's capacity and validates replayed superblock and group descriptor
metadata during journal recovery.

Link: https://lore.kernel.org/linux-ext4/20261102042428.65204-1-zhaogongyi@=
bytedance.com/
Link: https://lore.kernel.org/linux-ext4/sashiko-outbox-223131@kernel.org/

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 359f9d4ed4479..45d6f39bc3f18 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c

[ ... ]

> @@ -4939,88 +4970,204 @@ static int ext4_check_geometry(struct super_bloc=
k *sb,
> +static int ext4_validate_replayed_metadata(journal_t *journal, void *dat=
a,
> +					   bool after_fast_commit)
> +{
> +	struct ext4_replay_callback_data *replay =3D data;
> +	struct super_block *sb =3D journal->j_private;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_super_block *es =3D sbi->s_es;
> +	struct ext4_super_block *old =3D &replay->super;
> +	ext4_fsblk_t sb_block =3D sbi->s_sbh->b_blocknr;
> +	ext4_group_t groups_count;
> +	unsigned int inode_size, first_ino;
> +	u32 incompat, ro_compat;
> +	int err;
> +
> +	/* Fast commits only change descriptor contents, such as counts. */
> +	if (after_fast_commit) {
> +		if (!(sbi->s_mount_state & EXT4_FC_REPLAY))
> +			return 0;
> +		/* Deferred EA inode eviction can change group free counts. */
> +		flush_delayed_work(&sbi->s_ea_inode_work);
> +		goto check_descriptors;
> +	}
> +
> +	incompat =3D le32_to_cpu(es->s_feature_incompat ^ old->s_feature_incomp=
at);
> +	ro_compat =3D le32_to_cpu(es->s_feature_ro_compat ^ old->s_feature_ro_c=
ompat);
> +	if (es->s_rev_level =3D=3D cpu_to_le32(EXT4_GOOD_OLD_REV)) {
> +		inode_size =3D EXT4_GOOD_OLD_INODE_SIZE;
> +		first_ino =3D EXT4_GOOD_OLD_FIRST_INO;
> +	} else {
> +		inode_size =3D le16_to_cpu(es->s_inode_size);
> +		first_ino =3D le32_to_cpu(es->s_first_ino);
> +	}
> +
> +	/* Online resize can grow the filesystem without changing group units. =
*/
> +	if (es->s_magic !=3D old->s_magic ||
> +	    es->s_log_block_size !=3D old->s_log_block_size ||
> +	    es->s_log_cluster_size !=3D old->s_log_cluster_size ||
> +	    es->s_blocks_per_group !=3D old->s_blocks_per_group ||
> +	    es->s_clusters_per_group !=3D old->s_clusters_per_group ||
> +	    es->s_inodes_per_group !=3D old->s_inodes_per_group ||
> +	    es->s_first_data_block !=3D old->s_first_data_block ||
> +	    inode_size !=3D sbi->s_inode_size || first_ino !=3D sbi->s_first_in=
o ||
> +	    es->s_desc_size !=3D old->s_desc_size ||
> +	    es->s_log_groups_per_flex !=3D old->s_log_groups_per_flex ||
> +	    ext4_blocks_count(es) < ext4_blocks_count(old) ||
> +	    (incompat & (EXT4_FEATURE_INCOMPAT_64BIT |
> +			 EXT4_FEATURE_INCOMPAT_FLEX_BG)) ||
> +	    (ro_compat & (EXT4_FEATURE_RO_COMPAT_BIGALLOC |
> +			  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
> +			  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
> +			  EXT4_FEATURE_RO_COMPAT_READONLY))) {
> +		ext4_msg(sb, KERN_ERR, "invalid filesystem geometry after journal repl=
ay");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/* An unreplayed superblock can contain mount-time hash flags. */
> +	if (memcmp(es, old, sizeof(*es)) &&
> +	    (!ext4_verify_csum_type(sb, es) ||
> +	     !ext4_superblock_csum_verify(sb, es))) {
> +		ext4_msg(sb, KERN_ERR, "invalid superblock checksum after journal repl=
ay");
> +		return -EFSBADCRC;
> +	}
> +
> +	if (ext4_has_feature_metadata_csum(sb) &&
> +	    sbi->s_csum_seed !=3D (ext4_has_feature_csum_seed(sb) ?
> +		le32_to_cpu(es->s_checksum_seed) :
> +		ext4_chksum(~0, es->s_uuid, sizeof(es->s_uuid)))) {
> +		ext4_msg(sb, KERN_ERR, "metadata checksum seed changed during journal =
replay");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/* The VFS encoding was initialized before replay. */
> +	if ((incompat & EXT4_FEATURE_INCOMPAT_CASEFOLD) ||
> +	    (ext4_has_feature_casefold(sb) &&
> +	     (es->s_encoding !=3D old->s_encoding ||
> +	      es->s_encoding_flags !=3D old->s_encoding_flags))) {
> +		ext4_msg(sb, KERN_ERR, "casefold settings changed during journal repla=
y");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (!ext4_feature_set_ok(sb, replay->readonly))
> +		return -EINVAL;
> +
> +	err =3D ext4_check_geometry(sb, es, &groups_count);
> +	if (err)
> +		return err;

[Severity: Medium]
Can a replayed superblock bypass pre-replay checks on fields and features
that ext4_validate_replayed_metadata() does not re-verify?

If journal replay clears EXT4_FEATURE_COMPAT_HAS_JOURNAL in es,
ext4_validate_replayed_metadata() succeeds and JBD2 resets the journal,
after which ext4_load_journal() -> ext4_clear_journal_err() calls
ext4_error() (committing the corrupt superblock and panicking when
ERRORS_PANIC is enabled).

Similarly, es->s_min_extra_isize and es->s_want_extra_isize are only
checked against sbi->s_inode_size in ext4_inode_info_init() before replay,
so a replayed s_min_extra_isize larger than s_inode_size -
EXT4_GOOD_OLD_INODE_SIZE will later cause ext4_expand_extra_isize_ea() to
shift in-inode xattrs past the end of the raw inode.

In addition, sbi->s_csum_seed is only checked when
ext4_has_feature_metadata_csum(sb) is set, even though
ext4_init_metadata_csum() also initializes it for EA_INODE and CSUM_SEED,
and changes to features or fields validated before replay (such as
ENCRYPT, INLINE_DATA, HUGE_FILE, s_encryption_level, and s_creator_os) are
not rejected here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120025459.7029=
0-1-zhaogongyi@bytedance.com?part=3D2
