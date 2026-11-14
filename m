Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657835;
	b=XVA6ClPcIAQ1mnj4X+hX/8o5SmVOMg5O16CCNPKcsv2jIzH2QTlnzZI37yQiKsOd3W8I
	 QAMZYrJGzAMgdV6H7n1J9zZxVhIdlqDLMJ/l7SUovypzGno4tatMLNkDGs7E8H53U4Xbi
	 xXT+42HKRIkJPgUxXOJbyiRGKoidei80DWub/jwI3mIvYFG92h1t6v9jsuRg/ZXtM65cw
	 E4/KUJtjUXeUTHXRDSg2VVyKIoWi9g7LdBHdufdArZPzEFUKhOMoDmebq0EUQ34mHITxC
	 21R9BkIOAd1c9sEdptfYc1pOT8cevg/FD4u/QQwkfWqpv2WcFDsUS49pY0wbHkg99eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657835;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pNXjMoKGSGnuhUTAHMS+YwkhiDuYzrXzMOfz7bfeIeU=;
	b=gDSqGlC+QUxPtEMW+SKYUKrcqoCGk8Eps0aLVBRPwWDn8D+hlfN1usSaCXnaJ3rVeD2Q
	 w3k1eXJ56seK9b2OgaSJY3vMf3qDoDvDhPzidK8MH8KhmQBOkHFiakUN+yCdz72zqBM9p
	 fkzk8FcJfUBogw7K26RJDYtg3cS8sf5VJSmDEVjNpiukl7zlJVL0h7Fg+DbUqC9eBsWyy
	 bYh3I6ypSKG4taFQTWlPsxyl8vSDe8WQRoR1uHE5a/iIJ0/Y21kptIuW3u99w+DqOobvy
	 CU0eyfbUqSfIuV5t40tdfmV6RvPk/NVGYnBmuJwBgTEw2jGoo8ajshypmOSfCBbrvlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlO5VY6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3692E606A334
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlO5VY6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3A21F000C5;
	Sat, 14 Nov 2026 12:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657835;
	bh=pNXjMoKGSGnuhUTAHMS+YwkhiDuYzrXzMOfz7bfeIeU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JlO5VY6tqu7CZobZw2XVyiZPNrizH4rXgiw3iuqw6wjbff0R8neQPRBg5O9/Clm1T
	 4q0WIw5LRRwvbS9Mdp11BIEtAgKkVrM9fKETi0IoOl0s2LFK3bB5+SzA5Q5fPVcIyn
	 zpljG0XjjAVRsIotjsq9WZltQIFyc8cdnEhct3tj9mAlMcsClyGTWtIyvQMxSk4+Vj
	 hq32yfkBJ++Qqz9jHk2uSFoXz6eOqdi5J7jq9CY0sDfdxnjIiB6/aPRWdfq5GcjR+h
	 P0BQ6i2KBuDA8XFEeLF2mZ+v9TKVyO223rIl533W/d3xihx6fHwxu2O6wH7M3HwDtx
	 KJ+rwCovbLoUA==
Message-ID: <sashiko-outbox-214483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 32/33] ext4: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-32-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-32-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
> makes the filesystem read-only. The VFS then refuses modifications
> before they reach ext4 and reports the superblock as read-only like it
> did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
> and so do all of ext4's checks because they cover both states. ext4
> keeps showing "emergency_ro" in its mount options.
>=20
> EXT4_IOC_SHUTDOWN with EXT4_GOING_FLAGS_DEFAULT fails after an error on
> mainline today because ext4_sync_fs() fails the freeze. freeze_super()
> refuses it in the emergency state now. ext4 refuses writes in that state
> anyway and the journal is aborted, so shut down without the freeze like
> EXT4_GOING_FLAGS_NOLOGFLUSH does.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D32

