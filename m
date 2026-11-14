Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657815;
	b=UiRHrcTZIkXG+KrKQOFYS8aIoO+YFU7IuJIa3zoiQLLny2p8q5fh3Go59idkOjGVNHV4
	 XxIjq5o5nCnyBZx44HGr2CdWyRLdowMp87RdfS+CMhGAjkVRXhaIyKm2S9IkqMKJ8aBAu
	 SEAClLXEfw3VZIsTpTO+QNLnRxolMax4mB9eBafJCLq/xNSU2re7rCPRNht6lwZFZMu9V
	 inJDh5PZr0Mju8TT9uOhosxigW0/oCvGCv0Ha3hqfC10tPdbr7E8ij4Jy62+LetafnjGt
	 IpC1wYqWkWEUQuLjKlJoCcC9NL3KYZ0mhJ5kilb605XIkRFfzRByCTemtz+POgCQuMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657815;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7qeXHDBJnPB1mFOnlTjlHF6AZSkpCy7NcIAaDTa3ls4=;
	b=M/zaEaXL7DXtN+9gv17+HDHTVgKsX3sSooBcA7b7KjprNarfI5DEI02WMiIQY6jaRb9u
	 vYFRd4d3JNcu3wmWBRpbgTD8lBzRWbSsUZh/0jO1DJZhJp7KmHYRwBPheZtz6WSirwMTg
	 AKM1pmvQUKqODiQa09bu1LLAugKHOsK1LTN+QEQ9L9KmfS3xg6CBVLProQ/6v5QUFIHNT
	 dyDwNvUwZDVBpHQQSPkNktQHMG5tG5Cef5suXZsXkm5s0KlKCNOZOnZ5hnqvLhpGUYNFh
	 Cz6dSQ1s6582YQcin0qHy1QJXrSV+Q9vKvlG2sjEC0qIRTtDWKIfmbPaz8FpMBRuDvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dz769qEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC733606A88E
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dz769qEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633C01F000C7;
	Sat, 14 Nov 2026 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657815;
	bh=7qeXHDBJnPB1mFOnlTjlHF6AZSkpCy7NcIAaDTa3ls4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dz769qEGHbyzOek6AbB7aanffHc13F9bChhF3IxIPHVJINmmrqWRIhMU4w/vNfzK/
	 z9W68LZiDNGLXj4YIyn2iNcmXfR6w0036qxehO5Y1K4/GX/yr3DzV6j5BVjqbxswbw
	 /ovX+KhhwUMHYMs06D/JSAvl2+LV0A4AteFRlxmXbuyM/VpWA34akh8nhAr3OPgrX6
	 Wc9Nw1T0EYBxApmWc2jfE7mpW72yKCgX2QNXl9UFQvxGDlsJyLJIPUd6BAJnUtwlkS
	 CA9R3ayCIzSd4zupo35cB3YpDD0Ms9FSwWEv+kYPAluGY5ulZlvxwXfhyHfK0UEEHK
	 ELbtEgh/V/FBA==
Message-ID: <sashiko-outbox-214467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/33] affs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-16-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-16-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> affs_error() sets SB_RDONLY from whatever context hit the error and
> without holding s_umount. If that happens while the filesystem is frozen
> through bdev_freeze(), e.g. by a device mapper suspend, thaw_super()
> sees a read-only superblock and leaves the s_writers rwsems locked so
> every writer hangs.
>=20
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. affs_commit_super() leaves the root block alone in that
> state. affs_write_inode() keeps working because writeback still writes
> the data and the bitmap and extension blocks the inode points at.
>=20
> After a remount to read-only a remount to read-write fails until umount.
> A plain remount to read-write right after the error succeeds but the
> filesystem stays read-only. A remount to read-only works and keeps the
> bitmap around because evict and the last close still free blocks,
> affs_kill_sb() frees it. Writes through file descriptors opened before
> the error fail with EROFS.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D16

