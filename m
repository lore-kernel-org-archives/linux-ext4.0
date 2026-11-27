Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795810816;
	b=AhoLDKSJ+AM8RqMDWcEMiDeR8AqyIut2LRtSO3WBafDZzLS2s5+hooN1McG/QeZXQ+Ev
	 NUIN1vxwbbmDItqEhhPxp30agGA4BR7vtmwNCaYwxpYITn413ihxBOcEqJ145NnfUjJZU
	 AL3ZzBo6If7QULPm2CNpxTFz2Fh0KU/JbBnkTh2o2ZL4gO1Tf2SwY9Twr2nHHQMQp+7Vd
	 58klwQAR/+E98Uf0xG0H6/aOIDKiKmYDGFjDruIGf+pzm/HuIKHPiVRtQq7+aPSXS7aO8
	 EWFzjQSybKiYdUfITUkFLnxEWIam2KsuCxsoiVB3gCdF63hSkuZbl7th7IT/sOtWIhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795810816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0Ctr5GIqVTqbZAp/zx03x8mhcxD5c8TFIK+EBqlx81E=;
	b=yLyl3lqQTYk6Y1FMnsXMeVkHb2YXp3Dtpaee9WtA+iuIx7RBAsxOt6+D3hyARWNTx5hV
	 4A586Dj28kfTjy5h0mmCc2xrF14MUaNfuDzSNup8NzKBEguTpGQQg+B2z6caYGpkwZfGb
	 qQuY2xjsOYxNgeoUDlDem4rTLIxmjpSTXTLZAMOHAqi+zSxdsZvKY/D3GawAQWbANdFzp
	 UtKIAVjse7/oHscn1BJlABxuMafFeXnRlR4W2W05IBhF8Xsk0NTK6PWVQV2VBta6BGzx9
	 ONFuzPgquidC9Wl6rJFr1vaINOwGzbNm2lrF9YeUvDsnoyimvIbEGghAWt5chQ2zxBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7qkqrZh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A4E606A31E
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 20:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7qkqrZh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935081F00893;
	Fri, 27 Nov 2026 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810815;
	bh=0Ctr5GIqVTqbZAp/zx03x8mhcxD5c8TFIK+EBqlx81E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I7qkqrZhg3mBWTpyEXaUfQFYMF1cyuEE7c+ZJd18dcrE98UibR96pvFAIBmswQBlf
	 YBFTZ2xxWLYtF+cpYoVBn+RBH3DKg7fY/E5qnT+0q2BVu9q8TayLZWvoa3p9jhptdd
	 2Ap5W2m7njmsybmKpkOoJqe9il05u3cEcMaeNKAqJZ0ufGopsfnDS36oDLGW64c7kL
	 EBcYYI+VfSHzwxT/h5LBfYcEAWla3LaN2s6nQJF//LM/iOaW6dWt2RjNNPBHZUuY5o
	 ldMVDDUhst6uybzeoexvyMDGZ2/C8zv3dfyG9B0d+esdpkVXaVOn9/9KMyJ152xLWT
	 kN0xZwYloNfdA==
Message-ID: <sashiko-outbox-238228@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/13] ext4: re-enable zeroout fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-13-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-13-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 20:20:14 +0000
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
- [Medium] ext4: extent status conflict warning in
  ext4_split_convert_extents()
- [Medium] ext4: unmerged CONVERT_PENDING entries defeat zeroout in
  endio conversion
--

commit 675f4feafaf06eedfd7ad9cbdb682ca8af60a9aa
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: re-enable zeroout fallback

This commit removes the unconditional goto in ext4_split_extent() to
re-enable the zeroout fallback path when splitting an extent fails with
-ENOSPC, -EDQUOT or -ENOMEM.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5130416aa8b43..df3085f2fc446 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3567,9 +3567,6 @@ static struct ext4_ext_path *ext4_split_extent(hand=
le_t *handle,
>  	if (orig_err !=3D -ENOSPC && orig_err !=3D -EDQUOT && orig_err !=3D -EN=
OMEM)
>  		goto out_orig_err;
> =20
> -	/* zeroout fallback disabled: always return the original err */
> -	goto out_orig_err;
> -
>  	/* we can't zeroout? just return the original err */
>  	if (!(split_flag & EXT4_EXT_MAY_ZEROOUT))
>  		goto out_orig_err;

[Severity: Medium]
Can re-enabling the zeroout fallback trigger an extent status cache
conflict warning in ext4_es_cache_extent() when
ext4_split_convert_extents() is called without EXT4_EX_NOCACHE?

When ext4_split_extent() falls back to ext4_split_extent_zeroout() for
EXT4_GET_BLOCKS_CONVERT, ext4_split_extent_zeroout() marks the entire
on-disk extent initialized with ext4_ext_mark_initialized(ex), but only
inserts EXTENT_STATUS_WRITTEN into the extent status tree for the zeroed
prefix and suffix ranges:

fs/ext4/extents.c:ext4_split_extent_zeroout() {
	...
	ext4_ext_mark_initialized(ex);

	for (i =3D 0; i < nr_zeroed; i++)
		ext4_es_insert_extent(inode, zeroed[i].lblk, zeroed[i].len,
				      zeroed[i].pblk, EXTENT_STATUS_WRITTEN,
				      false);
	...
}

Because the failed ext4_split_extent_at() call leaves the original
unwritten entry in i_es_tree, the target map subrange remains
EXTENT_STATUS_UNWRITTEN.  When ext4_split_extent() returns to
ext4_split_convert_extents() with did_zeroout set, the convert label runs
ext4_find_extent(inode, map->m_lblk, path, flags) using the caller's flags
(where EXT4_EX_NOCACHE is not set, unlike the local copy in
ext4_split_extent()) before updating i_es_tree:

fs/ext4/extents.c:ext4_split_convert_extents() {
	...
convert:
	path =3D ext4_find_extent(inode, map->m_lblk, path, flags);
	if (IS_ERR(path))
		return path;
	...
	/* Lets update the extent status tree after conversion */
	if (!(flags & EXT4_EX_NOCACHE))
		ext4_es_insert_extent(inode, le32_to_cpu(ex->ee_block),
	...
}

On an inline extent tree (or unverified leaf block), ext4_find_extent()
calls ext4_cache_extents() -> ext4_es_cache_extent() with
EXTENT_STATUS_WRITTEN for the full on-disk extent while the mapped subrange
in i_es_tree is still EXTENT_STATUS_UNWRITTEN, triggering
ext4_warning_inode() ("ES cache extent failed: add [...] conflict with
existing [...]").

Passing EXT4_EX_NOCACHE to ext4_find_extent() in
ext4_split_convert_extents() (or skipping the lookup and full-extent status
insertion when did_zeroout is true and instead inserting only the mapped
range in ext4_split_extent_zeroout()) would avoid this conflict.

[Severity: Medium]
Can adjacent unmerged EXTENT_STATUS_CONVERT_PENDING entries in the same
unwritten extent cause ext4_split_extent_zeroout() to reject the zeroout
fallback with -EINVAL during endio conversion?

In ext4_es_can_be_merged(), EXTENT_STATUS_CONVERT_PENDING entries are never
merged with adjacent EXTENT_STATUS_CONVERT_PENDING entries.  When an I/O
completion range passed to ext4_convert_unwritten_extents() spans two
adjacent EXTENT_STATUS_CONVERT_PENDING entries inside the same on-disk
unwritten extent (for example, after ext4_iomap_end_io() merges adjacent
completed ioends via iomap_ioend_try_merge()), ext4_map_blocks() looks up
only the first entry and clamps map->m_len to its length:

fs/ext4/inode.c:ext4_map_blocks() {
	...
	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es)) {
		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
			...
			retval =3D es.es_len - (map->m_lblk - es.es_lblk);
			if (retval > map->m_len)
				retval =3D map->m_len;
			map->m_len =3D retval;
	...
}

If splitting the on-disk extent at the boundary between the two entries
then fails with -ENOSPC, ext4_split_extent_zeroout() scans [map_end,
ex_end) for ext4_es_is_convert_pending, hits the second
EXTENT_STATUS_CONVERT_PENDING entry waiting for the next iteration of
ext4_convert_unwritten_extents(), and returns -EINVAL:

fs/ext4/extents.c:ext4_split_extent_zeroout() {
	...
	/* Check right side */
	lblk =3D map_end;
	len =3D ex_end > map_end ? ex_end - map_end : 0;
	if (len > 0 && ext4_es_scan_range(inode, &ext4_es_is_convert_pending,
					  lblk, lblk + len - 1))
		return -EINVAL;
	...
}

That aborts the zeroout fallback and fails the endio conversion with
-ENOSPC.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D13
