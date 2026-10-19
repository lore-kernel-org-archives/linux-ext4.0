Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792421633;
	b=2r+qa4++ud/FtmgiT4ZekR+Pf7N89Nyep2UtrPh5PAPniw87mdzlRQa41YIV/JA9Gy88
	 8InKpgVY3+mvYlG4lCg3SR4hBYDNIQARp2V0fhjFfeeq1euBGuhWJJ0QV1ST3gNXKHaiS
	 dPhkno+1s9FhRh9FWKFFm503Kbe6eUTTYU6SuVSHEC6EQdgbGXgzjQI9oKYDvGN1LdGmZ
	 PhXe0xLv801bffkPSKPcAg4e0vfyLXTHiFN6Es79SATvbdbHNC9J73r77hH2nBnsmP6Zl
	 y+Dc+bbncm2ggnvXPhFWWOlg8ndyNZ96WCA/eZFdyXJM9BKDzrX6jBoK5y1ewasc87g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421633;
	h=Received:Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 Cc:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 Date;
	bh=UgJMo3qpGD9kU4mIVBRvnMHIva5udWLniAQsgSBYgVw=;
	b=NxzyfasTU48qwoYueEKBZcquu7htEt71pTSbLeDY9UK0XPZgZ6oVfvNG6mL9X72b87Rn
	 NpUBFyDE8ovpDN/sYCaGj8udzWqSdClfyAkbQXRKFiDV3O6qAigV5ChV1sGBbnfCSIuL5
	 Quzfhx1I0TefgZXJLeTarKSui7cPiRGBvw+64Ua8++IHjAOMtyfsO7JNSpJCRrY0bsCHs
	 VgECTLgwj0Cz1psF76EDsjo9amHBmRpN+g/Eedai2SAfYOuuuwX7ripbITC8L0fbLJ3/0
	 pKbn0oSMTb+YpXUMqGO2cnASPq/YnFgMzwRJfe/tasgNW+SuhBXEOcE2IYdGalUIV6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJnXKN8F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EDB606C169
	for <linux-ext4.vger.kernel.org@localhost.mlmmj>; Mon, 19 Oct 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJnXKN8F
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13926513F6
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421633; cv=none; b=WtoZphoNitI6DarWJ1SDxX4jnS1m/oYuzv6gMGyqc6ukgG/usu37+gH2pxgb7wNshQOJ0qqGEwrB6u/s6nIABD7QshzlXDHQJfD41cQo83yaj+tdD0hCFVd6utrE3BMMqhyTeilAhsyiu4bfXE7lQlc7FwFTIB9X2/GD+4rXCoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421633; c=relaxed/simple;
	bh=UgJMo3qpGD9kU4mIVBRvnMHIva5udWLniAQsgSBYgVw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=du9tJ4kH2LlLZwHdv6ftVcQLyl1s+99yl58w+QiLR2ZDqCzdcHKZnRbp4DuEA1pdpKUjEKXZO6v2Xl/tU4s2bZY2OcSN5wNBtl4q1dIaeLjSAyHAsAIy283sMVsrf+KSub0lvll2Y2ioZdYqAbp91Ybzuc9Pr8wfpNpH5N8k+pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJnXKN8F; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFFD1F000C4;
	Mon, 19 Oct 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792421632;
	bh=UgJMo3qpGD9kU4mIVBRvnMHIva5udWLniAQsgSBYgVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XJnXKN8F9jzB/sHBGuDMjgrDHdNEuQWuRmdgGzXkSJ9mlNiiuMIz9r7WN/f0eWv6j
	 A41NTV+JPHpmJJg3vLGYVvzEL5BGrskdSF7LRpRRPK00xh9WgI33rLAr0bNLZuEfQZ
	 xnmi38B3FlBkIhAHNWG4wUQNsgth5rfv6+GnH7CHrpAknMN9TdO0pDiEDrmqRZUfRV
	 taX5BytFaXuut9zcQSwTBSCB5G+f/nLGo34d/LwND5m5DQpUHoGGWhRubbtMHK3mf+
	 N0bw3VPX4EK2EpPuuyz8CkOiYZU7BFlMT8R+zSnZ4o5OEtjMXNfg94aPIF4hyESOoo
	 OLw25JCEOYL8w==
Message-ID: <sashiko-outbox-177541@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] ext4: guard against NULL s_group_info
 in ext4_get_group_info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019135441.1420968-308-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-308-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:53:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Junzhe Yu <junzheyu1@gmail.com>
>=20
> [ Upstream commit 8f3901fbb40745046e513226ad84e8b84492632d ]
>=20
> Resend: previous attempt was rejected by vger for containing HTML.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> ext4_mark_group_bitmap_corrupted() already treats a NULL return from
> ext4_get_group_info() as "nothing to do", but ext4_get_group_info()
> indexes s_group_info without checking whether the array exists.
>=20
> During mount, fast-commit replay runs inside jbd2_journal_load() from
> ext4_load_and_init_journal(), which is before ext4_mb_init() allocates
> s_group_info. Replaying an FC UNLINK for an inode whose bitmap bit is
> [ ... ]
>=20
> Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
> Link: https://patch.msgid.link/65c955b0-716b-4599-b925-59c2782e38b4@gmail=
.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-308-sashal@kernel.org?part=3D1

