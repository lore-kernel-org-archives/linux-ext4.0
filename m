Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ECA475329
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 17:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791826432; cv=none; b=hEYcPBbE+oqznwS3cjbUQZV8YoFLZDeRZQF9Cf4zZ98qhAgrf6YnG2oAghV0JQc/ruulWdPweuDTAsKDQemhnS9TKW6mTS+7xP1x+ETaTla2Yms60bniurFghx/Pr/N7pqhF1fL69DgC1qYUmsZlBlGHCQ0loQFrklbtzzU6U4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791826432; c=relaxed/simple;
	bh=xouAIUEB9hGyXB98BhRHO8tLFKWqOLJwYa4Z4+yLOGw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LpAWiTIfG28G8Wdrs2icAjik89ZrwHloS81wfA8MtnTnQvIKWELMgpJDNTgksubvC2yeJv6mQ+3PYnw9Qk6vFwpBZ3CWIwpLYoFoB6HPFVUtz81lkTj2nENVUOJzfzRV6kCwmlIotZEEJCcclEMMyir90ws8Lz2Tv53hsT0oJME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5P6hUG1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5P6hUG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3981A1F0089B;
	Mon, 12 Oct 2026 17:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791826431;
	bh=xouAIUEB9hGyXB98BhRHO8tLFKWqOLJwYa4Z4+yLOGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5P6hUG10kHzWUED627Rnfb0CRLKywhFqLCjkUFAR6rgXLQ5M33PO8p0oAg3J+OtB
	 E9XCKg1WT0RdNb/aB+3MYuhJB/FXRM5k0ueF2SHprhzAr7eek2VEFVP64wil571ai5
	 7jZDhZh+EAk8aOUX8Jz3T3f85oS+qDK6Hhu8d3/P7t0euv4Flukx+bxPsZfpU6yl0G
	 m6IqT7fhnP6vpFdu/w5/wVbArTAh+4a8DRgeRH7pSdVzTliaM9Iu2z9ApWfDbRlnPQ
	 CSSw+eRk5iO2fVsNb3NFvb9z8pCRAYkM5xvgDlmj1bo/QeDjAHrtIFR0BAFkYNVEFt
	 xq80FbFRe3OZw==
Message-ID: <sashiko-outbox-168461@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 1/3] ext4: reject atomic writes on inodes that
 can't do direct I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu>
References: <20261012-ext4-atomic-no-fallback-v2-0-c4b30c60e500@columbia.edu>
 <20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 17:33:50 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_dio_write_iter() falls back to buffered I/O when the inode can't do
> direct I/O at all, i.e. journaled data, inline data or verity. That
> fallback runs before any atomic write handling, and
> ext4_buffered_write_iter() doesn't look at IOCB_ATOMIC, so an atomic
> write to such an inode is silently done as a plain buffered write with
> no torn-write protection.
>=20
> ext4_inode_can_atomic_write() makes it worse for journaled data by
> advertising atomic writes for those inodes: statx() reports atomic write
> limits and the file gets FMODE_CAN_ATOMIC_WRITE, so the write passes the
> VFS checks and reaches the fallback. This is reachable with
> data=3Djournal, or with chattr +j on a nodelalloc mount. Inline data
> inodes don't have the extents flag and verity files can't be opened for
> writing, so those are refused before ext4 sees the write, but the
> fallback would still accept them.
>=20
> Reject IOCB_ATOMIC in ext4_buffered_write_iter(), next to the existing
> IOCB_NOWAIT rejection, so neither fallback into it can complete an
> atomic write non-atomically. Also require ext4_dio_alignment() to be
> nonzero in ext4_inode_can_atomic_write(), so statx() stops advertising
> atomic writes for these inodes and VFS refuses RWF_ATOMIC early. The
> runtime check is still needed, as the journal data flag can be changed
> on an open file.
>=20
> Fixes: b7987a7d69a4 ("ext4: Support setting FMODE_CAN_ATOMIC_WRITE")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260909-ext4-atomic-no-fallback-v1-=
1-5a6b9539c002%40columbia.edu
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-ext4-atomi=
c-no-fallback-v2-0-c4b30c60e500@columbia.edu?part=3D1

