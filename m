Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280863;
	b=TCWwQDUt2hsQrbTuyr4DyRh8symdvUOkocTqyw66GGRHkcAt8yAmUtyche52UX2KM78O
	 hU/VqjoTd5ISnhV47yz6RE0w1pTQptABHBhuCr7NnOKSzNbndaZnumlxfxriB5Bb2Iwxi
	 xc4XPbpHyqPic0jJTl55YGEyDRotbdIWtZ0dlvDyqDoXREB6mvDlLhd3aIqIk7rNAgFUa
	 8X+Xt+kRUMnEnmZWtfGZc9BqcBmz2jOS1PvAqI2s9KwRrmN0oLlZJ0tBn0R63HU1w/ITc
	 3e9/5kFtpLt5z5n3rCninG9EFLKo/IoeffQftApl5T3zrcxbs3l6lzwxUInp1FXVc3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280863;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0Ge4yvV+LHtekQOGveEOIsHB6CBXrn/QIr36g5AJKbg=;
	b=Uwb/tCDo/pUN1NwdRITbAgAj+BcHC/2mjiZeoFkrp8isNs8MP3MNzevEJxE1HhfpWYek
	 smgk2ZmW/Tbx4/OgXFyBoPRtOvirf5h7yG1AflHdnsN2CU31Ps5uyLUOCTGykwe0BYe9H
	 O29Xn6X6YyYFO9YIQrg9TlOzZS167J8LOarvh4dfuwOfi2kDI9vRji1JzPWcGJkHqiCaM
	 lkWtqoDEoCMhWtUPUzXhk5yckPV7NcWVWtd3Pj6PTrwCc7vimWa4U/kQGiLxkSzx21D7Q
	 wwZpJujwQPl2YXCfftq2oUVWWTh6ufMIjkEjahUhWUHAg1aX6xRiEFf+eTy+4SZ3prw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgBafVar;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4321606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgBafVar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229BE1F01825;
	Thu, 29 Oct 2026 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280862;
	bh=0Ge4yvV+LHtekQOGveEOIsHB6CBXrn/QIr36g5AJKbg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jgBafVars9flzFfHMpAr8vvWCZEELs8jk1N5+cRHr1a9lf9n62qWV0ihCCf71ueI1
	 RyManxxBvJbWMOjPTVpGjpMfK/OMDOJGv4PPrY5Q2hIVTIgsj463ZSQrrhBDSSfCHH
	 +HZmllTAqwmHDswfRiYfCCKQ5Cxnw8+2kYq7fbK7cPz6vdmEBUd7lpMDVJ3DH9ee/H
	 rvEKi3KBNNKq1RurdKkvi0Qyoi1h9le2xXZnWF4R4nwoZAvyioKJbglyRBGiQSljh4
	 +W6UFVPX7e/5eSHsWXRqIpYu05rudepCUw//g0UTquKgRzslNohNH3h0Xmo7EVSlrz
	 w4k8/i9K4uE8w==
Message-ID: <sashiko-outbox-189394@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 5/9] minix: add minix_inode_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-5-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-5-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:34:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the block that holds an inode out of
> minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
> minix_sync_inode_metadata() is going to use it to find the block
> without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D5

