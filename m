Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793720416;
	b=F6bb/p+hb4QvRUb2tC76Eu4r1u42L2yky8ue9PpmGMPqRtfI3BbVccR9yy1jayOFXkbq
	 IW2IICeFIh24lGrzuAgNKaHLrRepM7OZ1KCFFP/7/UQFVdwc5AM+fUcit/gtru3MofFWQ
	 D2SpxM2U+Wgm71ILzGXpJ50vUX24aLLHwLMYws6BTyC758xbbTy5+/RwRPiv+RJ4yi57I
	 gqDnQw9ZqnhLxnxavY++pswapCuXeTfhHsCqT4vwGPjAfyt2M8LAwE3fCKC5g2wXQpexO
	 /6LhxeATtCDDH90M4hlVsD0QNI0HvNHmlWAdEo+iarqMcUqm1fRxQWTHAYPowo1wpEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720416;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NdoqyCjdjdRK6+TQGCsDiONfmkyLlkLZo1WqiIem0IY=;
	b=VdZ2vwG9F/rBsNABgc3kD2Cae98+cJ10GF98GVcfnuEIp3niEziQ3HlC0ZDAhhgiiVtP
	 kQTlpse4BPOT/4qpVeLy+IGAlqLbu2V/r3A2dfqBXOAEAZl50kgOlGhdbexGOMJmIP8uy
	 GFZkNFpept7+xgM6RNf767lwiDiP0+tOJiouGsLd7SpwoOmt0FxMd9aD88jbNZO55jK8/
	 m+YFpTiuAp+56Yhbx0eXfJf7BcCKsVP268gzyjOSBabRyofofLstsRoch90pRUCFoG+6p
	 idnNGLEw9IYBdKfzUlPJXvXpFvjiT+Q3jF+FQutYlXEnBX1StgOAhvzQqlOD3e/NgjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOLyNAH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4514606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOLyNAH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544211F0093A;
	Tue,  3 Nov 2026 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793720416;
	bh=NdoqyCjdjdRK6+TQGCsDiONfmkyLlkLZo1WqiIem0IY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OOLyNAH29EWqbcBv2YQoDH7MvElVlipNuYwIUK5QPY6t3aIraSxy2/lup12hY8B62
	 9m+YJ7YHgsibQreP0KoVOod2QXlQ6y0UwuChO/YRac8OPCMNUi/CL32SPLVg1dmmpe
	 dOi8utoD0fDPl9zcuFISEnykcCG0ADXmOn3z5PnocGHaa36KOtvAIzlBsafZn/pJ3I
	 j2PsRvPi9/vKdfv40yMGN1T19frlTqOtdTR1EG6brSb1mLcG4L62kFshSqwsWrECq2
	 so+KqD1Sj5qmvFRM2/FHi0OFAcknJhnK2P4iY2w6ydR0bgilj+JcRHAaG2OrbPCuPG
	 d27ebhT3ra/bw==
Message-ID: <sashiko-outbox-195629@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] ext4: don't put a DUN wraparound in the middle of a
 read bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261103153132.4154855-4-libaokun@linux.alibaba.com>
References: <20261103153132.4154855-1-libaokun@linux.alibaba.com>
 <20261103153132.4154855-4-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:40:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Under IV_INO_LBLK_32, a file's DUNs wrap at 2^32, and the policy
> is only allowed when the block size equals the page size.
>=20
> ext4_mpage_readpages() adds a whole folio to one bio, but checks
> only the DUN of the first block. blk-crypto assumes the DUNs
> in a bio are contiguous and never wraps them, so blocks past
> the wraparound are read with the wrong DUNs.
>=20
> Writeback and direct I/O get this right, but with large folios
> a single folio can still span the wraparound.
>=20
> Fix this by routing such a folio through the buffer_head path,
> which submits one bio per block and so gives each block its own DUN.
>=20
> fscrypt_limit_io_blocks() tells whether the wraparound falls after
> the first block; a wraparound at the first block itself is already
> caught by fscrypt_mergeable_bio().
>=20
> A file's DUNs wrap at most once, so at most one folio per file takes
> the slower path, and the per-block bios can be merged again by the
> block layer.
>=20
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103153132.4154=
855-1-libaokun@linux.alibaba.com?part=3D3

