Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639078;
	b=kTGnu3HNTLcoOe2WtiQtTk0/isAYoORhhMJ5ckKsD5zyYMLr9qSHfE3otKyLoOjw47S5
	 xZjOUH3AySdPEnrDUg+AN9a4YAQv+z21ldMv3iqUqFsO8LDapS70bEwrteWvJ8z2Zn4qm
	 JATtzs696tsCfvIZkfl8ZT0hhwP0f2n+S+3ArOolz12gPN/1ReDQf03Rd0nJKcl+cdB18
	 2vahWDU38a3Qv/nZE4IXuqpfX+RhdKRcsGPqDPmbwQ7F1hLEfWLbBHe04r6G6J2L8pWHX
	 sUol6oaOa267BPkDHdYdcQHZfvv8JZ9TBeaNVrbBp5d8UUNphxda6F55IthTvqgvCDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639078;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t8P9gyaVICAuWNowW1KD9RsetjXT0S3fGThJDuO+EYw=;
	b=XEckCG9MgYE1FTFO0RfO1B4pyX7owK3uWMaHY8RmtZQROsfA1SAK4CX0iZVSjMix2dXs
	 4zlSEgFPoPnQd+WHQbLJmJOf/s4kQAprVKwAf7XfLm/gVZ+vkU86atmzuu0WTd5HPp3G1
	 hgSEa3wVBA7yvboumDaRmM3kOCnBsrbi6O/+zRXRfLxX7vysrxW+B/cmRl4QMhOExRhHZ
	 hMonzHyFYEQ1U8mpxI0Q6IDg34yHEGX//Uo+w0AJwfbyA+CdVmYhhCordzsTl1T0/aliI
	 WfaXdJMdCpHR/gYwNKvNaZbtsQ7eqqMfA21+L9QS+73JARfd/nh39fYAunStd9gs/Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCCYeqUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BD760A3831;
	Thu, 22 Oct 2026 03:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCCYeqUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEA51F000C2;
	Thu, 22 Oct 2026 03:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639077;
	bh=t8P9gyaVICAuWNowW1KD9RsetjXT0S3fGThJDuO+EYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LCCYeqUUMkevkXzBzL2j/CiKV/zueXdi7hqSGaZcSJLII2ZY571DTyT37J8yxEIpi
	 mFh+ip5Rtw24nk8hhnup5NRaXroRGZhQZJcWvlN4hlOdDdimj5nchIuOGE2lswfDRJ
	 MwLJUxoAOlIsUKmnuqWTtoo5drCYys6jMHbqMrYY09y0n0O+l6+TKt1fHuvk1fuij3
	 pNdZhPFwl9ERqczQVbBWJ1ZdYl9c0e5QwclbW5cKesxi3uXILZE5E8ZJ8gt4GItbQD
	 uSBYOgvNR+IgXPBXS1rrjV5+IRve803ubCcKJJGvlGwEGayzQUPCKhKo0uBTUTh6VO
	 eaPgEPYqxzoNg==
Message-ID: <sashiko-outbox-180931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 30/41] ipc: add IPC_STAT_R and IPC_SET_R
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <b086aef70fd4516d33c535b4ea3d5d6f204c0af7.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <b086aef70fd4516d33c535b4ea3d5d6f204c0af7.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The ids of SysV message queues, semaphore sets and shared memory
> segments reach userspace in struct ipc64_perm, 32 bits each, so a UUID
> or GUID owner shows up as the overflow id and can't be set at all.
>=20
> Rather than doubling every *id64_ds, add two commands shared by
> msgctl(), semctl() and shmctl() that work on a struct ipc_perm_r with
> key, mode, and uid, gid, cuid and cgid as __kernel_uid_r_t:
>=20
> - IPC_STAT_R reads it, with the permission checks of IPC_STAT,
> - IPC_SET_R sets uid, gid and mode like IPC_SET does (a message queue
>   keeps its size).
>=20
> The IPC_SET path now works on the kernel ids of a struct ipc_set_ids,
> which the classic command fills from its ipc64_perm. The audit record
> of IPC_SET has the new owner as a kuid as well and logs it like the
> other audit ids, in the initial user namespace.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D30

