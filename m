Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795804232;
	b=OgnuPDDKxCaFZEfdmJwvmXGivMv79y6oR4zyzuHXEiBIvGJBXIE/hfTVtb7zGKapRjxy
	 WfWD8L/bJj4x2bsVoWpEnx1yDczqkVJgD4Pin+1HI1CO+6sDPWkAJAQSgXNjQNYjmqvdW
	 M0YYwAXC9sBLKXyBBQA2mHQs9hrzbJKXMWnZnHs068oxc9zzzkXE2dSKJOwC++Hinetxt
	 5ZTu2zazal6HUvVGrIO81CSTW2F8ei8++flp/tlTkhvmVg9rJTS4ByKW3yzoeujheQJtl
	 esTgnbaiP0XNJW0sKkkqFO9+bfH324PZVLsO0Rpri6e4LMaANv21s9ASsjdQ2jWzO1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795804232;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=scU3Y1oS5oslB6ex5XHXNuaQoEosnQWn92VPjcrxmU4=;
	b=WPGTNJ5PMKylBa0M7XDtHXHqnMBbYmZ7lvOzj7vas/rmB08UsSuyYPnJc6dubnk76zoX
	 aJPy0YApGaVqJCapAJvM6Zy6K9xbQsgL3auAOjja3nCCAjulO4/T23JvbbjvXHxTe69kV
	 EIGKAUPpz1rSu/zHHPxZSKWANx1IcrQdyTiXUy1z3DLYEjbxYrS7Ep/FCrmcC0jscgzPw
	 c6C7wOiy296RzheDZdpMEXh7ZqjdFP7SQoSFK6dJXSERNso3X2iyISOp2s1bMnnqISX0k
	 /T5YsoWN9rlxROU8FV0v+WbMeopc0K48rYCTxnOSEJWW6snW4HoqHTUDJVZzOvN57nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfaR8iWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B2606A31E
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 18:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfaR8iWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3111F00893;
	Fri, 27 Nov 2026 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795804232;
	bh=scU3Y1oS5oslB6ex5XHXNuaQoEosnQWn92VPjcrxmU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nfaR8iWuZHa0tJDvMaqegB89lH4n8Q1aPQ1NZzrxE6sCD1fpgg9nOuZE2Nyau81J2
	 uV5/XAt+hUCEg+5ggjjZUQhHEZi7kMeaYJnOg7B/G36T96G/dTNfUaA21ztwwzELBe
	 P42LJTfSpxT5uPKVUDYnMNBM8nP7+B1ulOE3+MBQg3y+NJekKxxXRSqpWk2sDksoMP
	 JuSOAV1RBxxIRnU4gFlN2ecn/3pQq+827i+nytkU8xIl+zKp4dnk3PFLf0l0lQ0L7D
	 m0X0W8e4/YYcfmXU6ucUlhMgKuRIiC1bSJ5+74ZGNqqCA/QmQ0y2AAMqDofaV/K2NC
	 5g5wlP5dO3g/A==
Message-ID: <sashiko-outbox-238082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/13] ext4: add tracking for unwritten
 to-be-converted ranges in iomap buffered path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-8-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-8-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 18:30:31 +0000
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
- [Medium] ext4: per-ioend CONVERT_PENDING marking in
  ext4_iomap_mark_convert_pending() defeats ioend merging
--

commit 9d1e415d8a4e8a5c3f447bfed5eca35a56fe39f4
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: add tracking for unwritten to-be-converted ranges in iomap buffered p=
ath

This commit marks unwritten ioend ranges as convert-pending in the extent
status tree before writeback bio submission and clears that state on
completion error.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2031b1dd70694..947c20d081c6b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4575,6 +4575,38 @@ static ssize_t ext4_iomap_writeback_range(struct i=
omap_writepage_ctx *wpc,
>  	return ret;
>  }
> =20
> +/*
> + * Mark the unwritten blocks covered by @ioend as convert pending in the=
 extent
> + * status tree.
> + */
> +static int ext4_iomap_mark_convert_pending(struct inode *inode,
> +					   struct iomap_ioend *ioend)
> +{
> +	u8 blkbits =3D inode->i_blkbits;
> +	ext4_lblk_t lblk =3D ioend->io_offset >> blkbits;
> +	unsigned int len =3D EXT4_MAX_BLOCKS(ioend->io_size, ioend->io_offset,
> +					   blkbits);
> +	struct ext4_map_blocks map;
> +	int ret;
> +
> +	while (len) {
> +		map.m_lblk =3D lblk;
> +		map.m_len =3D len;
> +		ret =3D ext4_map_blocks(NULL, inode, &map,
> +				      EXT4_GET_BLOCKS_CONVERT_PENDING |
> +				      EXT4_GET_BLOCKS_IO_SUBMIT |
> +				      EXT4_EX_NOCACHE);
> +		if (ret < 0)
> +			return ret;
> +		/* Blocks under writeback cannot be a hole. */
> +		if (WARN_ON_ONCE(!ret))
> +			return -EFSCORRUPTED;
> +		lblk +=3D ret;
> +		len -=3D ret;
> +	}
> +	return 0;
> +}
> +
>  static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  				       int error)
>  {
> @@ -4584,6 +4616,15 @@ static int ext4_iomap_writeback_submit(struct ioma=
p_writepage_ctx *wpc,
>  	unsigned int blocksize =3D i_blocksize(inode);
>  	loff_t pstart, plen;
> =20
> +	/*
> +	 * The unwritten blocks are about to be written. Mark them convert
> +	 * pending before the I/O is submitted so that endio doesn't zeroout the
> +	 * range.
> +	 */
> +	if (!error && (ioend->io_flags & IOMAP_IOEND_UNWRITTEN) &&
> +	    ioend->io_size)
> +		error =3D ext4_iomap_mark_convert_pending(inode, ioend);

[Severity: Medium]
Does marking each individual ioend as EXTENT_STATUS_CONVERT_PENDING on
submission defeat ioend merging during I/O completion?

When writeback of a contiguous unwritten extent spans multiple ioend bios,
ext4_iomap_mark_convert_pending() runs per ioend and splits the cached
extent in i_es_tree into separate EXTENT_STATUS_CONVERT_PENDING entries,
because ext4_es_can_be_merged() returns 0 for convert-pending extents.

Although ext4_iomap_end_io() later merges contiguous completed ioends via
iomap_ioend_try_merge(), ext4_convert_unwritten_extents() ->
ext4_map_blocks() looks up i_es_tree first and clamps map.m_len to the
first unmerged entry's es_len.  In ext4_split_convert_extents(), map->m_len
no longer matches the full on-disk extent length ee_len, which skips the
in-place conversion fast path and forces ext4_split_extent() and re-merging
under i_data_sem for every pre-merge bio range.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D8
