Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51EA2727F3
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440146; cv=none; b=IBt1Vestz/IxRvQSsK4UU0YbuScvfTjYO7MCCeiDnROhyXHK527muTEHSYfi1fqPVh0YIok3g8GBcIYTzBY9qfCdZypm4XyhTnl3pRSl1MJCU8r3zLZMtBnj11takUdjru4mJEiKPo41Nqe5Q+51ZnZ+1xbLyMFmlmFqQ96/4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440146; c=relaxed/simple;
	bh=aca1Zq98CcbB3jgTzNMmcDxXSgBepqbbCD4jgIsa0Hs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fDns63ZbtXPfTBrtB9fVNzoEcVSKAO6DYIHg87u5qql3hcX6aKdxvmedRA6htBve2YimQH0ssPYQbMtV2JRWK7hxSNS3/A8de3x1BEeLVMJpZzaBqifVLYTL1mmQUp+UpUNf6rTOhd4YTxoOUPSjsAd2IMWj70glx/1h0bTobVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odYddhGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odYddhGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB2F1F00A3A;
	Thu,  3 Sep 2026 12:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440145;
	bh=aca1Zq98CcbB3jgTzNMmcDxXSgBepqbbCD4jgIsa0Hs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=odYddhGKJxMTmz8wxORIdH/7vk1h6W5XjOpvI9OytEi6QpOWgeZjdeM54z4wzc3h0
	 NBRro4IE7kG0ReTvoFYVbvYzNjVu0F+tAQ84GCvmBsjdZWrIGFSzQPDabgN4qoTMjY
	 5uuFh0yxqk6g7jbjwBijIEY2LU4iujZpsJxYqfo79DQWPOTFABvlyzJb2FemtWYicj
	 YqZtYCBZHcEL3gB0r06BLBK19xxTdKqg6mjMikK+qWG3M/3T6r82zDDQnFN5sLNW8E
	 Id9dOWI5f8p58dszd3XLoLxj/MZwriK+KFf3NPXFhOiGeNx5ZiZA4Q/2X7JqmhmOY2
	 oK4FSOsgZ85Kw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/31] ext4: fix orig_mlen initialization in
 ext4_map_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-7-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-7-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:55:44 +0000
Message-Id: <20260903125545.0EB2F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Save orig_mlen after clamping map->m_len to INT_MAX. Otherwise, the
> unclamped value may be passed below, bypassing its overflow protection.
>=20
> Fixes: 5bb12b1837c0 ("ext4: Add support for EXT4_GET_BLOCKS_QUERY_LEAF_BL=
OCKS")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D6

