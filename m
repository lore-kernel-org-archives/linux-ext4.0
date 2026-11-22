Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374095;
	b=QHUXKB28ru/6LEtjWifaqa4juFwmQ6etrGVeJ9ILjM7WdQ47H+T9QL3Q+maoug6QYVw+
	 TwNHKNB/Lgp0dri+l3FRUiKayVDWaIylsrAM/Azeh7mAW7c+1cHN8UZolBvFV2utipJCO
	 omDliXEmLmTkqT/+AEY2Xg1K0dhxGGEgyAxZd0vpZiKJdv7b0096o9Y26iEVc1mS26rA2
	 pZoL9OXMyE+ne5G3ZFEXnrzQ4SciVK9yiLAFTtaEkycpJT0gIubWLLKQhwJyPHMW6BhLt
	 MBBfVeXSLlRnGEJ6/mc6sZTMnxFkAbFc84V4MG7Q3jIK8Q9MW4mHje7KMhNobYqX3qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FCli+uIMW5jOnOW31gj11y0aPFvzX86Hb86SEYPSp2E=;
	b=VGXxwFErCdmbqqwrNtHtK9fJK2Huxr6QcDcoiC4uZ8K6DPEtSwZXsUs/GugxJ0ac5h2i
	 4T2WPb2FvjaIQLeGhxlTOUJhyUoO3jITC2RrTjNOBMuoS9RWKwX6ILf5aPYj/+SL7uWQA
	 yqBFSZ8RcdE81rX2PzcRia3ENzVtcsqdNoDWpUOXbbF9ofpEKenj1HSEZ05f13NpFr9rP
	 586OJiVWhtjxFbBvtiSGRuiRo9aCEA+xfP6Mp58bW/p/I9SwqIXCvEP5z+2MFzLDdkqjh
	 bqyk8YFuaU18jrZt7U/LNlGDYwgNcJyIe4IOHDw8Uw3Py7ve6pM31ou64IzRGKI2VVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+aI27Ij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2981606A320
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 19:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+aI27Ij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AF21F000CF;
	Sun, 22 Nov 2026 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795374095;
	bh=FCli+uIMW5jOnOW31gj11y0aPFvzX86Hb86SEYPSp2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n+aI27IjLxQRXQKfgOAgHU+H9T9x2pChJzjT7ZIRGu9tLk7kRxG69ze3fu2tqT1Fi
	 cc3LU2zTksKMpDutgssBFg+5ZTxvkAI5GJFtT7NsXJaZzqmSJL/LNtTIen1mJAMtfJ
	 dkzwCvZK1x8PHAAKHAXnPgPdilKXR9K0BEL8YpRK2JzUbM22d7cFjkyVwKqwEI73pZ
	 syZL+AaNEY9b2dPes4E6V3+dArCXuJUADdMR+bV9ZBXRIy3LBTjztXMO/QcE7L1tFm
	 EesSgcECTRuCtluo7t1Wk4Upb41eeneAaSaVZO4jQNwUm6y90TO8gblfs5Ex04DQk1
	 0li7jS3W9P+Hg==
Message-ID: <sashiko-outbox-228222@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 0/2] ext4: fix goal trimming in CR_BEST_AVAIL_LEN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muhammad Umer" <mumer.mobi@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261122185630.2112-1-mumer.mobi@gmail.com>
References: <20261122185630.2112-1-mumer.mobi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 19:01:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 2-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122185630.2112=
-1-mumer.mobi@gmail.com
