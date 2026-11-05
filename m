Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880228;
	b=m26eA91EGpKKJ5X8TeGV3P84KhCZ/lwU25L8fmOSJNhsSybHEwhMKNrFj96nmU9N6q4V
	 QkRHZFHTNEeR4nftluIXw6cit/BQ2QEm1ZSaJRHGFM21Jlwfu3m7mpvvUQU0GjhAkHKOV
	 uLWnGylGXJQ9gDBpTlcLuBcEfMB86fTT9BQ4J7X+tlLlFQAI2LUzLaCwuz81NOXgY3mJa
	 KHTWn8oV8+OqTFHBWnCUsX0+75CIM+/BPIIdl45WItjXMdxlFHI09Yl1PksE8l9qjNErL
	 6gPXzCgkIbWzJprIwKVR0cq/F0CEN78QRo3RKqpQVJ+ykUfIuAAYRkRliY0wQQBNv8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k/wi11Q8Kbwq/8dtX7S4+c84XHKcQGErwPRnzMyAsJw=;
	b=NrtsCkhWpj2YJ+LDIb89/9+zRZYPTtyumIIv73I/DqZKeZ6QYVzuCan/MIGsYveL2qom
	 221L/pLLQR4ybnkfowLzmuRoiH92b6Byr1ftdvcthKxYy+wU6ZlTAOgsVic9cszzooOfN
	 dGy6k4ETtjzdT3o8jQUSN8hxe6LqIRNHvEmOYM+EqGyDdKU4S3jUmk7msTOlujVG8R64A
	 rDk3G1Lw84FhqBoPMajUxQ2lP8kg00p1W8t6h24dZF5+Whmk7w2QjiaVl/PAJB/9/sN56
	 2uaus9Tw+SwIsD7YTOvrRVvTMEKH3OSizF5OIT3OLDy8CNWxvsh1qHnQxI5WgSzuaFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ik2wl13d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5521606A332
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ik2wl13d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328FC1F000C1;
	Thu,  5 Nov 2026 12:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880227;
	bh=k/wi11Q8Kbwq/8dtX7S4+c84XHKcQGErwPRnzMyAsJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ik2wl13d/USMdBZVuezajsFt0QoQiThbp/4So/UbVqw3aBzjyZVGsJ5iB322vMNOL
	 SBOaQTTeKxYY4lqvnSswK5TP13TRs91b9oq6Pt6utI1p4Yct8kpqCnic3vMDhrn5kA
	 CP9Ha4p/3DUoEthF6FzDCkyE3yzf8FTbSU3Uir5z9ASiPR7wvmbavsR8IS3osWsuNZ
	 +1gHRJ6mlKmLjihpLPzO8PqHGqFZAGyvrcNKpQE+pse2I11AakQ/Fs9eLGG289BFEh
	 qzI3oJwu6ZzOeLqBGS18M8Poe0i6VyfXDyYkurMJu2mFwDEwt0gBU8N/QIgiNbcdvJ
	 3Q5nbeNg3mi5A==
Message-ID: <sashiko-outbox-198986@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 1/5] fsverity: strip FS_VERITY_FL from
 FS_IOC_SETFLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105115532.613467-2-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:03:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
> Filesystems could return verity status with GETFLAGS, attempting to then
> pass FS_VERITY_FL to SETFLAGS is not allowed.
>=20
> The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
> however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
> doesn't work on BTRFS for fsverity inodes.
>=20
> Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
> no-op. The file_get/setattr() path is fine here as this flag is cleared
> right before fileattr_set_prepare(). The future fsverity support in XFS
> would also need it.
>=20
> Cc: Boris Burkov <boris@bur.io>
> Cc: David Sterba <dsterba@suse.com>
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105115532.6134=
67-1-aalbersh@kernel.org?part=3D1

