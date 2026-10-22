Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792673296;
	b=GO7JjGKOsTQPUB+6bibDActV3H/Dq3nJP9Fm9PI7HPD6MWzWIGVE642EOc/hBkBrfYLy
	 n7O1PjbZ9/BNhl7iUI3IkHv9d16HAxQnybSli9iBErcTH76vEbBXu9bQpB8u+z7OscR4M
	 lK8J3rhcKKY0I3LcuyxKh1mo8wACabqO88z9/TktO6EV8uO3mh+lw2SH9nQGpbrfL0HY1
	 HbXUzM5gish0kNab1nUsOiV3GSq6vdY11EPFbUBX0XloEX3hNRVMo+MdmBcU52bw7MZpn
	 wLYJsiahnjzURRpeJdRi4yJCsM2NqqU6yKn8CNP6s3pOWXnlYN/nN/4lSDFxyeMIufg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792673296;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=F5mdvUYsVNiOgtQvuxdVe/4OzAYQNK1lfEkEj7AIQdM=;
	b=bN+kVjkSLUTIdjdfo7W0vBBX2sOHx7arJ7KemVII649R0bVbJJECZTBJIuyRf2PQ/BIZ
	 b+bpDWMzPTeZHdO5M+jr1iWKTm3yfJe27310PCtdHta/5wtjK2fDDw8kVIwC/XMpajxok
	 qMQNzJg5tMoA30G7WXa++fbKJYn8kV4X4gpfI0Ey+IwgiZCoBcoo1xL84X/Dp87llImqv
	 osgbb+62GBlfCE4AGL5DcxfiU5WIDpjf3t5jSj0JL9ji+CYsSPPbBIPyuZX+KQwseJC1Q
	 egrQidg3ALYP36PZVUOBWXhP1PN/rjVKB0z4p/fW49xdXuIx6DyM1ex0WamyLrIIwjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVEpoySu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A09D606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVEpoySu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7E11F000C1;
	Thu, 22 Oct 2026 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792673295;
	bh=F5mdvUYsVNiOgtQvuxdVe/4OzAYQNK1lfEkEj7AIQdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XVEpoySuj0oOFhvVguX02V6cfUi4kKoQr3f63/OUDvecKKgmX1oj3QQd/uqmV1uOW
	 RilKuIiX09/7WFPuiwYUQvrk02a/OM3j6UzLQZSAaLg4SqjQLkbEWTGrelCY0pMAcu
	 OA9j1EOAJnp2ftRno+gTwh9tPjYiyU8Lvrz5BeZT8uewS3J1glvq+7NQg7+QNarzjQ
	 O1cpqON8TKhvSSpBW5X+PDIedY6e/0OfSo/AkSKGldA4cVvWqqtgLKUqgLtIKLPkJy
	 ME+jpRflUPZpyXpUN4HidySV7/cxttP/4UhTyXmWrjHefjSUgWtDhbufKG93Y5KOqD
	 EE/vdG9WJmLeA==
Message-ID: <sashiko-outbox-181503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: skip eof zeroing when the zero range covers
 the eof block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baokun Li" <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022122625.1744363-1-libaokun@linux.alibaba.com>
References: <sashiko-outbox-181121@kernel.org>
 <20261022122625.1744363-1-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 12:48:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_zero_range() drops the page cache of the range before allocating,
> to avoid exposing stale cached data.  However, the dropped page can be
> read back by the eof zeroing:
>=20
>   fallocate(fd, FALLOC_FL_ZERO_RANGE, 0, 4096)
>     ext4_zero_range()
>       ext4_truncate_page_cache_block_range(0, 4096)
>         truncate_pagecache_range(0, 4095)
>           truncate_inode_pages_range()
>             delete_from_page_cache_batch()  # drops the page
>       ext4_alloc_file_blocks(..., 4096)
>         ext4_block_zero_eof(512, LLONG_MAX) # not block aligned
>           ext4_load_tail_bh()
>              __filemap_get_folio(FGP_WRITEBEGIN | FGP_ACCESSED)
>              # FGP_CREAT reads the dropped page back
> [ ... ]
>=20
> Fixes: c4602a1d09ec ("ext4: move zero partial block range functions out o=
f active handle")
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022122625.1744=
363-1-libaokun@linux.alibaba.com?part=3D1

