Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554699;
	b=eSW/K8qD4S5lvtEcRTnNdqiJBmowTZXVuCaJhVNE0+hpMp3lT9xQJ5Wje9fBUmZ5/m0U
	 yujipKSe8zviOnEpjcJWnv4GR1jdQy/Xu1+gXczyqMpheNN409ItHn7qsWKb2/3eTsoQk
	 riwkyS08H6ABZtaLcG3+P/xyI/lho2Rf5e3UJwQ6DiKS4L1iniSBtkzgOyr/ml5ssab6N
	 Y/2wV01GiQjOfg9UwMh3dNSx/AUr2j8WFfy9rmczDJ0NG6V9uhB/xzJCc151BB+8qooeK
	 VtFdNBhtWQgBUV9Wo8Be1cbMClcb7mtS/3cCQF4mZW3a00ZgEsEuYT1KdDG+R1Ie9eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554699;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UYaWawqh87gkzJg25vF2jzXO4ZYIxfD3uNr+BCICtN8=;
	b=Zk9YVEjvhVJSfXP8VuQxtrYBiHL0cVt8OeLA55se3O3uHM8UZLK+2mC6SAi1DUgW0/67
	 vHsBs1UJHTZtXekPNV+h3by9mIA7Ju33HcklDK6F3CwT0/rb1pxv/nvCu/ikeTiqWG0uc
	 gA6fDTudzHx7imYuk32OFxPU5JZiLArs3fhnV89HrRTAOrqQy7eqYRcKiCscUBgzlIny0
	 nFucPEujNDQKosQpLhngSYgQ8sgmKZlXTCDmzZx9+gTn07Uvmw50lfAS2U9ERTsUK0KLV
	 0mPbDvvcQqHCIe6UpCDzNwRDVoNPIVEGWbUXhAQcy8eWEDmBXrGRnNFNnYFggG7rIVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SW9UzDOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248B606A321
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SW9UzDOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0161F000C4;
	Fri, 13 Nov 2026 07:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554699;
	bh=UYaWawqh87gkzJg25vF2jzXO4ZYIxfD3uNr+BCICtN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SW9UzDODf407+P8cFxf/IYSBiqXwO9OZQ+1dPnSmWl/yevWozILkjAqF0X88mZ6CF
	 nVEjZN9n55yM9egkxjsjlrKsMOo5o5QvkiDQbgSsU5320o7o0gRhvUFjV3f7eCKdB+
	 oPgm8DzSIBEnuArlGxRQ0QBQoEDxX0BTiS6f1ROJFW2anlHZ85tr1GxkGC/gBrHY5e
	 MfGiGHbkCZzbRgAZtuzil4hgX18HHB3ljE9cEMrfWEgmnEmDScMMwdM1pjLhrMP1e7
	 0t2tYXO1TvgkAJyQ6Y8lkG9kFYxDZU6oLcWz6ejl3xm4kMoxRPXDipMwRbJ2XO3zh4
	 fXmofRoxydvlQ==
Message-ID: <sashiko-outbox-212342@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 1/8] block: factor out bdev_init_dma_buf_io_ctx()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-2-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-2-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:24:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Nitesh Shetty <nj.shetty@samsung.com>
>=20
> Factor the checks and the driver setup out of
> blkdev_init_dma_buf_io_ctx() into an exported helper that takes the
> block device as an argument, so callers can set up a dma-buf I/O
> context for any block device.  The block device file operation becomes
> a thin wrapper using file_bdev(), so its behavior is unchanged.
>=20
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D1

