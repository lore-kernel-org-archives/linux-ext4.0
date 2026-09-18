Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B186348FF99
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731134; cv=none; b=s7hBsfqJUlEkJsMHI7YNGBj44msCH/C0lRHJI/06rdDkfeCGEgcTkrUbRX4yb7XpJMxGcby1l4mjLYNwTi23q6iJtkFJ/jkstiYPhZXtoC9tOhXmCmvlJctOKh/yI5qbu1UNxxrOQcv3okaBkEsfgz5MUirelonlyAOGRKRNLO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731134; c=relaxed/simple;
	bh=xkjxMO2OepWI1S4bRh2xELenISIcyEWGKzEehoxYpRo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tUoiSQ198m4vKa69jKfmy+JB86Hn5wSNcFmPGLO0yoT+sAOdgaUJHOuQ3NKz5x+BZXtU/hWoxe1tuLPRqnzznG43A4SxfNk9XjsJ1/1mrgq82/ItA64ow288xqt3rqffwY6rQ7U9r+SMuLYtDhUeDEHH0RJB/yE7NjH/DlBhawc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DY/mn05Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DY/mn05Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06991F00893;
	Fri, 18 Sep 2026 11:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731132;
	bh=xkjxMO2OepWI1S4bRh2xELenISIcyEWGKzEehoxYpRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DY/mn05ZPDgY8/btCFgjj9hbc7I+/FzGL2grnxu6o9aQ5Pd4eN0tcicrv6LRbHtAv
	 m4AIdhl8dOQMAIQi5WzTJh0bJQKA6lRbnvGpJykCjGFm3R+hmrBVvy4Mqg3LwpQ2lQ
	 bOCMYqPm+rs3ygi3x6SKUIPxWOx6PhSoRqRSdj0yj3vwlacV3iOTy9HHEEXXzjXJc5
	 e4QZAOkOovUSf/StxTr/049ADYTarpbKftb1KWlNxHzso0nzZVuGixWSA5yhOQuuQe
	 Z6uxvgqzdUMtWgOzPHhnuWZJuPBdkL7DcsUGnBY2R2xoqjvrjKSkR8wBUOVjydFpVA
	 XgUvI7wzdiiWA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 02/21] fsverity: expose ensure_fsverity_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-3-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-3-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:32:11 +0000
Message-Id: <20260918113211.E06991F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> This function will be used by XFS's scrub to force fsverity activation,
> therefore, to read fsverity context.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D2

