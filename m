Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645258;
	b=1/1Ad0npRA70dJkDvxVPtpBJ0a1OsTKvf+9OfmV0PoUk4lnYBnx/Pmm8LUt41I1+tkdv
	 +LvSGQ/6yVwqm+G2oAlqmFqxh6erkIkc/1Ibp2IZaL88Xjht5CDtMA/UC0R0uIpgkweEN
	 P7eEk0PvahkyPlmsa3GDGgmLVIh0Jw2CEGRbhVrMhsIt1ceNyVUzMH7A9Jn7fd7U+Q5cR
	 OPrPuD0KEejslxqW74qklabJFLpWQv8QTzcUcWtqs7c1xKmaObP4OIiVapi/lEy3dpprh
	 C/fdKynJfxhhQwbnPwJzZJTQdLdcqjckdNu90z2Sa3GaGIYKlgp+vRJ1tW9tTFfCNlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bd4qMYVIymFVTOqLKAPq0/6lg6N25eBrVghEDaqZeKA=;
	b=JST8RvSqrXEHyT8HApn2EjMPqFZoWs2m5r1ous82pEd9K5T2+egBuuSItBRXSt8Yv2xU
	 usLvN92iE4bHKsWPIEI9gPFlsJUgX3wNxOjLs7W+615z+WZsvl6fngOK0FApfPjVelNjP
	 Ns8n14mbYY9b6lmJjNbRw4aPSvmJP8SJhABNmqZ+jJ7aresruH6+iLQ7f6wv25VZfTb5z
	 VALmRp4oNNv0pq6EL7M9j5gwqvPRoRnZMiZlLXnh2ic4V8WgrHXXeeTg6nYTJZw2keHUP
	 NAAeGX7wzBpXognF6PXXFx0H5ionLctTeRa/gIRcnK3F+tmt6A4VY8QvDgXanKCg7BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDymCfnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F950606A33D
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDymCfnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE88E1F00A1C;
	Mon,  2 Nov 2026 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793645258;
	bh=bd4qMYVIymFVTOqLKAPq0/6lg6N25eBrVghEDaqZeKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDymCfnN5ZcOQwTEkns2DiirmznGRVs54ChWZLtxNycLdvi7HyZALEFpbEWNT4mlp
	 A2ABMnd5Z5o2mLRfYuhKFnsaFhNpThrwkxVIz7OOI9PUnG+iw6RRw7c2Szjq7HvPHK
	 WIdXrFCyfphZAXz/yl8NQw2aaEKLTmKkO64iL5RR5/mgUsobYynjD717Sxn37cWyEH
	 vHVw7BEthJAc8uLH2iSLxvbL2wclaYzX3RvH78Ak4seSnQbRLjiVA6HTobmrL5xv8v
	 atPI1yvOILk7u1ujrJWT014K+FCC2nWWnGajedJLBrIKBJTy+Dive9/ET+KJzLYNXa
	 9i9l/NhptLaYg==
Message-ID: <sashiko-outbox-193964@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/8] ext4: make sure zero range WRITE_ZEROES uses
 NO_CONV_ACC flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-6-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-6-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:47:37 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A zero range WRITE_ZEROES splits and converts an unwrit -> written extent
> but it doesn't need any protection against the zeroout fallback in
> ext4_split_extent_zeroout() because it's data is just zeroes anyways.
>=20
> Hence, indicate to the zeroout code that the caller doesn't account for
> itself in ei->i_conv_pending_ios.
>=20
> Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D6

