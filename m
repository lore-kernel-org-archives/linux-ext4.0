Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789311;
	b=qK+wGt0dPe9AdnrdVPux83YkrKVtsXh82R8rPawQj8TEYdgVv1iamp61rCA7x7tRWT9t
	 goKsrYpIlWRQLhMWVfltPKbkDkn0Aelbrw8Z3hO7/KoKfJNbVULlsl+dRAa8VDCOyZgtx
	 zVDl1p9do/bWfblK7exn+w2VSMd264KIdzi/Ly8JDNjG+xOeI/ky1u9piBwnQvH+svWfS
	 CXgeNl5T+dA4ew9sNfGhnQ0yAP7l0uda3eq9+434d7mFn3cGGcX1GOl4VBI7fRDeYE4ow
	 oMtsTIaCCs5bOBGG9VaveRsg9A3RpVu4rvGDTQZUEj/Bk67X0hXu6CDN9UviVxVFz+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789311;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Tw38uOgKEunZ32zO5UtTXKYntUVlEEVfCda/4aveH9c=;
	b=5M6RgwqYnOHANeZR+s2v4uiHLsyySMyGBMnQ9PAQvituyiKQIw+GZXi+yP0al7dU8LJM
	 ICuB0t9laM21t8XkYVOGImIBItknG0onYBmBK/r4hJoWYLX/Uv9wcGB9m0n9Ja06WZOs/
	 OVYg2NZeXkw3/WlhZ7GxU9JfBzj+IMZefRzRBU5PnBTY/LmF+sPcCpXi9aHgkKuyATCM7
	 65J+9QxtVo1wnx9C+u4meIKHOWudU7/91eaPU5+cRagSiTNmYue/x1mR3umktI6THvg0K
	 88bg6Ujr9zoIhSfRUywDSyDs8QUUclbpkmI6Q0jKVfAPctVrxKDrRWcIwSF7GayscnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NRJB+nRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE01606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 21:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NRJB+nRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784D81F01825;
	Fri, 23 Oct 2026 21:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789310;
	bh=Tw38uOgKEunZ32zO5UtTXKYntUVlEEVfCda/4aveH9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NRJB+nRZ3xNKcx4lrTVNvSjmIoS/FxE9Khl/PSPcrkZbswXUlJXlBxF5g8NrmZnP1
	 aZOyb+75Lhsl7ogBaP3ZITQnv9ZUUjSrO9fID+P70NaMDTI1x1zESlDquhbbk1LZrv
	 EcVL0KDVzsR/HDtA/WE3/xh1Kkb/Y//ao7SFomZ6G5x6PEyc2IMwY1ZBPP2+sTE+u7
	 xamcMF0/q3fBC/0x+gqfzG1cj8zwC/2HnIQe+xk0uu1zio82Fxb524M+HCgmevciUk
	 sBLZFgXhNCejGQhO/aV2qdC7xkgZ/YYPET5HbecUQ6QTL3WDUYcIqLTOdQXo7WP3hS
	 JiyEGFrSgWIdw==
Message-ID: <sashiko-outbox-183207@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: Make sbi an proper alias for EXT2_SB(sb) in
 ext2_fill_super()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nathan Chancellor" <nathan@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org>
References: <20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 21:01:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] ext2: 1-byte allocation in ext2_fill_super() via kzalloc_obj(*=
sb->s_fs_info)
--

commit 4e1ea984c67eb1fcebf92c70f142ca114ddb07b9
Author: Nathan Chancellor <nathan@kernel.org>

ext2: Make sbi an proper alias for EXT2_SB(sb) in ext2_fill_super()

This commit reworks the allocation and assignment of sbi in ext2_fill_super=
()
so that sbi is assigned directly from EXT2_SB(sb), allowing Clang's thread
safety context analysis to recognize that sbi and EXT2_SB(sb) refer to the
same object.

Link: https://github.com/llvm/llvm-project/commit/217e229a1f32785fccdd3b3f5=
1429f0d309dea45 [1]
Link: https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#no-alias-analys=
is [2]

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index fb217ef2d69f0..b55f9ce3267f1 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -883,17 +883,18 @@ static int ext2_fill_super(struct super_block *sb, =
struct fs_context *fc)
>  	__le32 features;
>  	int err;
> =20
> -	sbi =3D kzalloc_obj(*sbi);
> -	if (!sbi)
> +	sb->s_fs_info =3D kzalloc_obj(*sb->s_fs_info);
> +	if (!sb->s_fs_info)
>  		return -ENOMEM;
> +	sbi =3D EXT2_SB(sb);

[Severity: Critical]
Does passing *sb->s_fs_info to kzalloc_obj() in ext2_fill_super() allocate
only 1 byte instead of sizeof(struct ext2_sb_info), causing an out-of-bounds
write on every ext2 mount?

In include/linux/fs/super_types.h, s_fs_info is declared as void *:

struct super_block {
	...
	void			*s_fs_info;	/* Filesystem private info */
	...
};

In include/linux/slab.h, kzalloc_obj() uses typeof(P) and sizeof(TYPE) to
compute the allocation size:

#define kzalloc_obj(P, ...) \
	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)

#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
({									\
	const size_t __obj_size =3D size_mul(sizeof(TYPE), COUNT);	\
	(TYPE *)KMALLOC(__obj_size, GFP);				\
})

Because sb->s_fs_info has type void *, dereferencing *sb->s_fs_info evaluat=
es
typeof(*sb->s_fs_info) to void (and triggers a compiler warning when
dereferencing a void * pointer). Under GNU C, sizeof(void) evaluates to 1, =
so
kzalloc_obj(*sb->s_fs_info) allocates 1 byte before ext2_fill_super() writes
to fields of sbi =3D EXT2_SB(sb).

Should this pass *sbi (or struct ext2_sb_info) to kzalloc_obj() instead:

	sb->s_fs_info =3D kzalloc_obj(*sbi);

so that the full struct ext2_sb_info is allocated while still assigning
sbi =3D EXT2_SB(sb) afterward?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023-ext2-fix-c=
ontext-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org?part=3D1
