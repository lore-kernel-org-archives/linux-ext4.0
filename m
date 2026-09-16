Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61873D7D80
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 09:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551756; cv=none; b=HBcpbmVkCR117bbJooHQx+w22NgQ3EGubUWoIpO1EjgybLnp8GxkVmkgGUVlCYeTXOjXoTsf+i5w+D5w/SSoWLP9WcUH5CsHZ/JDhpFRUWeDEbWeV9cV4/2yDkIgPiRIKzdDjGh/5Mv86RxpGyjIHAvNVPwGbqnFVOInk+RYh+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551756; c=relaxed/simple;
	bh=RYGypZkvHAPSoTnSEHGuD7Zf1CWfm+jT+OFsEBjBzis=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AWuBiPPtivjpNXSwzxlm9ItSpLn/4ABT730ZPJyfJ6XySZ6ABlyrcAuRTsQxL/HJaR054uI6W2+RI10bIaibvztzevDZQ+ojzmgkvHcr8BiMtPh9fZG75wNNHAVtv6WNR4HHU/IwjDjxeRj8Lnb10dITgH8LF3YMlp7ddEXEhFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBxbYwMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBxbYwMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24D81F000FF;
	Wed, 16 Sep 2026 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789551743;
	bh=MN3Y6Y13J0+bW8SY2ZNycMgr4/HI/LIg08+gs2mPR9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XBxbYwMgLtNxNyMBpaxVZRt/Bpv3f8oAaUq5JGbI7D+x7zsKpISA0910zABlIx8cr
	 SScNvr9yWD5jZ5R1WgTGyng1K59EwUbVAo+AXn3V3s+FdvpMDJOFdDs6xxBzxFFgE+
	 jq5yfXHh3G+6VvI/+o48zwO6XbKhHO/S2e8yLAnn3mf1h6wDMhCjSpdmyn/FWJ8g8T
	 8igcVfVLWYNfh4v/Do0TfrSwCsgEgrxCpX2dceNz3Rpsw68VmoRf98IMFUj9ReKxcj
	 uAyH5NzOVQACk/BQ11FGwiqlq0mWUDjbZAAFq44AeRLZAN8b0zO6k1NmAdDYcQDGhx
	 XecjmtaiBZ9hA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260916092450.654408-3-yi.zhang@huaweicloud.com>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 09:42:23 +0000
Message-Id: <20260916094223.A24D81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> When the mapping has a non-zero minimum folio order (min_order),
> folio_split() stops at min_order instead of order 0, so the sub-folio
> containing a split point stays aligned to 1 << min_order rather than to
> a single page. The original boundaries were based on page granularity,
> so either boundary could land inside the min_order chunk at its edge,
> and the truncation loop would drop that whole chunk, valid out-of-range
> tail included.
>=20
> For example, a 64K (order-4) folio with min_order =3D 2 (16K) punched from
> offset 0 to 36K:
>=20
>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>   folio2 =3D p8-p15           # straddles: p8 in range, p9-p15 tail valid
> [ ... ]
>=20
> Reported-by: Joanne Koong <joannelkoong@gmail.com>
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AY=
sy=3DOWzVRgD4202y1g@mail.gmail.com/
> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916092450.6544=
08-1-yi.zhang@huaweicloud.com?part=3D2

