Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799978;
	b=jkF28f11KfzqnH0wTdlpWcZcsmmwBnvbmnDuLsxgbrDmfrnouZGQXKoSsSRv2ZRARmai
	 34MB5PhnUsmzzMe6zEQWHisv3SLKD/CInt+Ql3s+Ox821Xw6EViXiHqpP8nknLSvd78Ty
	 sKHAr2NeZ7qI20lNBOfSMcUhE74YiCbabjSgxcnaAHFCVESPADoiGxdaZYW43nrW5A7+u
	 DGAj/gzpqsFEjwQU2/tsVwwXs8D9eGIwRoX5sx4E1mxa5Qc+L0QD3EzrnCIKmHMycuTd5
	 rlX6nW6HH9y/WC84ERhVSIM/nNyWAyMmtlNyKftj8c2G5JIB7pgdHOm2W87NmDKd28Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799978;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2imsxU8A0KS70NGKz0S13KD51yfp5zQ6UmqseGmAIog=;
	b=Ocga46bsLz0xqFKU2qbtUxGggpkttAxfWoTzXP0Xe/LSKA6PA2B3kvE640uasJzjmhvZ
	 XvUech6IfHDEWYYbv6huzpjhEJnCEptHMRgQO10ju43+AveTQS9nMmhwMYk1Yl0VkBvfI
	 KtXAhkunmvtV7mipaTyTLsovHCFm/zgEaGtn6IGOEipI2CUe9RPlU9MvPPZDbWgD+gxig
	 lbp5LZ7H58OMQCytTCMMxc69XSNrWkxRzaDYMcj9+oyNIzA0oCKm611lNSNXbSctaXq80
	 REc/VKvlpyh7VD6FtjVcB7kOkQL6lvAVq3L2UJo3zBr9X0go3WWoMqxrRy9+VWtlYRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyEgzwgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22569606A321
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyEgzwgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54541F0089F;
	Fri, 27 Nov 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795799977;
	bh=2imsxU8A0KS70NGKz0S13KD51yfp5zQ6UmqseGmAIog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XyEgzwgJCIHG7dhqK5+s+mXxasz0yG4/2/Qrt1A9bgjLjo/T6Wi7wyjpYU/Rbzf4F
	 nNECLyLBsI3U+QnAhD1UddRrmzQFcnOKRYkNXRD5zQPTTCTSFtLv5sn2/8dXxdsVlm
	 Y4klyJx/H0HurB0c51EX20shg2tywY5LZxAdiXQsDOW/1Xzc/1dkN1SR2esrCsoAE+
	 NvXvEBJzJd6Ng2/IsCJB7hi3jQrEIaY2itfvtVURu2tuBa08rq4qbSBek4dafU7Oja
	 RTPW5onHVRp8/1aSM7eExm1Pyz2J0xr82Cm9JIQ+i5oMjUpETvQzAMOWgGDcTo4fPN
	 KjyoC8Vmk13Aw==
Message-ID: <sashiko-outbox-237982@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/13] ext4: add support to track convert pending
 ranges in ext4_map_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-5-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-5-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 17:19:37 +0000
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
- [Medium] ext4: double delalloc reservation update on retry in
  __ext4_es_insert_extent()
- [Medium] ext4: ext4_map_blocks() clamping on CONVERT_PENDING splits
  ioend and atomic IO
--

commit f21d7f26169cb4b1b89944929ad98cc0819cca34
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: add support to track convert pending ranges in ext4_map_blocks()

This commit adds the EXT4_GET_BLOCKS_CONVERT_PENDING flag so that
ext4_map_blocks() and ext4_map_create_blocks() can mark unwritten ranges
in the extent status tree as EXTENT_STATUS_CONVERT_PENDING before I/O
submission.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f7fc5fb7e8197..3e4c0e1396ab1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -750,6 +750,9 @@ int ext4_map_create_blocks(handle_t *handle, struct i=
node *inode,
> =20
>  	status =3D map->m_flags & EXT4_MAP_UNWRITTEN ?
>  			EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
> +	if (status =3D=3D EXTENT_STATUS_UNWRITTEN &&
> +	    flags & EXT4_GET_BLOCKS_CONVERT_PENDING)
> +		status =3D EXTENT_STATUS_CONVERT_PENDING;
>  	ext4_es_insert_extent(inode, map->m_lblk, map->m_len, map->m_pblk,
>  			      status, flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE);
>  	map->m_seq =3D READ_ONCE(EXT4_I(inode)->i_es_seq);

[Severity: Medium]
Can passing EXTENT_STATUS_CONVERT_PENDING to ext4_es_insert_extent() cause
__ext4_es_insert_extent() to deduct delayed allocation reservations twice
when __es_insert_extent() retries after -ENOMEM?

Previously, ext4_es_insert_extent() only inserted WRITTEN or UNWRITTEN
extents, for which ext4_es_must_keep() is false, so an -ENOMEM from
__es_insert_extent() was cleared to 0.  Because ext4_es_must_keep() is
true for EXTENT_STATUS_CONVERT_PENDING, an initial GFP_ATOMIC failure in
__es_insert_extent() after __es_remove_extent() has already removed the
delayed extent (setting resv_used > 0) jumps to error:

fs/ext4/extents_status.c:__ext4_es_insert_extent() {
    ...
	err2 =3D __es_insert_extent(inode, &newes, es2);
	if (err2 =3D=3D -ENOMEM && !ext4_es_must_keep(&newes))
		err2 =3D 0;
	if (err2 !=3D 0)
		goto error;
    ...
error:
	write_unlock(&EXT4_I(inode)->i_es_lock);
	resv_used +=3D pending;
	if (resv_used)
		ext4_da_update_reserve_space(inode, resv_used,
					     delalloc_reserve_used);

	if (err1 || err2 || err3 < 0)
		goto retry;
}

Because resv_used and pending are initialized outside the retry loop and
__es_remove_extent() returns early on the retry pass without modifying
resv_used when no extents remain in the range, the second pass calls
ext4_da_update_reserve_space() again with the same resv_used count.  This
underflows i_reserved_data_blocks, triggers a WARN_ON(1) in
ext4_da_update_reserve_space(), and corrupts delalloc block and quota
accounting.

> @@ -911,8 +914,17 @@ int ext4_map_blocks(handle_t *handle, struct inode *=
inode,
>  	}
> =20
>  	/* If it is only a block(s) look up */
> -	if ((flags & EXT4_GET_BLOCKS_CREATE) =3D=3D 0)
> +	if ((flags & EXT4_GET_BLOCKS_CREATE) =3D=3D 0) {
> +		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
> +		    flags & EXT4_GET_BLOCKS_CONVERT_PENDING &&
> +		    !ext4_map_mark_convert_pending(inode, map)) {
> +			map->m_flags =3D 0;
> +			map->m_len =3D orig_mlen;
> +			goto create_retry;
> +		}
> +
>  		return retval;
> +	}

[Severity: Medium]
Does marking sub-ranges of an unwritten extent as
EXTENT_STATUS_CONVERT_PENDING fragment the extent status tree and clamp
later ext4_map_blocks() lookups across a contiguous on-disk unwritten
extent?

Because ext4_es_can_be_merged() refuses to merge any extent where
ext4_es_is_convert_pending() is true, each I/O submission over part of an
unwritten extent leaves a separate CONVERT_PENDING entry in i_es_tree, and
ext4_map_blocks() clamps map->m_len to a single es entry on cache hit.

When iomap merges completed ioends across a single on-disk unwritten
extent, ext4_convert_unwritten_extents() now has map.m_len clamped to each
unmerged CONVERT_PENDING entry, forcing ext4_split_convert_extents() to
repeatedly split and re-merge the on-disk extent on every sub-range.  In
addition, if an atomic write (ext4_map_blocks_atomic_write()) queries a
contiguous on-disk unwritten extent that contains a CONVERT_PENDING
sub-range in i_es_tree, ext4_map_blocks() returns ret < m_len,
misclassifying the extent as a mixed mapping and demoting the atomic write
to ext4_map_blocks_atomic_write_slow() (synchronous zeroout and
ext4_force_commit()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D5
