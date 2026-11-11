Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794383462;
	b=wxr5mn+ZgmMCO6JJJbFvijdIw6PzhzYB6ttn1UakHATK91OgeOysn95RQB2htKMtdew0
	 rfAkhz1dEdWLiGDeaXcaVuVBr7a1rpSMSutFcW+Xn2yzbeXi6meCF1OvhZyZ3nAMw6/Ke
	 kATJkn+caSwhyllln/tIK+tAwIETzZplTQIdTzOy3gc4dwuTgPyB9wELGn0Kbe+TtTyYA
	 DNDrXRH/JUPDGvrAFq0MWkTd7K6DVnYoeBx3fqqIv4zpLYBrrMUPltl9zUkJ+PuAsMnfr
	 oewQbMg9lW5uLCYuzLvrOl2zBCS48z5di4epH5PWkiMRoToc/12a7SUX8fAYXoiukkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794383462;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8pSFJGnG0yr8y6scpXPzOOogeUMUfUHBKdrIB+uPnRQ=;
	b=Gue4EdjGNh0IJoHG0l3pay1N9W1sNexRhf0M9nPe3icNYRUYwuhXisZpF16+lEqlGFYY
	 tYan09syMv+Cu3WL0D6BAmQ0DSWQAJnyOLt2c5gEXBDzBhwTqBZX6T1ZIrOfAubUmoTRK
	 Q6OMZM93h9Pjix/zJt/eCIpe6myzusz40POEqKCu5WjXGUJ229yCXzzBVsUYIs15q6dWn
	 brQd6nF6uu+Trs+8n7hh2WQqwL6wdDL2SE/V4Y23R9hJL6WvTV8ujJxFwqdO1WoL+Udd9
	 s0/lhZW3Gx6IyM4GUqsadRM1wEQEBetK1Z92Lu1u1cHjGWmKzEulgmwcxBH2QIlYbfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A0qgZsS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE78F606A31C
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 07:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A0qgZsS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694D31F00A05;
	Wed, 11 Nov 2026 07:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794383462;
	bh=8pSFJGnG0yr8y6scpXPzOOogeUMUfUHBKdrIB+uPnRQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A0qgZsS4HhVHO6TdPmZirMWnprDngg10iL6jKN8ZNOywb1tTb15mlj77UENGIKFSk
	 vD0PUDIrA81sZMkbXM7pW2DxPn+NjBVLVzQ2ixwYcbh2R1/vA7xmLt1e5CFNdiHJGR
	 T0DpkuaQQwbmW34P222vx/DD/2+mITTJHjlMPVSN3zcydRp2980N5Ssb3LQ2VUfk2l
	 Qhfq2tFFHyOYFGuJU6acWKzpTkB9upXkIQIZKNOQ0Fs2Bm55yXtVT6szdsqKelWQxm
	 U1+rgulL9M1wN7gt0WdxA1puUxzdPfllLiMd1/yTvpVtqQj7bNgbjEuTgbwb9laUjD
	 PhvCZE+IDi06g==
Message-ID: <sashiko-outbox-208546@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: free the new extent block on failure to grow
 the tree
Reply-To: sashiko-reviews@lists.linux.dev
To: Alan <3164729207@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_DF25FDEF46DA68C4E18D6DB40F08E30BB705@qq.com>
References: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
 <tencent_DF25FDEF46DA68C4E18D6DB40F08E30BB705@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 07:51:01 +0000
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
- [High] ext4: single-word name in Author and Signed-off-by trailer
--

commit 28c8d79985e366b191e9eac1f2d5415854ca0289
Author: Alan <3164729207@qq.com>

> ext4: free the new extent block on failure to grow the tree
>
> ext4_ext_grow_indepth() allocates and accounts a metadata block before
> getting its buffer, obtaining journal create access and dirtying the
> new extent block. If any of these operations fails, the new block has
> not been linked into the extent tree. However, the error paths return
> without freeing it, leaking the block and leaving i_blocks larger
> than the number of blocks reachable from the inode.
>
> Commit 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> removed the implicit __GFP_NOFAIL from the buffer allocation, making
> the allocation failure path reachable. The two journal error paths
> already lacked cleanup before that commit and are fixed here as well.
>
> Route all three failures through a common cleanup label to free the
> unpublished metadata block and undo its inode accounting. Keep the
> existing buffer unlock and release handling. Once the new block has
> been linked by ext4_idx_store_pblock(), an ext4_mark_inode_dirty()
> failure must not free it because the extent tree already references it.
>
> Tested on Linux 6.12.1 by injecting NULL for buffer acquisition and
> -EIO for each of the two metadata helper calls at their caller
> boundaries. Each unfixed case leaves seven unreachable blocks and
> i_blocks of 40 instead of 32 on a filesystem with 4 KiB blocks. With
> the fix, all three cases retain i_blocks of 32, preserve the original
> data and pass e2fsck -fn after a normal unmount. Retry, truncate and
> uninjected growth also pass for each case.
>
> Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

[Severity: High]
Documentation/process/submitting-patches.rst requires a full real name in
the Author header and Signed-off-by trailer to satisfy the Developer's
Certificate of Origin, rather than a single-word name or handle ("Alan").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_DF25FDEF46D=
A68C4E18D6DB40F08E30BB705@qq.com?part=3D1
