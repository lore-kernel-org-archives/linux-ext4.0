Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194428;
	b=moKkeCrJV5iM00Tpiatk3l7+WtSFIjmR+1mF2AbQEIfvbaGNQtrSdcSciDyLlkYwn+OV
	 gSNR07Wnlxgu8BZuTxg/eXaRbiQXRNYSVNSZSIchD9t30KrDmlNkfyEli6AUjAUNxT9gh
	 qkwC+CW0EQEZuIrquTzOumY86XeMy8VEvJgyNdZStKTEolW8nIGM1n9E4ECLGTQRGpv+z
	 fswDTlBynUL3SsTWn/jRrWsHBjpCuRbXbVRkmbNxPIzkIFB5QLiR/2vPwDx+bi4jA7dr0
	 eNh2ADBVxFAglioF/bFdLnqn7pRk4BlBOV2DzG6QdM3PZp1z0EZYz7SHjrFodKhsKhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194428;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q6JQaWIPmatXOnzRdreA2gNqPLP0Hpf6HnWnV+1sW98=;
	b=ztwj+gXuBmz4H7QCOgvyquGY9vloRurfyoVhTjLzQLgRdlzwdZCUHm6+rYMoWDY/X7IX
	 +yxVY7ODRknRBJtM3Imn55ykYyx2v3BrdOaX6QonKPm7vYokOkOJZpyYXVZURXaemvz5L
	 ZM7khcvOhunPfJ0yBESQpD0ZvW5vitKbmfu3gXpXjYIdS92P46aWnPUkZpUzyzlXuQDQn
	 0fFmDCPA/4A6mWAiiYpvsDB+0alYWSsti9pS3P1oktpKv6BkMNhmT06H93zDReoPuUD0H
	 cd+SyJZiEIV7uSGyXWT+emsOlT9lh57JVKNom6/0Tdv1XtzMS46EakN1neXhWhQWTJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FPhr2HZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03492606A331
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 03:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FPhr2HZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A5B1F008A1;
	Mon,  9 Nov 2026 03:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794194427;
	bh=q6JQaWIPmatXOnzRdreA2gNqPLP0Hpf6HnWnV+1sW98=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FPhr2HZ7+ksfegkg0O1BOujYDuBCxDgOEsuSv5/3n5DigjGq3DmqWmjG2Cy5v6Tgt
	 FtquXNfRzH+2A47otDQBMLBbR9ED+voYvD19EKsqFX17/KNiVfUmcd238iwC+78OlZ
	 mHgKb0j84twmU7EzUvMRWKXXzEyMcvRyTRsqQi2k9vtaDhg0A/ecnl7ynl8Q+Qam4p
	 P8iHDs2J/U4Uv4xFt3AsnLDP+QUHruQPjaFvHdfaG2n6lWh5fPLfHfNHFgaTKHzwT0
	 Oy+9H1GhPAn63vyCgAG92MJ0syd1YXz9BN31cYHIt/h7ilj4OHEphYywQL9s7NPmud
	 V93TG5sCMiAow==
Message-ID: <sashiko-outbox-204368@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: fix soft lockup while shrinking the extent
 status cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianping Liu" <frankljpliu@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261109031356.10659-1-frankljpliu@gmail.com>
References: <20261109031356.10659-1-frankljpliu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 03:20:26 +0000
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
> Signed-off-by: Jianping Liu <frankjpliu@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109031356.1065=
9-1-frankljpliu@gmail.com?part=3D1

