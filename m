Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376591;
	b=ZFn90iuRRqXYCm9T+bUpJMFUAoJRe11HyLQv38+K6dlKh1hNRn3o2EMLFwcHpoBZwcgK
	 wv0q1d+sAXD9cXjH3L5FFJ/p5y1qV0CLmJys4bL2UEkzIRWf2jvvJavxEsWHT5mihOLip
	 qOkUs6drOHWWo3JPRf6qDwWw+MnWycr/FWj0NME9sV6+862hcXsbEfiLaXH2tjqmEryYq
	 pUijPOxXPwxSUuNdNVTka96+JvpSZpAfWYHPxvBJdVWLOXTYTcMWDDmyMbQ4X+c+UPylU
	 Pdhuuxt0GXGkOZJF0Vonk70bKdOHMNU1NctnvvSUWEzZ8fB1Y6qsRNjAenodV+AQWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376591;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BYYB7At4WjTynYZSwvqNmS2cwQNmo8uTNUtaYVy19Wc=;
	b=qly2RQVMuHSuB3PHQi3GZ6pMIQ1Z/fi73KZZrmPEKrOjdiyXt6C2arAnsHLXUafKR0Av
	 mr4HJpzD1v+uXM/wjNQXW1OVS4eE9o0yQfkwvBusi1GKCQhVNJXscT6+nBzu4vSEb32SA
	 Bc/eGahXT1/IWjz19EC4pBQqNesZNx1hT/exuF8+cP4NPQQrz7qVlguyAAEn92ZAdihb9
	 eTrsE+L1VmhzlPT+BqHb5MO2bxAmD3ZrLdOpRNUovlktDDMDEMq/CrsMdj6KipR1XhyLV
	 HtgliiMPG2PqSoAWNcbcl2pO7nnzgkaam+aY56GDMFXEUTygiewvhGj/Y5sofuQPKdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n9iWlzTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA2C606A326
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n9iWlzTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6DA1F0093A;
	Fri, 30 Oct 2026 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376591;
	bh=BYYB7At4WjTynYZSwvqNmS2cwQNmo8uTNUtaYVy19Wc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n9iWlzTN2BVUu1PhSAPIpVctHe+1TEtP2WNExfuebf/t6SnWIJfXFfawV1Y7oNepx
	 H0TAR2GxlJyI+udq5e4ufokATbQSDGfgeMbg1GcBjXLIntSHJHcqAmqB6tt7aHVzS2
	 cvf2aiwC4cMvbcEMsUGetY6WreHMOwHVNCK1bZ/79xFlETToHmFn4bwwfVmRtsg7qw
	 3NmtJG9/80kesFTQXekMbAjJ1xfKg4Zv8/2DKPv36x7O2xpr4vpN6iduPoNXbz2nId
	 cVzdUGZf5wqhAYHYMF67fuFdX3N71qa73io+BRhi3deoKhJF9YUPWyPx7PGOifX/+b
	 j+OGQfGLirEJw==
Message-ID: <sashiko-outbox-191223@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:50 +0000
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
> modifications. ext2 still refuses allocations, ext2_write_inode(),
> ext2_sync_fs() and ext2_xattr_set() itself. The superblock isn't written
> after the error is recorded and unlinked inodes are left to e2fsck.
> ext2_handle_dirsync() treats EROFS as success in that state because the
> entry was already changed.
>=20
> A remount to read-write fails until umount and writes through file
> descriptors opened before the error fail with EROFS.
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D4

