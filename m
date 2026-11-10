Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794338887;
	b=zRotAjykdljyrnZIItIv4uKoeTwArcy/zftCqKKU0LjgHfGkUoqzSQNW8XQKyPz1ULJ7
	 ImzNNn31J3MwXPpSge6JQvqGurKTjWKoAuMNITkdZ1kdMUzRnIylf/67KnzhLyALSMmuO
	 aVF+PWWdIxWLffr5sHYIjHFi54bVSe+c1mbXEMguwDQmdud3yRqZL4ojfY9mOkf6Eeajy
	 p7A8vxfQ8tnC1ZrJVIdwfLFJ1Ay1UA1Ps7vLhqYaMJhO4wPw5rt7TuHT/d+zb/hTV/BnD
	 DuEsV/01gNMN6Qpsw1LAdWAXE0RPwjd0x/lIGZ5QnrI/yi1DRqiSQpDJ2UX86ywupvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794338887;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dxbek0+Ruu7pCFTdBsZVP6NxZ190pfxHAYsOYbBPJNI=;
	b=cd45ACUMJ3mTaL7ES/6LGZQDk25jfy8dEcGqVfJUTA8g2vMYXcxXl4eFsrTxsUcCjyFs
	 WAVqchkIEz9/s1kdczp2LiYeyHIMwjBliw2z3LOts1XC/DzFe1KQMOHiEoOIR3CiqBdAe
	 7GWMo34d3d89VEaSmzQjsu/4jWgSvNYA4mx+1BSIMkW7xIkg0Cbb6LhYZypmKHRilnnSU
	 TBU+IlN0EvJ/ZMFTakP2i4W3knv2x9EzNAN8P3XHarePD/WaLmIySGMGro+s2AMwEIQTZ
	 DHRwZ8r48drFQkb9redNzBKT5UBLpghT8r3/+eVgOSQqfSABZv6FSkNr9SKDw2euc2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRZxVS+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A82606A320
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRZxVS+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD261F0089F;
	Tue, 10 Nov 2026 19:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338886;
	bh=dxbek0+Ruu7pCFTdBsZVP6NxZ190pfxHAYsOYbBPJNI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KRZxVS+SEzXAKMrImO5CwnOWaVreWTi+mZaYLAVK0Lg80+9cHFiTvam0T4uM34tL9
	 Pz15Yk+5Q+dR/WV6zKYILHVZfzorKQdrYEMk7ToWmyvFI4d3NnGgi9uN+owHZaCIKi
	 gtH2qi4rx+49VXrbSfQKVvKwYC1AdIGAuyhfBlM3yIkG3i54gdf0EIhBl6S+ADmYrQ
	 CiaE83m4erdNXNlmfikCVgGbtGtKcYPCaXU6aGIIG3qzgp6N16rewmPN+KFQQ2OU0Q
	 kzX22hZPxTyUMAc3Ugx/gL7ISITpVxS2V+qOxcu7Lp8e9R8ku8Z8cR/9HaKZ28vqos
	 hdI0H7KwtJ5rQ==
Message-ID: <sashiko-outbox-207657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 07/11] xfs: test for reflink after the dio write
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-9-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-9-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:28:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A direct write that is not block aligned can expose stale disk contents
> on XFS if it races with the first clone of the file.
>=20
> xfs_file_dio_write_unaligned() falls back to buffered I/O if the file is
> reflinked, and tests for that right after it takes the iolock. But
> xfs_file_write_checks() runs after the test and can drop the iolock, for
> example if S_NOSEC is not set. A clone can run in that gap:
>=20
>     direct write                        clone
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                        =3D=3D=3D=
=3D=3D
>     takes the iolock shared
>     sees that the file is not reflinked
>     drops the iolock
>                                         shares the blocks
>     takes the iolock exclusive
>     writes a part of a new COW block
>     maps the whole block into the file
>       /* the rest was never written */
>=20
> The fix used here is to move the test after xfs_file_write_checks().
>=20
> Fixes: ed1128c2d0c8 ("xfs: reduce exclusive locking on unaligned dio")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D7

