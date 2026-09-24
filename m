Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE2246EC7C
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 11:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247725; cv=none; b=Nhl5AwnZB9OsBNZQR4zfVUS4OqKu/GdqOjWTfcfFKZFrCtWRQEAetNyaN3BIMvPNHsVAGHGEyJAdRGlyr6dOaYYrIoEFxsSKQA2KWy/gweDda+Js3pA7X43nmM2xCJb/xV2K6MbZgZyJ7P5G56BwUf2BDNvEq4oN8mLU2IhpMfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247725; c=relaxed/simple;
	bh=4nyTzDa0JflOlapoyIF5L5eQVkJFnmhRj2oh4rpwlEk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qNUlAurMz37P/sv/L/6PICAM4xm7z2PefM79XpQj4PQdCXdq65LW4KlN7Y2ZyElNssqrV7ZdrzgRgAydk8nJQCKfWCNf7YrVYvaS+YeI1dOzDfC8nQcKqLwpnJEhVdbxK8NW+jYI+4KB/GdhHhyvgbW08r6qJJZnEJxeeBbcuJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDDuagjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDDuagjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8111F000FF;
	Thu, 24 Sep 2026 11:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790247723;
	bh=5DTA+aGyUjMXoSkq/ghZDS/W1NNrULpzprLt98wCc7s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dDDuagjLZDfASq7VLXJIf/F/5tuGBxUBhuOxYStmPS5YNlz4w/E/3/7NsfevcpQhy
	 uCXj3TzVVcek4ui8LKJ31b45oBr3X+iBVqsnQQhjZZS3RppdNHlDkcOOUc8zwH0qeG
	 ulLTuQRPUC8Qt1RfziKrxLmXNxSjKjx4nGGmvxhTbNLcVGYn35hRZ8aa1LwQuQkm64
	 XPSvysPGtgPCWgep4iOh9nH13oWNINLBK0YjsWR/UINWH32d3dMBcBkZ8nY2EVHZMX
	 gDM1yknNrImia4oAALSeHNkNny4tAzVVM9UWd/PktkJ/mgzBMv0HaOCe9pqFddgvWC
	 s9pVY6nyysA8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260924105125.577714-2-yaojiale02@163.com>
References: <20260924105125.577714-1-yaojiale02@163.com>
 <20260924105125.577714-2-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 11:02:02 +0000
Message-Id: <20260924110202.CF8111F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924105125.5777=
14-2-yaojiale02@163.com?part=3D1

