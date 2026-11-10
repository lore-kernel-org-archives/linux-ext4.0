Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335124;
	b=bCdHoHQ/YVmGIVD4Ca/f+XrSDoA9/ZO5nHaY7teuHBCVMci8qxdanXr5LAHL/QgG8jR2
	 X5YurdEsHjmDshqpFx9XgWlNcr8gZoRzNtGVGOwgLfPYsuKo8PxPpnivSvfCzBedUb7q+
	 I2ZFZ96sTXJ/mQ5KMVs0Xlt0WC+NSsSlXhWOYVDAub/0IuMbyAqmtdsVxV5c57LmW92p4
	 iok4pvU3PeaQckrQvQVLYQ7a7Zbw0NpLPFJ+cKRcjWV8OZNU54T6aRTvnUVcq0X0nrmFw
	 Tp+0g97sVgzxsYe2z6E0uPiAbQe5rvQUyplZ+LquN4K3SmB8NdWWiYb96KGTBKt9Xwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335124;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sntjsb8vaxzMs6RSUKP16hu8cFr/XSMkjPCI9tWtKhQ=;
	b=PyTePr7KfOCVQTFXa/rSxutRxXJO7cpQJFBQGC7gIwkeGTbXalnZ3r5gF5juFkiCq4Q4
	 2MBgoFp2bpgaPtNi0C1kNcxa8j743A07L42t3HEgLEIR6VlFXtB403KDkyjXFghgBld1+
	 zMYpxTzFOMhZZlhs4hSZJSQXJEibqgO7voPrSglOHlt7FEqrkF2v92QhZQqQsOdIxFkwi
	 8lsQxzKeeAhVL/kWHTtlPjQtxm+2LFJct2rOCDVjXupq+FxHyvAIPiD1R9KhM6HxqC/6d
	 MDthGVhZ+Ah4oqMQv8HOznV1za7TY/glLfa5N0xCu8WSMgvbReKAIvZeE2sOFP+UtEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeWEkr+s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3D6606A321
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeWEkr+s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8C61F0089F;
	Tue, 10 Nov 2026 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794335124;
	bh=sntjsb8vaxzMs6RSUKP16hu8cFr/XSMkjPCI9tWtKhQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WeWEkr+sNRu+2czvoGPP8PUhYfiGdEhJRD6ptP9T+AZHfd2GhumVFJFeoh/aJzSdZ
	 0t5kZiTdBtoDFuPhk44wDw20UhPP2cX2cFHsLjE8ZvPRtn40IMXTHbjF048IVKDt1S
	 4HJ21rvlDCUT0zjwxvAiZCs5+5a7M4U/35uNlV46Q4EOXQm5RFkF1PNLDXWGzQ8meb
	 A9RYH5y29htdfG+PobPSJ8f8XVWTNtz6Ig/CmzECvZS6gPy72PpauwgauRZ2Dx3Y7O
	 hLaBNLiTYn4aNXQavBjGiFp1mNWwZsyRrj8/sv4iTHY4BZHkW2ERpRhDC/uGT8To9j
	 GrtzHZidJHkOg==
Message-ID: <sashiko-outbox-207575@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: test reserved GID block allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahaj Chaudhari" <sahaj123.sc@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261110182040.798390-1-sahaj123.sc@gmail.com>
References: <20261110182040.798390-1-sahaj123.sc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 18:25:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Create a small ext4 filesystem with a nonzero reserved block pool and a
> reserved GID stored in the superblock. Fill ordinary free space as an
> unprivileged user outside that group, verify that another allocation is
> denied, then verify that the same user can allocate a block with the
> reserved group as its primary and only supplementary group.
>=20
> This exercises loading s_resgid from the superblock rather than overriding
> it with a resgid mount option, and detects the regression fixed by:
>=20
> commit c87abbab6147 ("ext4: fix incorrect function call when initializing=
 s_resgid")
>=20
> Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmai=
l.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110182040.7983=
90-1-sahaj123.sc@gmail.com?part=3D1

