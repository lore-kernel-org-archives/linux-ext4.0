Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8493542F6
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335527; cv=none; b=gNK1X6opo6BuYw5tlWl1k40rMwIBkc33cS/xfs4SAwrFj6so/+VdW8P5sMSpeJa1Qdb23aH314/n2bE96m1x1vWb4SF9eHI0Mh+CptvGguy1eRv7teVprX7DIMD1BJcxq1MwMU+nQhQvAd3Lvx5bfJnuiWoebZYeBJnBXCaZkog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335527; c=relaxed/simple;
	bh=yMBUh/O0gr1s7+0bMhdt3AQlwaqUVhqAelYxhJWVTqs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cHZJzK2oUzmjYITdb5B/IASAZ5bEy4UgazBVNhMkw7oAgb1twUOCr/q5BC9UJ4Sb0TImIhxAmk/rlWQUMgu0orG+YP/7IKz3glB6SCv0tgbpARm/S8w5XTJDZxZF3x+F+VUAe3Pv0S39OBICTkGcg/Gei3AoMjmqEkEOinDByaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXrdyJ9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXrdyJ9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578161F000E9;
	Wed,  2 Sep 2026 07:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335525;
	bh=yMBUh/O0gr1s7+0bMhdt3AQlwaqUVhqAelYxhJWVTqs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RXrdyJ9I76Y7PQ+M+dWv2wSsKpJG0EsVnxpBC31cEonKqUGfih+Skr9mdQHYm3k8i
	 yzNJqmhJZTKjMgWGK+QwWqJPkWwgI2M4ib/LPCyq1UwVQ6rPBSIsmPmNMdXF52wYYb
	 mWTGfhIN7/MDBhv2jn6I8y0SRHJBYPByjzcSD57UxES/6lQHem0CZS3NMJ2sZb6Tq9
	 lu9Nkj8rpoZP323NhVVsLV2iIlFQGt91a+NCp4+nqzl30tbjHDwH4swGlSL5A6WCqv
	 F0CohrRyRQFsOwIYyKR+Wp+Xxh53Bb2YBZ2mSJaHHN0wf/98LCoPPsHhN6lRc73V44
	 GhxJyFwDFzoQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/8] lib/vsprintf: Use acquire/release for ptr_key
 publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902074805.398540-3-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-3-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:52:04 +0000
Message-Id: <20260902075205.578161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb() + WRITE_ONCE() and READ_ONCE() + smp_rmb() barrier
> pair with smp_store_release()/smp_load_acquire() on filled_random_ptr_key.
>=20
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> No functional change intended.
>=20
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D2

