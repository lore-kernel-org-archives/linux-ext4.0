Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B82455608
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544207; cv=none; b=uQzAkYl3tq/K8rZPZoekJBDrA9MzoKkDpzC4XiIQYUjTo3ULjqLHEZhlCroViGznl8SvUZiOpyLktxsMFQgbGOKqB1JDZ/3JJUfxrzMJnoYToljAlIatVj5R2o+53oySp8igomndJ/A60BaQIe5E87IIiV0OX1r/OlFLDhkMXXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544207; c=relaxed/simple;
	bh=Y5C9acaQHMt2nYpy+3/p4/78TMoHcrQ7WTD0aOeX9Pw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=l/QEBr76zZy5gFbwHlhkV50c0/X1RnWBFrwzDmRkfPeuNNIRrcS4VhVGi1K2kyB0QWPYrEGG+gzk+sR+oUv6knMXCpLIDbsO4AbLp0+KKg14B900kF8cM+1/fYs5Iewcnb325bRjYnjVDPwES5de3maw/hKLsRBSvF/ohawAi8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6iuJv0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6iuJv0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034771F000FF;
	Fri,  9 Oct 2026 11:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544194;
	bh=Y5C9acaQHMt2nYpy+3/p4/78TMoHcrQ7WTD0aOeX9Pw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J6iuJv0okzb2u1DbIGGnLsw13geTINd6Vp18bQD7uMkmL9iS3ZbyJPmW5PMjVy7BE
	 qMNK9yyhCSm66ocmVxiUwIeHH6MwrEsNa8hVv9bE/8Kykvc0nJfnXplBb6eBqZQoTT
	 WCdWU0Q0Qr6Qw+BYMSxpMsUG95KDK2H/Bj450fOkBHAE68eoqyg7o87WSYoG8TUhPA
	 DcXR0dxHCHp3+3DOPe2SAhnLkVhRv9Fm72/furDgJ6Bo21VNh4z/ZN8bPL+NpRsYqo
	 XFg9krljErG4HH+8DbzWSdCx3vDggo3oHE+QgF1+rN4Bw26iuM3BA8NQFlaUhaD5Rz
	 BTyz/QFFrOOag==
Message-ID: <sashiko-outbox-165325@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 17/31] ext4: implement partial block zero range path
 using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-18-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-18-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:09:53 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> ext4_block_iomap_zero_range() to implement block zeroing via the iomap
> infrastructure for ext4.
>=20
> ext4_block_iomap_zero_range() calls iomap_zero_range() with
> ext4_iomap_zero_begin() as the callback. The callback locates the
> range and populates the iomap mapping. If the range is mapped,
> iomap_zero_iter() in the iomap core zeros the partial block
> directly. If the range is an unwritten extent within EOF, the
> callback collects a dirty folio batch via iomap_fill_dirty_folios()
> so that iomap_zero_iter() can zero those folios directly, bypassing
> a separate slow flush operation that would otherwise be needed to
> convert the unwritten extent.
> [ ... ]
>=20
> Subsequent patches will address this by deferring i_disksize update
> to i_size until after the zeroed data has been written back.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D17

