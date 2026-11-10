Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794338217;
	b=3Y7RRroiXYhAVzPwRTEwQsyAFYc9XynP9Na2g6aJgESsrgEkvkDWRDkf8MP9m9Dgc/3Z
	 zP9kvo1y8BxNjo397i4Gjg9zn5oPZGZwSmgd0HB2aVbXKBsOFQNKARgfeA5p0qDafx3ZX
	 hxrI9LkStIblRSlsRuiP0VcnqIkfOmci8gRdFZ9ZbVG4ePckal93Ppx7SkJ9zBpKtNMjh
	 xY5O0BUIwIbGoj3zQLb/K/n1y3ZgKS+xkFUmVUxRNk9QFZKNAMTaT1HF6NWTYeF+wSB08
	 dkyhMQHR747SavDZ+G2HsI5fV4PWdhdugSmhp3akatcPtAIsQmrVveaK2rl/xDD3Zaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794338217;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9yssT3sLGegFzxFyFNurC0+s0dETl10LtwG5h8MCph0=;
	b=xVr3+EHZ9opbW1bi00mrvGFULFdWIIaNVx9hhczkC/aw/yHf9fIZfKfMwZb3GTkyk/CC
	 2CwxEGLzwgF96jdIEJoRYQSDGcyWwKMCpTKXcrEfUbLMX15u1Nee86RMGMY5sI0Y5P4d9
	 s3gbbtaFYuf91pc4/2e1lhIiBCDluJB/veceNVC1w1SIYARfdaA+wISt6lDucIL/H4mWr
	 X+iejsMURcYsj4Dv6UXUCrnD+qLP7shOeOpmr8KTPmtfe7F2zUiKC2Qou1aEM7t24iSiX
	 zgZBaiC2HzxLQW3xk95hPU7lBasgdOZLmnSB3dQwCsww3m542g0rCX/cC4cE8YHJ5vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaVrSLBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48EA606A321
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaVrSLBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299DD1F008A1;
	Tue, 10 Nov 2026 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338217;
	bh=9yssT3sLGegFzxFyFNurC0+s0dETl10LtwG5h8MCph0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EaVrSLBclaU/KFZwCH2k2TRriaCyNDT3n4FrxSrqz2kfP3/+FUpwqKhKXGzIJmP9M
	 6jbmIdfenoS7OIH3/5xSmFxbsxrkgln09oWbjJGB5MQJvS9rKi4sDAYNU5KlCqqkrB
	 045czl4SPd6tggsQPE7GNodpzw4FNBFRUdt9/6kMlrY14ryGncB+AkxXkLvi+eKfsH
	 PySsvzTgh7o7u4Ce6GnaSlAChmeen4w4eps+rEWTm7i9hn8iuUCVPQPGd1gUDQbgOl
	 ZoL53JLPPHuV041UCeoUxD9Di+KtfdgJBAWqxms7Cp5LfmZTeDzzFafP3KFoZapniq
	 tg679A4T8Q1nw==
Message-ID: <sashiko-outbox-207648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 03/11] xfs: don't change the block map under a dirty
 folio
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-5-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-5-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:16:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With CONFIG_TRANSPARENT_HUGEPAGE=3Dy, writeback on XFS can write in place
> to a shared block and corrupt the other file that shares it.
>=20
> xfs_map_blocks() writes in place unless the COW fork has an extent for
> the block. write() and write faults reserve one before they dirty a
> folio over a shared block, so xfs_flush_unmap_range() writes back and
> truncates the range before a clone changes the block map. But the holder
> of a GUP write pin takes no filesystem lock, and the truncate keeps a
> large dirty folio that straddles the range:
>=20
>     clone                         pin holder         writeback
>     =3D=3D=3D=3D=3D                         =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D         =3D=3D=3D=3D=3D=3D=3D=3D=3D
>     writes the range back
>                                   dirties the folio
>     truncate keeps the folio
>     maps a shared block under it
>                                   dirties it again
>                                                      finds no COW extent
>                                                      writes in place
>                                                      /* shared block */
>=20
> The fix used here is to invalidate the range instead of truncating it,
> and to fail the call with -EINVAL if a dirty folio is left, before the
> block map changes.
>=20
> Fixes: 6795801366da ("xfs: Support large folios")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D3

