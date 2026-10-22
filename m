Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639051;
	b=hkpDupOabbaoNI3IQUno8zqMluRbm74E511kfTe4Ny9XdcSpcPu5UiWsfM83QOBZKWED
	 DzEFWqYsXa4Cr4pwALM3pFKUGRPHDVdmcoltTZ6qQZna7+hpvdVQaKD+o0KkpMkw8jPiE
	 nUdB59usDwVhAxwI2ExYd7OYrZs1Zmu7QpXsGzChhxLA8Bwy41x0AkgzGqhQ2LkHBZ5Vb
	 HhxQRMQEsYNDoPC77jLId5w0lHHb7/gTsFcxhgBVCZFr5rAYw/YSHMI/HmKdHWbsbgHpq
	 sUrMzJenvzYMSl7Wup+Qu0FuLR0YNw6nDlxDn3faI9gqp+u28bmgj92B4oAtvHEPrpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639051;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dbgqiX/sviK901Xj8LT9Kxl4/89VYb3aJar4PxZxOT4=;
	b=IRbUsF6fv7VVbyZlfHaauFoRc30/Un4YhoS0F1KQPPtaiYLmgL5gWbkzQTJTYt5SQLTM
	 zibYvK1PHc4OwDrcdlCwehlIf5EvQwI+14gvFB6XEH6Dq+RtaRHNaS+SmfHSx13YMQboJ
	 S3P2YxIjSLRzLGGEKew7rdQgMQ5wuldHPLJ7t1+j91/wpMP9ZL9+zSkPh+XkpnST5MHoX
	 D/eHHMhrnIgh/AiYq9QS8KJEjiQ02VmjoyNc3x7UMovpSb04bflDy2ZcYEDEajJOXDU1g
	 U3PxhuILXUA329wBoRxaS8is/PmVmZ681xea4zRzg85XbN2e04ybhMOEPKYxQ1JiKrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JfrrWcAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4306160A2628;
	Thu, 22 Oct 2026 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JfrrWcAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5BA1F000CF;
	Thu, 22 Oct 2026 03:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639051;
	bh=dbgqiX/sviK901Xj8LT9Kxl4/89VYb3aJar4PxZxOT4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JfrrWcAGqZKWs50e6dBgTfZtXqWwUfYZ1VIAWTILSj1OL4Vfj+4V9a8862H++WxOJ
	 PYNeqFE1lqvq+Sa8Aw0ljW+oY4kF8vJDTorl/tc4c3Ur2KQReYVzcQXO4pqPBjdzbY
	 VGG91yT1mvG7yut+DIFMn+Ne4tvfOls1y9nONAmPOPusvt2/lW5uomoV/W+rIFwpTl
	 c5AE4KYqS3T8aOXAHfBzcWFIn4j5rKasKR/DbQQR3swZ29PeQe7UhnKbCLAudrw35i
	 dThXwlzH2+3GXfGE73tPuwDtgSE/p3CtvVOOwW9sGAAJz3+hNuP6KNjZqTvT/vOji+
	 pbHwqqlT8JBwA==
Message-ID: <sashiko-outbox-180908@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 07/41] Bluetooth: keep classic sender ids in
 skb->cb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <87c721a9d6ca632152d6ccf6e7ce954fb7886301.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <87c721a9d6ca632152d6ccf6e7ce954fb7886301.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> struct bt_skb_cb holds the sender's struct scm_creds for HCI sockets,
> which no longer fits into skb->cb now that kuid_t and kgid_t can hold
> UUIDs and GUIDs. Like netlink, keep them as struct scm_creds_classic:
> classic ids as before, the overflow id for UUID and GUID senders.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D7

