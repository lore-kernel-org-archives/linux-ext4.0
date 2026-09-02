Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91862F6565
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316960; cv=none; b=eUL2QKU+rjvgsIoupTXP3H9K8bBcp/4X0xdqogfWybLQTsjxRu4OT4c10Fitx33yM1dRhJswE5T2ZXdTIX07pxH6VWj4+rRar4DiMtbAf2ExufsHp19DNciVkZXidpnEO3ivQfsi/o82MtV+CVnRgOKwq3YIDrQemkZYgdHgYOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316960; c=relaxed/simple;
	bh=fTeHsUB9r7Qg4wEsY1IIJ3Tzocpc9pDzBur1adRGRAg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fHDhp5zP/gV/yTb6Ej3EQaKOwKhGc/RkshheL8ulb+n0dHX/CQZbvKBfnYd/A3pV0SqZM4wxPxpelknoyfKlhWgJIVTxttwZPLf8GiOSQEjTrKWsGGcaU0CYkaR+WTkYmR8ap9DnPiwRWqaPPOBWSV5u9W0QmzzUt0VAcwM6rHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9+xs7om; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9+xs7om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719C91F00A3D;
	Wed,  2 Sep 2026 02:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316958;
	bh=fTeHsUB9r7Qg4wEsY1IIJ3Tzocpc9pDzBur1adRGRAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U9+xs7omlIUglm+btSpRIbhaCsT2HWyayrYUVxaI7jAkZSjgwG4IHqGYKX/z/DUeM
	 3P33I16adYAKKaYcdvLizJP3+b7gXrA+ULe4CvyPydXPQgwYaq2HUgtEJbf/CiEERY
	 N2X4hjsHdPrZyey3KbgBOYEqZiqOtCK4k8P9ApqcfxISUlc2+CrAH8xGWWGLemodgX
	 JDPSV+rkW8yXRj/yveBJDAm1I8YhoPM1LnaxFqfksQYIPk4WcEllcYqEFf/FirXZnK
	 2gvLvxy5zRnDVeFepQoHJx3Bl2JkYdZfc6c33WLH0O8biiZ5dPLMcLKvIr7k9nwbO8
	 egL5C+7a+OBrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/12] super: Use acquire for SB_BORN check in
 super_cache_count()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260901024234.135119-7-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-7-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:37 +0000
Message-Id: <20260902024238.719C91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The active SB_BORN check in super_cache_count() pairs with the
> smp_store_release() in super_wake() when publishing a newly initialized
> superblock.
>=20
> Replace the historical independent smp_rmb() barrier with an acquire load
> on sb->s_flags via super_flags(). This expresses the publish-subscribe
> pattern more clearly and allows weakly-ordered architectures like arm64
> to utilize efficient native instructions (e.g., LDAR) instead of a full
> one-way barrier.
>=20
> Also remove the outdated memory barrier comment in super_cache_count(),
> as the underlying super_flags() implementation already self-documents
> the matched smp_store_release() in super_wake().
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D6

