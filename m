Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296904AF68B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442172; cv=none; b=dfuhbvkUg76BdyOY7QWrEVUSlYxQVxvNLiP42/+B7kKgIhAez+CrO1Eaf5W8IoikLkfDkPayDnuxW/iNLeJCI/Egsmv/MNl9Kn6OJ9tTCP8OBEmgXiOLWaULWLiqJuSpyoi73cI8EarMQ2UmGYH5h8zX1KR2ZGx3SuKnFasd3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442172; c=relaxed/simple;
	bh=78d3h4leii9fYAZto8w0aZI5khmNMh/taWZY+FM7db0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d8dK8WzE/aI7IPFUs2nndP0MMAdw6zSaT5I0VEiFiDM6ZuNxDdbcxd3cjBV67kfL04W1CkL5rvq43gEv+tPpA28jU8bmV7VUbbooqp/+Sm6BvvVPh5fGDoYmu/ArcVB7Md3TDtFvMP0YrfBKP8objTQY8qVL0V6NvEGlVhPwQgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0UbHOuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0UbHOuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117251F00A3A;
	Thu,  3 Sep 2026 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442158;
	bh=78d3h4leii9fYAZto8w0aZI5khmNMh/taWZY+FM7db0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L0UbHOuYol2IeXE7/llcMuAEYzn9v0xQ+xI/sagErJ4LKuPfEFl5UiU7s6NdfXtgy
	 Gxb/aCzDHLzBb1mXYWzCBrPjhxfPly20zlAXZYDzBWncmD62hea3iCzfQ9A6OojBL7
	 DZQULnHq/h4JEPtWsvV0bpTdDMDuIDHjGqu2HMdvrLjcZk5d/D06A8ZXwrgs/h93ZW
	 ZEiQhvqPyiqe4qa0MzWFQVlUorm8dT1667Zi2uTBDhAqJMXGhkE0ZuYdVmHK8joDXU
	 Z4kegIWN7IJDknX1oZQBaOSrpbCWT0So5yy5EvsB5+C4l4PkEnhR6XWyCIyr4rm5EI
	 nCK2rWdb6R9hQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 17/31] ext4: implement partial block zero range path
 using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-18-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-18-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:29:17 +0000
Message-Id: <20260903132918.117251F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
> infrastructure for ext4.
>=20
> ext4_iomap_block_zero_range() calls iomap_zero_range() with
> ext4_iomap_zero_begin() as the callback. The callback locates the
> range and populates the iomap mapping. If the range is mapped,
> iomap_zero_iter() in the iomap core zeros the partial block
> directly. If the range is an unwritten extent within EOF, the
> callback collects a dirty folio batch via iomap_fill_dirty_folios()
> so that iomap_zero_iter() can zero those folios directly, bypassing
> a separate slow flush operation that would otherwise be needed to
> convert the unwritten extent.
> [ ... ]
>=20
> Subsequent patches will address this by deferring i_disksize update
> to i_size until after the zeroed data has been written back.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D17

