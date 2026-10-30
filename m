Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376599;
	b=JLF45yIei3RRDGQ1oFPf9Ry5r0q8GY1KZH2XpKV3G2rV6p/YD8F4Dg2vUdYnGphWRaMq
	 bb2SInmTmitQtpZ3TxDiZD7RK3B5b2VfuOboywi2Bfa4o1XYRAGQlZh7o/AYDjYHSReI/
	 kMz6obssHcuBEsGOEOO2i5I7NwMBeamk6ly3fNLV5Z+hsODodG/zOHzKXSvlsRdXYJlum
	 6FK1hw3YKZPIcpgUKW55LY228hCsiB8mbI1wBES1+C7ujDoD0hlAWTp7ZYkntS5aJrHGT
	 ghXJ9hhpjOTN7QFePJp/OrNTMxY2TtMGqOznVlE+A4LfVEECQ61Htx3W6CXUR03RPiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376599;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DmFLPgaaguNFOiAdl4kxtfiobXvWJ5iIV5BwvQvmfgU=;
	b=Qa59zN+tT+aOrF45ltwxnb7xqRvm9sIcCRKplDp0UHjnqPO2ylfNE0gCUVA4cU+UB/b/
	 yz9ihE9h2lipvSEaDrhuK2TK+N4yQk8CkQPhR0ErKpX3njf3u663og9v4LMsFaeEPVRqr
	 D9SCX4HTLX5+1SrdqU4s9oMkK9UEU7mWRM+TaYh9lfzQ1TpB0POp6Xt6e1Ed9CMvXwIFo
	 Wc1Wp8b3EDMihgKx4SMczR1Rt0r7ZBYT1IkmMNbA8kogHPLI+H4j+AOZlOr+WF3di9Xx1
	 0bWCEdIPJHnOVV4X8fK0TzPvUIKpv9G+5mGNfPULVo6m2AQdH/G90ujV50mJhwjwQiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="U1/82Y3f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92096606A33E
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U1/82Y3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271791F00A1C;
	Fri, 30 Oct 2026 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376599;
	bh=DmFLPgaaguNFOiAdl4kxtfiobXvWJ5iIV5BwvQvmfgU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U1/82Y3fkSKulGzrJKdXPopWU3lpy9X+nDFGIk40ElIU+LS+N3sXvKGOfqSpMq2vQ
	 tQ9CKABBQlDma1tdvIPWjE/2YYsal/gYMAidOjMwFT9o8QXIe9dyu8ey1n+csROI6x
	 rnP2rHA/XT36zRs+GQFk5N1d3lAbwwU+MWhU8xUbC7XjpgxznKWy52vF/R1+ntEE0x
	 bpK+Nufza0jvesLNR4yeuiRS4O3sGE9fhlqWNmkc4atyQNiE/bRtUuUUlN3hN31ZLj
	 FRhGkHqeywwQzAcXoJbaKMiOM2vrauB4y+8T+dBvwDXPf2QRlk6DkGpbS34AFrV8bO
	 JLQ+TdI+zPsuw==
Message-ID: <sashiko-outbox-191231@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/34] hfs: use the generic emergency read-only state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-12-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-12-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
> the VFS does now. What's left is hfs_get_block(), hfs_file_truncate(),
> write_begin, O_DIRECT writes, the hfs.type and hfs.creator xattrs,
> hfs_write_inode() which still writes the b-tree headers, and the MDB
> commit, close and dirtying paths.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D12

