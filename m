Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793720672;
	b=1ndSTii99TMtNnJQ69ys6WhmevHRsoUNLtjAyupc51a+nsh2XiMtJNBZtMD/4gqFYVGi
	 4sEwOXXF9qhMJGmesjW6khfmXfyAKRwpMkX/COH6IUfXjudmBdd3f5Fed2beE50xOYncS
	 jXSKsjQL8s72yUiCnUF/WLyRpLCrwCDUKEL76yv7nBcnpmFYp3HyGKL/EG0O0HB8PjLxn
	 iiOT96QZn71/IvxumIht/BWGsKVHzeMTdXu+m8UKeCaQyRVuZk9vv5uM4wZGf4Umth96S
	 tGaJmYrkj4km071PrtWdmL5nyLzMvgBm81rq4KOgKiXPCPlx0t1OgrSI03Sh1aKPW2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720672;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Jt5aLCSjfQsnxO2fmof6yPupB1YMql43faLHHjO7krQ=;
	b=5M+7MjyGbEmsv4TQV/lp2BkpHbjSZhOodkSstMYle/bDoTjXdbL7Zo+bKxoxFzWtWwMt
	 wwYzI7lGP3Jc9XwmManRjFGi5FTI8E9mlutSVc0ig/+9on+x+k/te5asWwTyJ9zK3T92v
	 5gdrIa8JsAT+xIaS2x/RCwZn9/pGmZK5W/l0R64mir6k6h44Ztn6JFhX7GhGskmXPTHXg
	 3vDDHUQmRFu1KgpF5iF4OroXTr1QWzblsGdu5wrqlSxj756P6ezPpAhsGhZimXtTchswK
	 mBleiuN+Tx5p/WzOTfEn8UBf3SqcqT9AMhMZvMLXRDuLRj/V2Z+9u820pyhmSehfUQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="BkVJDYS/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917DF606D817
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkVJDYS/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F1D1F00A15;
	Tue,  3 Nov 2026 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793720672;
	bh=Jt5aLCSjfQsnxO2fmof6yPupB1YMql43faLHHjO7krQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BkVJDYS/aFAMEcsFdngSkJWXGaeYNyQiCI4UE1lEJweTIscJLldvYMWSBUJACIHO7
	 gVAaksF89W4r9eT8FFFVwJl3t1woZCSMTIcEdn3nlQhigMJOg9FE3FyJqG2qEZptk2
	 patKvClpxfJDFwit03ruTiiH2LTIlxHCV94XcDX7F2OP1lhOXD4L4NcPl9p00awLPM
	 ///B3d6c+z4APuLF/ZZTKGpqGFgdX//mzeUaiH9XiunwJKytx/TTPMRMht1BR2Vvjx
	 Oc1NE77qHl3xwBymsNCDlULvvkcuNTHeSOtHrH14Hjo0SHzzchfk9tq0OZ9no4kz3t
	 O64Pcc4WrwmYA==
Message-ID: <sashiko-outbox-195645@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] fscrypt: Cap data units at the page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261103153132.4154855-2-libaokun@linux.alibaba.com>
References: <20261103153132.4154855-1-libaokun@linux.alibaba.com>
 <20261103153132.4154855-2-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:44:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> blk-crypto-fallback cannot handle a data unit larger than a page:
> it walks the bio one page-sized segment at a time, so a data unit
> that spans multiple pages never ends on a segment boundary and
> the bio fails with BLK_STS_INVAL after the I/O was already
> reported to userspace as successful, losing data.
>=20
> Fix this in fscrypt_supported_v2_policy() by rejecting any v2 policy
> that explicitly specifies a data unit size larger than the page size.
>=20
> A v1 policy always uses the block size as its data unit size,
> so fscrypt_supported_v1_policy() has to reject any v1 policy on
> a filesystem with a block size larger than the page size (e.g. ext4).
>=20
> A v2 policy with no data unit size specified uses the block size too,
> but rejection is not necessary there: sub-block data units are
> supported, so it is enough to cap the data unit bits at PAGE_SHIFT in
> fscrypt_policy_v2_du_bits().
>=20
> Note that a filesystem whose block size exceeds 4K then cannot be
> made compatible across page sizes (e.g. 4K and 64K); this can be
> avoided by explicitly specifying a data unit size of 4K or smaller.
>=20
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Link: https://lore.kernel.org/r/20261015185325.GG2170687@google.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103153132.4154=
855-1-libaokun@linux.alibaba.com?part=3D1

