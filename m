Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE68632
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064038; cv=none; b=TATDx+eCl2tT/TWVyTMgyFfES6MyUwDxWW6+OhcXVLGzOC+K8dGNbGMrTj/MWVz2KdIe8ztJv3DbNdzI7lUPJT8GFBVOnpGCPW+Qfx6yHoChKJWT6tp0TCZ+hiW4AMMPEyxm1occuY4gntdd94YBgs+SRjHPXyLhshA56lapJA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064038; c=relaxed/simple;
	bh=kI8ZWX85buRTkUS6QnsDW5b4DlUy3VumRIdPBV8d+as=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DqVPosHn90LWPJmWNX/MAZZ3bGcJiVSgf4YhSZI+DGHJB/LNa6NPUQQa4WAuFPOLc0xJ/W9XoFnnnfPyhJ9QGNqo3UuLTjmcX0KF/osQibReiK0CrwBVdNVh96EkcsL/Y4OPkqQ4WuoWduwdvl0iS6Ctozw9M531J9o1k+l/p2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQcB3vhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQcB3vhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48751F000E9;
	Sun, 30 Aug 2026 04:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064037;
	bh=kI8ZWX85buRTkUS6QnsDW5b4DlUy3VumRIdPBV8d+as=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SQcB3vhWzuNXnqR8BqSP6cANZ212Wdnr+jH6pbIsw+G5mncFQq+95IZ208DAHcTwp
	 quxjj3wcXA+5f3i0tNeg9zcJ7xgYupjMzyqEL5I56RFsU4veyijGpKjG51/+sR9uiN
	 7b4/EwJfyugh7jHJsloCdWeS+js/PLJbspYSD6UXGFQ/2ep2QoOVMohY09gK43SEP0
	 tWCNUw2OCFNBX1XqOtR3fdwOcqgeU7Ckh2bMz9ypMN605JdZoLGXCnyCA73Qn8bsaw
	 lKwcMLenBvzkFWE2EOoQsDkoOmLkvKtMAEhLftTNZUVi0l2LWDbLlJYlmzAmQ2XASD
	 N3r8a1wWJLvuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, "Anna Schumaker" <anna@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:27:16 +0000
Message-Id: <20260830042716.A48751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D2

