Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639045;
	b=DsXyVDOzJ9jfiHC4rGGo2ITOaHytsIrIIXPylzbOFyYsTs/wlCzTToZkyYeXWU1N++XA
	 tFH0H7A5+3exhvtzB8T2FPAxoZeIl/vMv6CGBm5D6K/FedDPcwTXGl3lSQan4I1OZCQ8z
	 yvbTHph8hm/k/8fhy/VdVDIgQeU6R+bpvuqOofLdEqtJlSf5L9ffZxHEnkKwrOy+cdPwJ
	 3rEip+MvxWfV/9x9+lA/A7p/x51c4zhIGDGksBTNQlCz0OgWuDvQKywEG57cAUelVX7a8
	 dX9REN/fvvQwb7QW8PJi7tylB0FA5bqRV6uweJSsrsTqRRfBMBkdU1/sMT5MBnRP1hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639045;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1M1PI+4xPwdxh5VjbcwveXdNWigK+mV1WpnNmf8pV5c=;
	b=YecWF5XFPR8aav+y1ZOex7k6uDvLM5kgFM7Eg7EPaE4ZEqGb7le4QcCkb8oQaMEBsIxE
	 /w4mmludC6SDk2oQ8N9B8zyjd7ijfhwpLeDWrsA64R5cmW3j4pIgNI2KZg6XMH0i1k19Z
	 TbwWrFAZ3wRyJcYcMmWXetWQ1r5UmqSKkxrTMdDX2YDaEEoNj5hB5S6NAKUzuNTFRBXj0
	 HRup8a1I0FW19ODuv9TboO5Udb3q/isyn9eLSn6u1Fw1sD2FWvWerhIPoieFMhZehFh0c
	 Uxfo7Fq6z+dpbd7ZwaOZ8kMGN0+CTDprmNNwPwWQF4jaWLpe2FbJQ5mSRSF1HO5ZhHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmeAfj0E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8072606A31E;
	Thu, 22 Oct 2026 03:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmeAfj0E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387311F000C1;
	Thu, 22 Oct 2026 03:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639044;
	bh=1M1PI+4xPwdxh5VjbcwveXdNWigK+mV1WpnNmf8pV5c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UmeAfj0EeMztsHslBBnbY1FpciwTqXF8kaShKObdxQdYB+oGncYLPbDAqDcmm4VTP
	 G6ZRTPX6AKClQL1M+4cR7q+Yv/H8v+j+vjG528IcO1lRlUBWPz44d1tdldmOWffKQ2
	 sS1D6RzFFvKrikjb/J2METkPnoQFicbTnzxB65MfNDAkYRJ9ZonLrDAldGqOaHKnE9
	 BR7cfc3iPFgRkclAD8rJb+FmmrFXMslsz3QVL1Oy8xS6c4tjoXJLvl0bTGZFtNb8wp
	 SieNkHVb9iX6KVQAOf6J2xKvihx++T1LIQXEKcTiRdAVaJSgfFUBi5nzPEbvnsHVsq
	 o/CCun4GAGANw==
Message-ID: <sashiko-outbox-180902@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 01/41] uuid: move uuid_t and guid_t into
 <linux/uuid_types.h>
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <cbbfec8ce428602e02814d258aa5e516b11b30a1.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <cbbfec8ce428602e02814d258aa5e516b11b30a1.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> <linux/uuid.h> pulls in <linux/string.h> for its helpers, which makes it
> unusable from headers low in the include chain. The next patches embed
> UUIDs and GUIDs in kuid_t and kgid_t, whose <linux/uidgid_types.h> is
> included by <linux/sched.h>.
>=20
> Move the two types and UUID_SIZE into a header of their own that only
> needs <linux/types.h>. <linux/uuid.h> includes it, so no user changes.
>=20
> No functional change.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D1

