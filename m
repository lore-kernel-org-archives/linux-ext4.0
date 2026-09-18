Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD04447ECDD
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731274; cv=none; b=hHCBZCz09zcf8k7vpS4iOWkcJ0qYxsYiEpP4t3ZPUQncFjjb2BVPVUUkZv28aOylJYcKkeA6ZYZybKM3GxWyedXCMVLUdXvjPnvsVtPdhYytpxFqmWX6zvFzb2AJDyIT0TQe/A5D5ZntRBr6wo95GZcbTkefBOlibO1mNyUw6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731274; c=relaxed/simple;
	bh=cdE6vCpmxfw8il8sMIJAi+prYmU+S5cmeTWABvLOjz0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ufaEiy6ybNzdy7Z/WSVsb3nG0PMpcoZKlXYnHSrp9OjQbNZXOAjO6Gfp6QxsUlE7M+RKtMtXyDeOuF4LMh6sTGcCEllZsfjDAUntKayFqhL6tRZftiGnIdRmqrroUKJKxlGTfOsRfe2rUaVi/c7hxJslcXAjTwoVSEMv6ufHvoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AiG0GAFc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AiG0GAFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97511F000FF;
	Fri, 18 Sep 2026 11:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731272;
	bh=cdE6vCpmxfw8il8sMIJAi+prYmU+S5cmeTWABvLOjz0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AiG0GAFcSjH1iXu+2mJ8yUrrYHtm8HV9vq+hrhV2PGgLpXu/UmZyblfYjgRgfgcy1
	 MQKY7yX2avWHJN4uTBf1wCkL5fdi6AlqlVfkbRZgmi5TC9eW+WpBfTiOcyoIq91TNS
	 pgWI58VnjD6W1mUBrqftKTCOEpwRjqQZKcFAfoSo0IbHOhj/V3w6k3UeAgPrs0yVUR
	 N460JkM5PVb7Q2vlHz/PoxqE9x0zpx/PIEbe+HkGhz0R1Yu59d8mJFYDgvga+J7lPA
	 bcnHYf1SSwgwaDhT8V0gTwnK+jTxQWOdpB0z2G7rkdbOhEyNK8gUHwRCCrPTmIymyP
	 t1UaDaKuCCgZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 20/21] xfs: introduce health state for corrupted
 fsverity metadata
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-21-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-21-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:34:30 +0000
Message-Id: <20260918113431.E97511F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Report corrupted fsverity descriptor through health system.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D20

