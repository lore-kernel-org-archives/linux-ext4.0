Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795400925;
	b=xT0q8U/B44JLuUZ8OnbL5ZjQLNeSpWpT0zJ7Gn3mFV+pKiDnZwMHtCb1XW8LLlmhyl15
	 VaYXs5UrLDvAuq2B2/eXDFjUYjLyfXDmJbPiXjAlTqmNTsIZkIG7XuU/yPhPpMHs9MwzY
	 oAE+Q2f+R3S3YCEDnr6vlkYFPfjpA9iII8dbBoCVHDgIJuRxA1RbdtmX4/m4Sa+Y15Xhi
	 jTrH43j/A6N7JVStpWQx4GXkrZpjkrz1DZnnk6uQA5pLfk94xNMah7lf3x80Gu8LuDQNq
	 Fum0GJpNS/+dwijtzRbHFLxz9cOCsZfyff//4TAG5qJmBDHJfdfpgiS30LkvvyhxbRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795400925;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=o5erJ3rynnoj4HPD/nwMbveKcC/In0NQoKJE/bHCOZk=;
	b=rgNGEtyqFXLcUSe+qJTeP0XyNKHp168PJ66WNTbkyrqqvH7L1ASYN0rq1oPG9twmKpo4
	 R3/yw1s8msjsX8GTo0NmhsIK4LqAtSCYpq7J8umyqUF+snL5I4K5JQiB6T+jM2K4leDfn
	 By9dmuk7HPY9hP5HsV0Sx18hpULTzereq9Xwb/TU7RvZBgHkq73W3nXGDi0CRGwbKZvSh
	 THLuHeWhPJ7X0VgH3YmNVOQeOZ65fpZpNVe6hq2ffjjErWmgFWhqfiuIjyHIjMkX3Talm
	 KKvUF1jw8beGkmsrdKEobffbiSM8O00C7vceWU1r4UKfUHfBR+xdur0l0iDogsWqcFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kvj2n5Ts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F964606A31E
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 02:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kvj2n5Ts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B851F000F4;
	Mon, 23 Nov 2026 02:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795400925;
	bh=o5erJ3rynnoj4HPD/nwMbveKcC/In0NQoKJE/bHCOZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kvj2n5TsDVLyQxfchK4sOrqva7Pk7RjcQ93EA7zH4neFA3qsvErokf26SnenlN+ZB
	 G9Qk4TXKX31rb48UAnCg+wt+CIhMn7uBWQSf5UjXWOnwhCVH5Nf9BA53xhbkpJuQYn
	 rGVKWJlhOcwhCium1m/pfzoL5IDcmu7V01Y+chPiyXFJCSCzttTrtkhmHaf79LQSSr
	 PBegUwzd0qLjUQ41gOuY4pmHlx/keZtB8HvbQFSLO9YNqHBKP8WiAGt92D6pORUaue
	 a69h7GxrIJNV6p9+c7zI4ta4aoDal5CEBPBwHAvtEKk7/bZ9wsWRGDBUD9DCFboNNW
	 xBhJJ5oCnpxIA==
Message-ID: <sashiko-outbox-228550@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: use unsigned int for inode numbers in fast commit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hsiu-Hsien Lee" <swinds24@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261123022309.990044-1-swinds24@gmail.com>
References: <20261123022309.990044-1-swinds24@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 02:28:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The fast commit code keeps inode numbers in signed int: fcd_parent and
> fcd_ino in struct ext4_fc_dentry_update, the fc_modified_inodes array,
> struct dentry_info_args, the inode number in ext4_fc_replay_inode() and
> the argument of ext4_fc_record_modified_inode() and
> ext4_mark_inode_used().  On a file system with more than 2^31 inodes,
> inode numbers of 2^31 and above become negative.
>=20
> In the commit path, fcd_ino is sign-extended when compared with i_ino,
> so the WARN_ON() in ext4_fc_commit_dentry_updates() fires on every
> fsync() of a newly created file with such an inode number.
>=20
> In the replay path, the sign-extended value passed to ext4_iget() is
> larger than s_inodes_count, so ext4_iget() reports "iget: illegal
> inode #" and the dentry and inode tags of these inodes are not replayed
> after a crash.
> [ ... ]
>=20
> Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Assisted-by: Claude Opus 5.5
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123022309.9900=
44-1-swinds24@gmail.com?part=3D1
