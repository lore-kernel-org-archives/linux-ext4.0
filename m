Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657821;
	b=bkyMNqBkoat5wu2pXEdE0ACPfSLRAdDteW/a03sG9GPSYKo6qiAd0QXCOUhTqbxtz8ZK
	 ePHGRmbnV7y4oAArqD4MlCckXNMgi9h3w36Vgum4kPEOJEKKeM8ShKSZ/rkDA21VioZ1+
	 xM2dlnWj8TmNkVWv3YzmR2KMoKhlRpw5qi6c/VP8UYz0GeTL0gmbUX9VNE65T8oFVxM+Y
	 Rz0iR4mZd0mTT26sRA3MVkmsFaBkS2ozcQsiWWJrKdKjHiukWT2TlE2O0iHFZFBMwqhVq
	 tMzlT7SYSgrv3fpuZlL7FA4geTg/gGSrbajuPcmBCgo3l88zAwExuLGVWHY1FguinSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657821;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8+05a/EQaEZaJ1ycYsg+50mut1mrOiksIBEGFiS7adU=;
	b=H1Dhgyk6cJ2a5W5F3bmTMmVL8PLap96xC7CX9S7el2NrdjtWDVXCcvGEntiz0hs8+xjp
	 BQzocz40WlpSZSt3deedCN+6FZ2j6X1JumZF9Ix6szB68eSs9kcd9RUF8P/mdrFyRK/yc
	 PByTEl6qQHNngZsOIhT4FLGrTtDWr+Vexy0tObckyE7hFqKXEfgZptY6TozaGGiRyyFSi
	 OrUKrM5EUH+RG3WbNniBoX5Y7YBAw1n8AumWRJShB/5NPXsg3p4jP3Yq8fqYgYu5TNwV1
	 5ZNv34cYKRpzgdO21L6Am4biwOqr0KIf3JnxLNUbDZTlsesAvPuRkjwT9jbkzy+4dGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKevSRn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBFC606A33E
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKevSRn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0DC1F000C5;
	Sat, 14 Nov 2026 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657821;
	bh=8+05a/EQaEZaJ1ycYsg+50mut1mrOiksIBEGFiS7adU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dKevSRn06CeeRDvBCcP9Jdeyd39F2IAxcQAJmXODJGUT4Dtv4E7oNzdgJqPbxrOQR
	 V5Vc36L0TkKzqb0rAVR/uAjQ59V4GHxTiPu66N5wqOYV6wF0f5eRylMlwES5Gg+dqt
	 Z5EfW18BjAIz968pmm1E/UR0y61DxouVjPpIGcqyeW/N0ncaiyV2F+19YVnLW9b0hN
	 f512vX23L+JWlvVD1VO0MNMKZUkjWZvgyTQtxFRvdFVWSFwEJVP5DVz2sa2wRo7oDy
	 HWz7F2H7H4SUdymw8RoKbUZMTxWflm3Se3XzGrayj7obDt2bHdEBpoSbUHomtZNB0C
	 SfRBHq3Y0DEMQ==
Message-ID: <sashiko-outbox-214471@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 20/33] ntfs: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-20-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-20-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
>=20
> The VFS also refuses to freeze the superblock in that state. So
> FS_IOC_SHUTDOWN with FS_SHUTDOWN_FLAGS_DEFAULT or _LOGFLUSH shuts down
> without the freeze after an error, there's nothing left to flush
> anyway.
>=20
> Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D20

