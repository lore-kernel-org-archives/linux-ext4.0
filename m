Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657806;
	b=m2j63OAEA+3nnSD913Z3gosyYIpP0iucoVY2j0e1mseAJ8WV5rwSfRPR1WfXLfUgYRMF
	 psD0iF4jKG9GjB5q6QugGzIDYzKpOudL8qeSv9wxBfN3wGMXi4tBmu8EtIPEXluaXWiXq
	 tQS5y/rUpQwFmFQSpx+VlszF/diqOhgqyDeUOqhHjV7omIpCX+XPvQN8XEi8cJk1I0wbB
	 sjRNA6hGAme0x49u/VeTLUF9gTqF4k06Z8cmPvZCkABR8TSbf9aP4lqRItv3tjXsztW6P
	 2vIsUAJYklRieVMecOZk2XUtcwiALZeMXPmoy1xHKnMEyTffFbbepoEu5FyxniMvwsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657806;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xK8r+jkTKj1jmx7WZ3d9IIvcN4gUnCLz0BYHZzggLXY=;
	b=ARwYZTSaNY/sHXFljN/Z7ioo8d2EY8KrbceHxoOC/Bc77AwD7ymy3h+oWCUiV1qiVCTX
	 QSgNY/UxNfOr+Vmppf6fGWqi/AUUJ4yWC76fybR6qASnyMQhOgGOm5yFLpwA9n05jn/V8
	 r94GIA8sMxJEhKOXwNBd3wYVoH19fBAKL2uFwnjeA4WPKQr//D0IM6hwaYjhDxLS60rbe
	 zOVJq4uz2MK0ISqGqJ7pHSbuOI5mYVOX/UhDWQMi+/e/QhkqKoloupFboqAHbik5b3He2
	 VPRjD9MqHBU/wzqEi2Ke/vz3vhNfaSGxomPsxTd/MRgFcA34PnKvDwFY30ZoEYkTcgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCuwDFYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52DF606A327
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCuwDFYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AEF1F000C4;
	Sat, 14 Nov 2026 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657806;
	bh=xK8r+jkTKj1jmx7WZ3d9IIvcN4gUnCLz0BYHZzggLXY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hCuwDFYKwj6wmpmzfJRNTRy12SKhq5tj9rRSklJx/KnQBS04GJvpiKJHnq+/B8+7/
	 YG5Mdf1ewduNygzeFEqW63arYCk0NNlNiTfLh6fc34jmb6n2bPewkt3F4eE8h0/Hqo
	 MgKJ3fs+KsWsd3URoHaBStKf5KoaynpXyy3Z7Pv/U6XCLkKu+SRrRzWy7mv19FZWsX
	 G+xDpYOnTW66eW1c0aRkoIndWEu4W8SD4FCWTUwtFE22et1a1kHhcGR/z0qFQ15Yem
	 0jHYOWGe5J99EyfB74CXJVgDIoqG+OptNWk8iDrLZOet4NtEcsRuctCQcapVI9Prf8
	 p15dqLilFfc2Q==
Message-ID: <sashiko-outbox-214457@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/33] ext2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-6-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-6-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:25 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With errors=3Dremount-ro ext2_error() sets SB_RDONLY from whatever context
> hit the error and without holding s_umount. That races with everyone
> else changing sb->s_flags and it breaks freezing. If it happens while
> the filesystem is frozen thaw_super() sees a read-only superblock and
> leaves the s_writers rwsems locked so every writer hangs. A lookup in a
> corrupted directory is enough. Karl proposed teaching thaw_super() about
> it but Jan preferred fixing the filesystems (cf. [1]) like ext4 and f2fs
> already did.
>=20
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. ext2 still refuses allocations and ext2_xattr_set()
> itself, ecryptfs calls the latter without write access on the lower
> mount. Unlinked inodes are left to e2fsck. ext2_write_inode() keeps
> working because writeback still writes data, bitmaps, indirect and
> directory blocks after the error and they'd be lost without the inode.
> A thaw after an error while frozen still writes the superblock but
> EXT2_ERROR_FS stays set in it.
>=20
> After a remount to read-only a remount to read-write fails until umount.
> A plain remount to read-write right after the error succeeds but the
> filesystem stays read-only. Writes through file descriptors opened
> before the error fail with EROFS.
>=20
> [1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7=
pzcrlu33@p7zzlgp2ehjf
>=20
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D6

