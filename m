Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B80638910F
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991258; cv=none; b=d1E+ebM78QJDU9gZv548uzcfErfH0XRde8h8hwhCk4vxgr/iDkJIoW0m+8y7VlpROVHUeYfxiTCrI1+V3/i4MWxNPP6UJ7Fd5+Ir4FO1kLBU61LuVMgfOQYUQBTczi+foI9iVRbybrhxMI1uLTIQJDlnsAOh5WRPllnYeiqnyJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991258; c=relaxed/simple;
	bh=t/FYEeN9SYMRxzfuvOUUNm8bZlWgx1w0JtUwPKv25gg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KwTpwRi9PBvjLgr0dBzAdgOxwDQglGD5fX0hURQHq9m5LKPMSadWXbfsP9y9gGXXOkI6lMkRNao6WGlkrimFYCgdXgeOklxBYqnYqViG4IGmkdef1ltPpI7xXSbZMuSmBLZxLegURFuCeG4C5uNgEeJL7/MI4r7e3Ck/gpURZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBa3YT39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBa3YT39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56D61F000FF;
	Sat,  3 Oct 2026 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991257;
	bh=t/FYEeN9SYMRxzfuvOUUNm8bZlWgx1w0JtUwPKv25gg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UBa3YT39C0yc2/n9soB2gvDOK0mrOvBWeYxOPmC8RjsEErj2Jf3LVDM9ZO3livDme
	 9flRvYqs2PJEjypVEapUF2DpZIFUuArpa3BFqAkaeFEGKpvq2RQrSA3vfL3YIEIU2N
	 I+MNbfdriObgSlvUO3MqEGTILm1BLR3X6u2CgKzYq87jVeLXPb9tsm9+majc0usL7T
	 /bSHBzDlAStSRMUdR/TmqulChoNYGmkXMoWAnzv1oFqH2+6Qf6X9AsqV1wAjaJsdhc
	 4PYqlL+B9vsMPqQ2qvIgqPwQMVeGLkziezTlEEeDlJCdyNoRk/Puq65p7KG3fjPstO
	 YprGgc2/+nBsA==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 02/21] fsverity: expose
 ensure_fsverity_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-3-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-3-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:16 +0000
Message-Id: <20261003013416.D56D61F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D2

