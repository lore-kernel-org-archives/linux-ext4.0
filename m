Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104750;
	b=xvFsX0YNa0/+/l+zHr7aqKLUQQGj5QUCJZ4m2Vqb56jjimP2JVzOdvjTkD3uqY+uVDGX
	 HOwDgGZf4QvUPPH9EyLNke+2a3a5JrtYASlOjjF6M8VYJ0X22OT7nq8YnfisML9ovLCtg
	 7cTLQxJxyozmEFU8HkioDA0Iu+eKFjH0nUSMuetus0zM8IByka1zFFRfYWzrW+IBHZDi/
	 eLXjXTFieRewCYfSIsCNdJK1oPnZuDLByF/DYbG1yinOoIKtuShRkLQmmiS6aDrncHwVy
	 u03ph2k3xPVcGmX49O15MnI8G22DH04vfd1QpzGa1gpdj+gSgrpCtMv/0eTcSWTvp4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104750;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lP4vWIbmX3ypWAZPcKZteKQYfxaWYH40MYLHT5EqhNg=;
	b=gHrMUiST0UFOf4qEGCXKv4yMmMHBxTq/jJOh+mTZTWSpYVkH2ZLwK5/uyE6bJCF8qUS1
	 sfAm6qzroXbQ3S3P1QpO3e9MfM2xfQsGdBE7J8j+gQX0eWY5uBPtgLdAYcyYWkbDKJzFa
	 45pPoE61TeE6p/p9SBbcfdOLbVc3pLSz+SYIPQv9r9s1Kkd4j3ACndlXrM5owEqsxrEzy
	 T4TdOniBY7cvXZb76RpH0WNDwk9HjWlMyWUuXIZA8skEkeq7Nf4JvOuIz/3skvh4hI3kT
	 EpyWr/3hKQrVD/oSzujY2OlsX2JGbfGkKXzbGWzhrhjai01vi9cZOfWSjTUMa4C1pDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apCu1zlC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DC0606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apCu1zlC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2049D1F000C6;
	Thu, 19 Nov 2026 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104750;
	bh=lP4vWIbmX3ypWAZPcKZteKQYfxaWYH40MYLHT5EqhNg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=apCu1zlC/pwZON2CqY9ORyHWEfkJ5IIF15zFvxnPJQzJ+qwNcO2GLxjMQ9pOCgkf3
	 MxZ2XSuVFyHKTRe1rZ1AZb7aC/mF7gTDRxm9epf3fcBnsfeU3n7ikgYPvz7RmjtR1V
	 jhRDQ9LubrvPpSwxhqMkqznW6k52/rpQEnCQl2yKCKRWD0JcJIdXpIMPoDbPwv4By6
	 nIr0rqRLUW2FTvtKdvIlJB7EkP73aEHc/Ti/29HOe7zjz2USbn+2YQ2EgOy/q8s1y8
	 y2ArkUiC0shOr4aJ6xStqZBcHlRBksgydI0ofK9G5iSfOxBGvGivHU/uUeiCMXMn4l
	 Y57YK3NaVmR6A==
Message-ID: <sashiko-outbox-223486@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 17/26] ext4: add KUnit tests for fs/ext4/ioctl.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-18-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-18-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:12:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_ioctl_test) covering superblock online
> tuning, backup superblock propagation, inode data swapping, fileattr
> validation, forced shutdown, and ioctl dispatch in fs/ext4/ioctl.c:
>=20
> - Superblock modification callbacks (ext4_sb_setlabel, ext4_sb_setuuid,
>   and ext4_sb_setparams across error behavior, mount counts, 64-bit
>   reserved blocks, 32-bit split reserved uid/gid, hash/RAID/encoding
>   fields, mount_opts, DIR_INDEX / CSUM_SEED feature edits, and
>   FORCE_FSCK).
> - Parameter validation and normalization in ext4_validate_tune_sb_params
>   (-E2BIG mount_opts, -EOPNOTSUPP flags/feature clears, reserved_blocks
>   and hash algorithm bounds, DIR_INDEX hash seed initialization, and
>   CASEFOLD encoding defaults).
> - Primary and sparse_super backup superblock updates via
>   ext4_update_backup_sb, ext4_update_superblocks_fn (including
>   EXT4_FLAGS_RESIZING contention and unjournaled >2 backup updates), and
>   ext4_update_overhead skip/force semantics.
> - Inode swap rollback invariants in swap_inode_data (swapped vs
>   preserved flags, extent status cache clearing, double-swap round-trip)
>   and metadata_csum seed recalculation in ext4_reset_inode_seed.
> - Immutable enforcement, DAX mutual-exclusion rules (including inline
>   directories and verity-in-progress), and end-to-end ext4_fileattr_get
>   / ext4_fileattr_set flag masking and VFS flag synchronization.
> - Forced shutdown state transitions (ext4_force_shutdown) and
>   ext4_ioctl / ext4_compat_ioctl dispatch checks.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D17

