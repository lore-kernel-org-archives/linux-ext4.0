Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795093380;
	b=i6ERsiqRlKKQNvZuBrtUQs635PAiaW6zglxldyerbR4hlsK3OXEokF8zjdvCdMF7KVRx
	 t2XfOHNcAEorY6Vih05r36g33X58yv2cPdT+Ja4rYoQBr0psWPUsZesOmS1NFziAZvu96
	 tjLHT3Nf5qxcHA23U/qp4CBw2IjPbxSaWJT+EVjl9Tu+oc06IRFGkf3fnuwJxjW4Pemmh
	 iIbxbyeJQn2GgoeHmyYHlQbfTCYs6rt5/+AdXl6THkguqJEu5pDIhIrk0EnW5ZxkLasoN
	 qWkD7HORH+9vtoIlGjEiyQeUNK6g9uW24Ak4WhW6T3q8cGmklpadTs54X6jFvu5XCMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093380;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sRAoeGeTLWDsHkz/6UdDgfRLe/aGI5/TmbMcWf8L7bI=;
	b=35aiYix0uo0JEh9jxxp7TFaVgGNRaFnMGmiexl1Bh3hAnJClnovdNzHAbDwOcMTOzwcN
	 BAPDwiG5lDD1ZuEdzDNh2Pe2Hg2XADuecLyI2mFIoYqkui6oTKSshERSY7k8snrxiZTYV
	 eiHCS9+tEHmXnZPXZp+x1lEFX/gWHVQjS1MGkIHRz5v6zEMXVVadwKQIBA+hDQZ0aUF6g
	 LPNbwowYCwCMS40sf5xxdsBy2EaqnDHdRjioXB3xu0PJr6UD/FRktG/iSGS4hz1MGWEU4
	 /sDOoEsnPop13ZXGeuhJZNSoHbZxE60o9Ish77n3h5QqvFci/bZth7KiwAHiqecIYNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xzzss55K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99801606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 13:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xzzss55K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EFD1F000C5;
	Thu, 19 Nov 2026 13:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795093380;
	bh=sRAoeGeTLWDsHkz/6UdDgfRLe/aGI5/TmbMcWf8L7bI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xzzss55K4/+pVZPuOKTVG5QPFQk6aYVydDI+98xa2V/7UvdLUFaDvWqotQGBvMXZJ
	 LXZ4I+OhsnheD1/omtakxoS22TM1MrH3hhyNUPRrzslhMerVvyhzdZTuDOsEnBIi+O
	 CbacedWU/tto5lz/DyHAYBrIdfHdiYiBF9wvQ4EFQZrjon6g1UST6vVhhV1HmXx6qi
	 YgNVfQe09J3+Uo63Cdq+z8Ao75ojF8DwOLaNngoChDDwlvMdszMWn4yNJooNaWOAX5
	 LXJgC69cuf+e2vtFieOtMpbaHKMvjVD0VD2xBJclUecbxHiw5bPcR8a1y9JNG1gCpo
	 2kcTE+6WqfXZw==
Message-ID: <sashiko-outbox-223131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ext4: reject impossible group free cluster
 counts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261119122601.85293-3-zhaogongyi@bytedance.com>
References: <20261119122601.85293-1-zhaogongyi@bytedance.com>
 <20261119122601.85293-3-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:02:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] ext4: corrupt replayed superblock committed on error in
  ext4_load_journal()
- [Medium] ext4: early ext4_fc_replay_cleanup() in ext4_load_journal()
  before work flush
- [Medium] ext4: missing s_ea_inode_work flush in
  ext4_validate_replayed_metadata()
- [Medium] ext4: uninitialized sb->s_encoding when replay enables
  casefold feature
--

commit 8d754fdcbde13550773a9fc6bd6d91302151721b
Author: Zhao Gongyi <zhaogongyi@bytedance.com>

ext4: reject impossible group free cluster counts

This commit rejects group descriptor free-cluster counts that exceed the
group's cluster capacity and validates recovered superblock geometry and
group descriptors during journal and fast commit replay.

Link: https://lore.kernel.org/linux-ext4/20261102042428.65204-1-zhaogongyi@=
bytedance.com/

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 359f9d4ed4479..68c33a9542897 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c

[ ... ]

> @@ -4939,88 +4970,193 @@ static int ext4_check_geometry(struct super_bloc=
k *sb,

[ ... ]

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
> +		goto check_descriptors;
> +	}

[Severity: Medium]
Should ext4_validate_replayed_metadata() flush sbi->s_ea_inode_work before
jumping to check_descriptors when after_fast_commit is true?

When fast commit replay unlinks an inode that drops the last reference to an
EA inode, ext4_put_ea_inode() schedules sbi->s_ea_inode_work with a 1-jiffy
delay.  Without flushing that delayed work here, the bg_free_blocks_count
updates from freeing the EA inode's blocks run after descriptor validation =
has
already completed, and on a read-only mount requiring recovery the work runs
after ext4_load_journal() restores SB_RDONLY, hitting
WARN_ON_ONCE(sb_rdonly(sb)) and failing with -EROFS in
ext4_journal_check_start().

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

[Severity: Medium]
Can journal replay enable EXT4_FEATURE_INCOMPAT_CASEFOLD while leaving
sb->s_encoding NULL?

ext4_encoding_init() runs in __ext4_fill_super() before journal replay and
returns early if EXT4_FEATURE_INCOMPAT_CASEFOLD is not set in the unrecover=
ed
superblock.  If journal replay sets EXT4_FEATURE_INCOMPAT_CASEFOLD in
es->s_feature_incompat, ext4_validate_replayed_metadata() neither rejects t=
he
change nor initializes sb->s_encoding, so looking up or hashing any directo=
ry
with EXT4_CASEFOLD_FL causes a NULL pointer dereference of sb->s_encoding in
utf8_casefold() -> utf8nlookup().

[ ... ]

> @@ -6261,9 +6426,11 @@ static int ext4_load_journal(struct super_block *s=
b,
>  		 */
>  		if (enable_write)
>  			sb->s_flags &=3D ~SB_RDONLY;
> -		err =3D jbd2_journal_load(journal);
> +		err =3D jbd2_journal_load_with_callback(journal, callback, replay);
>  		if (enable_write)
>  			sb->s_flags |=3D SB_RDONLY;
> +		kfree(replay);
> +
>  		if (save && memcmp(((char *) es) + EXT4_S_ERR_START,
>  				   save, EXT4_S_ERR_LEN)) {
>  			memcpy(((char *) es) + EXT4_S_ERR_START,
> @@ -6285,6 +6452,7 @@ static int ext4_load_journal(struct super_block *sb,
>  	}

[Severity: Medium]
If jbd2_journal_load_with_callback() fails because
ext4_validate_replayed_metadata() rejected a corrupt replayed superblock in
es, does the error restoration block right below still write that corrupt
superblock to disk?

When the replayed superblock in sbi->s_sbh differs from the pre-replay save
buffer in EXT4_S_ERR_START..EXT4_S_ERR_END (or EXT4_ERROR_FS is set in
sbi->s_mount_state), changed is set to true even when err is non-zero, and
ext4_commit_super(sb) stamps a newly computed valid checksum onto the rejec=
ted
replayed superblock and commits it to disk.

>  	if (err) {
> +		ext4_fc_replay_cleanup(sb);
>  		ext4_msg(sb, KERN_ERR, "error loading journal");
>  		goto err_out;
>  	}

[Severity: Medium]
Does calling ext4_fc_replay_cleanup(sb) here clear EXT4_FC_REPLAY before
failed_mount3a in __ext4_fill_super() flushes sbi->s_ea_inode_work?

In __ext4_fill_super(), failed_mount3a calls
flush_delayed_work(&sbi->s_ea_inode_work) right before
ext4_fc_replay_cleanup(sb) so that any EA inode evictions queued during fast
commit replay run while EXT4_FC_REPLAY is still set.  Clearing EXT4_FC_REPL=
AY
early in ext4_load_journal() causes those flushed evictions to run in normal
non-replay mode while sbi->s_group_info is still NULL (before ext4_mb_init(=
)),
so ext4_free_inode() sees ext4_get_group_info() =3D=3D NULL and triggers
ext4_std_error(sb, -EFSCORRUPTED).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119122601.8529=
3-1-zhaogongyi@bytedance.com?part=3D2
