Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376590;
	b=S88KMWgGi3Gr1i2L7kPuguOXkedtZvsoK1SRY9f5PHxJ4RVe2kR/GAF87jR8DyJTdkzT
	 WqnrGEVl7o+h8qS3Cd/UP1FZ5n3o7f05vza3FcRtLzEk2YKhl76rS6tDWdwz1GCxPNZrr
	 KTSsr3Jc6qg6pO9uaErHNRAB6IZNU1jTOEQ6pnngxE94ZXxrh4R3TzYnvzWV6Un3KfpDa
	 luHEvH0BQ9qHyDxB8DdvQ6azTfk/qXFHXEeWp6DpdwuQ7U5wmoXyH65DqZtPN4faaq1Gu
	 UOXMJBfMGMtluNvjqPK6oXOAjTHDv6XF2YVKyiIlU4CU7mzE5LEzdMFo94ZmciwA6Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376590;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sMX02TYQ7+EZpeX8EHqV4pCHw/qnuHR6meLQHzsk+hM=;
	b=klFAWmgsiNjaQpZMjeyZcv6x9XcOn95AuDf7pYP0hV43hPzV/780VN2bG0vS+z0oMz7E
	 1s1TJXHMlLsCQs7XDHqE20MjD5tgHx23DM0UmN4wwyP5sXYBGm41qs8pJdNE6gm3rNCCU
	 s6Cb5QUW5ijsn4Ewh04Y22dTjA7AiSMH/evcp1RGPqsTnh4/BsLl916jvZre5cJBMwxEI
	 bAAb2kOPDB0v5cJ4Rfm+kuRxBhA7zuv0pLrshOjpF1WZa/lFuPkciJAuld/vQEbqajk74
	 YmVCGcy4ac5XNCViezmiBDNrRDRXrl5f5ShJA/x1yCF3qv+LfR0PMeUt3zQsh0cDeGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vel7soKf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6945B606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vel7soKf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E453E1F000C1;
	Fri, 30 Oct 2026 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376590;
	bh=sMX02TYQ7+EZpeX8EHqV4pCHw/qnuHR6meLQHzsk+hM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vel7soKf2Bxt8oGmei53cm6t7Zi5zbD38Nd4+igYqArOMmeTLVh5KZekc2ieT/jtl
	 D3KNsU4yRwkKz8GAq1k+AY+im2PiJKht5xhSvccx3izXeMORTpyNdXdtk5QkZplXtG
	 940QTBlOipwJYAPqv+dt7NCNuW1BorPlP6R6PfM6l1SIdTYhs4BW/EsJLCyg62+W48
	 YD/WoZf5GFyHn+8Itm/qy3WiSaTyUr1XcrjcT/DoQwPLdm3B+W/TYMJZBpMNYOZqXM
	 NvDDDbbL/FkYviVXQBY1mk+nfowbW86OzKmj4M3An6uPaM0Kic/n6QxwaL+m9vGnmI
	 +pphV4yRVdwHw==
Message-ID: <sashiko-outbox-191222@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/34] fs: add a generic emergency read-only state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4 and f2fs don't set SB_RDONLY after errors anymore and refuse
> modifications themselves. Doing that in all the other filesystems means
> the same checks in ->open, ->setattr, ->fsync, the directory and quota
> operations and ->reconfigure everywhere. Jan suggested a flag in the
> superblock instead so the VFS can do it once (cf. [1]).
>=20
> So add sb->s_state with SB_STATE_EMERGENCY_RO. It's only ever set and
> never cleared and SB_RDONLY stays untouched. A filesystem calls
> sb_set_emergency_ro() where it used to set SB_RDONLY and the VFS refuses
> modifications wherever sb_rdonly() would:
>=20
> - __mnt_is_readonly() and sb_permission()
> - notify_change(), rw_verify_area(), remap_verify_area(),
>   vfs_fallocate(), vfs_fsync_range() and do_page_mkwrite() for files
>   opened before the error
> [ ... ]
>=20
> [1]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyo=
cp3yxbnj@aphfqdiej2hs
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D3

