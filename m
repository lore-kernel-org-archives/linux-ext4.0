Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B422367D3
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790598443; cv=none; b=fjqCTlsC+KHLkDFmXFoTMRjbInW4a5Gs4Ln1Iir3pIltKX9Lpx40rXb4oD9kfHl/0CU0Utzx+NH4n3wNLlKGVjTGWruDkjam0TMgHF5PwHGd62IXP9aH6ZB0HefdQB2uqBjlZdvOrIapv5k3lXKv+DMMdOywK3X6r1ncNYH+fR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790598443; c=relaxed/simple;
	bh=0uDumeWeJ8vTSR7lon5amEHgllfxVev40DPqL88UaFU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M0mu307KCRF42/q4jteL9n1odLHgOm/gblj1w2iY8Ui2R87mT2vx1VAVUAIAoSPDFcl4S82swn9VuVTtJVBefVKfUYnGtvPuDt+LvO2OO0dWWB6xfSaWTpSjv5Y0qUHZt4JYgSSDS/QMMcmML1z15uSFlHOsefQ2uQ6n8jFT8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7EsfqWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7EsfqWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDA01F000FF;
	Mon, 28 Sep 2026 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790598441;
	bh=0uDumeWeJ8vTSR7lon5amEHgllfxVev40DPqL88UaFU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g7EsfqWpxfYLZ9ggAeM2LbkzX5dQCeuBacfcejcBp2dQvg3ZdpsO6y9duc6ItD5Tr
	 H4Y5+sEQ8tF4o/UbOSXRHCT/vb2bbeeKUaxAq4OfIIYI62Sm9BELZnTi2+gRbTPAfo
	 3YZHusfCYf6Vc7x8cRqq262ZBwk6iuigemMoDK2NLVSzZVP52EOog2BfW7MgmMB0vS
	 KVaX2pIqEiTiLiqq7F7uDJp6Te9ab2Y8nzsLWrBoNdZRVs4pcYterQFrD14nU50yHm
	 i8CXJgZ/kihwSHL4nKITipW/K98i/GBXHZBfLl2GT4SRJRvMLRJIEyTAqCQkrFBs1Y
	 y3yJueKFkonUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/4] mm/truncate: fix data loss when splitting
 straddling large folios fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260928120833.3440834-4-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928120833.3440834-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 12:27:20 +0000
Message-Id: <20260928122721.5FDA01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>=20
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> [ ... ]
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928120833.3440=
834-1-yi.zhang@huaweicloud.com?part=3D3

