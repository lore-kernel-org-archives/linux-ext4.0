Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611E3A9636
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802178; cv=none; b=PikCRgfN3GdsUIokOjuUNdc3oZtM+51W7AzodlDcKv9pPF+4MA8GrpAtzGpqIBt2YFchRIfGzcDpqY46zrgrvuuBnrW2MbY+bHa6/slVZcK6SGogQhDzbf9JGOVhttI3WnGS+tMGMFCyGSNFkDJWvbyJepXLcERFs9Vd+OAikYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802178; c=relaxed/simple;
	bh=NH3KryQmk8Zw/zL6+vgmdW1MRgtO2xD9QbuAyHYLnHY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rd4DTQ+e4o3rw/GF3bFvz0TBzf+Fv0ZTBjZvIBSAFMsTnl0d0ecoubqCGbk6v9liPi5g9pADaEiTdO6c/hZ3rQSIhNv2zXtQmvOEYG/iwOQdqEuIpc+0CNl8NEIhk5bx0zsPT9Gn/AyzaCwHFhNxCEVeAsfvaNa6GXc84/2ebvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWPPjJgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWPPjJgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA68C1F0089B;
	Mon, 12 Oct 2026 10:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802177;
	bh=S8c5gaw88l9TQOUKKXTuBD8ddTweBbLyuSr77d3xMCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JWPPjJgNxDaRpAuOTUpUENLeef9TTTbBQ8qAWPKeVDDEdxhHugr1udpYIUqQrDkaJ
	 neY7v3er3ei6zQCpFbrxweu1F691ZK0W42Ms2ZJ+v19i//qVSFf53RVHMqLq9PaQ3i
	 RreTbjbro0E+vxpRqwhtuqLYUlAa7RqvijVtlBWtMfAO6P/EOvpP2knXtc58FppnL+
	 KJN0ZUw1uARvlTVtCewmRNbeELxfPUU2k3uEHaRhmYQ/OXy7GMh9bRxxw4xe7pFG24
	 GZW43PHUiOXuAYp8qHXVwvT5IeVNvhRhwEtqB/SJYX0I3L7JY4DGU7DBHFulr9axiO
	 UVbLxMn9R20gw==
Message-ID: <sashiko-outbox-167987@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 25/28] ext4: allow remounting read-only in the
 emergency state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel
 Becker" <jlbec@evilplan.org>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-25-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-25-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:49:36 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> __ext4_remount() refuses any change of the read-only state with -EROFS
> while ext4_emergency_state() is set, i.e. after FS_IOC_SHUTDOWN, after
> an error with errors=3Dremount-ro or after an error that forces the
> filesystem read-only like ext4_abort(). None of them sets SB_RDONLY
> anymore. So a plain remount to read-only fails and the filesystem stays
> read-write.
>=20
> And emergency remount (sysrq u) asks every read-write superblock on a
> block device to go read-only with SB_FORCE. ext4 refuses that too and
> reconfigure_super() warns before it sets SB_RDONLY anyway:
>=20
>   EXT4-fs (vda): Remounting filesystem read-only
>   sysrq: Emergency Remount R/O
>   forced remount of a ext4 fs returned -30
>   WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#3: kwork=
er/3:1/50
> [ ... ]
>=20
> Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
> Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D25

