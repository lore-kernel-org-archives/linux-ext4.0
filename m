Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794812568;
	b=OKdiWSfaAuEQZwX7TxHB745xHWEOgKSwnc3Cwh04BCvF7Tqa8nseKi7QUAlCyp+fG5qu
	 4KdIanRSoiZBboe71DbLirhBMDIDIOMKvtrr0zpQad7U2zneL8uRXeuG/umAx6inrnHqR
	 DYrSAJP8ZxkCSxRxcA+bih02S9xJ6ispdb7kbmPjDzxVEp0J0AfMVRn3+EibwFDVnzRyg
	 UJioPqmy2VKLdOCH406k5001Q5O1PS0tTb9yHO/zYfOYqUUWpaGTeG3hQgnuyYXTe1p26
	 sgOFzo8zB1yB3pwZz3PacZAV64fTyXjIrFw3EMA4SAEFULY1uysjh56f3lm84ammwPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794812568;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0LBnmEkE2q1/mpDaxTR+SHFwiCQx+HXvGXXyTwDWSxM=;
	b=H2beQ1U7y1u8eOgH+iFnlz3ls3ZB4iqoZ9JlugfQdpuwMj8JGaz0QyLyjSIsjbIFkBgE
	 /86cXzWRShrvmAQeBODuFqn7rKDUFPn3rBhbONuRsTd0DQ5Nr3aDk6iP48h+oe/YYo6ji
	 y06DrmbrcBq6/R3IzdmnhVaBmO1bYYaBk+GPokdjLfooMsKTLopa+igTO/Tqs6ZtqV6Fl
	 9y0qmcnd71kwRNIhykQSfXKCD2qno/eMk10JK5iRqKCZSrGdPqCy7VoDUGYSws4IyZIdV
	 neX7cpoVmloPXsUxh7XJf8VfixHTwKqcVsE6zU9fGoCAAlyNIkSc2MYr4oS9wATINqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nye7/p5M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A53606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 07:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nye7/p5M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0BC1F000C4;
	Mon, 16 Nov 2026 07:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794812568;
	bh=0LBnmEkE2q1/mpDaxTR+SHFwiCQx+HXvGXXyTwDWSxM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nye7/p5MbHfY5UGn/agAyyzl/cwA+SPT27v0SB1851PuZR/c9E0p5sSAYeA4Rky/6
	 CMvYbd87iwF3ALqBsmzyVPqyn/zupoUR/lstV7GF1Na8OBbrCVY+ZfsVJSHzFivb9C
	 TGwbQeJJ7weNtTvgIcn+WY5bzYdXd+r8vB/5b8C3oDrMleeW7MIM74atO7cXEvHegU
	 xL3+nY3mNA7sDSDwoOsXFnQmVSo0ymETkwAffboQHKxrZu5hwSj9rJZ8YHvPYpvgNf
	 Sx/0dWo5KcwZi9AQF70k6caAPhKYc8v3t9xPRTLIdOpVoULszik8lr62n860JDuCR9
	 DzbFUVWC4vVCQ==
Message-ID: <sashiko-outbox-216366@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] ext4: fix a race between partial writeback and
 truncation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261116064404.189911-2-sunjunchao@bytedance.com>
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
 <20261116064404.189911-2-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 07:02:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> After a retryable mapping error, mpage_submit_partial_folio() submits the
> mapped buffers, advances start_pos into the folio and unlocks it.
> mpage_release_unused_pages() subsequently looks up the remaining range
> and skips the partial folio by comparing its position with start_pos.
>=20
> Once unlocked, the folio can be truncated and replaced by smaller folios.
> A replacement at or beyond start_pos passes the position check even
> though writeback does not own its lock. Cleanup can then hit the locked
> folio assertion or unlock a folio held by another task.
>=20
> The race was reproduced reliably using local code instrumentation to
> widen the race window, triggering BUG_ON(!folio_test_locked(folio)) in
> mpage_release_unused_pages().
> The issue could no longer be reproduced after applying this patch.
>=20
> On this retryable error path, cleanup only needs to unlock unused folios.
> The partial folio has already been unlocked. Its buffers still needing
> mapping remain dirty, and ext4_bio_write_folio() redirties the folio for a
> later writeback attempt. The existing code therefore intends to leave
> it alone. Any new folios inserted into the same range were not locked by
> this writeback operation and must also be excluded. The following unused
> folios still need their locks released.
>=20
> Record the end of the partially submitted folio before unlocking it,
> and start cleanup at that offset.
>=20
> Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents =
mapping loop")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116064404.1899=
11-1-sunjunchao@bytedance.com?part=3D1

