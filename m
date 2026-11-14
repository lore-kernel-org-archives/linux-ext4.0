Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657826;
	b=VyQp1UTM2KB9uChndaLoH1xvc+pYxiYgXGD3gmDzaER9KF+eZEmQIc99LZ06sqr2wpjC
	 SQa+2qB0navKBoeCyL0Amuy9LlxhZKKMT52riAI6eTcigmBESDYJT+VLou9tedPlDrO/l
	 brNXN9U3k4tLgrL90/8q1/dKxHTtbH0K7IMtdN6FMD+M7+UqWKUFupnT3ZTnN39FiHqnd
	 vtoOTYoBnMMfkcb5iBUADjYdMun8PXU7w+ARTmS4ZV+WRjs2ZOeQd73AApQODnYHISREB
	 wYiYtZ2kMlw7S2ZvZUVkF2urwJbuOCFY5zakkopJG4Sq2EU35eWhB/fSKzAhTvCQkxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657826;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nvg4fIvN5qtMATjvOR2xS4eNpAt8eUmvUzinIY1npxU=;
	b=SI64W/dWGv+yoPh+t6fstpnDWtfU5J1vWyFvr7hesS/nbbWqvrrvwc+ePyjqmj9JxxM0
	 boK6GO6QWPETdk6C4cP7iMcZJNNE+K77hRAWH9jH0PvSvPNnjOpdUTYy9yLKf8a4/n8YB
	 Df86tgh2RcsJgllR76aLaIt42ODMoheJhrZvJdLW4sefXAc1/rlxhULXQI80qQFaFurj3
	 7T0UN8+uiOHB+NpcFKbfMgT06JHcDEFu3qv05nV+UubuCvsQmianjS8LhW1pJGSHHL5Wp
	 kHUwjplkzgp0nc/JMp7aG6L1zfm/ZtQwbqwbh1RQHILDraFW3NuePFa4AnJy1rCXlZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ET4AWmsH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E7606A336
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ET4AWmsH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFDE1F000C5;
	Sat, 14 Nov 2026 12:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657826;
	bh=Nvg4fIvN5qtMATjvOR2xS4eNpAt8eUmvUzinIY1npxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ET4AWmsHnV0GAfAy3Efk3F+877T26ynnv6XoRz7cAmyqPSvieDWwQUasn+ZymRPI1
	 MGBFw4ZGvCkxrt5RiQ4SKcnJM6rR6ctR1KxG58hyjYgsWvyMRAvBLzaya4s9OyjMUR
	 lqNjH8RAQYfyf+tCHLxnS4nxMZ0WJRUQIqiQOX72TR1MZOfrnVlmPtgjeEWf8hPgHp
	 x0Y2RLqqk4m8HhKJarG3+Z5eT30PEt42gWf6OfExD8sKxR3r0SZmztVLx9oRk1BbKS
	 l6nAfX6IxLnlPhv5ki46q6/6EU+4fl/tug3MsHrDxR8kafwh9kBNzYJtA7qRlgXSPP
	 f6bTY2VAGmlWg==
Message-ID: <sashiko-outbox-214473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/33] ocfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-22-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-22-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With errors=3Dremount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
> without holding s_umount. If that happens while the filesystem is frozen
> through bdev_freeze() thaw_super() leaves the s_writers rwsems locked.
> Writers hang and so does umount because ocfs2_shutdown_local_alloc()
> needs sb_start_intwrite().
>=20
> The soft read-only state doesn't stop modifications on its own. Every
> read-only mount sets it and those still need transactions for recovery,
> the local alloc and the truncate log. Everything else was stopped by the
> VFS because of SB_RDONLY. So call sb_set_emergency_ro() instead which
> keeps it that way, and keep setting SOFT_RO for the existing
> ocfs2_emergency_state() checks.
>=20
> The xattr and ACL setters get a check of their own because ecryptfs
> calls them without write access on the lower mount. It sits in the xattr
> handlers and not in ocfs2_xattr_set() because chmod and setfacl store
> the ACL through it after the new mode was already committed.
>=20
> Quotas aren't enabled at mount in the error state because that writes
> the quota files. The VFS doesn't call ocfs2_sync_fs() in that state and
> a remount to read-only doesn't suspend quotas. Q_GETQUOTA and
> Q_GETNEXTQUOTA can still start transactions. I've left that alone.
>=20
> Writes through file descriptors opened before the error fail with EROFS
> and umount completes instead of hanging.
>=20
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D22

