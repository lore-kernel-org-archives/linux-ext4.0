Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F280A44BC9A
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703145; cv=none; b=INCgJ8cxE/WQLLeGoaMGkD/ZpGzaZ+S0y3T682aMpX1Y3kMHSenXtQ5bhhv3Z5VkuWSSWds2uEi/idEZ8xoVy7jsx/AFt9znL1rlogDrRREFFuQ4TIv5kDomskag36tRFXOtaK5tNNhYxIssVid81OxXwHXehXLrVSDlNMmAuT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703145; c=relaxed/simple;
	bh=/RTJlLTQJnxZuwqrAqZdKxWrU/VSjnkdzsI07R7IHmM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YBkjQKRJy6EHPO8Lv1MTIjAPkHxTWJk2vcezzIi4Pkq13Hj5mC+ZU3Y2Njjq4YujUsxbeJ8Jh0oviP5yU0okb3cj/XgT62K79z4IZGNBeujlkeySmz5Gk2FbTkY1CPZ7TYeZy8XM4MjEIpVrWlXZ5hU5RKVf3FUw1qs/fL7ScqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNoO+AJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNoO+AJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AB01F000E9;
	Fri, 14 Aug 2026 10:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703135;
	bh=/RTJlLTQJnxZuwqrAqZdKxWrU/VSjnkdzsI07R7IHmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gNoO+AJs31NWS/i2vdl/RxNT228wCxYfAXgMr7GMFgh8YD1LQehTK5TZaksl4Oq2z
	 64NL2cVVmTelUJxFuQ0m5keZEtmybjVO43dj3SLMdY49WQ38wIRKbYPBtWnrVc+xTs
	 47QeGg7y/F35wE98JfxadqHxbWYkRHO20LHe3KOG3Sw2z0gGFyo9QMDmD2iTmlR+SJ
	 RJoP7cI4ALJ+QSwNbo/bV+sTWXGSA2S9fpN5DoH7hL7RIIQoqhpN7DjZyd2Rue8zgP
	 q4EiRRY3VDyM259E+kOSGkHNt2M5S/G6JaAgRp3kHcUTlDVcHgfZXIQL98EsE9Uy0u
	 ITJrU9fzpZXEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 18/32] ext4: implement partial block zero range
 path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-19-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-19-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:25:34 +0000
Message-Id: <20260814102535.46AB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
> infrastructure for ext4.
>=20
> ext4_iomap_block_zero_range() calls iomap_zero_range() with
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D18

