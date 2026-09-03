Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619124A8413
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440790; cv=none; b=H5G2CRGacvfa/E1e0DszaD6Rbi+l50bTLoF36mq74Z2cxZ89JH2g+cHIgK8pXKYlS3+7X7OLutKrTYdyWa/2Y7Zj4sNHsJjQAQMox32JZPUrzMV3NfyFsE5lqOoil1hAMNOJ9X3Mg9K1tlezXf//r7LiZrPt9G1gsOQcf9yyZCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440790; c=relaxed/simple;
	bh=oFjrr2EUeDadSU2U22w6gjFPEaFMu8oaJzFXqnkx3Es=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WIx5IQqWoufDgx8aEjH18gmb7eCGsy+Cyiwl3Bz+ZAD9ezFPOVwDyZ8qBbGidB3KYeklAaTiOqbLYSOMyrRMUmq/A9R6lisZOHJl36zerbQ2haVgL8F/vM+HMXCd7wMi7Zz4JMzbYK9Q0FTppYap0o9jM217KgMsTTxFIXf16OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcy1dvP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcy1dvP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39BE1F00A3A;
	Thu,  3 Sep 2026 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440781;
	bh=oFjrr2EUeDadSU2U22w6gjFPEaFMu8oaJzFXqnkx3Es=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lcy1dvP3mcmP+cO6+sf3ZLzaC6jGabio7vRp7KMzbOL5e6BowaZyWrnVGAFjbHpC0
	 cXX1TvD39/eo/FYkL5kb7fP+oH9vQ4W2dWiF24qA5ntwWNhdnK1MA/hztOeF7Rz3NO
	 VJJgMZCB4VgiP0uvrzOkbzWQNIbCr4Mh/vH08K+xF/EVJRUjD/QdHpI6yFEKRwQUk5
	 nWWsNw/7ehbIoWfuLGt23ya8KwzCkt3Bj+hHj5lQEHC/yfZh03aw0QDI8yLkmQQtG+
	 5hnduWulkyUGksnoq/WbLEhnttdNgSU6I7pGfLtp7GdDt0a5wJsoXHMduNO9MmnXFi
	 1QyasK5D2ZUqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/31] ext4: avoid unnecessary transaction in
 ext4_map_blocks() for unwritten extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-9-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-9-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:06:21 +0000
Message-Id: <20260903130621.A39BE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> When ext4_map_blocks() finds an unwritten extent in the extent cache and
> the caller is willing to accept unwritten extents without conversion,
> there is no need to start a journal transaction since no metadata update
> is required. This avoids unnecessary transaction overhead in the
> upcoming iomap writeback path when overwriting already-allocated
> unwritten extents.
>=20
> One thing to be careful about, as the comment in ext4_map_blocks()
> states, if the flags contain EXT4_GET_BLOCKS_CREATE, the function will
> mark @map as mapped.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D8

