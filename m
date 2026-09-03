Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C874AF9FF
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442187; cv=none; b=epyNFvrn10TM+OlED/+zTcbRlDmm33jPravi/UusgsuQmjuvFzj5LWufudnmDdOt8P2bqzDDT0SFqzzU+QQGGOjYUmsNaunfKol+d8yfdDk0YOVOg7KpbzZoFQfYEmhmpOYzEzrJTrMa/U9OlgoH7wkRAPaw4NCgR8EZv7n2Vio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442187; c=relaxed/simple;
	bh=LTjZuU/CDab/YfWEuKWrJhNCJ0+OGsDXAti88xYwzkQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pGivVlXc5NKh3OkT+xOjalNDlYWz08WqSTK2AZIpSWNNrOY0IhQqaC3/MJP4rOjaN/vU61J8cjYhFSDOwSikrI+oVW5UNivxvMHMkHNWXBuUlczJQtHaYl3svnC1nmxnq+ww8PhHsl1WESk1u4TvwnShyb5L3B1X4oFoJX9UEs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ub0ZSdZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ub0ZSdZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE781F000E9;
	Thu,  3 Sep 2026 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442174;
	bh=LTjZuU/CDab/YfWEuKWrJhNCJ0+OGsDXAti88xYwzkQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ub0ZSdZcoVKonKXmXAdx8LinWbg5WqTLEhUahxZv0asCXp3gsrn3BhbMqxy/hv3T4
	 O/Yqwa72E5kr5ZbM6opTKiZAaCK+tb8xz1Fj8hpOxIGs+JyKfb644aDlL1BOe14mWD
	 rs95EppuRhDX0xfYtQXwWBRV1e34q5gX+f4r4JaKZrzkQQk4QRO40QbcCAcYhjLiVu
	 fa5WtyvWoNhpyUn+qX9mwxnMeVmYPfRW1tjfzxh7Fp40PJBNAdLmXPhcMaJBc1+z14
	 Mev4G5typCvYE/0TyWEYuq+jXVvpPiCNjr1URvXJL15+G4kxR9C4cxRtAg4sDdZ2IZ
	 JUDrP+BuKJrPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 16/31] ext4: implement mmap path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-17-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-17-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:29:33 +0000
Message-Id: <20260903132933.BDE781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce ext4_iomap_page_mkwrite() to implement the mmap iomap path
> for ext4. The heavy lifting is delegated to iomap_page_mkwrite(), which
> only requires ext4_iomap_buffered_write_ops and
> ext4_iomap_buffered_da_write_ops to allocate and map blocks.
>=20
> Note that the lock ordering between folio lock and transaction start in
> this path is reversed compared to the buffer_head buffered write path.
> The lock ordering documentation in super.c has been updated accordingly.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D16

