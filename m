Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376602;
	b=q4bGvIsopfmP4ocbNtvU9KPlYqx/ZmTDMRGM+ExXxFnt1AP52oxeLgPMHM1c8jxBUj5M
	 v6YFu2xNL7eeebs3XIDQ1b0ApmkgL3hKKQO+3OQ7N4149f2BhcJeB3Q+wsJXYV88nsXal
	 UXxXP+Yxs80p4mv3f6BZ4D6dW+afFp3U4wkv0Mdp1C3sdgisG0ufnpSEIgP+FM2vnCjhB
	 rN/RMEVTO3E/nvkvSrruwidkZFwSJ6iCYFNxi3NSMj+X54EFT+ahB2D6b/5qbivDT5Oy3
	 oc/ShQPEwD62jnMz0C9gU8te2RwHdUMBL6Xdxp9jPBgbxqd7MmnZfZTzcWh2kUSRWrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376602;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KB1FhbsDSM0Wt4I9Umt2kVDwdZjD4x8Yqja3SbMsYQs=;
	b=WZwGL8GIEqFhwiHB6C5FkSLC7zHbNWVpupnQADWhbHBmfJvFEyDTh09mNMg1FlSp5PI4
	 fcmQlTTNOZeH1Su/4bWUwm3IFoX9XayfDNRnddV6wQbBUfeajLdSm+X4CulxgAk+LE5Js
	 tikS6uUUMxxbpjIBiTh2rz6aQZ8A7Au7R+XH4gIHzja8H2T3tf9Ynll0ZJniQTw7tDfbq
	 Hk5kHEQQOSiTUrarCrx2ZNNf+7hPpSaKySFl156C5jF/RgO/UK1d4WLJ7TuZRAKWGaVx7
	 3bLTx9yXMrtNNH9R4r2nTahOwzlv3QqCleczAtZpeBwAWsVhK1R5X+vfObFuXwhvUvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VgOenZqW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC1160A2608
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VgOenZqW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850151F00A1C;
	Fri, 30 Oct 2026 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376601;
	bh=KB1FhbsDSM0Wt4I9Umt2kVDwdZjD4x8Yqja3SbMsYQs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VgOenZqWFFvt4YehSm51agd8DiMqRE22nNqZdL99FjFIZYiXj0Oa2y7rHtx5vt1tq
	 znLARPMEVoxnxAbemWugXvy9M1eTd1Lmij9c6iejd3j1sG1Glfa3k7Mvhd1cqbfv3L
	 I2XDcRyawCnFyRmy1dQRNWAFAs1UHoL/5PqDCelk0Hakz5cjrbq9/gXQI20tWlHasM
	 rpQiJsn54wRGE03znYnltEiCG2LqVcjfSppB99DbefGu06+wnu+a8h//NWdMZlgiyM
	 1XQtDjmVKR6q1EY/9KeHenh5NZ31CksCoahafUHKsiWjPj/riXih23Z6kbza2/jkq1
	 vP2W22PMTZM8A==
Message-ID: <sashiko-outbox-191234@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/34] ufs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-15-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-15-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:01 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ufs_error() sets SB_RDONLY on every error, whatever onerror=3D says, and
> ufs_panic() does too, both without holding s_umount. If that happens
> while the filesystem is frozen through bdev_freeze() thaw_super() sees a
> read-only superblock and leaves the s_writers rwsems locked so every
> writer hangs. It also leaked the cylinder group info because
> ufs_put_super() doesn't free it for a read-only superblock, and a
> remount to read-write read it in again over the old copy.
>=20
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. ufs_error() and ufs_panic() still mark the superblock
> UFS_FSBAD but don't queue ufs_sync_fs() anymore which does nothing in
> that state. ufs_put_cylinder() doesn't store the allocation rotors and
> ufs_write_inode() refuses. ufs_handle_dirsync() treats EROFS as success
> like ext2 because the directory entry was already changed.
>=20
> A remount to read-write fails until umount. A remount to read-only works
> and keeps the cylinder group info because evicting inodes that were
> unlinked while open still loads cylinder groups. Writes through file
> descriptors opened before the error fail with EROFS.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D15

