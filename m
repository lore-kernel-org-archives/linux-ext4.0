Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C45D377ECF
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335837; cv=none; b=UXymdAE8vWDHrWJcEOOqOw2NFJXDYiHrkn6qzVkfthUsi5cMA4h/3daPiR+TnpUdduLAymUnQ+Lj3dxpqnFus0Ur3Hdvs5KymBDtOWHv7yuD/WSFJdyAp/OfW/X3n6M3PtA8MwD2v/X+ScxA+SkB9vkkxujNu/qd+oabecDxHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335837; c=relaxed/simple;
	bh=fpFOxCVp0FaG1k4gX180NfPnGTIvgpJ+B/DMIzaZ0jE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mHGOVNHTrAQR4jtwIVVlipCHhKviEtqAFqCv1IMpzFVH75WpXEujvsRQfrT6z9I07hutiliePgZW8tDz6Is+khI2D9dyNu6e3o+esVTAw9OqYWA/BTInBrJwiyrJWq4mULZOvMtDF09R2E/SV17kKips7j2di1jMXxIOS8ss/gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c69e8DJL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c69e8DJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35761F000E9;
	Wed,  2 Sep 2026 07:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335836;
	bh=Xpq8qE7csq5SKx89vpcnW1066WKf4Cl7ZdP1VoyCJ20=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c69e8DJL43GBAvijDqusOPlS0zQjVyB6RVvj7C0vPzgIeHAloDGEZeNUTTW8nUoGL
	 MaH5ndamkdfpxnSWrqWl8utBKoEfmwN+6aDBWAahH648cEuX0ymLKrKBfeFFH/HbxI
	 oUjThPDshVdN8dNRsWlDOy4Gqe6mpJPvK1kolfBlNQrHpY+vanxmyl18P3wTTtI4LB
	 zjuH0X742dunjf7LRwCYnapLtPR9TFP5u34DhDjG4btComDgKGK0hfcybbpFSnbQvE
	 jJ5yKFIjY+ZrI7ceGywvsWBirJ3KS3fJQpnyHFVnRhn0bhhXlH5z2vgoEu7bxI5PzN
	 my02cADewLSBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/8] fs: aio: Use acquire/release for ring->tail
 publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902074805.398540-4-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-4-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:57:15 +0000
Message-Id: <20260902075715.B35761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message claims to replace `WRITE_ONCE()` and `READ_ON=
CE()` which do not exist in the baseline code.
--

commit 8b8ddb17380f4323933c3731f5ced979ef864fa3
Author: Jinjie Ruan <ruanjinjie@huawei.com>

fs: aio: Use acquire/release for ring->tail publication

This commit replaces the explicit write and read memory barriers for
ring->tail with smp_store_release() and smp_load_acquire() in the aio
completion and read event paths. It aims to clarify the publish/subscribe
pattern and optimize for architectures with native acquire/release
instructions.

> Replace the smp_wmb() + WRITE_ONCE(ring->tail) and READ_ONCE(ring->tail)
> + smp_rmb() barrier pair with smp_store_release()/smp_load_acquire()
> on `ring->tail`.

[Severity: Medium]
Does this commit message accurately reflect the previous state of the code?

The message explicitly claims to replace WRITE_ONCE(ring->tail) and
READ_ONCE(ring->tail). However, the baseline code only used plain assignmen=
ts
as seen in the diff below.

> diff --git a/fs/aio.c b/fs/aio.c
> index ebdb0e5b95fd9..a6ec7c51ac456 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1206,13 +1206,12 @@ static void aio_complete(struct aio_kiocb *iocb)
>  	/* after flagging the request as done, we
>  	 * must never even look at it again
>  	 */
> -	smp_wmb();	/* make event visible before updating tail */
> -
>  	ctx->tail =3D tail;
> =20
>  	ring =3D folio_address(ctx->ring_folios[0]);
>  	head =3D ring->head;
> -	ring->tail =3D tail;
> +	/* Make event visible before updating tail */
> +	smp_store_release(&ring->tail, tail);
>  	flush_dcache_folio(ctx->ring_folios[0]);

[Severity: Medium]
Could the commit message be updated to clarify that this patch also fixes t=
he
missing WRITE_ONCE() annotation?

The baseline code here in fs/aio.c:aio_complete() performed a plain write
with "ring->tail =3D tail;" rather than using WRITE_ONCE() as claimed.

[ ... ]

> @@ -1288,13 +1287,12 @@ static long aio_read_events_ring(struct kioctx *c=
tx,
>  	/* Access to ->ring_folios here is protected by ctx->ring_lock. */
>  	ring =3D folio_address(ctx->ring_folios[0]);
>  	head =3D ring->head;
> -	tail =3D ring->tail;
> -
>  	/*
>  	 * Ensure that once we've read the current tail pointer, that
>  	 * we also see the events that were stored up to the tail.
> +	 * Pairs with smp_store_release() in aio_complete().
>  	 */
> -	smp_rmb();
> +	tail =3D smp_load_acquire(&ring->tail);

[Severity: Medium]
Similarly, could the commit message note that this fixes a missing
READ_ONCE() annotation?

The baseline code here in fs/aio.c:aio_read_events_ring() used a plain read
with "tail =3D ring->tail;" instead of the claimed READ_ONCE().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D3
