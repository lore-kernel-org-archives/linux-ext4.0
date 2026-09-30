Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FB9359A99
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776434; cv=none; b=OYHnniEdz9VmQFCrnhm+qvL2fMptFps5EiOoEOEewZ5Gsov7VcSOVTejUr9cyrprj99TPNIU2y5OIEDt0bRGdyqBQxI/XB6xWl2wK/7e3/a95Z+PL+6XNuYiOJ1taty9zk3GO7SudgoJSf+QKQVNL8m4Ay26ebwEOosLVHG9kM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776434; c=relaxed/simple;
	bh=MchVN5hDoP6aAW/XKRsEo6/J9GnNB7pMSXrT1qqxQ0s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A/A6eLkrXCc8rv+HU8IwZtKCTzLeTmwa/zgClSU7tGCsTLDVEXKc9LZqoEjCUXcqMnhnjB/BlLt17z60lcBqgtcUTk61aTxcYTpIRlvjiCEixUeIbwNIPTdJuMzkzC34b9IuyT2Ec8hPnYJNUerQg6Xll5akGl242N9eRv/1DHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRQjeYoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRQjeYoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C351F000FF;
	Wed, 30 Sep 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790776424;
	bh=ReYRL0kO9qi5CUxqDHSIzbtb0BY7LQ++1UQOBz35joM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nRQjeYohPgiXqJ1R6R0nHVG6PcSKH9TNmQqN4cO8uXQzYwXJVeSV6JYDzBn+30q+u
	 oPnZerIdX1P9XiG94RiNqDrN3tjfD9jpNaN55pqOWUeClJC3RRlqRwUBDrqNLwZtbd
	 Q3uSYeaC9hvf8S+gTLdWEcTFEDdcyscNbx54+nCIo7SeR7whEl9LM7f4V5ldMrP31A
	 q6LvwTmlsA4swjd4ncmBpDZi1b1AEjJRhwmTn31p9ij6Lx5Lbc/omj0q7mGC4Jek2i
	 jH2ze7i4HCYaGkYsLt+QuZ9R2zh6d9+qU/U35K4WszTgB2NFbip3/tsO5Ov3lywnkG
	 8zAjBKV9IFCww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: save converted extent before merging
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 13:53:44 +0000
Message-Id: <20260930135344.77C351F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> In ext4_split_convert_extents(), merging can release the leaf holding
> the extent pointed to by ex. The later extent status cache update can
> then dereference freed memory, causing a use-after-free. KASAN reports:
>=20
>   BUG: KASAN: use-after-free in ext4_split_convert_extents.constprop.0+0x=
b98/0xc80
>   Read of size 2 at addr ff11000002547034 by task fixture/65
>=20
> Save the converted extent before merging and use the copy for the cache
> update. This also avoids using the old extent slot after a merge with
> the left neighbour.
>=20
> Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
> Cc: stable@kernel.org
> Assisted-by: LLM
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930134516.3977=
54-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1

