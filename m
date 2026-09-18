Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C1D476CC5
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731118; cv=none; b=kEvcFQlBgjM6mmqr9ffCdgn406+cBUy9TsLEsdg8nZrUiUlWRtcHhB9O89PiqkGGE4YtvA4nWGXKeuG6zy0gNMo2VvLRDg6hJWlKz18a3750rAMmnaysTbkkgGbFPTAjMCgUZ/zKwoHLLVw7kHSrUjkKsvW8Ehwa7Zn2ELzC5B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731118; c=relaxed/simple;
	bh=iQAU9mMou69xS3mvuHh4PIukfNPoitPrMzl+ealrJfE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cJT8w2l8WHVEyVtLkFuj/PP6wspfhVANz4PYLy8XeCzUDbp99RNEqy13hp8p/078ZsG2N9OonCmhdaqtiOGF5HSO3UvT0YJcLGWs7YQZCSAEhwhfBrHqj9oaZhIPxyAyZNoQ/tg4fpEpdG477jWcjVHLHynMsB9yINw4L4uxEw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D4tX1hF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D4tX1hF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA921F000FF;
	Fri, 18 Sep 2026 11:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731116;
	bh=iQAU9mMou69xS3mvuHh4PIukfNPoitPrMzl+ealrJfE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D4tX1hF1rmKFeHzeKtqvRi4xCas9NCSKmjufqvFNo1n4P3/OKLIm+EjPjf9ZR57Y5
	 v1Bh8TJXJMlF9UUdFJqqEx6pjU6ueVgjSdtrTAHA/AXrKtyS95qQPMHyJOHBNeuW4C
	 beehu1VshRjQeowncmSydGqr/WgXbYtjXyBl4e3pj8n5Gb8mJzmSX4HlaC44nw4f5C
	 JcFZqKsdQ/7jBFhuOkSXDfccxJ70iSAt8jF+jh3J8ORcdDTg/Ze4AGpBIgQkQ7zM1k
	 BYce0S5qXrz923e6hbfeFAYtNq667MGyIhSj/EHUlFZn8QjmUMbS3C1Q7oM2zU3k/c
	 /EFwFZwiRgZZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 17/21] xfs: add fs-verity ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-18-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-18-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:31:55 +0000
Message-Id: <20260918113156.2CA921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
> tree pages) and obtain file's digest.
>=20
> [djwong: remove unnecessary casting]
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D17

