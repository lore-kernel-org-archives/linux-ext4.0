Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E489A4078C2
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731230; cv=none; b=YpdFQoqQzAIKUt84lDlI9DUo5P3RimBMA5u1af4MFS3coxTYDnbOzZEmPtobqPMb+2VErbJJ825hKl2g/XKMc6H2bjBKMmlddnlXXTpietuGFQh49MiEl1f0UEoDAhGhXBtU8w5q9xQN8EAL+aaXDA7IxiUfDDy0gtnJeSYIa9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731230; c=relaxed/simple;
	bh=IPt01/xH6bWp4npa6vn4iNk2R4vetGioWaC5xmfHWAY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oW5SO1uHeDFQq/jRfwjLmG5ErTy9Fh8d1EqbsXBOqnZloKijU2dvpDH64EZtDAIT2FPeOvHaC2IvhWh/EG2QbAfY4XTFV9zNfFPoZ91Mz9H2hI/2sKmxk9Os7Q2Ocf8QXwWKzFgyS6tdBtYdkjcp+Z5FVeRUuRrNBAY8HWBP+R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YawkDrNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YawkDrNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969881F000FF;
	Fri, 18 Sep 2026 11:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731228;
	bh=IPt01/xH6bWp4npa6vn4iNk2R4vetGioWaC5xmfHWAY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YawkDrNXnx7UfDtD/WfiRN78Zbvn5cpjpH41BL3fxLO3PRaGscpcWnZqhutVpEyW9
	 Z7Ij6MOQASH8Ugc6/RISavYIgfumWH7KS22VwLkz2lYZpCh5qDTAtsa8gTTC0buF2x
	 qT5+ewK+39zrszVVdBKGS6xTLxcTWZZAsIWREQQtKTg0Cu3nAJY41LYiROwq25uyJz
	 z5ZSsaI246gLQprru+R16pZyhITYYgGBZKv9WiMC3KBduO3EabRWxKEfDXfzH83onL
	 f8hgg0mzcq6/TWFjPpAA2x2n4BEcFy/2eWoZVNnvW22Z42UvoTDpL4Yv7u87ptc4Bh
	 /HU0GZHW5kyMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 16/21] xfs: initialize fs-verity on file open
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-17-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-17-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:33:48 +0000
Message-Id: <20260918113348.969881F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> fs-verity will read and attach metadata (not the tree itself) from
> a disk for those inodes which already have fs-verity enabled.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D16

