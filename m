Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376608;
	b=t51kDtR+JTD1qOOBmD5ba2Oi8889loFTUeV/saGQ4CrGlQyTahFnoyBYlbXfyXiXmmmp
	 4T96DUhIZBEmMQuhTybQXAtMpTkCoBNKpe3klkLt9zWcGDvYMs+qcOOJQ66VHDvMpb0Ju
	 H75GAtp86SuS3D7TvcPhj2GgVvDynW91wH1KQ1CikmlgwKWOdx1s+MpC+iHYdRC/HkRTT
	 l0YTbONkC551BDIF3IQk5KIuOBbrsfsXzoA7JDtbPGPFJiKX4gcJndMohhQFksKCeSxDG
	 TSrydXKEPvMn+6yNgfkHO4GYxQa5qx6CTLB0xjuPhRMGCFXZaU0thoSm8diC5EIESiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376608;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FW6V2+0zU9H6z1iqsWehrCUIHFTOSbD7YMLT14NqzmE=;
	b=aiAIcjpwfK9S4JRSGcmH8w3SqROZTDwyOLjDxkKshCwkQ6XD0xeGxWyQRaeGVmn2jB2n
	 Zj/fc2nX/cVjwYtCfc86ZGSKfxwnzBlwvGI72/Y9HI8FOSMY6OvX7cDR4iRY2lcLvWk6y
	 mTR9yAWi2tqvXqyqSG0Aoo9QkXHqvesjzmwKaXCeY+iUU3cIuCdmxQhLlsVBxmAKmEK4x
	 Z9RfufyU7eHgc8opfEpN7NC7Zx68ysDYFO2/lC/goSmIRdqEsmhHZ8EptPJJuWIwi2vYN
	 EQv3HJ7nl0/x51uZAE1eXDVO+K+HoGlXoLWd0jQSSWHoFXNmEvnYo6Nag7Vd1h6axoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nql1Oh/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8AB606A320
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nql1Oh/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174211F000C1;
	Fri, 30 Oct 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376608;
	bh=FW6V2+0zU9H6z1iqsWehrCUIHFTOSbD7YMLT14NqzmE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nql1Oh/BQeXUDWLQ9VnoJ2wHU1/0mceYht9uUz9LNK+1Qre4OYc+bVEXmDyrEc7z+
	 tvBG56oPOb79rCzXQ9s/L/F+5TSzQrIgJNwH9kubvFr4l/UJUkxuV0FJLQH0JrapFC
	 cRzV9AjsrMIZzBt0KegvGlNj1pWpfFd07+UJrx/WCjEdBxB7FvLpUfOjI1On5y1tB8
	 3M9kur1LK8XpE/19LkVwsZTwtXLLpvTN/aglrSRTtOuBj7rnLlirwTIsx/bOCb1zF2
	 sDyeU/OJLcwIvywsKERYm/bdY3RJjNlEBu5MiNWg+kHq4snB1ljFRbDz8j6ZmkIyqw
	 AJETKi+wYGhMQ==
Message-ID: <sashiko-outbox-191242@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:07 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D23

