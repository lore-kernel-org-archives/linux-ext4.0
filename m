Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880113;
	b=SR1jmfMGWhXSd/alWuHtY2RJGgSHGTDq7260/p222k5jiuHiwQHsrdVdnZKWFz5BKiQ2
	 VqRC8ri1w68e9p0ThQXVLFmlecQr4FGVQT8DJ33zz2Mnzs0HsyRhF9EncPBrzJrA0n0gs
	 Ads5AA6/VBLM8SdRBRmbG55wbxGFgxjLJ3fuaTUeRUA+ZV/g/j9X66DncqsxiWB/zwhjz
	 xkHWkgOGm5v5M5WWGXEM+dPnjTOWiv0Mtp1IMvXVZHeIz+9f9FNHvKh5gzsX69E6a0EK2
	 ZASeEGD1N+BJiBbSBwmE+Uz9pjew1mFJMTl34uPcN59L8jPZQmzWJJJKMLtKGOusSfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880113;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1kh3k6aMqGTsQaqUB7ASZrbf1baX0RqEDBQzsIHmO/A=;
	b=3251WFVBp8NLCY9XBPyqw8VwAszY35usX+iMorfK/sG+2+kdfLnuPdNoaOfnvbUHxCIH
	 4k6x1WDOVx8Qya9OPAFsX/ROUnzz098fPbLv4FkGdv4wBJX7aEY4KpkXMZQuR/yzjwfkn
	 rpsDRDpK3jJgHJi/BEOAq+VrARbdelhJl+VqhJVgyzv/LcDvTZCsvSzdT8BEfpsMCKYqh
	 oLwLViF+UPNer57ssd7y3jtqNjHDSBPktVxHs/D+ZGnKZIvc89SJqiqDebizuhUirfh83
	 bRYFw6/s3udt6kRGiQJOP467HGMpqTAReAEloAvfoiG/sM2ka4hqnSrHWnbho1NK1pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cguM5kn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476A2606A33D
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cguM5kn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDCD1F000C1;
	Thu,  5 Nov 2026 12:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880112;
	bh=1kh3k6aMqGTsQaqUB7ASZrbf1baX0RqEDBQzsIHmO/A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cguM5kn9+Wi3r8ZarJhDkIERZP9gaEBeF7Hc70tIZNT06Yv7TFtayNubvANlQiEcf
	 yZz+p+fKwXovlX8SzmmT0wjCBnZnR/ajXY0zdyLyRDJ/PFPdBNdjxpDRzoo4glLcTE
	 yjog1eeWiddOX1MrWFJ1w9sg/6mqrzDPbkbTi9FE38il8j1NIynOvjW949Wcif8kM5
	 I3k3W2OFqvW4WOUhUAq9OEdtx9YYrE7Khn7vsrRWaUiXHWKL+uUky9MaUIxps2gQor
	 hOM0smm/Jy3UqRPKJ4HDxHeIBjTx17yExeVc2NQb6JLhTjxyDHNOhQm5BSOKfYv0dv
	 m3AdUi2eKMEqg==
Message-ID: <sashiko-outbox-198984@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 4/5] ext4: use I_VERITY_BUILDING instead
 of private flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105115532.613467-5-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-5-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:01:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the per-filesystem runtime flags that
> duplicated this state.
>=20
> Replace ext4 own helper ext4_verity_in_progress() with
> fsverity_is_building(), and remove the EXT4_STATE_VERITY_IN_PROGRESS
> flags. The IS_ENABLED() guard is fine to remove now as
> fsverity_is_building() has stub for disabled fsverity.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105115532.6134=
67-1-aalbersh@kernel.org?part=3D4

