Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD26189F43
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316958; cv=none; b=sNt2yNSMEA2l2Vh88GzRkiqAE+NVR6c0LGlNvE/d0NYTTH7v5+SnIEXaLlC/D/aZaKjUJF4yR4dR+eo4QhXh5qnAJTi/ZOyUIqyI5zDj1cLOsyJAj8ALJ37ZsI1iLWvXh6TyZacx43YC5Cnosl/MLg0LAyJo/MHBpICy5lI1tSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316958; c=relaxed/simple;
	bh=OxMXGVbn/Hjb0mFZzxZs+wSyqGgNVkcYosZAgLY22ck=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ltr7cB8BJLwBZsj0awarkFSpZxmEvJE/D5f94oT+gkgPpy0YPECye+6LHacG6sngzS/ZNgL4cFdgEnpe7QKD45MadV6sl7XVbk2DQzkTeDS47BKqZWZSc5vVtnx0MMba8toliJ7aUoiQ/Vd7BR7rfzOwyB9tfjuiI3Lb1faUCaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUgFt7Vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUgFt7Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33041F000E9;
	Wed,  2 Sep 2026 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316957;
	bh=OxMXGVbn/Hjb0mFZzxZs+wSyqGgNVkcYosZAgLY22ck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IUgFt7Vq4INacib1A5P2hdVTWFCHoP+AN8R0ptX3WF+pQy/mTJjZySrPJ/o0c6eew
	 8ANUXn5gxe1UuUbUbdGXdqHqrwAEH3bL5D5lt4il2fGl2eoObiL7PlWyZDfa2yikGW
	 wNZEBVVk6UhYqlPQYN1q4AQbXC+iCW2NYna21h0eVXfNC35r53baxCE6f8dDDK6H40
	 925j1iE2sRVsCG8z6DIv6zvPxHW/PbA/Ld6CgaVQjIjmfKqMnVcegjWITqs5YHz9x8
	 XXBctz+jJnVraq8bLz1CiHKzCZvRpwi6gNEHPvELAzyKCc2k5tMF1NJASbz705Y4Tz
	 UrrIrnQjXitug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/12] fs: aio: Use acquire/release for ring->tail
 publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260901024234.135119-4-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-4-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:36 +0000
Message-Id: <20260902024236.E33041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb() + WRITE_ONCE(ring->tail) and READ_ONCE(ring->tail)
> + smp_rmb() barrier pair with smp_store_release()/smp_load_acquire()
> on `ring->tail`.
>=20
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> The release ensures event data written before updating ring->tail is
> visible to readers that observe the new tail value via acquire, which
> is exactly the ordering the barrier pair provided.
>=20
> No functional change intended.
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D3

