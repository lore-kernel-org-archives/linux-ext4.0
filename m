Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794447628;
	b=33TY9SsFKuUDzX576WiaVrkqf2WFCjFVVecsVX+GOHbYkXGPcjT2ftRLtXAOSiQlU2lB
	 yE2sjSrLH4MX0vQEj/gOr4sOWAG1HOxAC8W0ufW91TGsk3bl4PNFg2meinWDYLOxFXGJj
	 uL86VvpwwqmZRHn2Rb4Is1tBHKx+M2ZWZoewIOC/bEU1NK+XucRwtdJBrl3B9RZXWLEtQ
	 fptqfdn7MPz5NDlXq/SuG8eYSAifOBB/fDtFDY46NdJKpigz/v4/9GzGYiEIyoXKfn7bS
	 bmNxEQ+qdUm/Wxewr/2tTk/PCM82dCyPdgvjYIs3f41TmFuSLiJsJnC07xBooM3hRfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447628;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mhtJko3gA/lEq0Ku3+0I1J3zMbx9B5jXlyLdnESHmAE=;
	b=IIOln0YNDEA4aY6Ie7jol+uWxzdq+128bWEscmE3YA7R4Frf3deAdMNR6sjP7f8+EbB9
	 IN442SrqdbAZnDifzqafYojZWBJWMIWkv97gS8sgf+7HDCzTrwvuTXQlCM3VI5dG7Yn6+
	 QTEU0J7eSQzx3Noex0fksPT0c6dHy3Uzlsf8mDcKbeLElvsg5IBO1LQOAXgb8dBTrt/6W
	 gubIfDHLKP9DOJTzLf5tBj1t61xnoMCRBKAJkAD0DJA+0TgtBYdxmdYfX/AiPfsU43inG
	 G1emPx+PXXfgkGtIFIpT1ZH+GkW6WL3ETrG3NzIKJU3TgnxPGwFNcfBX1CCRNUF1quA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtVcgX65;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3C0606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtVcgX65
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE591F00A08;
	Thu, 12 Nov 2026 01:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447628;
	bh=mhtJko3gA/lEq0Ku3+0I1J3zMbx9B5jXlyLdnESHmAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YtVcgX65qF4RWLNNrKh5leqhgmMpCTUrf+1yd4eZ44QAeO1AaIq95xSSGb1Rwljw2
	 JmN9ET+YRoXtnoazYC6vARSKjLPZbfBO11QGWAWeknyNA5uzYBVJL7z/iNlUuPH/R1
	 c4yEShvLT9frVyowBgsolnO3wy4IXK/wEd3t6oHDUBGa/tbnas7e/JZxbd8BkC7WXS
	 QtO1NJv2IklUuRbSGHH2UAbtRM70pHCKIwVVdZjK23OladnFfsqiLY8/WNYYALOZvZ
	 XRS8wUNrrOPGrps6VTKghSHXMmO826FI0D3Y1+C0r939NUPrqbHDNz7v/S9qpuWBpY
	 BtdysW7aRZulg==
Message-ID: <sashiko-outbox-210081@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix out-of-bounds read in
 ext4_inlinedir_to_tree()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiahao Xu" <xujiahao@cmss.chinamobile.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261112091303.723243-1-xujiahao@cmss.chinamobile.com>
References: <tencent_4F47889D184C7FA2287DC2A33A52F3BE9F09@qq.com>
 <20261112091303.723243-1-xujiahao@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 01:40:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_inlinedir_to_tree() reads the on-disk dirent hash trailer without
> checking that it lies inside the inline directory payload:
>=20
> 	if (ext4_hash_in_dirent(dir)) {
> 		hinfo->hash =3D EXT4_DIRENT_HASH(de);
> 		hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> 	}
>=20
> EXT4_DIRENT_HASHES() derives the offset of the trailer from
> de->name_len alone, so for an entry whose rec_len ends exactly at
> inline_size the read starts past the kmalloc(inline_size) buffer that
> holds the payload.  Listing such an image with getdents64() gives:
>=20
> 	BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xb6c/0xc00
> 	Read of size 4 at addr ffff8880052496bc by task init/1
> [ ... ]
> Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> Reported-by: Guikun Yang <yangguikun19@qq.com>
> Closes: https://lore.kernel.org/all/tencent_4F47889D184C7FA2287DC2A33A52F=
3BE9F09@qq.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112091303.7232=
43-1-xujiahao@cmss.chinamobile.com?part=3D1

