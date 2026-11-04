Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822149;
	b=ZxowA7bcrwD79NyxvtRJYdTylwA+jNRzqePOWx71hMp3bogTSJ93F0QFKxMT+AcieQZ6
	 J0D9ciOp06UoKkTBHqTyHCY34uEfKBhR+Ke3bbHaHh1DuIxnsBqcUANtfWwK0Sw6uzD/b
	 vgHSgFs8oSB8S/f2KkM8kDrvBR03G9ZPndVMi6mrRcYFbyNnCT2RHV9i/KlNO/IpIuezG
	 hva0JQ8j+P4YrhRfdorg+E2fq3BBcOSmaceIQTJp4bTAyEpfkvgZoQ6lqTUSrX4Vw+P8f
	 6YVKZIR8375vJs1NCllfLYBjCDpA2xWXF1oifs0r1c9DIqsYlSFTrfajE1Drf7YfwKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822149;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gfWY6BhQy/l5XUeviaVGxoE8/PGZH66UjzLdRUePJ/M=;
	b=pb2e8flp4OBOuY0qY5vatrh//f+Efk38idm/aoNkg8nJgekqlMLhF5NBI2sH/wey95i0
	 gHharT4fjdCYx/y/9qEYH+1ggoaRjeOIF6MHiKgGSa94WTT0Ln6gFLyn4kSy11hm1Y9Mh
	 LwRGL3azPcusaaw5UfnsYA+v9a/osbo4toqy1n/3gb0CTyLO6oW1AZw0tNNVI1jWIAKML
	 kwZXrjSuI3jRwc+ROFMDfXr8I6898XjFxlWed7KDNi1J749nsh17gZ0l/Tm98i8GTcuYV
	 4SnpIkwQ690ci9JxODM95GUtplg5+EkBxfOYv489ZHeiAxX2DIn0KNMJjqmPCiNRLwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gcDS0AZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A910D6078735
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gcDS0AZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3357B1F00919;
	Wed,  4 Nov 2026 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822148;
	bh=gfWY6BhQy/l5XUeviaVGxoE8/PGZH66UjzLdRUePJ/M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gcDS0AZ4B+5/avve+hUqjhkiRuKK2kB1egbgLjJUzxaV1GjWcX/xPyNnw4Zofphwq
	 kL8rCEF+S0oel6Uwq2lcu8deECxEwfQ2Z0yaPeipYz6yVIRn+mLrR2BHz4qWC4Z2Nn
	 luaPg34tcAQ3HssgRnO2m2pkfYI2vci/LcM2StYHWMghIrUFt/rbZkazSq18wjoh9E
	 Nhd9F7TNg4uLt8Fxs/lsJHY10ISKLRxSO1HF1JuzV5280gNp3UWYQ4PINTFto4VkWA
	 QcvS5dYpBJlqqsT6BOYhlzWCdFPFgHtJrnnEsqJC8Mn26S+VeL1kMSA9yX857le4yX
	 WmTtGs57eU1Eg==
Message-ID: <sashiko-outbox-197980@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261104194618.103332-2-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104194618.103332-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 19:55:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
> Filesystems could return verity status with GETFLAGS, attempting to then
> pass FS_VERITY_FL to SETFLAGS is not allowed.
>=20
> The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
> however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
> doesn't work on BTRFS for fsverity inodes.
>=20
> Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
> no-op. The file_get/setattr() path is fine here as this flag is cleared
> right before fileattr_set_prepare(). The future fsverity support in XFS
> would also need it.
>=20
> Cc: Boris Burkov <boris@bur.io>
> Cc: David Sterba <dsterba@suse.com>
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104194618.1033=
32-1-aalbersh@kernel.org?part=3D1

