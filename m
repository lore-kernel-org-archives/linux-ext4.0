Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795807971;
	b=5LlJb8hoLdWWXYiUXh0L8ZcSiJxKkMho2PYM5GSxwOMgTZ3nIakAJXNZrPn07kz48Adi
	 heP5d09udZpm1iogEGVhJtBoFT6wsezHiFvptCtbaPm6abyzqZxZtD/WfQSPGBR0EdEv0
	 cXT2aRlEUHWTbcugN5TscoXG5PurbDaOg/enax9DiiGBxCq1ht6Ywye/EgkXgZmmcq4tg
	 G7/lFni6AQV6381UoodfGEgjH2Q5Mi3RxkTODYIJAQPamYrJglAKyEzmZ5hjRINjqxglG
	 elbJ6XIeOFHiycoyrRTQrJS3tx7LfzGg1BkYsdgdwfZuXv+SAFLYVF9kh5vyM6+aQJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795807971;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CnKfcNv3N/qb0trezbkpxynoQzoPb8JbNUGqJweF2CQ=;
	b=Xex0TvHfNH501eb4KDrW7+f6cfm5HqXMutsUPQG8yhikvusz+kOriXh1Qi6Z4G3eDV0h
	 gourU/oozACrHNcAdIcpG1Y5awu/jOU3BqePpGNawT5Urd+LPfLu4qAXPeu+ByYewjd4k
	 +juW/7tNH0P++5x6uZ/lgZ0lxQbX8rs3k8fE4/7Tmw8BXGDANd4zHNlKVgTChJZTafP5b
	 EzOb2raT7UnShd1GD3AhbVoe1gq21LqW9ZOJgIj3eaDFUvAo2qDfeu8MqiD4Tz9Pkq4/J
	 4wIk8h0azVDweBv3Lmt/B81r9kNfasvH0Od8FL+TZI2rZJy1EIz/aNN1sphAuXpa3OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hMqmVRfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9103606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 19:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hMqmVRfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45171F00897;
	Fri, 27 Nov 2026 19:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795807970;
	bh=CnKfcNv3N/qb0trezbkpxynoQzoPb8JbNUGqJweF2CQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hMqmVRfcydi7+fDHfzpYc/pnhXisz6tpWNreqzWvtK+9c+H0KchDRJibzZmnfitxW
	 uTT+Sv9a57+lZ+opw+UEEMfItnbV6VlYKsWCpoVcU5Chybtt7v+vuTyEwQ4WIo0FuG
	 BFCC7ELIms4I7P7yXA1UiSR+epZaUWSQlQi9fKaCfKOnLClWIAQ13fHcxfMiZ/pLD/
	 4mkk7zQ0ipzluMu3CN5pvyEiuDWupp3TdMAC8F0nstVh9naG9IYJXGy/BxscNHnXc5
	 BjxfAgBL9skC3Y85SJCqOh2434NfJVFlX52z8g5wGISGfz9WF7fBycEy31HhXQhM33
	 OLENGoOrbvQCg==
Message-ID: <sashiko-outbox-238163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/13] ext4: update extent status cache when zeroing
 extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-11-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-11-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 19:32:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] ext4: premature extent status update before ext4_ext_dirty()
- [Medium] ext4: partial ES update in ext4_split_extent_zeroout() causes
  cache conflict
--

commit 0cf9a9536a99953085924a6638817aafc21bee09
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: update extent status cache when zeroing extents

This commit records zeroed sub-ranges during the extent split zeroout
fallback and inserts them as written into the extent status tree once the
extent is marked initialized.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0f5d9f3c42a9b..e8ebc518e58ba 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3341,8 +3341,15 @@ static int ext4_split_extent_zeroout(handle_t *han=
dle, struct inode *inode,
>  	ext4_lblk_t ee_block;
>  	uint64_t lblk, pblk, len;
>  	int is_unwrit;
> -	int err =3D 0;
> +	int err =3D 0, i, nr_zeroed =3D 0;
>  	loff_t map_end, ex_end;
> +	/*
> +	 * zeroed[] is used to record ranges successfully zeroed so only these
> +	 * can be added to the cache
> +	 */
> +	struct {
> +		uint64_t lblk, len, pblk;
> +	} zeroed[2];

[ ... ]

> @@ -3450,6 +3469,11 @@ static int ext4_split_extent_zeroout(handle_t *han=
dle, struct inode *inode,
> =20
>  	ext4_ext_mark_initialized(ex);
> =20
> +	for (i =3D 0; i < nr_zeroed; i++)
> +		ext4_es_insert_extent(inode, zeroed[i].lblk, zeroed[i].len,
> +				      zeroed[i].pblk, EXTENT_STATUS_WRITTEN,
> +				      false);

[Severity: Medium]
Can updating only the zeroed[] sub-ranges in i_es_tree cause a cache
conflict when ext4_split_convert_extents() re-reads the extent?

ext4_ext_mark_initialized(ex) initializes the entire on-disk extent,
while the mapped sub-range [map->m_lblk, map->m_lblk + map->m_len) stays
unwritten in i_es_tree until the end of ext4_split_convert_extents().
Once commit "ext4: don't drop the extents in case extent split fails"
and commit "ext4: re-enable zeroout fallback" in this series keep the
extent in i_es_tree across a failed split, a caller without
EXT4_EX_NOCACHE (such as ext4_ext_convert_to_initialized()) on a
depth =3D=3D 0 inode hits ext4_find_extent() -> ext4_cache_extents() ->
ext4_es_cache_extent() at the convert label before i_es_tree is updated
for the full extent:

fs/ext4/extents.c:ext4_split_convert_extents() {
    ...
convert:
	path =3D ext4_find_extent(inode, map->m_lblk, path, flags);
	if (IS_ERR(path))
		return path;
    ...
	if (!(flags & EXT4_EX_NOCACHE))
		ext4_es_insert_extent(inode, le32_to_cpu(ex->ee_block),
				      ext4_ext_get_actual_len(ex),
				      ext4_ext_pblock(ex),
				      ext4_ext_is_unwritten(ex) ?
					      EXTENT_STATUS_UNWRITTEN :
					      EXTENT_STATUS_WRITTEN,
				      false);
}

Caching the newly initialized on-disk extent conflicts with the still
unwritten mapped sub-range in i_es_tree and triggers an
"ES cache extent failed" warning via ext4_warning_inode().

> +
>  	err =3D ext4_ext_dirty(handle, inode, path + depth);
>  	if (err)
>  		return err;

[Severity: Medium]
Should the ext4_es_insert_extent() loop run after ext4_ext_dirty()
succeeds?

If ext4_ext_dirty() fails, zeroed[] has already been marked
EXTENT_STATUS_WRITTEN in i_es_tree even though the zeroout fallback
aborts.  In addition, when depth > 0, ext4_ext_get_access() clears
BH_Verified on path[depth].p_bh and ext4_ext_mark_initialized(ex) mutates
ex->ee_len before ext4_ext_dirty() recomputes the extent block checksum
and restores BH_Verified.  With ES_AGGRESSIVE_TEST enabled,
ext4_es_insert_extent() -> ext4_es_insert_extent_ext_check() ->
ext4_find_extent() re-reads the unverified leaf block with a stale
checksum and triggers a false -EFSBADCRC filesystem error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D11
