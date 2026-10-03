Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D96380FD7
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991253; cv=none; b=NJYG+n3B62S+ERzgLwSGiyB5T1E12cwF5J82vGdPOVD1GlgX7vyvKi6LbgN6TGKSVM5DhxyycefrPQUNXJ6vnN71H2kwelWnsV2tgtyYCbD4Ws1TLqc4ODAA1a2iLeoZGH7Ic4OEL00YrhFK97V1/t/GgO0Z1K4wNNJO0WzYkXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991253; c=relaxed/simple;
	bh=RGiHbsQAzr00/PQscUywtgDahe38a7wI2DyeGVG0f0o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B7ZJimnn5dYaxdNWHfni32Le0D6oPzdDFUFjN3SV5hXXZS3IIFzI5T87I+nzPVmNW5ZH6Tinpn4dPr3Mk+AjuFlFoqONg8d/MUjAJZdbdxygZpp28bTUua46pI10SMmerpwK4cdH7VGH2nhEKMCoiFW9Gldi0gk8yM4Prz6XUUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNHigDoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNHigDoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056911F00898;
	Sat,  3 Oct 2026 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991251;
	bh=RGiHbsQAzr00/PQscUywtgDahe38a7wI2DyeGVG0f0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oNHigDoYb/QGI8ydcTun/TixDHMKY59MDINk27dFzvyTJnAtoHxfGRIub0uNVPoql
	 xwXSVkq+YmtwGwecaMNgTy9ETWmD77561KCQo72DhQg9uLiHXsZPOGSSW30ix+e3wz
	 PCqybB624RfDmGoWZ5A60oj+ChUP7c9AMH3vkuIMz+1VEZEp+4SsDSifGvO5cgis2J
	 zk+w1imKQktX3iC8NS0gxC5aTa67/H3R4cBvJwyYax6BSK3Y/u0KieozFc2ADx/pU3
	 e6Damsy1afWNgm6/PdVe+XKHrN4x/ottsRt3nrRcL3HE3nJWscS4puudE1Dsuaiot5
	 cWTLCT/7qkGMA==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 01/21] fsverity: report validation errors
 through fserror to fsnotify
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-2-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:10 +0000
Message-Id: <20261003013411.056911F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Reported verification errors to fsnotify through recently added fserror
> interface.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D1

