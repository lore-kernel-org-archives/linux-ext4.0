Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A05D48FF99
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730935; cv=none; b=PEcctYWEk3Vyw3rFKP8+iZ9T7fBY3aVA9W3AK1iiBcxIurgnqvN+P+tMlVx8l2qDpLNZf6/d1O6aNmJ7O3SxZH+y6I6HMWVu3ouGBN4LDBmorLRuz/5Vk1rZ+O2yc5SIhkSX2qGb3LY9TFqZTUv39N+3wXhpFWvDw/5O92j+qgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730935; c=relaxed/simple;
	bh=1h4/Nr8xz2CNG9UZsBFda/LpZWRaTde+tvWh67CLjFE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SyaakEziQw67vvue1D+rFzeLyy8bBZTXPA8jiKhiucfByqjgq+lU4zrBnEL58CTTJPtdVH9sNT2tWt918ljVESwV4PBQnFlPQWI4uhCCcEUr4Obmhf2NTQXrxP3k2RE/V9vjweUMypetB+C7CFaO07/fynW8ZRKxz32cArSdsDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnMT4Gkz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnMT4Gkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2FE1F000FF;
	Fri, 18 Sep 2026 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730933;
	bh=1h4/Nr8xz2CNG9UZsBFda/LpZWRaTde+tvWh67CLjFE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BnMT4GkzFdqDd3EgF0FswFM9N3AoZ950NEY9Ki+ZRalrEaNhxE2FO+i7x1kxI+tFx
	 ZsnlwxNbYPbsw7Wz9J1EWTr0x+5rrhnYgDBjQljk20QnSzkUAzYcpYHFLtpulAeAi+
	 kWTFhu1rTpNKMzt2T98YFS3nNK1FDJpZzf1DBJ8NFnfxHNMpD/fk2Y9wCJZa9stXbe
	 Xg1J24lFlPR2ZxOngXeW+QbAuA3GDddv/f4HPltV7oG9pIU2bzuZXtx0EmwZLuOB45
	 Rh/IICj9wja6xPKgJqQKdl2oK969n8QYEaWLIoI7dRsm8jqq/nZxwR52h/6gGFl6sn
	 vJVF8HlP4f4WA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 05/21] fsverity: don't allow setting DAX file
 attribute on fsverity files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-6-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-6-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:28:53 +0000
Message-Id: <20260918112853.6C2FE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> it checks if file has DAX enabled and fails if that's true. However, the
> opposite case is not checked.
>=20
> Note, that the only other filesystem supporting DAX and fsverity is
> ext4, and ext4 does check for this case.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D5

