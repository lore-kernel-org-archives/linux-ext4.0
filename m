Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B731429CF0
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701866; cv=none; b=fhlIw34g9Ox7E58uN8rPBJ5T3BnS65edBsQ8ae/ute1UBnEipFprwTFpanKqxkPRwQ7q6iUsSSHNUH2/7HBF/4J7LoUFFpGRjI4d2Hn9WE2J3DmHM+c8S9OzvUVA4WaSNMKrksSfH1kOdseNAcLWMc4PQ0QLJPL41GWnV6DTukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701866; c=relaxed/simple;
	bh=lT3cqnObVqbYV3pplPJpqANq7LL4FDrbU6R0zQAn2CM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QojWNzaSiIRbobBAfoEQr/LvVxhN+GrAb6OSPnDPQrcshFf2Xj50lZSwTJCbTWKsZqudNMa4U2DhfQJJB9mwlTiVA7K/rFigbriaIksn+HvenCxZ1YQ4UsF+JV665/3aqPsy/LES4F4mmulx59waWTxjlUWP0flUbravQb8KsY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+Q3oOnl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+Q3oOnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3181F000E9;
	Fri, 14 Aug 2026 10:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786701857;
	bh=lT3cqnObVqbYV3pplPJpqANq7LL4FDrbU6R0zQAn2CM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E+Q3oOnlvf9NHhyLR8UogHn8+/UhxxKfbKAGPs5/kt9C6bWXYG9ol+jkGPvgktnvz
	 XDzsZQbgAc+SxBrs7v47M4vxmU9W9wvbAR8PqzM1O/ANvgW10zDrUCwyy046wnMNGy
	 lZu4fq3+mc7F7YNpCNt+sDdu7zcmcLA+j1KsanIn6OJvmqNjpYEx5VqvpM85cDUq68
	 BgKMPyePHU6y9t6PmrymCkrcxw8DcIsZ6wHZWd7dMVcWEzaTkpErmsDlOEMmPHjpMc
	 SbtcHWrtOVXvwXZkdnwhmE7bQDirDr6yFu4zXpNmzpFbFz29V3Etx7Q1NmDjSAArM5
	 VaEFO3WL9Kt2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 02/32] ext4: factor out
 ext4_truncate_[up|down]()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-3-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:04:16 +0000
Message-Id: <20260814100417.1A3181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Refactor ext4_setattr() by introducing two helper functions,
> ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
> current ATTR_SIZE processing consolidates checks for both shrinking and
> non-shrinking cases, leading to cluttered code. Separating the
> truncation paths improves readability.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D2

