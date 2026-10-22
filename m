Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682158;
	b=NhpncC0gaBlOAA4ipvX1CXpcKD+g+QZPHfIwX+RLYHlaaJzyejNB4FVH5rrcAtTjZMuF
	 noMDsoKH8Mq7vmbXQ6Sf9SaN7YUdXvlKx53sEGab0JlZ6f7mQu/FM9p6Z2mjcR26jHiGv
	 JsnkLd700O423qEPDwZQ3jmCq2zQRE3If34ADctZ2EIAyuFDn0hLZYdNirXcBn+Pqf1PK
	 y0aBtUHDrgsYqO0rgkW806KtCUBx1jKF+hsFTcgafBqvTTO8yV9lwyxU6P54uzY0/NfMy
	 vWg2tgo9CAZ2ofFZ+dUx9BA/Q+Qm/rlmgg4SOfVvswYQ1gSGybLLyfk4OCD+J+BqqEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682158;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0+dxTVfu4qA7A8udIxzvEZ2T1z8lngpos/gi8+qRrNk=;
	b=BetDtXxVipRQDyZ7gmA0CbvTaR99Mm1deWU0oEkYoMwoaLj9Pj0C1DtTLq0Mw9iILgSx
	 GwrnDgf8MyEqDbRLCOD3Y5IgLMMgTZdRCDi0cN0dhNNxxI7IrSjcYmPIZ0YPc2XLH5KK4
	 danuJT4FiBCRAwSh0YRBYmc9uAJZqcwMv97DW2eaO7rJqUwAefFOhEU3uUQS93wFLajRB
	 kt4Ek9IZfmY583E5opnH+onR593c092v5e6TlQScReYslQHPJMlp1b2TK03fOTK4LC8R4
	 j555XC6/CiJEfQnR2OWxO3Uy0OGh/RKENMEXFZj0uga5eJt1Qy2BdFer2d5JmWbqJYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcSs2ByD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F788606ACEF
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcSs2ByD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF7C1F01829;
	Thu, 22 Oct 2026 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682158;
	bh=0+dxTVfu4qA7A8udIxzvEZ2T1z8lngpos/gi8+qRrNk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZcSs2ByD8AbhZWBDZaLyk2CzYZ4iuL82n027UDOxgTL0kbDZQMSufkTktQZrSg1mN
	 pNFSmH8G8FCkpMpQFJ+5gzNSWXUW1F71mrFF6Hr8ihvNcb6y+nP2EE1opUQToR4jR+
	 uSBihkulmZyqtcITLVCA8g8jpkM2DPjaTgVj8fc2BxkKNZF+yh2F/XBrT/FzJkwYWO
	 jkWqh32dcGMlV8TZnks2K8Ibh1OEGL632ULEOn6KbmD4GHWnhmki92CGS/8Z5La49e
	 UnXvB8Syk5eL9cJgR3vaAZHRloMlC4NxMKXufPk2Txv+twgOSRjeipgu+UrBh8zmeQ
	 EZ6o+REWAkmSQ==
Message-ID: <sashiko-outbox-181684@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] ext4: move extent mapping error handling out of the
 loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022145241.2950379-2-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022145241.2950379-2-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:15:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the error handling for mpage_map_one_extent() failures after the
> mapping loop in mpage_map_and_submit_extent(). Keep buffer-processing
> errors on the existing update_disksize path and preserve progress
> tracking and return values.
>=20
> This prepares for reusing partial-folio submission when buffer processing
> fails. No functional change.
>=20
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145241.2950=
379-1-sunjunchao@bytedance.com?part=3D1

