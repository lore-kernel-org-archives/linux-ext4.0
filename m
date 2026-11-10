Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794297076;
	b=RvLUPxQf2DxVzmdbNxWE/W1ZnKSMkB5L0IFV07vxg2ZASplVsTa0uBOAjSNR/bF/Wr9h
	 QPKmZgAOxkx5yg72etoDEBEKIMid2nHs1wjtubPEi22ilfUVX0+jN8iBsT4/uKxLxcOEc
	 qkiVgkZcZGJj7UpJd/Z1I7b6M9rTCg8B8XozSF9EJerDiWwrnjRaxyjUQ2xHptX5Nrc/T
	 lxMEkI6Hu8MAWpFYje0atFbep7XVMXoQFv6KApQDHuuMr2wzclGfR07X0rYvNBUoDhuoE
	 pbwdcT9Po2ZpY8+mZ1bUL9g+0urhdAAqDWbvMhsb5WWzxsX25D4/LcsHbCxOlEYkpTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297076;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Cnz7uWoErCgBDHVpX47fGG6rcDauHHKjnd1wPwYTEKE=;
	b=aAyBB1AAlAouybxy5SZmG85iemFJ1uggFniAA8WGKYsw53fM8GZECtgYTmKr7hK725Qw
	 A3omVRoPKNYp0OUWAk5K+CU9mbhZx39TgTTfQcSxBGT/YXRNEqdke/RYoUb3hXW3+d4ow
	 yAt2PQ+w16/BG7UD7BFIdxPJeTjqb19B/Syt3O5pji3E0tT5qRJiPn5ju2fmUbmDpWAbW
	 wWzF8OL1GrbvBi6rQ7eJah3QaOPfWr6/mSPzk4oIdgkWnzgZ2WX2L9naVqXHzLJkGs7Km
	 TwutuLdyI8cbj09tQwxEme+HO1eCwBBGl691X2xfOv6pS5AtI+0EVXs+Y6on+gYZUTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOTSFnFx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C00606C637
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 07:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOTSFnFx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05901F008A1;
	Tue, 10 Nov 2026 07:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794297076;
	bh=Cnz7uWoErCgBDHVpX47fGG6rcDauHHKjnd1wPwYTEKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BOTSFnFx6x7O8WsKow1sXKiE4KJ9KpBIDMpawzZjRlLhIgSoQeKPYQmhmibDH1SG1
	 vVs5REAPQYP1j98G5O8Mx1fCBn8ieoO5DG8ERuvJbTv+YjLAsLKIcHsLcd3/eCG6XT
	 bmWFri8dDTWtLRuL4gPS6fd/F8lS7xZWVhjzd0STCROSNKyYtHZ6Fmgu5Y6WsULY/e
	 jy/nOgmDFtwiWdNpw+F1Ves5bWq1wc5YOB7gp3PwqQIoOg6wfEZCaKZM6VomLv9Sy4
	 e3586OzXb4dcuhovC4K2EAzHQoNGm185SRw77YHZvZuAOGyg4Z82JVe0Rtp1cmnwn1
	 G2LJhQVvGjHZw==
Message-ID: <sashiko-outbox-206535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: free the new extent block when getting its buffer
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: Alan <3164729207@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
References: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 07:51:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_ext_grow_indepth() allocates and accounts a metadata block before
> calling sb_getblk_gfp(). If the buffer allocation fails, the new block
> has not been linked into the extent tree, but the error path returns
> without freeing it. This leaks the block and leaves i_blocks larger
> than the number of blocks reachable from the inode.
>=20
> Commit 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> removed the implicit __GFP_NOFAIL from this allocation, making this
> error path reachable.
>=20
> Free the new metadata block before returning -ENOMEM. Use
> ext4_free_blocks() to undo both the allocation and inode accounting.
>=20
> Tested on Linux 6.12.1 by injecting a NULL result at the caller's buffer
> acquisition boundary. Before the fix, seven failed extent tree growth
> operations left seven allocated but unreachable blocks and i_blocks of
> 40 instead of 32 on a filesystem with 4 KiB blocks. After the fix, the
> same failures leave i_blocks at 32, and e2fsck -fn passes after a normal
> unmount. Retrying the operation, truncating the file, and growing the
> tree without injection also succeed.
>=20
> Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_9EB8EBE9103=
78E46C80E006C6A7DA918BA08@qq.com?part=3D1

