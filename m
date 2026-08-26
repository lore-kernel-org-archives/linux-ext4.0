Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1230D28851F
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2026 05:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787722469; cv=none; b=kgnuLE1WcMcO6310wMHxv3xaqjB/zB+SSpgU46yt3WE3wdZ9C+ubJUiG19o7KhOvU7smgRAt1UUKOC1V/c66NmIEAkRocz4w4nhBCevl4UxM/hDVOtqNmLgLwYGjmnmvASn0o9lgc1gJ4gt7Eua7M7y9QU8m4bEy4fR7Cy9AzCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787722469; c=relaxed/simple;
	bh=0Bw2Ipq8VSPrOyOnbeHIIMnZMe9z4BsjIRwQt7UXT6A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JevkVFkPYK05eUi9lwvjXbSJwmJFYpbVFG2nKMwY4DzuuG8DtBQJeCy34p3iDpj9GbeOfLSvEf6TdkMjzKd9UE6DMbpLt+aWHjtjwVOOpamI4/hSMdoSfqet1pIFXhuSIZwv2jbjOMjvha88T2qfqG3z1PLBFM8qZMLSRedDYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yudc4Fnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yudc4Fnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796C71F000E9;
	Wed, 26 Aug 2026 05:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787722467;
	bh=OWWFTOg0iCcA91TPG4twNhq8wImoMTAjPIcGikMbHtw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yudc4Fnu7+AI2F5aXfVAy/FG+9dgxQ5Y2t7lRZSyi4MhKsQ3yVXc1FgMqZfY2uwIP
	 e1e/CqaLzRf1RzcX0hCv1zOvshV9AndoDpagX+nLc23DgeYomdBzmcSwAqt/WFL1JA
	 WViQRyqV30QCwRKrjbZ1QZlEkH4/RoVG2tE6tg33hVsGFq4gPVQg8yDvZD2BRaVsoE
	 AwIOia82FCmvA/3VA2eAg/tl2Rz/tU+7MpN8tNL9GSl50K5jAuh1BGruZiJ8+evrTX
	 NAi5x81c+d3j2zcTcGKmBA/Udnjf4ufQRmntXKDGX1LZaGe+oIdwLeXdTX7bysAhY/
	 81ArXUYxbNr7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
References: <CGME20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
 <20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 05:34:26 +0000
Message-Id: <20260826053427.796C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
> it reports by counting the empty subtrees under 'partial' in the on-disk
> indirect tree.  That count knows nothing about delayed allocation, so a
> range holding delalloc data that has not been written back yet is
> reported as a plain hole.  The extent-mapped path does not have this
> problem: ext4_ext_determine_insert_hole() trims the hole it found at the
> first delayed extent before returning it.
>=20
> ext4_map_blocks() consults the extent status tree before it calls into
> the mapping layer, so a query that starts exactly on the delayed block
> still finds it.  A query that starts earlier does not, because the hole
> reported for the earlier block already spans the delayed one.  On a
> 4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
> data block is at logical block N and is still dirty returns:
>=20
> [ ... ]
> Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
> Reported-by: Alexander Monakov <amonakov@ispras.ru>
> Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27=
ce3aa3@ispras.ru/
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826052446epcms=
2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5?part=3D1

