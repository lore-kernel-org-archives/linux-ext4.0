Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE1C4D0CC4
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543686; cv=none; b=IhT9vQWsAqhiuDnaoLUUtJ2VrcaQMvI6x6y5xCPPvPObtHLtByVm9qMJN9OZ0GgYPjnX8wr0dbNk3N76B4CK7Cs7UFQ2LcIS4m27Xv34qYQ3LT8GXwnCCmTdiZpGKWkDWGxTwUv0RmHX5WvQ6DPcbr+5A3Nrs7v/HJ8q0+HQU8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543686; c=relaxed/simple;
	bh=WMwG//0d1cXpGHvwFHY/dwwvHa+llPzRWDWSbjcVrIM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=s0YFiH+bNnZ+Uzc9OIJrmMmJUoEJH5wY1z7cEQxQb+EhiH/EhSKFAN+loMPXWn3Hqjt+97XT3SD4toCS/nHIQ4S/GuRrialnKcyAB1e2V/KEQgbTv0FHdOX7dYbUy6FqsvmsW0yxYoR1BfgsdxLXWmvOxLXfJCXwWtgzCfR4edE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlcWKbo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlcWKbo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA4A1F000FF;
	Fri,  9 Oct 2026 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543680;
	bh=TCvUsPEY+QLzSBc4F/BeCKTG8E1nXt4loK+NBCX1Fss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SlcWKbo6eRyUkxraAfRHFINaU6cky4dPkYQZTk7I84yfnSPaoDWgyhr5A5ovLfOJp
	 BoPw6x+LMhwuGvhMkm0Cg0l/dNFjMCgCL5Zlh87fPpjhDpoLttMbuZI6c7fjV9UC73
	 ict8W+W668v/oYbOSHuOv0zPgHKNqKd6tQCJ560Y1BTrjhBHyasngtBQBCtDVzutOX
	 LLO/bGtzQff9nIExyhGcm0031Y2ux4ur7eslnWDQWXBUt5X6qKON40MgKvlfZhKax+
	 Fwl6P7hBzvI9sm24rfBXsXeUbXEHqKOSVpPJRZ6l3Ut4hCcMjScwkR3gDrejorn+tO
	 ZCL6WVAA3qsPA==
Message-ID: <sashiko-outbox-165299@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 12/31] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-13-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-13-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:01:19 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D12

