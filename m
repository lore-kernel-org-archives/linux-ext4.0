Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457111;
	b=eonGJ/93uqIi2kIgR8Uy2jXn2Iu6Ir79dFzRBmpdQNFBg+OZ+/CeLqAaq6uUyuC5HstB
	 IUrSuj3v3fO8VgkfFmQcuxJiJTstl/nHGgBwjH/qrFo4hikTzqd4+zfdROvKVNwKKneVu
	 1xfg+7pb/lNuWRXANqTjwxblaaLA9p21FRWLMTpM4QzrVRMjpjPIPmP7C4g/zGPvJInRu
	 G7+UOkmw99mrOo1yKUofesAZewijH4pfp+JvMrpKsaruXFxPm/VJ3yp1v0KCdD681ZUQx
	 h3y+g3XxOMCxdLzSRFloWVFvzz1GthDXG/9gM1AeFS4sj+gCBm+2XQsCecEU6L9ekfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457111;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IKS85BWfKA/TaCfkeMcyLb1KCuDej7feT4w/+jdeOx4=;
	b=jpIap5taI3pKeHcpKwfBYkzh4CXFPo4fOMsPR6YKZ9f2MUgQzbhzZr8Qsk3rWDTebDDq
	 /monCB3ZsmCuP7ILU+nzmfO91g0I1thl9rYIh2fdYTYFxUAOvhWWA18v/ZlBB+AS2YRP3
	 gqvtMuMSfU9xRPSEr3A3py942YBG218LJNBAacVOr32zLNOG56bTcKeD5eGpNGdbQrabw
	 bz7d1BoDIpuUQutCrWV9BR4+X4SD76PFtEs//Uh/0okv9sJr0devbr3a6hW0KuwFyA3A5
	 KQfiuXnD2fmT19qGFFa+O/EqpNwjjG6yK2PPQiwbtEBEFEPXYMl+pMR+UzgZMIOAX8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUTDiv40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F9B606A898
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUTDiv40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CF51F00A0B;
	Thu, 12 Nov 2026 04:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457111;
	bh=IKS85BWfKA/TaCfkeMcyLb1KCuDej7feT4w/+jdeOx4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=kUTDiv406pn/LYPONP7oahZY21ZLwDUDAivBYf8f2ox2Zg8MRaO/qe1nFNed1n8Yf
	 +awgNcymcs6PquHjkrK0yNmWz0egrEFE2Uysm742qZVR14KRFUgsduc69uO5mJvIc7
	 dPwP6jBnac65MEQ9YzN/CrsUy2O4EmPqjIGjh2AZ0Qo/KAcRcQpM40TyoaBGH7JBA5
	 zxrOcuj+k9YMGhXPFimPc+fpKrNsnROirQ+B6gkcZOcczK3YkvDqGy7qDjrcpKIiWi
	 qGqU2bayxYKPiZ+sHDcIoaVqgN2OpVX9z46nycrE8FfProFnVfnpW93W7WkhES5brS
	 Ec2aE2tMjsv/Q==
Message-ID: <sashiko-outbox-210323@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/27] ext4: add KUnit tests for fs/ext4/orphan.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-14-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-14-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:18:30 +0000
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
- [Medium] ext4: unexported ext4_superblock_csum_set() breaks modular
  KUnit build
--

commit 7b2d7b8d20233b110a9621f769fa6154acdc1c4b
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/orphan.c

This commit adds a KUnit test suite for orphan inode tracking, orphan file
management, and mount-time orphan recovery in fs/ext4/orphan-test.c, along
with a static stub redirect in ext4_truncate() and test symbol exports.

> diff --git a/fs/ext4/orphan-test.c b/fs/ext4/orphan-test.c
> new file mode 100644
> index 0000000000000..f93057df1d31d
> --- /dev/null
> +++ b/fs/ext4/orphan-test.c
[ ... ]
> +static int orphan_test_init(struct kunit *test)
> +{
[ ... ]
> +	/* Keep sb_bh unmapped so ext4_commit_super() skips bh_submit I/O */
> +	ctx->sb_bh.b_data =3D (char *)&ctx->es;
> +	ctx->sb_bh.b_size =3D sizeof(ctx->es);
> +	ctx->sb_bh.b_bdev =3D &ctx->bdev;
> +	atomic_set(&ctx->sb_bh.b_count, 1);
> +	set_buffer_uptodate(&ctx->sb_bh);
> +	sbi->s_sbh =3D &ctx->sb_bh;
> +	ext4_superblock_csum_set(sb);

[Severity: Medium]
Does calling ext4_superblock_csum_set() here break the build when
CONFIG_EXT4_KUNIT_TESTS=3Dm?  orphan-test.o is linked into ext4-test.ko whi=
le
ext4_superblock_csum_set() in fs/ext4/super.c is not exported with
EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_superblock_csum_set) until a later commit
in the series, commit "ext4: add KUnit tests for fs/ext4/super.c", causing
modpost to fail with an undefined symbol error and breaking bisection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D13
