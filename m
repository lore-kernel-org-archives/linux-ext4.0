Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792760427;
	b=vNQYVLgdZqsD+TsA5x/86D44RDk0oeL7FaZjCPedmke1TXlXRfr5eUhUDlXk34HsGeTz
	 RmEpPzELgWJtTjtRiZtSa1s0Wf5qhWYfK7Qdro/BwdfCHPxVR5P/pR/++NEd8mmMNa7Xr
	 HrCoaTOQtUnhxW/p6ypYhtr3DCFKWyB5G/Yb/7v70mv/gbNRw0d/Ehu0BjIgYFkre3Rfs
	 TdRyh04l7cLanWuHfKA1fH1AvOi1PYIHbxNc39YtApCVq8zAsBGkbTWlN9cYyRJTCebn9
	 7QJfhk9q/zSeQMWd2umguy5NXp290JU7f1Y2vs4apCr1A5HGNDXhqsbhI6EIc3LnAWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792760427;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=te1RO6Z/LET/aLZd7Bq7HRZsbKI5OoQBsAgzwh0u4Jk=;
	b=ZhYFIvT3z+256mRM9dyTcrXC8DwK6RELtQNkj0MmMtiRlpFNsExGZUMcDCKDwri40zGD
	 qO/Fp63WuLHq9IaKGqC75HzJTupihYpOdg/QQKQzEwSTUBkRaXrqlIXmj8nDLidHGHivu
	 K+z1xea3OWKn4B7CBXwu4/ZrFoYbKiE+gxmbzz6Vs976zcy/PAPeQ1C9WexMvCsK9cC11
	 PzBjeUOkToocL9CSW/9QSqMOGwWQPWL+1mJviv1ha7R/lO3xSpU3lTr6RKM4YKypytWBl
	 AbGt5W5fcz6nbyKh3sktvbRNjO4Rl7CmPrqplnwGpW//CzJt1pVAkRVZAJHeidcniGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ltd5BWlJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F56606A330
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 13:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ltd5BWlJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B4A1F031E5;
	Fri, 23 Oct 2026 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792760426;
	bh=te1RO6Z/LET/aLZd7Bq7HRZsbKI5OoQBsAgzwh0u4Jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ltd5BWlJq6Yu87TObhZpPHxlmZyPDaNb/bG683B8nq7e1uRmTznwTuVdL0Ic9DYCd
	 D68dqkMQpTY620rKh87l1Dy8uTTnIdzVc48XAJ5oiuG7G41Bnk3cEyWyU/uoG+ABQQ
	 9c0wu67QIjEZdsfv/nxxgL7r4PlIN561q4ajewM6SqoeE9OZAhSTNNDu2spDk/MunI
	 MCY0AWYgSq4R8WQyfEoPBiIt1a5NCX8t+Js4A+HZl43tuP56RkCNdq995Tx2ItO/4J
	 0QbonHcDuhgSod7XyphPA4jml9x0i/A8JpbjSbFfcxHynknXQvFiQp+sHUY3bKBpkK
	 SmahwiIKkHfPg==
Message-ID: <sashiko-outbox-182809@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] dcache: don't leave negative dentries in casefolded
 directories
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
 <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 13:00:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4, f2fs and tmpfs keep negative dentries out of casefolded
> directories. A negative dentry remembers one spelling of the name and
> the next create() through it would write that spelling to disk.
>=20
> So their ->lookup() doesn't cache a miss and their ->unlink() and
> ->rmdir() call d_invalidate() on the dentry so that d_delete() doesn't
> turn it into a negative dentry.
>=20
> But d_invalidate() is the wrong primitive for that. It's for a name that
> went stale. It walks the subtree, prunes it and detaches every mount it
> finds, under namespace_sem, and here that runs from inside the
> filesystem's own directory operation. ext4_rmdir() does it with the
> journal handle still open and ext4_unlink() does it even when the
> unlink failed. All anyone wanted is the unhash.
>=20
> So d_delete() now unhashes the dentry when the parent is casefolded,
> next to the dentry-negative sysctl that does the same for every
> directory. ext4, f2fs and tmpfs drop their d_invalidate() calls.
>=20
> Nothing changes for a casefolded directory. A miss still isn't cached
> and a removed name still doesn't leave a negative dentry behind. The
> target of a rename over an existing name, which tmpfs also passes
> through shmem_unlink(), doesn't turn negative either. vfs_rename()
> detaches its mounts and d_move() unhashes it. A failed unlink or rmdir
> now leaves the dentry hashed and its mounts in place, as in any other
> directory.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023-work-dcach=
e-casefold-v1-0-1b0bd5c73a69@kernel.org?part=3D1

