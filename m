Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657829;
	b=SSb7/JklBRbt0iGS0rxb7UDnXoFzcF7CwY1LoTHGe6+xrcHY1CVxmAIOs4hvamT/iss0
	 TcO5HpCll4vduO5K6FbDwDJAyPHPChHW9p9qwbIVGKhYLa9EmjkpjuzEik3L5plt5m48m
	 c6OWiq2aqLDgSsN+QymvPIwFXv2NMg+cIGg0/nsoCeNeMSH26lL2ieWTfdHAITxsw8bum
	 U6SBAnV3ukizTgGH9cmsg5OgZG5KzMIaDc+Sff4sU0oKiIJZOynZB1PB2L6u6VHNLzvUP
	 HHuPbHGvc4kdKwRjpNEo46iyigXa7EvqDuCu+yvOmsBip9U70KcY0KmSq+JofnjntSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657829;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AVzM2bTnwW5X/yv649pLgdlgUQnPxEZn1gvV+bqJ78w=;
	b=5Sqdx3Y5emsa3xKfrkxMl/NczQsqLxknKW38ZtvQhdQBqBqxQxhbQKYP2udb/EhIp5tK
	 8QizAoclI56uObm1RcAgxrr26LndUH1AfZ3ByiXQWUSkRfWcbziVCOE6Zl8ZtzsJeURfe
	 iELzkqzYhuj//WFN7z5j5tHOZvihPgkjxohm7YMXXnkdE+5VMlz6HuOeNlMbrqBgkYMXH
	 5JQwfyB1+HAc58mu5gnOqobvJEyZUeu/ozUCz5BEv57fRNAdGlxVFwYdHc05Dl4eiVlRO
	 GqApDM0zj2oxShhX01qs/xidnslp5U3ochci5Y3xYiFovUG1S3asnLKL+yFNtOo/THg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KAzp6tkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBBE606A33B
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KAzp6tkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8CF1F000C5;
	Sat, 14 Nov 2026 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657828;
	bh=AVzM2bTnwW5X/yv649pLgdlgUQnPxEZn1gvV+bqJ78w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KAzp6tkfjPbms00G9RyJPJ7dTNEMLFWsQPyiGAqRWSNUxR4wi8zBUcoKT9Vqz0K+g
	 YD255+27ArCwrAA1Ln39mQCKKMibll9vnLITQ1Rq1e1Hs7YjDCyH5dy3JKmUa7Y3Ya
	 3i5mlYn2LUX3QcQ93MKcAGtk4nTiOdK9OzfHlXamCYf944JI8FAT0P9TsJt+TttwMY
	 7A6l4CiRSzDlXfDIQhiCK03ZUgMsUzcYZgRUUrViWCgvupXR0C21aeGugvSUGClz2Q
	 cAv6KH7GARiGGo6Xda47dQaHQOgF5/Ijap6SNGxO+VTMcJ6/3jaGmYCrLl+ML7XYWQ
	 SPIpFYQbI1WdA==
Message-ID: <sashiko-outbox-214476@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 25/33] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-25-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-25-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add btrfs_fs_rdonly() which tests BTRFS_FS_STATE_RO and use it instead
> of sb_rdonly() wherever btrfs checks for a read-only filesystem at
> runtime: the error handler, read repair, async discard, close_ctree(),
> btrfs_inc_block_group_ro(), check_inode_item(), device replace and add,
> cancelling a balance, the sysfs label and force_chunk_alloc stores, the
> qgroup PERTRANS conversions and the subvolume orphan cleanup. And check
> it next to every btrfs_root_readonly() check that guards a modification,
> e.g. in btrfs_permission(), btrfs_setattr(), btrfs_update_time(), the
> xattr and ACL handlers, btrfs_fileattr_set() and
> btrfs_remap_file_range_prep().
>=20
> BTRFS_FS_STATE_RO has always been set and cleared together with
> SB_RDONLY. The remaining sb_rdonly() users are mount and remount paths
> plus btrfs_is_full_ro() which only matters for rescue mounts.
>=20
> This prepares for not setting SB_RDONLY from the error handler. Until
> then the only difference is that ftruncate() and FICLONE through files
> that were opened for writing before a forced remount to read-only, e.g.
> by sysrq u, fail with EROFS now instead of modifying the filesystem.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D25

