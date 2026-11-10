Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794338355;
	b=tuclWF5zX7s/HpDfDw4MvnlfvIowkNOoVKojy+JMOr2+N4JmUiQCYIxZyPoUAbm2h20r
	 DNH0BMrcK5CuL0kyGLN3DHZqjRog5Tl1SrRcVaKUNnVtZ0Fv/K69hy5evCQ/GcufwKjZq
	 Jzlu6161+eqS2bFdftGvEf/hn+BbD/8baPo4tNSIP+anp7eiL2JSsIwsScI+sQ76aw/Io
	 TxrTIjopywhIcF3DK4KEsW6X3wtH+swua1UNAC79AtA7C+S6jexYJok8Jma/mcv2rwcd7
	 TTxZ+kXHn9cRBD6V7d8dXea1qXm4suP9LvI6t+f80iIqQabb4bfoHyZz6xyap3i+KEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794338355;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J/Zb5FJ20/BfjSc0uItRD8sGFdDh7rLx9B79Pre2q+I=;
	b=PY6eVzbcCcU+k4dRG0/f5+farY0/5H6H5vE8aWpovmU+RR88vx9OEFnoMjnKEWUxqZIi
	 wID+UGqRNui425cBMdY6dTfVRzdN8eKHoLYrQXfnwQT7H4BiDm5OBo+e/awCjal81ffms
	 0hkIeitwmBU527bMjNjBr06xLrHIYJlDUoCJyG9rQatJRqZt34k996bLkGMUnduCpNjnS
	 gcAmab/gLPdnbbxSWDblUugqGS3WU0Z35c1XfZyBn0P2jcA5MxIYkJhQgtr/fCZPQEwx2
	 NMSHX/RjK4wmJrmKwPr0MxmTm1mMVgxUmA50Aa63k7+woQB7GywM4/GRf2OoejaPbwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILasJVq9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE58606A323
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILasJVq9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061881F0089F;
	Tue, 10 Nov 2026 19:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338355;
	bh=J/Zb5FJ20/BfjSc0uItRD8sGFdDh7rLx9B79Pre2q+I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ILasJVq9+ZeRt0jBx8XLQpQsu1blFkS+m6iEUmLiJ7j1CKedmuNw9VNE23/wTfLAE
	 UWSO7SDauzDDHq5oR8WKVjGL4+4elqg/gr6rllRZBQnYuHWHPnX2Y8Py1LYHSUbWPa
	 jA6rF0i+qejUPbrccGbdJqh71deR397pqCpCv/0Va5UbGmDH5LZIiBxuElYPolQIlR
	 8wxauFgSYJHrxRyzKZPh1JuPA1nKwon7yysO61RWYocaqg/zQFk2cBeinBLXPv7Dxv
	 bSTSKlIAsabp8rtr+q8n2O75hiqXzPfwmuoH+ejn+8ikRaLI/lF9mcOjsEy0ru1acm
	 cvsiRBaCX+hxw==
Message-ID: <sashiko-outbox-207652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/11] iomap: don't punch delalloc under a dirty EOF
 block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-6-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-6-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:19:14 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D4

