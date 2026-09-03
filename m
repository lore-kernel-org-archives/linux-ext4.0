Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8BC4AC145
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441276; cv=none; b=HJfrCuOrTdiaSB07DlQMD/SwSFgy1qrfPIJw+RHGgt/dztGAYDYGYsaLJ9D2N8hpg+CkmSejMP0uIEddEVjmMKBa080j5C11yiizxnKanOYONydHKyjtn6Zwjy6HTOUU+6rGQTgmHfIQW03LGe+2rI6uJ/mb3feJofRZ3PxFIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441276; c=relaxed/simple;
	bh=OPqoHvF+b1l6e3DkvbNLBLHs/GEArrpR49ap64KcWZE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UTdmQi5PjtRShD1Hdo92P4xEiDaeyTUBe5TNLvCjFayEW2OwXLtxNzOi4Ln6lK2ElJ5KZ+T7EctyO+E8NeIuSY2dZ8rp2Dk998MEdKEgJVDxIx3ijpZDrzJRfv/AILuNoft+x7fG5r0UpQo8s5ZnCbb7lv/J0buU8iic/lWhANA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULv0GS7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULv0GS7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D12E1F00ACA;
	Thu,  3 Sep 2026 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441231;
	bh=t1RgXYWpko1tcobvLVZ6WQu502G5fRMq9UwhscRG6nA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ULv0GS7q4OJ8pDj6daHyOKhCF2rWmIFz+MrLKiKfUGaekczGYWbM4/jX4289zRQk+
	 0rG7Ft7L3ZskQyjHkjRLXhQfTjYD/dBJfyUQblOxseqsJNUc5gwp3XyxNRGUPFdpzv
	 ZkiQvKw1w/XzVu9NwptXP1TQy4zdqjvipymUcnbRw6rKWwlTEKYaK2XbIAge+4lfKh
	 kL5cVcGcA5kkF5PhKYyb6mIeHiyQbgdpoE8uJBg1mptpMOTyQQAdJVzhDnI45PHoi7
	 yfI6davOBKuaOVxlaaclhIqftuBtO94RNZUvzyUVYT9pKRlkNuFIa8GZagV0dfp+Gz
	 4X5tJdlwjqdaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/31] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-14-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-14-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:13:51 +0000
Message-Id: <20260903131351.9D12E1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The data=3Dordered mode introduces two fundamental conflicts with the
> iomap buffered write path, leading to potential deadlocks.
>=20
> 1) Lock ordering conflict
>    In the iomap writeback path, each folio is processed sequentially:
>    the folio lock is acquired first, followed by starting a transaction
>    to create block mappings.
>=20
>    In data=3Dordered mode, writeback triggered by the journal commit
>    process may attempt to acquire a folio lock that is already held by
>    iomap background writeback process. Meanwhile, iomap, under that same
>    folio lock, may start a new transaction to map other blocks on this
>    folio and wait for the currently committing transaction to finish,
> [ ... ]
>=20
> Online defragmentation does not yet support iomap; this can be resolved
> separately in the future.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D13

