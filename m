Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238547;
	b=JPVC5AhjYHj6Wpj+EyIx5QR1cUHchCVhUifmOwr5bMnb3Gv5GdVg+UH7T0rs+RliFn8+
	 bF/MUWCCtRbA4/fd74O+jbFiQhxHn1wdQ8QKwAEajPjpWrIt7UVhCABOYza+kL9xqc0vL
	 tOhIOIjwDz3uifkXx8mMrr/EnGtZSNqNXQqCGK5U1KaW/+lJIos82/+Io/lFVJat4trTe
	 BAoIupSa9AiLZgwnvYRBtwsp473wX7IZcaEmE7hZ2OGhhRa+nB7MRNjrD19nuPXtZFVPL
	 4PK93DiTSP9zCNyZt18g2rIfiKwJuwZ8GMxHBv5SK02z7CA3U0LOwhNXw7oVOrgN0IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238547;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f+Fo5zjJtl3fk9Hpb5AQrI5FdriMduDsTQxBFiTldy4=;
	b=SmruzZxGlSO7J+F4geWUf2SZT/4xtk08wiWJyzkXsTMstXs8LwKupllrziJk4Babw5QI
	 /wKaufU+REzTt0y8aIDUw0VT0DevbkfcHqvmjqXdtCQUqc9KbXNPop2OQPcUn8tK1/bT/
	 0JOTggLracPkuoCiydcG7sl+f6sMvwtrnrRW0hkRXl4M3wO8ISFu7Bjj5odb4EeKSH526
	 ul6SkXz6Nnv4COzyRbcfQEIsjMdwAWboDefsbyVNcMMjfeKI4fxVP6moaA/K26slU4NxP
	 3GfhzkokdxQUMWuXWDEtEf6+gWHont5Suis+LO0Ex1haIMX+ZyNkxrYOIWsx9TILTBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MabmoiRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BD7606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 01:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MabmoiRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2061F01244;
	Thu, 29 Oct 2026 01:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793238546;
	bh=f+Fo5zjJtl3fk9Hpb5AQrI5FdriMduDsTQxBFiTldy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MabmoiRZ1ss1uQbeiZN9yGK7LtFCGwPTpVQi+AeCsNzAvU4okdnm4beHEdhSS/FQG
	 CKIqJ3nWRSPDzs+7qz2bQelJ/b5R3FkXKiOgbrsCzFiGF0aZb7t8/Cq1UrYv0URKss
	 Mdgkbl0fzL/K9lz+6xgI5EybeLjdEwOmBKY0N7IVunglJ02eUV4CujMugQcp2t/xLR
	 apRHxB5oRp3uAZtCzsug7DUUqlGrLZ1wwA+Z0JyuqcUthh3wx6QDWfolujycr4GzP7
	 GL/qqFp3VKceQkSg/o57vnTWzYjiKCdNPkb8pKsYuAeXAWqkHprt2fZ+0HTo+RGevC
	 wkpEO7NFbyx1A==
Message-ID: <sashiko-outbox-188620@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: preserve IOMAP_F_DIRTY for extending direct
 writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029013616.97194-1-dennylin0707@gmail.com>
References: <20261029013616.97194-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 01:49:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext2_iomap_begin() sets IOMAP_F_DIRTY for writes that may extend i_size,
> but clears the flag after ext2_get_blocks(). When the write uses an
> existing mapped block, iomap can then use FUA and skip
> generic_write_sync(), even though ext2_dio_write_end_io() updates the
> inode size. An O_DSYNC write can therefore return without persisting
> the new size.
>=20
> For example, on a FUA-capable device, a 512-byte O_DIRECT|O_DSYNC write
> at offset 512 into a fsynced one-byte file returns successfully and
> extends the in-memory size to 1024, while an immediate read of the
> on-disk inode still shows size 1. An explicit fsync persists the new
> size.
>=20
> Initialize iomap->flags before setting IOMAP_F_DIRTY so that the flag
> survives and the required metadata synchronization takes place.
>=20
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029013616.9719=
4-1-dennylin0707@gmail.com?part=3D1

