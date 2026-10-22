Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639056;
	b=akn8nY7zEc4yYPDE4h6J9kr8P1aT7oGXkaJ4anTzJQ+DxlBBJUn7IviuVUBmuiXwjcYI
	 gY6M0QASjm50lriLJr+iq80pCvC+Z+xzILhXQnPAMFRew7RnWU2BRl7pLgdnSWdkDNf4l
	 oQX/vnTx88fi4QExK0tadEm1brzPip+6bONtJN6hZKKE6GIAbMes8lIpwimtPiAGDZzzM
	 uPNIfnuktVOoyL0PtW7yT/hLJjqt3fD8TKkHycdwVx8J4a2QVAA1H3V6zd8kar02R0/8G
	 FB4+UzZWlV93OhOrzsY2tYD7RuET/1XTDMaBXmEy0GLortZhW5dnXe99nNc3C33dsvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639056;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TNLmO5jEu7VM+JVZ+feI/RBtP/MUHn74yZdlT75I5ik=;
	b=LcbnswpRk7Z741nzn1B8E/4MB1Z7goMG1BcZ0rZhGt9/zyTYAPOD0KYWnAxb9VCf3srg
	 Ji4ZrOY1pSpOQqUKxJF2queTN1r+1RTbKqm1uN9pDTU+B3iXUQbAgSR+HQi+bfs8Q6Cy/
	 /bbsWcZZM8jKDI5ua69haclTjtpULLRwuHCZPLdejofCdPuyGoJvqh6onmX6r0CeRajfW
	 sz7Z+3LOsaOKzsrDmiTQGE3JW1fAM1St0uCPlSJnVuu8ggtrWip2NnbXI+qqdRLjSOb6Q
	 LJUEQpqIZ93l0Dseq5uRe9rqrUyGOZ8BAnSeYWC6MclvnNoDkCTMe8y5MKaY4x8pd5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VR92E7rl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92B060A2610;
	Thu, 22 Oct 2026 03:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VR92E7rl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549A71F000D1;
	Thu, 22 Oct 2026 03:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639055;
	bh=TNLmO5jEu7VM+JVZ+feI/RBtP/MUHn74yZdlT75I5ik=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VR92E7rlkT3Ig3oPbdSFNhXNywTEsmBImt7FcgdCtR6D9uiWULV+1uPXqFs13hRMf
	 yq5TRJjzmYxhIhYTS9/PXGqzj60tv0IJPyfLh9Bmy9tD05DcvtJLRJv2EbUqQte6yO
	 s4A7tx55DcXw7/ye7NfOdCWMf2iIwaW7iankfyc0dOnDXsCbTpPyeQ+LS8j+XjO/QU
	 uAp8I0CsrqgMWZgSp5lfY9EUK6uphNJ49SimG/h96yclkEqB3UtZvB9P47hyrEfgA5
	 0jJ2UhfCslBsWoovanGSt4W3MVkfbBfn/ZhaIpzVap02wQ6rYJehlTa7Ge5F1F2Upu
	 fNUAGD8pQUPZg==
Message-ID: <sashiko-outbox-180912@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 11/41] fscrypt: show the whole uid in the
 description of user key claims
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <5b72905c9c3703b283cd9ecd0c39024c4fbb6eaf.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <5b72905c9c3703b283cd9ecd0c39024c4fbb6eaf.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The ".fscrypt" keys that account a master key to a user are described
> as "<identifier>.uid.<uid>". For a UUID or GUID uid that printed -1;
> use kuid_str() so /proc/keys shows who the claim belongs to. Lookups
> compare the kuid itself and are not affected.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D11

