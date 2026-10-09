Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CDE4C10D8
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544389; cv=none; b=EUQEEnc8n6Ldg1IJ9F5h4qKlnB79HGYbAoFpwQVKFz9pOI+M4m1ApHlh8FlqCYcCV7EsJhfXuHb8pLq6CoST+KoGEEIr/aHiqTfmY0vmhQH/ITHvmtWUDGPxUBiFFqc4/So0LBqN9X8ySuQsyG4fRfp4QkZuYpyHmR3cOxO+4vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544389; c=relaxed/simple;
	bh=6Q0F99Dmit74nFdrNlzX47r+AIw2WR2xAnVizEVaTQ4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QOrGud66p6ZJ81Es2E3/yaE1yAerWnM2OMCt7pmvjz2JtkwGiYUVFYbTmDixgz5d86+7ajOe2XdSxvlczeO22JHWf4KLsXqkVKAQnBTeAo5GcOhr6XYalQ1l85FU0dZNP0tu90b5bV43vQV041MUlv0d7w0NHOjNbOnAyAEtjxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCil3h+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCil3h+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489661F000FF;
	Fri,  9 Oct 2026 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544381;
	bh=6Q0F99Dmit74nFdrNlzX47r+AIw2WR2xAnVizEVaTQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TCil3h+loNdE0/TJFHsqOQbMyB3qjStZkXttn6aJiW5rk0wK283FP4gHAR/URY8Tb
	 QxLOhDx+vPW3jGie1t0XfH263Z6DeFR7+bI7RhRt2FX85l+yH0qaglap2aM1X57Rfi
	 CgXE0mk9jUgedU+bnXqvrRybKLP3a+CF+knNeywttz8ShtbKiyhNX1Osmg1ivfI/3m
	 ouZHPiQedUo+xTDYl4muLpiLwQwRbH4Xe8ghw657z5sbp1PhKlo1phgUnQlLJJOL4D
	 rWqndf4zcjfAOIZcy5UnPUEZ0bnLwuqEx3JSxg/wHsdcg9yemNZmw2AKB1AGRcierc
	 KX40050i6syuQ==
Message-ID: <sashiko-outbox-165331@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 28/31] ext4: add tracepoints for
 DISKSIZE_GROW_PENDING set, clear, and wait
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-29-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-29-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:13:00 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add trace events ext4_iomap_mark_disksize_pending(),
> ext4_iomap_clear_disksize_pending(), and
> ext4_iomap_wait_disksize_pending() to track disksize-grow-pending
> state changes and waiting.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D28

