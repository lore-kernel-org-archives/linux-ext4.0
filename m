Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793099103;
	b=gYgGwmRpJGpjOxYUvjkQprMkk7s1/3InCYfIEwMcLcGgaqLHxNLNHHYPS6v9QEnk113J
	 qCE9vwh5vvLHMWNR/ukaT09Sq+14PGHPTk28NG1cqFLa69Ji2d0gs6Ndyw98yKau9SZh7
	 1YHf/IfZK3rL0yPZoQlNom1o4gKCYYNszJlgePQDldG0zniXqUJxjriIgJsVyFUrkK6VX
	 BFhF8Zra9lYk0Uhl+RpIWV9Rs4poIMfHBqyQ13ierrOtbQVG87vW7ampyR25HRhpzTima
	 5xDGiIVCvj8WIv09CKeXwnJ5FXE3uEKxzwM+pKoJHHVyB+KZ56pmrG+CjZzhiFXZ0OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793099103;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6SikWFvoaCYgkbnwo/X6ZCVzUUx5/0q1DRavB/2CHXE=;
	b=meBEsmwCbqc0f8/mDCEuc34Vl6cs4nCNIuW+yFKEdA3jk+PCBfPfc1lDAXjaJykxEbNq
	 n475xat3knS3W0RmE44oMWcevtwAEuOA7L/jGgiavPlrS0wXdAELtWif6CpUYWk37fsQ0
	 O22VcIaZiMeDWsignxoNFkzD0+worVwQWKNvJkKGUY64V16rHyiepRtbUtxs5gBO7ZcUT
	 rfk2mvQ0EpLX8UXaRSSNEno8Wae5svFCR6NIUZMOuV68GlMHceL4s5Jb0nBSoiSV0CxWF
	 u8XnG5F24CROp6AweJHU+08sWgpT/xvCdQRmcN8fxkuBaovw17B7y+O5HhgP4gvBI9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDavWKO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08EE606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 11:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDavWKO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1487A1F01825;
	Tue, 27 Oct 2026 11:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793099103;
	bh=6SikWFvoaCYgkbnwo/X6ZCVzUUx5/0q1DRavB/2CHXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WDavWKO0jyhCanaBaDmLqWb9uN9PTRV4xOunEwG5tDR5+uLc/WRSQCidq5KMsajff
	 xI7pDwS0weh3DIDRbkACgft0lUj354fm6RxJPDCEEUOi6xmbfD5wLtSlxEeweRo64D
	 RS0Q8CTmosi56YKmY0V3POit1uEAu7pEifQXzanIpiGwpuHAw8tVgPUm9TK+mGzWKo
	 KvPBQd6d4qleYiM44FgMS9g2E9vU0g8XX9vTJwDJD0Ly9YI9yai/29WaUEnTxLGMym
	 /F4yrf9Cw2QEtCcVTlEGJhk0UR2H8SbX49iKFIVXjsLt+Oa8owFtzyGXGTET1oOkUx
	 Oo0Z3gODKreRQ==
Message-ID: <sashiko-outbox-186411@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: reserve inode write access before unlinking entry
Reply-To: sashiko-reviews@lists.linux.dev
To: Alan <3164729207@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 11:05:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __ext4_unlink() removes the directory entry and dirties the parent inode
> before it updates the target inode's link count. If the inode write access
> operation fails after the directory entry has been removed, unlink returns
> without decrementing the target inode's link count. With errors=3Dcontinu=
e,
> the directory update can still be committed.
>=20
> Reserve write access to the parent and target inode-table buffers before
> removing the directory entry. This makes inode-location and journal-access
> errors fail before the namespace changes. Keep the existing namespace and
> link-count update order, and release the inode-location references on all
> exits. Fast-commit replay can skip the parent update when the directory
> entry no longer matches the target inode, so reserve only the target inode
> in that case.
>=20
> The source-derived fault injector reproduced this window by returning EIO
> from the real journal write-access boundary in ext4_reserve_inode_write().
> Before this change, after a normal unmount, e2fsck reported inode 13 as
> unattached, debugfs showed Links: 1, and the parent directory no longer
> contained the file. With this change, the same error is returned before t=
he
> directory entry is changed; the file remains present with Links: 1 and
> e2fsck -fn passes.
>=20
> The failure injection and the repaired run were performed on Linux 6.12.1
> with errors=3Dcontinue and an ordinary sync/unmount; no forced-shutdown i=
octl
> was used. The repaired change also builds in the current mainline tree wi=
th
> make O=3D/tmp/linux-mainline-d135ab-build ARCH=3Dx86 W=3D1 -j8 fs/ext4/na=
mei.o.
>=20
> Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_D60E766CE07=
D3A1847B81DE9BC37B4466908@qq.com?part=3D1

