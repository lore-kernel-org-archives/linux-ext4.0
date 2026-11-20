Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190302;
	b=Rp4+Q2sFnfLUxItC0vjuLjimbE/BEcFJldR+Hw8ewSEo+0q195fvcMdygiOFGDEW+J8z
	 X7ST1iwXGkRlFuKV8CaEfj7vhEyPi2IEQPsvZ1FBTs4uS9osUQEAdGOs3EezhMwlDwwwX
	 xeAefLGOEeOwrGWAqEZO6xCCr21VziXbHBrKwDzUbPD+5v/E8Hf8BUMfQSU0W8TA13pNx
	 K6ohc1b3rHJFlfbK8Fq4ZMagrkVcHlsfE0NlokAN/700wdLr9DEOw3cBmfhYLEjkqGfPn
	 ymC715omtK4dREF3i9wF2/S4bFOQ0k0GwXX9oTsGQ/nVybMrjEhUgyjIZXcoV2dfrXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190302;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jvwEi0mFhrneUn8WmBlzCV4c4DO6QGI+7c0zI56VwY4=;
	b=J1/T9WjViMRGyXvTpB9qvCAjTwZyT1D4nLsXZiT7sNPsioj6lUD6T2Kai3DYofMedUXu
	 FXBUrAyKtUpj0XpgNfxzEFlS25YrB7VyllHGCIJdo7ksLcsD8OXV69GyDjw19bFcYZVqu
	 xjL7DpK+buHvCIu4B0Qt8dIJSXmXgytSDKcFYX1iOp7haKEFw+WTgaYMJWhGtjOyO+sFi
	 7kQ+WcXsId5jprP051Q2Cp1DyYEp9Ncu9aerDQB9mv52aDC1dwWZAr7ofGEsvmsWN63Ls
	 tg9LnWc2t5BnWG+6X8o0448WC3er6DaoWwvGSMKYbp+Q2vPGfiSJg7HYQec/Wner4qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjyMN+r0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41379606A332
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjyMN+r0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2541F0156E;
	Fri, 20 Nov 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190301;
	bh=jvwEi0mFhrneUn8WmBlzCV4c4DO6QGI+7c0zI56VwY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OjyMN+r0uVTYROhtINlZBKUCzJHfiYwgLVn6u3o3R277UCp2JtDHtNoJhHFN7l3kx
	 kl4mYu+7dYojI6uikNFvXtIJ0R6STC1OXiFHcBbKSZ4VEy+dwp6yVxgtwedywqnzVy
	 IEPKSgc4AkwGJFTrwbqHklRagRTm8XASCpCMm1hHhz+WQC/xNvlmkJf6WvOD5a85xw
	 TO+PktVhnW3DzhBJl0zkQy3cZGAI5QXZjmZwJe4h+TKEuh359IOlAEVD3fOuc4RGKb
	 6+H7FDVehAchcMEFeUmIAU+kEwbRB0yFTLKvfJrJbUtuKnDIRpybcJJeu7FLBGer6R
	 e7zG5SYwZ0XPA==
Message-ID: <sashiko-outbox-225490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/7] btrfs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-6-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-6-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:58:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the inode runtime flags that
> duplicated this.
>=20
> btrfs only used BTRFS_INODE_VERITY_IN_PROGRESS internally, so remove it
> outright.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D5

