Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376609;
	b=WbwdDPa2u/02yfODPyW30F6vUvO4YWtfE4ZbW+zFappYlVO/0NSO8etHCrm15U9R1MdT
	 gIWcgEkQr6H+sSxYd77Mgmd8FMuxS44HKVnq9o3EgmttXG8FbMjy7lwoniRpP76Lt28w6
	 LOvjNJ/BnAxaWQ1XqKRpDBOdFaRoZbYf/JW4zyy8b5Ls28JjyCSF+/Yltv9d8QDQyQQRd
	 u0QXju4MWGrYdwRP2yJ6STbs+3QyRbkboWMlIl9pOVaD6K0xnjiZL+9zSOcgGdB49OXKR
	 n2oDTiZyYIr2+208E7MbHtNJyqafy+2RE0G87ej9y4/v7Ed1jmFeTSrgHrtR6rO2B3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376609;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gtry/3deETlhVR4rjXCXqxCHmQqm1INyh6ZoGDMKB2U=;
	b=TT049roIkuSZhub7IMg5Cye4xYf7OomvPimAkDKnN6+LnYuqOUvCRdeekV2w/23C1K6d
	 3r1/miqOioeUUHNbUuk4Og7bj5SkIMkZJ+rJhrcFfXMMgTUpuuZ+UOIpt4/86VoLVVzMG
	 Q/1y5/iCkXUQmCRM+CWTZMUV+O0F4ag3fUVgw77qsLXPf4HU5AuK4u3ldogE/yFtajb2d
	 oZZOWe+ye0ximgg0LQbTyC65iqknJDS6Amj7YYV27WQmUIPzAtOQZlA9UQOsB/Zl+Vp+i
	 5LuDVc/Mxj3ZaXH3I9tJRHkqeI7HTJDmTvbcE+ExHjdSv83bkGf6eVQC+0PlbQVJwVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRA+1mXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294BA606A334
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRA+1mXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CF21F0093A;
	Fri, 30 Oct 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376609;
	bh=gtry/3deETlhVR4rjXCXqxCHmQqm1INyh6ZoGDMKB2U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lRA+1mXhy60ecTdfRQzbSvlma2JRrYBRF8UPxtgpJVvLlampiVOubvCuzA+BC/uiY
	 oy91St2cWcYdRG+ZaqY4orILBn7lxBfNwJGuGpou+J0aNk6iW0cISsDM6Ze+FOEycL
	 NR4Tz/cLqwBCPwBSSaKIK3rrUup3WmsCJK/VWAhOfM6C3CybZecwJxa1A4c4DNlt8j
	 CGVzv22INd9xpsgn76c6CYVHqJt3qBB7x1YEuYV2/xpJLoNh4CLcP9jdW280pNj90E
	 vyDA1y5/oVLEMmmjrH05du0hXXXmIjM686k0j9FR9kkNmxt34mcx5eoGqU4C1tqrB0
	 etr5DyJzIUoCw==
Message-ID: <sashiko-outbox-191243@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 24/34] btrfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-24-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-24-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:08 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __btrfs_handle_fs_error() sets SB_RDONLY through btrfs_set_sb_rdonly()
> without holding s_umount. It runs from any context and every transaction
> abort ends up there. That races with everyone else changing sb->s_flags.
> And if it happens while the filesystem is frozen thaw_super() sees a
> read-only superblock and leaves the s_writers rwsems locked. Today only
> btrfs_zone_finish_endio_workfn() can get there after ->freeze_fs() but
> that's luck.
>=20
> btrfs doesn't need SB_RDONLY for any of this. fs_error already stops new
> transactions and BTRFS_FS_STATE_RO is what btrfs checks since the
> previous patch. So only set that like ext4 and f2fs do and call
> sb_set_emergency_ro() so the VFS refuses modifications and reports the
> superblock as read-only. That's not done for the shutdown ioctl, rescue
> mounts or a superblock that already carries the error flag.
>=20
> A remount to read-only now actually happens after an error, so
> btrfs_remount_ro() skips the commit and the unused block group pass that
> can't succeed anymore. Going read-write fails with EROFS instead of
> EINVAL. ->sync_fs returns 0 and btrfs_freeze() skips its commit in that
> state so freezing keeps working, and the thaw skips check_dev_super()
> because the superblocks on disk may not match after an error.
>=20
> A second read-write mount of the filesystem succeeds now. A non-forced
> remount to read-only fails with EBUSY while files that were opened for
> writing before the error are still open.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D24

