Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759800;
	b=br0D9g+BR340dt4bjm14djc3Y3Fsjp9ocQDlNXFjeBhAgvzk8MGNsUhGYgJgNTcVrQOI
	 VOYUOly0LagqW3ZSpa7gu0UL+UVf1QwJallpKnBrWvcHANo02bRX5PtdfexxOvxwtVTVC
	 Siug6tV0P+mkRm4E+YAJRsQxonkonnpqsD0RWjfpIo+G+QoHxDytuzj9g+M1xyR/rxP+v
	 xNgtiHzY6IMODAhJXheVSMUxLcdhu+h7YjGJae9dJO/qF33YCWvB5UHE6pmrhkFCDQeyt
	 c2wbWYyV8l3KS0v71StGAwJz0I8MMndXiYtrzZy+9K0F62SWxSf3Vgufw3pPBa1yM1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yZMbd5CR/+MTb6YFiP5NEjCLj86azU09kOo8/qhdOCQ=;
	b=1wYbeOgJOXA7nf7c0fv5D3H4c2MQXpsnF/UAEa8sPDQ6rFjB8Iz3m4+7kK9+qsexl/ib
	 KtKLDLzp+mzEMsM5pc2GV4WcffBwzg/2fFBRtJK+vGqBegndbZ5PWIOxQVH92wyyVfzXS
	 d6M6uml2JY4Z0PSpACdLCtkHKY7/lA5IgDuBHrXH64YKwDmOIR+erxTMLjE3RfF3euNlI
	 mwIPVsSb4GpoMvr42F5NE/Q5EKPeaACGGvIVHT5xJs5Getzsxvxtl3wUYRBC4xT81IM/P
	 5y6t60VhMWb+h1Ees6rd8SF0FxFFYys/04aQ+InogYr2yMM9H5HQ1WUPNona2KUp9QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZNUWDsA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC4606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 12:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZNUWDsA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6586E1F01825;
	Fri, 23 Oct 2026 12:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759799;
	bh=yZMbd5CR/+MTb6YFiP5NEjCLj86azU09kOo8/qhdOCQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WZNUWDsAOUDJ7SdXPAaAMg6GBZ5+HmORgPQ4qh6gvGF4f7BLGbYuRp2+DAxqIIDcQ
	 FuUUB8dGedoXdBU5syy5o8y3z31pTuUlfc4biHr8D/bKqIJcJAObC7wUlM5vn41N/V
	 oxlKFRmGx4MJguC9JOGiAC18hevyRp3X7yK3su1wPkJZsgXfPFueXkHzeMnbs3K4YG
	 QVhbTAzqwfg0sk5tuqIxwy+TMj7EJhFzkmlsk2dhq1kY0qVw2/NTFdXUqE4cW2c2cY
	 HW+I7TPIum6yABQ+Aw55ZmtDiOIS/XWGXd6oZ6LpskXuPBjIRoGetT3sQqXsTzl183
	 ula7JBKedrBGw==
Message-ID: <sashiko-outbox-182796@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] xfs: unhash a removed name in ascii-ci mode instead
 of invalidating it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261023-work-dcache-casefold-v1-2-1b0bd5c73a69@kernel.org>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
 <20261023-work-dcache-casefold-v1-2-1b0bd5c73a69@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 12:49:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> xfs_vn_unlink() uses d_invalidate() on the dentry of a removed name on a
> case-insensitive filesystem, so that d_delete() doesn't leave a negative
> dentry behind. The next create() would otherwise reuse with the wrong
> spelling. But as the comment already states all it wants is the unhash.
>=20
> But d_invalidate() is the wrong primitive for that. It's for a name that
> went stale. It walks the subtree, prunes it and detaches every mount it
> finds, under namespace_sem, and here that runs from inside the
> filesystem's own directory operation. There is nothing below a file or
> an empty directory to prune, and vfs_unlink() and vfs_rmdir() detach the
> mounts a few lines later as for every other filesystem.
>=20
> The previous patch moved ext4, f2fs and tmpfs over to d_delete()
> unhashing the dentry for them. ascii-ci doesn't set S_CASEFOLD, so the
> VFS can't tell these directories apart, and the feature is deprecated
> anyway. So just d_drop() the dentry. d_delete() finds it unhashed and
> turns it negative without hashing it, exactly as before.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023-work-dcach=
e-casefold-v1-0-1b0bd5c73a69@kernel.org?part=3D2

