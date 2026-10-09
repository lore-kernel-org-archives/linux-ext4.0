Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE294C6EFC
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543012; cv=none; b=X3hN4r66uk7rmAce8/b0Tzssjj+mm/hXrVsVHQktfqPjXsG1n4Fv76tdTzlhrr8vBcuQc8eG2dbObfmCp9+1keA61RiKUx2gsxFTouZJt2qHu5tmdexX8UvAYrkblyozj9GZsdsPK22ey3YfUzqs5QgFOyqQhCBrtqVsSGegaQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543012; c=relaxed/simple;
	bh=NzmKI0muqUccblTxA1qrSMRB//bPgaw+b3tXSnsQtgY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aXUZQa3ZXZ6jmAT3644quQLbe35pyvTGR9I/2bMRo9ipmEn2n6nxuIb1vHeuXPg63+n5tKNRtQ0gHz1zMS0uxdP8eG+dP4sqCKOOzZGL7uXMI/VQHm1cezFGZzOtlofEU1T+dJGB8W4RGLAz2oq1CAgrMNC3KD4928tNIeufWy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqwJdsbP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqwJdsbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8337A1F000FF;
	Fri,  9 Oct 2026 10:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543003;
	bh=NzmKI0muqUccblTxA1qrSMRB//bPgaw+b3tXSnsQtgY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqwJdsbP51y90XBh3xVQLtqoc+RE4RHWM9209XyFtb5TB9AUWxKuZ29s9/lsCisWB
	 m3HtdMQmAq4TIW9QAVDIddytQ81+vLDQhNNPA4PcmFpHS5KZftRUB7S+5QguRSpHz/
	 9EcOMlpimd72hoDJ2v2T5IOOBw+2t24vlY/0e3BxtdQs382jY0jpPsd6SN2QXBGT9Q
	 hFwXclcGs24u7pAOo0h63UqCeDxD8ZVohAQigXGLIhAHjBomtMSRvCKE+3ASW2UYzX
	 SV8OeovlhwE/f40jP2d6hfNX0iTrJS7f6ZuWE+jBAHPdFLHcU0i5G0HhEJ66bg8BE3
	 uLH5IGum9f68w==
Message-ID: <sashiko-outbox-165274@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 03/31] ext4: set EXT4_MAP_NEW flag for delayed
 allocated blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-4-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:50:03 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Set EXT4_MAP_NEW in ext4_da_map_blocks() to properly indicate that a
> new delayed allocation block has been inserted, allowing callers to
> distinguish newly created delayed extents from existing ones.
>=20
> Currently, the buffer_head caller, ext4_da_get_block_prep(), does not
> consume this flag. It intercepts EXT4_MAP_DELAYED and returns early, and
> unconditionally calls set_buffer_new(bh) so EXT4_MAP_NEW is not used.
> The flag is prepared for the iomap buffered I/O path added later.
>=20
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f95=
55d7@huaweicloud.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D3

