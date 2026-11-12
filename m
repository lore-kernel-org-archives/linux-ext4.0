Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520492;
	b=ptD7BZWb7B/dDCSnPpPJ7vIh896s0KYlBJ8uhwim/IUshN1h0IomtmCUP6HdEd+GUsDp
	 t1un8FiF4/f+5XdR2D8vAOxBaeEuK4R0t2nAAZwEoehO5erxwMEXBqBz4m3401DNDCv74
	 RIaonDouOH29Wki4lbI3WRlOnl4v14GIPNKYeUKwQP1GcnWG1T9QNVnx/i4plFcWnuAK7
	 8SgODsGJcJwD99W8wzSouswOiyYNG0797saYmz9qCryo3nLmllRrNKxxBsERIPn1Z/xq9
	 Vsj3eTvGgpp3yWnyJvZqjOMvgOk0wjJ//VxOqPoGE+bX/wkGeqn2CTKWLuT0q7DrsUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520492;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pO9q99x6lrhPeaABMArwtRP5wn/FSOKCh6TPyMPCgK0=;
	b=PydQE1vix97M2hM6xBdl9RMfoIV8KbgoO/oryXiyqv6fNs0ee3oO9MzxRN/SOO2YVoe+
	 5SsgTc7Zl7fx/eNhASxanVCbaDZkYny3QyTTfRlnLR4WFQNRZyV0Rg7U33ybydHCd+av4
	 8AJ1YLZV+DrSGDLUUdiEGxaqP5ywsSwnqXovBicyrfZz6ibnSLGmTfMZJD9aGQQJdUr6s
	 eTn32J+D9uzvs3N4dMuGEq2LXfRiHf85OaVyWnQ/TJtEdzoPbKbTwincy1O2mtIyqoxVI
	 hD21O5wp4GqrwVtTwlqjymYGQKhSl5Ol+ML8baFrbr+Hft0sJgLXkkjuBVQSM7m5EDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFZpljA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64167606A330
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFZpljA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E6A1F000C4;
	Thu, 12 Nov 2026 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520492;
	bh=pO9q99x6lrhPeaABMArwtRP5wn/FSOKCh6TPyMPCgK0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KFZpljA0jRInn/cpeJwtTgEf4om7ZFsbnU9AvNvngKWtEEpq1p/l7sfETBlIZUxxz
	 po1NITI8xX+CkJm8DLc+0/fLPdeRJbaW5xDWGtiXgd7FGryNp3ZDiHTH4AxjeJLsoG
	 EFlF3F9K5wMASJpS6WVUDcz6FcO/NZrYHUkJ6wpKufT3qHL0l88Dh4LURiUzCzC1vq
	 DKEwQJNW+VKRaWnh/u5Cr6iRyUkBkRkjXvReXybbDEslMH8mSVd9/9730WY9WaTjog
	 jFT5+7O0429CW2P3+EZJHMTG0clFc/X9cQBY7ZifGC6jVXWLvQ2BXRPOh2tBNKqaSs
	 iPhd2dSzIHSHQ==
Message-ID: <sashiko-outbox-211877@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/14] iomap: don't punch delalloc under a dirty EOF
 block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-5-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-5-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 21:54:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> After a failed buffered write, writeback on XFS can write in place to
> the shared block that contains EOF, and corrupt the other file that
> shares it.
>=20
> After a failed buffered write, iomap_write_delalloc_release() punches
> the delalloc reservation of the write, except under dirty folios, which
> still need it. It looks for dirty folios only up to i_size, and punches
> the rest unconditionally. But XFS rounds that punch down to a block
> boundary, so the block that contains EOF loses its COW fork reservation,
> and writeback goes to the shared block:
>=20
>     block size 4096, i_size 5000, reservation 4096 to 8192
>     searched for dirty folios:  4096 to 5000
>     punched unconditionally:    5000 to 8192
>     rounded to blocks by XFS:   4096 to 8192
>=20
> The fix used here is to look for dirty folios up to the end of the block
> that contains EOF.
>=20
> Fixes: f43dc4dc3eff ("iomap: buffered write failure should not truncate t=
he page cache")
> Fixes: f6f91d290c8b ("xfs: punch delalloc extents from the COW fork for C=
OW writes")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D4

