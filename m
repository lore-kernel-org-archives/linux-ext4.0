Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26B1485CE7
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 09:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586444; cv=none; b=nlPVENPWrX+C+9mRCdJ6ENL8wt+MPAFznzCgDo/glCFnEIQ0EgqsWN+xcYd7lRypBxacW/K0svfoqBCBA6f4n544TeRUo2QdoNpBUGKSIw5sWzEZhfEJ3lmxYRb1k7Yf6AuD3YUQAwAGFq+FAxQv+yXrRcxh1/AYTFqrjrq3Ekk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586444; c=relaxed/simple;
	bh=U068mayb+xFc4Ko9PCd48nxhoik7N2C7YT+cS2/zpIM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=riR/WIkWwGhlwW3Y4FjGQ9vrk2lIILdRTxwV4u1KKepEwa8NAA+e0BYEKHzyd6nEdWybG/1SxkJk8tep+bjEzwpJAu9H2S3gfBErZT3iGlUJbAemH/whjzoLnGnLXCfD8gb4ADPRBHDNM5w5czw47aJQjuIxVximP/PPqsti+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/Zf3tIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/Zf3tIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F661F000FF;
	Mon, 28 Sep 2026 09:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790586443;
	bh=1oZIk6hp1S3qISoxUnRBENovA1F0krirQ+xkELOuq2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h/Zf3tIpOO7qRCAKv1m7tnemYUzZ9gc6gLVItFHtnBpdq/T0whxQt6mtCGtFbTvTf
	 0mDwH6sfEd9o+qIJR7ZpNsl+N00ZPMVJY2+zQPMtIh4GyZiUtoOFgqu4ZpOs1wHShw
	 ccB7bpKnJQ7jruNZDfpeebQLLPQOxq5fmfRFzkPBxAiASBSiukTSFSzxiLRdfMIQDz
	 b4Fbo1Wc9VSgQj5kRPoNFq3ybj6kV7ynzv2u0Qn/IcYif1i/t2eIfuhAsvwH95h8hq
	 hyzz39AHWC70y4/rfnd9KGJUcenJ4ilcMxR/Yj+YahdYrh3FWPZnJ9KDObrOp0Zjqh
	 lcR6xJ95Bp2Mw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260928085412.2221055-2-yaojiale02@163.com>
References: <20260928085412.2221055-1-yaojiale02@163.com>
 <20260928085412.2221055-2-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 09:07:22 +0000
Message-Id: <20260928090723.21F661F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928085412.2221=
055-1-yaojiale02@163.com?part=3D1

