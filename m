Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751158;
	b=ezuRdtk9XC/GTsbPam8EyMvLTHkVUDORXFfTGfYaQhfAJxkYCXd9BOxsnAaDcQj8VYiv
	 TZmPm1svuF2QN+9AVOHLQfjfM/EeA7iTtszusY7N1/dFtlnSXO33yWIlauq4vgnPkZwyx
	 q1uoWGc4XfMS2YsBPKGtudRZ7DpTHYzx++8SYgZ6Gb5oRP8HpcTao6FoDHJ7rxb50HAxA
	 FEgcp+5wsbr6zXUIakSX1Z3ZqiivLbTMlrfGK2ypGiaz9y4Oq9tAq88hKcL2eubw9CLJT
	 6hwsUyfFZQmGrIF1pBswy9pg8ldkKw4+A85I3zsyVNdIKWLBF82aN7xSuIbqycin5Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751158;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ONQDmmODWYQySYis9J/pFHHB76LyNpvih/AaWvZTgfw=;
	b=cCNs9ARJOp8QK5gsRLiQkAlVHP436+k1fF84hEAEfE7muaMip7vtfeqgf2UK1+E+GQ/n
	 o/VMJ2irvDZWvrbkjOkRHbawXRRXAV6Z4nbk3fqWxdepb07JQBrEDOew9yDQICxgOnr7K
	 1mmKBaAsslxxQE/TZ6G2Kful/zQLtJ6yp2ed7NP7mfexca3EzvoPJWElxeb5I780cU5/b
	 vxfEh/HxTD7HAyp7DGYZHEy94dnIoZZOMS+8vcl0mWHkBi6TKcUBVSfwkbzwZFv7eQep9
	 Xzf3A9/4Wc/+uspU3HLPW2ctoFcmAUYJb9BJxmyvx+gKxy44Us7berZblY2OFNYPv1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g3GLu7KT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076F5606A31B
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 10:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g3GLu7KT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581551F01825;
	Fri, 23 Oct 2026 10:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751157;
	bh=ONQDmmODWYQySYis9J/pFHHB76LyNpvih/AaWvZTgfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g3GLu7KTFIEwAWxm21iY+HEuLHsbCj3Uf29U/jr/dUbeexWGNFqjt4244n8d//22d
	 UD9KNrrQ5Ki5YeCVl7tLBb58JOEo30hyEEmh5yAjjbDxEN+01Qw2+bqUlSlcB+Ubmo
	 ztb3rRDJnHWwRh1QSPJ4RKfgMZG2ie/gF/wx5UfDT4gLztj46+WtLHA5LsMDPcL8sN
	 u/7txMKWoJSw3dwrdxrSRtrfonnsTpEmuSeO2wuNpy+ZTVdujDKye+pdA+wxRfz+d4
	 tYJujCPAtNYo2pQSkIsrCqXwQdxfzzcyo6TC6ZxeS3wdxZ60V6z0amUj2OivYbl0Qo
	 x/+/J/1d0f94A==
Message-ID: <sashiko-outbox-182682@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: return -EINVAL on hole in
 ext4_convert_unwritten_extents_atomic()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
References: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:25:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> We should ideally never encounter a hole during the endio conversion as
> that indicates something is wrong with our extent handling. Still if we do
> find a hole at atomic write endio, ext4_map_blocks() returns 0 which would
> be returned back to callers by ext4_convert_unwritten_extents_atomic().
> This can be wrongly interpreted as a success. Fix this by bailing out with
> -EINVAL instead.
>=20
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023-ext4-atomi=
c-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com?part=3D1

