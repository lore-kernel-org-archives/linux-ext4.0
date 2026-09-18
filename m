Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05ED4E1415
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730903; cv=none; b=AjIp/FpDu4lFcw0ko6qtIxNebnMZGOnlNiDa2RRMzunCfJlvC8kfHt2LLyC/FNOdN3eAIzpLvklUjwf+bhVozy1ztG8SLemWKg9U4v97pG3Y/sgaUh22iNuqphug3bK0EAsvXDRLJyzk+88opossTwYSDAlQyAkQNuX8KAx55NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730903; c=relaxed/simple;
	bh=JJerGBciGqVRVvgehLcGw7ICTDWJgrD3Oz7iOiTYf3A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VGJE6JVdmlgCOiRGMvs0V5MFnKfGvIcS8jImCooghdn+vXou+2FBXhqmHlkpgaO6lguqegW9TU7U00P6oRVinLvlwQbpV8lpulKpRvWCEAwVrt73U6AsXFPV1TyhJ66UhrUzq6hFtDUZmEMojHLZ6zHv6seZbPQSu/S91hE1c9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fn3YGyLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fn3YGyLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278771F000FF;
	Fri, 18 Sep 2026 11:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730901;
	bh=JJerGBciGqVRVvgehLcGw7ICTDWJgrD3Oz7iOiTYf3A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fn3YGyLrz6UbzTmOPs2bzCF5aaE1wGj4KkS7acXc5hRUVhATQlFWIiWPqr806HhnI
	 LJvEUB+TIpNsotofqiTxTBtiMtj+ooPAO45+aXPSbWysxB2oaesR3BbvPLoWirWQKr
	 mJo/qonK7SoXH1nvHDLGYq6yJj3fvHBIxeudbcTRrVG/9v/lZ/XjTiw2my94vDzbM/
	 6lWRh3j2vkgcbMiAsdk15aKeSyN5Nzc9weLZwFOvXEQnGUnli8TJ1EK8xjpG+Z6N0B
	 Cc16UXdXK0H0atVkS095/0sz8mSzNpzU4PYqIj7ErFQTpvxKH2Zh1m9dXnNWo8LOjp
	 Auz6VOmi+bPuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 06/21] fsverity: hoist statx reporting of fs-verity
 flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20260918111539.1003439-7-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-7-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:28:20 +0000
Message-Id: <20260918112821.278771F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D6

