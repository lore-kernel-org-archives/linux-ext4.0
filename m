Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403D341DED5
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 11:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248411; cv=none; b=MmnlDyZi+FYIdBcAdvuGGY4cOrJuuh25YSv7kwnExDJWwdmNnOsEkr370l9Tseuh5AJbpNvWVSGlhbdoNn3ApTVI3lB+vvs4qlxjjcv4CpLYqP3C0wT8H6wA41fpqTuf2AchT/eS352P/GeqtGSAQPz2B3uQ4dOgxS4u5W0iVxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248411; c=relaxed/simple;
	bh=tdav3fbLMVCGr9ryaDfLvJmVttXaXURX+NsoK8+3jCM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nHaawGSl9AyRRV/jyRh9r+G+5fOXUi7A7HQ3Ib8TatYHpAlt9g4ai4cY4s38wjEo/tomDbaiNTC87vSeDr+4b/XtfesLD0O817QgScdOxDaNW87pb48ahcVX8+IzQPu/mLVK2rHAM2pomN93jEcj1Fp5FGgfCN37PTDKaj5U+jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3E4+GiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3E4+GiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C91F000FF;
	Thu, 24 Sep 2026 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248409;
	bh=41aSsTYVPn6juJt44S++0OxRod4Y/3Xi/CYzQLjrRpU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l3E4+GiPRKYlPXZYpeTcacRq7zWyASAUIJESWsTcaEES8O9TMpZUu/TGRA2zxTZ2A
	 AyYG6JpLmGubTZot7vcXtBizb58p4aaZkq2Y1cTdW1yLHA9qXATXyhTqHUZs+BhYHd
	 ZFzWIA3PNozpgaE6XYP4Xf4jg7id7kV5FgD0OVKAQlqwTPK/3JdRSbdHqktJ93csVx
	 F9TDPya06mqlghxFHsSo5PInNpWjslIWv5InZ5vaSZFId+mJj+bAc9hs/HYIAv2vR5
	 RlEHojYyVnL8p/guo3obpe5y5XfcNXvwmaxp4h/ttlAhKj+MTlxSAKUJIX/vNoVLiD
	 xACDsk2FL0WFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260924110544.601390-2-yaojiale02@163.com>
References: <20260924110544.601390-1-yaojiale02@163.com>
 <20260924110544.601390-2-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 11:13:29 +0000
Message-Id: <20260924111329.AC1C91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> An asynchronous direct write can remain in flight after the inode lock is
> released.  If another direct write falls back to buffered I/O while the
> first write is still pending, generic_perform_write() can dirty pages
> before the first write completes its post-I/O page cache invalidation.
> The invalidation then finds dirty pages, reports a page cache invalidation
> failure, and records -EIO in the mapping error sequence.  A later fsync()
> therefore returns -EIO.
>=20
> Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
> in-flight DIO before buffered write fallback") fixed the same race in
> ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
> -ENOTBLK or a short write, but does not drain other in-flight DIO before
> dirtying the page cache.
>=20
> Wait for in-flight DIO before calling generic_perform_write() in the
> fallback path.
>=20
> A reproducer using concurrent AIO direct writes and buffered fallback
> triggered the following warning and made a subsequent fsync() return
> -EIO:
>=20
>   Page cache invalidation failure on direct I/O.  Possible data corruption
>   due to collision with buffered I/O!
>=20
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.a=
libaba.com
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924110544.6013=
90-1-yaojiale02@163.com?part=3D1

