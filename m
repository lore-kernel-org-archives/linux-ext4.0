Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793936447;
	b=gTboDO/mboR9oHbV8LVazCj1zqtWTp2oGc9N0BUEln313u5omi1SEvUKbeIwEyV3gV5L
	 dKNz6tR8EuQxPTWJCiRV3PzQQ/VHjH47DkAK86Pl5OAIxX2VOEKGafTMkAA9YlUDlusde
	 G5FN316GgEXAliryPa898xVSjHt9maylxVShUt64WXpXwYI+sY89+m0SBR6ArCHUqL16y
	 b/FycD6JoyOhpQuRAkbk4crUIdTFofV5HAF7ZuOJSWgguOPyMb4RTsoIi/U9B8CjN6T4J
	 7Ds6YrF0ow2Pe/AzDeymT+bmu7Fr6LCKhDlbBIYn/qa9BsA9Oe57yc/VgBj7KpSFPdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793936447;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YwXXN9wN6JU8L2u2s486IzNmNBPerRX2ZKBeX1mYfEs=;
	b=1/8ztBhF4uT4KSVOM2a7BLSZL7gdqCDS7giBZJnyKQZ+8336RYDiRUl+vn15WO5PWBzG
	 kbE0je6ckhoJs4nVPaks85GvaBuE+RlZtvmILsYUV5AyEmyWoVEeXxfyBezpvE1ZHsi/c
	 juhqjWqC7LVnX/1fuqeGUBb6j1uLaWMZw28fcr0rRfCbIllY8a5EwoM9SP1P2vWdPqrdA
	 V54sul8VsV2Xsl2OXcCEXgh6adWNUjkXhuSZj6IBk6CEI7TUGtMJ0Wc6egfCWzO9lZu0c
	 kiY/tb31tpZWEKiwbRFYdsnzC4ihCqno+U99/scHJ9QmsFvsA2kqYVlTUTVXiafXStA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAR3hcjB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026C4606A31B
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 03:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAR3hcjB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5111F0089F;
	Fri,  6 Nov 2026 03:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793936446;
	bh=YwXXN9wN6JU8L2u2s486IzNmNBPerRX2ZKBeX1mYfEs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FAR3hcjBfC3LGNzWj/faachiteBTUmPNg9mdds5ZirJJIwoQ8hfB5nk1gKZGlBStc
	 hVveS4aBAuhH/067qZZtQ7dMkqNPjJXKH7Ha9Ayq1sZ9ATbwPN7zTaF1HBGwmagO1Q
	 5hAsR0fsJl9UvqoBvgj7bdXoK81dXQGun14sHjM5enOUIcaXMmqXvlGItLM1v84AZu
	 nYkmKjcJKK53WP9l5Eqgk4u6Za2mIpES8BR7Qz/b3pl2nJg5ovja/qO7XOOo4EZHfe
	 Rkpk/xnZtNNBf5WFIjvIMBpzkD/liQfxBTFA+Q/a1DdOGsZ13MtwcfKuk2MgSyKnB3
	 Yf4BDIYmLCi2w==
Message-ID: <sashiko-outbox-200657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix soft lockup while shrinking the extent
 status cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianping Liu" <frankljpliu@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261106033141.1509656-1-frankljpliu@gmail.com>
References: <20261106033141.1509656-1-frankljpliu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 03:40:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Jianping Liu <frankjpliu@tencent.com>
>=20
> __es_shrink() walks sbi->s_es_list and reclaims extents from each
> inode. On a non-preemptible kernel that walk never gives up the CPU.
>=20
> There is a soft lockup report on our company's machine. The machine
> with millions of active inodes, 256 CPUs, and heavy memory pressure,
> concurrent shrinkers run too long.
>=20
> i_es_lock is dropped after es_reclaim_extents(), and s_es_lock is not
> taken again until the next inode. When nr_to_scan remains, call
> cond_resched_tasks_rcu_qs() before continuing the scan.
>=20
> cond_resched() does not report the RCU quiescent state needed here.
> It is compiled out when CONFIG_PREEMPTION=3Dy. Otherwise it schedules
> through preempt_schedule(), and RCU records that switch as a
> preemption. An RCU-tasks read-side section ends only at a voluntary
> context switch, cond_resched_tasks_rcu_qs(), idle, or return to
> userspace. The helper reports that voluntary quiescent state and still
> lets a non-preemptible kernel reschedule.
>=20

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106033141.1509=
656-1-frankljpliu@gmail.com?part=3D1

