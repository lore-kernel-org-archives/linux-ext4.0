Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C520F47ACCE
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731247; cv=none; b=kJMMaSdL6RvMR4RAZyeBGZlMl4sRMoEpl661WsDUuTdqVqdbbDV36XZUA6UYooL+ggzE4WwLxU1ZoKWJpV6bNUal1iEr5ur46a0nGoHup2u1psR+Sj3eNocNSytjSs809y28DOrqa5RH9PRxXCCkCL7OP/1agH0QuGiwhkiPHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731247; c=relaxed/simple;
	bh=nYfLZCzVxckN9824xkARzY7nlhH4Wi4/ChQW7Ldf+Co=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vEYBTNKfBr26UguRAjUgf/me0F4FsxECxfNKm7bnSleBRtz/TOhvkawbKAln3XYlbvFuCl2qqlSafGVHB6I0oAAFQBkPHx5BhlVS1exmHx8iPteXTwqM6wOXt/hoyK6mQbHKZ04f26oytdzE+Dv5hygtIEh3InMoJh0rLEIslbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kz0nK58z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kz0nK58z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABA01F00893;
	Fri, 18 Sep 2026 11:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731245;
	bh=nYfLZCzVxckN9824xkARzY7nlhH4Wi4/ChQW7Ldf+Co=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kz0nK58z9jpsKPb7wVEU7NOUE/3aCioNdLtkcn0fkvTR40y1/P0P4TGET5B5Wk70S
	 FAcwVVRzb/zCJcPAHIJsXoYDBGrAgzOhKxUPEke3C14BuK7J95nrvkgpRGSEzvJkAq
	 L2xdHIAjElX/CkQrak0C4rBOvj5Tsgx+2t/0+DK4sN0Yb0W38HUIaG8hwIk4vOT9LT
	 kq2Y3AclAd5oAY64ArrO60sHvByJBgJQybl3u7DryEa1ercTh8nt391s1POwE4UXSS
	 3HPmjQYzCykuI8DAUkMc7X7/t49cXGFHwUL9OtmTWOS+Adwtdvv8Lz2WEhJzYvbypf
	 bDf0toiQQi3LQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 07/21] xfs: introduce fsverity on-disk changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-8-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-8-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:34:05 +0000
Message-Id: <20260918113405.7ABA01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Introduce XFS_DIFLAG2_VERITY for inodes with fsverity. This flag
> indicates that inode has fs-verity enabled (i.e. descriptor exist,
> tree is built and file is read-only).
>=20
> Introduce XFS_SB_FEAT_RO_COMPAT_VERITY for filesystems having
> fsverity inodes. As on-disk changes applies to fsverity inodes only, let
> older kernels read-only access. This will be enabled in the further
> patch after full fsverity support.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D7

