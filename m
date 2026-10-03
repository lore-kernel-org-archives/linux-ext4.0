Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CDB3815D3
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991254; cv=none; b=DQZlVC5BGElZL5aQVph+Vnx7z0HEzYhwrXRlWJ2EsOWjWBvg+pjwt62BFN4rIE+/cxn19DI5Ajy+8Yw3k4S73tIeNB24Stx4x52I5KBpaldjXVG0cHRHyG31GISPDxtGVFJlrRWxH8e0bHzpPEbWkl0jYX4grGLd4yCGpzi54Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991254; c=relaxed/simple;
	bh=e4zFVSBhPyRgG1tEPP+5huJGBqbfOaa0lmUglEOyBiY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y+whiO0k1/4HML6VWx1MwpEfkqRJb8OkKlDnZiDImnCCOuYIuHwRpkLvd/V8ZmlfCnVa3+IYm9U9gudrjagIEXeh+v88DB3ZZGc9eAKwJsOimk3g136cIApBZFFMGnjO5JqHn1Bxqy5T3VPsDcFbQO3TuyJptOXN57LgpTOX8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GO33rb01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GO33rb01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62111F000FF;
	Sat,  3 Oct 2026 01:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991253;
	bh=e4zFVSBhPyRgG1tEPP+5huJGBqbfOaa0lmUglEOyBiY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GO33rb01AiRdSmdM4GvBik9VsDrOo0Lk52n4y1+SRSfAFOKZD/X3Uh1qrwJ2BTnPL
	 pRoxbFrQe1Y5w9r6BYnc8OG6q+HcfELEhcRopmADg0HhoFmt3sBscWKJP2lvxTKIQF
	 Yl8+Sp0r5C0J5/21r1hzYpfxNKb/tIe/3vXIVHaL1YZv5WJ3kdy41xUVVPVwTAk881
	 SF9rUwz9CdVQi6tt6Ue4NkjMGqT0Wp4ny9YcgHzhMvuSkfR1GzNTZOm1ngN/6el9+Y
	 jJ+nSTHXz7ZwEwVqw6dYlzsyCmiiHVDodg7cGq/i+FraMSM63ITLe3GbRMmCO1fFd1
	 66+jin4gJNzDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 06/21] fsverity: hoist statx reporting of fs-verity
 flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-7-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-7-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:12 +0000
Message-Id: <20261003013412.E62111F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> All filesystems, supporting fsverity, report this status by checking
> inode flag. Also, BTRFS was missing stat->attributes_mask, which is
> fixed now.
>=20
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D6

