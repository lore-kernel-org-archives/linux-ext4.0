Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7CD4BD7AA
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543226; cv=none; b=Bx6hFHsG8lov5HKvwkMz9l9+bqVRyhLMlxpby3ngtUIlXFs0WowL5NQgoXgExEHMV5cYlsf4x/sdrTHDluirEmHFKf5WlLYjfQqZU/pJdiNgO0rs3KRWZjw8LO5SOuGGcsjRojU3A/M14L30BORqSGiLoyBuNdO52MB1DE2EBVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543226; c=relaxed/simple;
	bh=bn1Y+BvLy0FoFXxSvWha9ZMeyHI0H0K473H8WghhzDg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KOAaKwhPA6JS4lEFe8q5Igpq2/s25A+B5affRw8wEwE1LYxf3EZk6LMSbcBSqDWSjw28+nfQgVbkFJHMaETrFlQU77ZYR+f88SD0qJo4P9kOrXDEcVyxZF4KKYlF1yKmcocDMme28kOJ00F63a3qRZi62Ars3vLm1+ZDwFS8RSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSgEmpbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSgEmpbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7931F000FF;
	Fri,  9 Oct 2026 10:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543216;
	bh=bn1Y+BvLy0FoFXxSvWha9ZMeyHI0H0K473H8WghhzDg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JSgEmpbfT14uqIuAfQMnM+z2aDaaNnnRO0T3kaNzsw/ds0QB0RnLXXrWMuuY+qo99
	 GnybBTjUMiUpmv8y1nYzFq6iI5ZY55gvLjI7bMaCWmeqkVA0XG5waUWyIe68xHAEPr
	 xsgK19cCjDE9bC5HDke9emtegwxvo+iTM2SXj+JuNmLOCamzie0rXEx/uqodx/mLzp
	 ZmxtWB2bAzun9HHOv/0K+pdOaw7limR8k9elCx9euk2Bhp8mMNhXHOU0xsYKO0xjy3
	 DHGj522dYXlbokYybS1gToIcMCzK0P1bS1aASoLNGqdwyzaTGpZuhiW2hBwrDoOxCR
	 CqOOR1baWwnQA==
Message-ID: <sashiko-outbox-165282@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 07/31] ext4: avoid unnecessary transaction in
 ext4_map_blocks() for unwritten extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-8-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-8-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:53:35 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D7

