Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376616;
	b=n9XBI6B6kic5L4RhX/fUOXTkWTatw0LAap5pELqFC2l1imq9ZK3DW+Ny6uovWBQqPKhT
	 L5GoTUQPnq6NK0w1g/WQO92+620qzH+BoWySW3jwlk+4Gtc1c8VzxBdWaQ/ylKT3xqXMY
	 7RiSQQgXOLEMuGEvfM1yAtM8FslOQCWSGYMkCcpoqy9OupUFyWgbyA9otTAOHZZqy0f6K
	 GakFIfNHlZNgzniR4SDYw91i+PkyFQtNa6yKFUxkLwq5FssK0AALtMAT75C/UEYafXltQ
	 HxLpNrpt21CDv8T4zs6NsrIZBkrtB9W8d69e0TPCf38Ql3tWs8FE/lee6TjtchLMzhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376616;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YM8HwiFPJwyOwaT2a+Kb7owjI1w+V+1rLdDKqyAW0l8=;
	b=gYhQgGaK5rhtujlxfnV3lvCyEHES0vKrkt70DZpN1t9rviKcrLh1WUFVlW3RalJ52Ux+
	 TZD+GB8GhLJyCtGypo6sDk3dR4DydPS1gQvcmMLF3HQB1g4fpjO5LavOq2/LC6nkHumpV
	 RQvz8toxw6nMREa+wbfAYKZKpaINJFLynRLmrcslsNTmGPaXSEaHbX3jvNsYLFrL5lEuF
	 mxAbD7VosUhPCKvchO1Cq62nK/64fe6CjabK4gInSrTAUuJXkzBRX84ydU0fbvFmK/bf1
	 sIomUyGbDw8f1uGJX8MWHcv9yDpXCoQTchAT/zWpCtPwiWqDYWKuwFoEjnmGsS1I1Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iQYSq/4h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC860A260B
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQYSq/4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2E31F000C1;
	Fri, 30 Oct 2026 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376615;
	bh=YM8HwiFPJwyOwaT2a+Kb7owjI1w+V+1rLdDKqyAW0l8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iQYSq/4hjGn1IJYLe3eI/o6I3hss6Tt0dDW0ISogGO55X809Yagp1rxM8+67XXs96
	 jMXJzYzewpjbjHgCLew0jBBxGUaYFeDg7uJQxMesuYNNswEwEldCKtL21SoQUxvp/g
	 JTmMoif57UiQXyX++yNtfisJf4QK2IdFcTB4JpUGTI1JB2FGukSsZqhl3HK1z8gaHk
	 76yBAPjLEzp8F4lyYfJh+MDAR9bnxGSjig+ispuc9STMeFD0JJlwvAYji8Fq8CdwUl
	 i4mHRdUMH711R71OU+8jBrBjOxh8oGjKZTPBV0Ga0vvL2aGbr5ylM6G0LOnznmdyA2
	 MxCSha4jlai6w==
Message-ID: <sashiko-outbox-191251@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 32/34] selftests/filesystems: test ext4 remounts in
 the emergency state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-32-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-32-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add tests for remounting ext4 after FS_IOC_SHUTDOWN with the default and
> the nologflush flags and after an error with and without a journal:
>=20
> - option-only remount doesn't make it read-only, the error state alone
>   reports ST_RDONLY
> - remount to read-only works and writes nothing
> - remount to read-write fails with EROFS
>=20
> The tests need root, loop devices and mkfs.ext4.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D32

