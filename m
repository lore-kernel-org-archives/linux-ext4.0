Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402914;
	b=iOR/zrohdvJ4dAG0IioQHMIwrq6/cR+Su5Tifs4b5XkbEYqmXyvYz2UuSplVAdQXGKjY
	 IPk0U55qgQQ2nWOnPWcivdmnMrqfr4pzeu7UTfZrcou7/BIfTMb2rOvQpZLwiBhxIHMJC
	 /CLS/NIK7Wj37QL3r8lWUKfCeEuMZhcGze8DwH9V01Ls4Wsl33Em5nZSFGOAtu+vD0ocq
	 s0lgf4xYOXGwIf2tXPDn4jb4l+bzO+xNtkOBeHriwiAtN1gfZs9rTo8FvBuBgD4dKP98G
	 zuN+N29klC6b73GyvtMFrVEsuHFvKgOFy+5cI53lTm7pku+BZbsawebO6HVYYBjshlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402914;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HQ8kLeHPKLuehwQQau21rz0a4Kx6ePRIwxYmiDcAnh0=;
	b=jn6f5dmv8Vk/R+Fsvl3PyQz9ZUGOJ+43T7dOqff1V6BIATEIO5g/PuYkYyJ4/n5ghaxJ
	 odFa7QFR63XK0g1cw2+t3h5hECvbWvCwsFvkGKECDnTiokYbHpKvwvPJBliyaTADFYRnf
	 pAbJu5JViY6W93wdWgIIJnOKPoSp0cMCH521zMkLuIELCfV9wFOpbN16wvQtegRfp36Xw
	 FFfbzvtVPQyHd2fzUfuvgXYywkusnDumH3c5UxO1oKrsBVZ65S8ut1mT2UEsu5jqWDVZR
	 dCDpEQh4ejbiqwm0D1GC0XOB3pP5hYZEyrB16TPJf0UdJ6Tmuz0/MqZESt1lOY+AqQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEdHkE2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEAF606A324
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEdHkE2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3A91F00A05;
	Wed, 11 Nov 2026 13:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402914;
	bh=HQ8kLeHPKLuehwQQau21rz0a4Kx6ePRIwxYmiDcAnh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XEdHkE2tVU9GbAg29o0xQ4VeJuJe8Lqvsx1wZ6Di4S9NMFlbpgdaUXMLLfRLnNf77
	 Vrir2tKsG62YiIHRoZ5lBphfA8ZytjK73kyM1yy8GFeBYdLjVd5S9LZA/aef5HaDW2
	 LRufho+nmA1DD/Djk2Tgd+LAu3fvlX6/IOmEqGs6cFDb6ZXZ9CE0dZLe0a8+WOX60g
	 HY2jQHvpPdKnmUKYbZeVy6vRs1sAT/2p2o3VQtt+3HRCaCw8O1NU8QBQW67ynjVF45
	 Grws3xz5xxfceWgDfJwXeHKKnZZs94OTmyfpCPjjaVUgnifT5+KNN71glvn+liIRzt
	 DD9H8mpCiJE1w==
Message-ID: <sashiko-outbox-209051@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] ext4: make fast commit support optional
Reply-To: sashiko-reviews@lists.linux.dev
To: "Max Kellermann" <max.kellermann@ionos.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261111125242.1078620-2-max.kellermann@ionos.com>
References: <20261111125242.1078620-1-max.kellermann@ionos.com>
 <20261111125242.1078620-2-max.kellermann@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:15:13 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext4: build failure exporting static inline
  ext4_fc_init_inode()
--

commit 2b96da3e6bb4354cc67ea3393ddf5ce91b735978
Author: Max Kellermann <max.kellermann@ionos.com>

ext4: make fast commit support optional

This commit adds CONFIG_EXT4_FS_FAST_COMMIT to allow compiling out fast
commit support and reducing in-memory inode size.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8d3af062a8306..34843fcc1008b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h

[ ... ]

> @@ -3109,6 +3123,55 @@ void ext4_fc_destroy_dentry_cache(void);
>  int ext4_fc_record_regions(struct super_block *sb, int ino,
>  			   ext4_lblk_t lblk, ext4_fsblk_t pblk,
>  			   int len, int replay);
> +#else
> +static inline bool ext4_fc_inode_tracked(struct inode *inode)
> +{
> +	return false;
> +}
> +
> +static inline void ext4_fc_init(struct super_block *sb, journal_t *journ=
al) {}
> +static inline void ext4_fc_init_inode(struct inode *inode) {}

[Severity: Medium]
Does making ext4_fc_init_inode() a static inline stub break the build when
CONFIG_EXT4_FS_FAST_COMMIT is disabled and CONFIG_EXT4_KUNIT_TESTS is
enabled?

fs/ext4/mballoc.c unconditionally exports ext4_fc_init_inode() for KUnit
tests:

fs/ext4/mballoc.c:
    ...
    EXPORT_SYMBOL_FOR_EXT4_TEST(mb_set_bits);
    EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_fc_init_inode);
    EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_mark_context);
    #endif

With CONFIG_EXT4_FS_FAST_COMMIT=3Dn, exporting the static inline function
causes a static/non-static declaration conflict or fails in modpost with a
local symbol export error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111125242.1078=
620-1-max.kellermann@ionos.com?part=3D1
