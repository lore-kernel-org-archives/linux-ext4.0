Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795801731;
	b=JkWxgrK5tATZIkdoFT6XXCFtBE9f/E4EPTGTik1m1cQVXp7e0XPNIedWYbH4feYU1YU8
	 +5PB/mZCIPn9qVRTba3jSC2E2cErU9fN88vT4l2+1FjPAgOjJh2PPuTSsiQS+KQ30sZ+e
	 57By5XyfX2mzreGLRnQnHHKleB1e/YEwx7ilxeap2LrB8iUWdy+p/hT8qr7evtr0sxP1i
	 389eeT4lIwRyXtkqgxm8zvLhw6lobUnV3pMMaImLcVNguA45YSgpF13lekc6aPfsA7W8f
	 Rs4pCenUrn8mK/eZN3xmLZ4VshPpuzmV66l/MqwXiJghkdcWmZ7myRgpVh54M4m4riA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795801731;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JGxBtVgk9/iy2nLn+WwcIzsrjWknBNrsUXlwfCIbUMg=;
	b=QG5NjukMrkqI54V/4vWRXJNKRiDerZCbFo1J7SfpfFJ7bPEq2xaEnamyEumLP/HwKJlS
	 vdWIzDWbznIy/iyf05MOBNyVgVV3ZxO+cRpJ0lgqvfBklXXTR+qaasxLQrXT2Ohv6M/Fi
	 6a25OX4vyshqXw8kezmSIMtGwBQTgjIGC7Aj8IPys7xwXkpMHmuWoHByMoqn77S2VKBT+
	 Q5MpB+TrQFdB9nVs5X/6KBTCACrbROSmh2hqW62HV5kQEUD9lUqKXnNwuzz9d8zL6ZtqV
	 Q+wtEhVXS+yzOiCljezpM42X0N5Po8+//mJ8U2ha1ww9G+uVx1442kbbh5guxRa6NvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gLaDC6UF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986C4606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gLaDC6UF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1310F1F000C1;
	Fri, 27 Nov 2026 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795801731;
	bh=JGxBtVgk9/iy2nLn+WwcIzsrjWknBNrsUXlwfCIbUMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gLaDC6UFY9Is9Hx22LKjfMMzbFGmg8bueNVie+8iqA3Jn45+TLOVtG0ubW/O6jG+I
	 tw32kjZGlCVGHgLDHWLyq46U+nnHt0gDUQcxGY++0oHEKQEGxCA3IPIS0JfoFnNTZ4
	 p3I0ZWuyPtdDP6TNbxzEkLc62EzY+HZan9RTiAtiZ1Omwp13v2eLcx5FYVXsyltKEa
	 ErV5DKTVwfXzR/z1vp2mpxLU1vXU4B4jAciqCqTxx+oXMTXbE3X6oiRqFdbu+noXoH
	 abjJ03uYftTJsvte9LhZ56npI39zHpMva7K00T+B9HvhRsAz6PFjyPM3C6Ubz1PQhR
	 teVKs12n4txiA==
Message-ID: <sashiko-outbox-238015@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/13] ext4: add tracking for unwritten
 to-be-converted ranges in dio write path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-6-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-6-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 17:48:50 +0000
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
- [High] ext4: fragmented CONVERT_PENDING es entries break atomic DIO
  writes
--

commit ad9b3b49092f6b64f0a47182a02163ecc97b4e9e
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: add tracking for unwritten to-be-converted ranges in dio write path

This commit passes EXT4_GET_BLOCKS_CONVERT_PENDING in the direct I/O write
mapping paths to track unwritten ranges in the extent status tree while
I/O is in flight, and adds ext4_clear_convert_pending().

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3e4c0e1396ab1..4aafd0aaea699 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -4012,7 +4043,8 @@ static int ext4_iomap_alloc(struct inode *inode, st=
ruct ext4_map_blocks *map,
>  	else if (EXT4_LBLK_TO_B(inode, map->m_lblk) >=3D i_size_read(inode))
>  		m_flags =3D EXT4_GET_BLOCKS_CREATE;
>  	else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> -		m_flags =3D EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
> +		m_flags =3D EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
> +			  EXT4_GET_BLOCKS_CONVERT_PENDING;
> =20
>  	if (flags & IOMAP_ATOMIC)
>  		ret =3D ext4_map_blocks_atomic_write(handle, inode, map, m_flags,
> @@ -4082,7 +4114,10 @@ int ext4_iomap_begin(struct inode *inode, loff_t o=
ffset, loff_t length,
>  		 * especially in multi-threaded overwrite requests.
>  		 */
>  		if (offset + length <=3D i_size_read(inode)) {
> -			ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> +			ret =3D ext4_map_blocks(NULL, inode, &map,
> +					      (flags & IOMAP_DAX) ?
> +					      0 :
> +					      EXT4_GET_BLOCKS_CONVERT_PENDING);
>  			/*
>  			 * For DAX we convert extents to initialized ones before
>  			 * copying the data, otherwise we do it after I/O so

[Severity: High]
Can marking sub-ranges as EXTENT_STATUS_CONVERT_PENDING split a contiguous
on-disk unwritten extent in i_es_tree and break multi-block IOMAP_ATOMIC
writes?

ext4_es_can_be_merged() rejects merging whenever either entry is
convert-pending or the status types differ.  When a sub-range of a
contiguous unwritten extent is marked EXTENT_STATUS_CONVERT_PENDING (from
a concurrent sub-range DIO write, an earlier failed DIO write, or an
IOMAP_NOWAIT lookup that marks a partial unwritten prefix here before
failing with -EAGAIN in ext4_iomap_alloc()), i_es_tree splits the cached
extent into separate entries.

A subsequent multi-block IOMAP_ATOMIC write across that range hits only
the first entry in ext4_es_lookup_extent(), clamping map.m_len to a value
smaller than orig_mlen.  In ext4_iomap_begin(), ret =3D=3D orig_mlen fails =
and
skips the fast path (causing RWF_ATOMIC | RWF_NOWAIT on a fully allocated
unwritten extent to fail with -EAGAIN in ext4_iomap_alloc()).

For blocking IOMAP_ATOMIC writes, ext4_map_blocks_atomic_write() also sees
ret < m_len, treats the contiguous on-disk unwritten extent as a mixed
mapping, forces a transaction commit, and falls back to
ext4_map_blocks_atomic_write_slow().  That slow path maps with
EXT4_GET_BLOCKS_CREATE_ZERO, which converts the unwritten blocks to
initialized and synchronously writes zeroes to disk via
ext4_issue_zeroout() before the atomic write BIO is submitted, overwriting
any concurrent in-flight DIO write on the CONVERT_PENDING range.

In addition, if concurrent sub-range DIO lookups split an in-flight atomic
write's unwritten range into more than two CONVERT_PENDING entries in
i_es_tree, the loop in ext4_convert_unwritten_extents_atomic() clamps each
ext4_map_blocks() call to a single ES fragment and performs more than the
two extent conversions for which it reserved journal credits.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D6
