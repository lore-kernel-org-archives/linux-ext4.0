Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763814;
	b=H8ZFJxyliEQ2MlrVILz8436895V/2ywWnYdBTCM031cv6uWCAXq8YF3V3MeKr8pgm5kr
	 f4cOQ4mOiIw7mU9TGm58EcQj7q/1zG/CaRNaMh26k7dTXuqrPliedV300anfNIbexu49i
	 ci2D8I7YsF/R2CJsHlL7ex9jFUTY10coiabdYYBMNKR7jpuMMGqR8fPfy14axcf3ZTc00
	 Cq9CeqCZa4PlVwyNwQvZoXGo8owpEiFHrQK0WW+X6UpViSfB2RuE5Yf2dsgZ4/C2ev8ys
	 v6RQMQX7mHmzGSd/sAyZiYGsTAvrKZq9+Sy0J+DMFdpuFeokWTh2CBBgctjfCEYRjEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763814;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jqC9oaRo0BRhQ5eTnN9naQJVI+Wu3k9cD8m0V1opafo=;
	b=zY2fR98NkaV+z1wQf5CO7Cs9/S7oCQGUmIp142fPKQqG+WHaaYTXEkD2X+pry0yJFPAp
	 D0SjBnoYNrECSq8Gl8k0uuKflH/PYdaFh/DDANFvvfrGmbPWjAPooXlk0aWjw6DC2RBCZ
	 clwYPPg/d4Q1l1J/ZnykgvZfzgm04MnCwDrcAOFzFoLoDo1Rcgs7UFCAaiUC9I35c4YdK
	 ymKOhx0gx80Lh0hUhF1HF7b+pxytFtA0krGoj7KB5NTZqjhUZ8U1rK639GVIlKIGXCeD9
	 Pz0+B5vrBto9JKvI8L4l1OrBmN9w0W8aKCWMtezWpe6T/Ap+IWGjIhgt3vjjGhEPxtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FW+JSpLK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1177606A31B
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 03:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FW+JSpLK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F631F000C1;
	Wed,  4 Nov 2026 03:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763813;
	bh=jqC9oaRo0BRhQ5eTnN9naQJVI+Wu3k9cD8m0V1opafo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FW+JSpLKu3Q9MXztH7M4++N70FfrcUUvVknR+6mvihuYLdu2/3u9STMDBqYFJF6ib
	 8ENycXg06DCfqtfhU5hFQDm+O2cdrI6jys7z425+E9BzK3eHNteuqmLDveuZsnM8le
	 5XmgXtG5lqNrrYsQlgbRI8S3oc2HMwwoWZjfd4W9TfSx1TkgUfj4WXnVG2pS87si82
	 s020eJ5T3t8f77S/sJ/iWPk8ZuNpGxw9lJe0IMVUMBUsjO74GPbVWuwg3xINAGwrbp
	 a8OpZmBoUeIdUZdwOkydUSDOnC/oH262QBmHbzoq4kDul5G1JPurXDbg1wUsQiPs0B
	 rrIrySI1dnDVA==
Message-ID: <sashiko-outbox-196624@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix soft lockup while shrinking the extent
 status cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianping Liu" <frankljpliu@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261104033539.3031910-1-frankljpliu@gmail.com>
References: <20261104033539.3031910-1-frankljpliu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 03:43:33 +0000
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
> Changes from v1:
> - Delete time out logic.
> - Change "cond_resched" to "cond_resched_tasks_rcu_qs".
>=20
> Link: https://patchwork.ozlabs.org/project/linux-ext4/patch/2026102806162=
8.1209508-1-frankljpliu@gmail.com/
> Signed-off-by: Jianping Liu <frankjpliu@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104033539.3031=
910-1-frankljpliu@gmail.com?part=3D1

