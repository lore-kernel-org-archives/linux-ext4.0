Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190537;
	b=5GXmPdGUGimqNsaff4wz6PwCLFaGmoY4sXS7+7PsgJ88gRqFKdwpCbTK7eqVtMvaDuzQ
	 LFod+3uUs/qnQak6jjhsZHckK8dHNcBRgF8KcLimb35+o0zwkwt8Q5xflJ2GVwvNaBC0x
	 908SMTsuYURmffXMvy7M5Ax/qaek0HnZxL7Rom3O/GY2Ty+wqmWvEKz7rzKffG31hPBa5
	 mWgMVVw4KYpKOsfEVb6t1KJoSgOVfj8ol4YLKFuME4sxi/y+EuuL44UwUkSpyffGKMJyn
	 fQAmmusxTK3rzMjHKpfBWGGFMEyWu5n8+mD3EUT4CcKjR/Ym/0xulVfQKRVSJV8show==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190537;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9/9K6HhsndJQ/nzQ8RpsAxmO2z4gWxjSuwZEQXhBWos=;
	b=3K1LGICnAHeRIrvYEiFY4tNaIREaxCfjf935nnKgxSsmlflhuNgHLeWCFuSg5LxDG4HP
	 A94um3FPOTvTh4dKX7/3vPLkmmdhHcG8o1QB+ojjLGZsOy2zmrbXX3rGJjSMHYjfxvd+v
	 8zKUMjeUXv36pSpFr5pz3BCa9NZ8jjG0xgXlIAsHAL+FtJXSbK6/CstnIXB+GZLz0gxGq
	 m8R7c20W/aUYNWY5mEZY2jyuHUt0lgjCATsNp4sIgzLAIsxRia8uCZ+n9H/RNEEVhboop
	 nE8ekaRJLAI9LkDZSLpZN7W6xqMdz1zLV6NQ1iYIc7mddo/sP7OfmBMQNOeIFFz+CXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E15lrCSx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA3B606A320
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E15lrCSx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EED1F000EB;
	Fri, 20 Nov 2026 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190536;
	bh=9/9K6HhsndJQ/nzQ8RpsAxmO2z4gWxjSuwZEQXhBWos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E15lrCSxeLx9URcGzKw1kvGe4SHKRIXJHye8aNZlDXKT5/CqloPs6FDI8n53Hx51y
	 yaYDDLX1GIHhGS3qWeWn176fSk/XHhF7xAAgg9jY/NBl5IziQi6iXJjVYUmmDkyl9t
	 0bnvZ8glmwIb6Y4rKcfvd54J7VjSEak3gAVcDhYfOl0W/uCaij8OnYJFdBNSoLbv5W
	 9+JfZUA9cdqyOdQZ7TTMyMUS1NWq/zkVjffBiFyekG/rfQyDFonjB8mz2I1dDrcFg0
	 S53MBYjwxwiydWGdUzplNcbLAbNlVodnyJcK325P973E9dN6CCxT1RRy3nVh//LEf4
	 KVGO1wXYsSvfg==
Message-ID: <sashiko-outbox-225514@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/7] fs: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-3-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-3-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:02:13 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-1-aalbersh@kernel.org?part=3D2

