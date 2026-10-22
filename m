Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639052;
	b=sb0MdYVmG2SDFdayFP5lDJMIdzNqo/FcBZ4Zzu/RKcOu+VeHtGJKQdl1XsanoE0nq5D+
	 zP1RHHsJXcjBTpESq3EuIwxq1A/1bpkKVhGX96YZ7G/Pf137jmIpB9taSOJvGwVGDC/Vf
	 xFWpb6g4zC37jYJTPoaFmXUM6CQzAZUNTC2r7lFxId7sBA7/aIYOODUOUbAq72r8LHMcj
	 qBomwl3vu1E30eqPvXol6JSqJPpo6nS5EFk7ikvc2L/WJNH3tlmFzN9PXUXtQl6Xa8JBR
	 KbodwprDJwezLE3kryKHcPPw47HjgFQrVciPAJl9PaQJjTiTIpYvhQ6zChcGcpLI+eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639052;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dK225VUR+EUBxsvk+oELfzwcLK98Tjy7MwIIXrjbeqQ=;
	b=rCwTHgR0O5fPAEpd6f8P4n/rWsHr4tLNsq5311OmRJdwDvYQUBoS8Zk7k6FgO+04crcf
	 SR1Apbqfmit1KMNpdEoqkr5k6EEnM/Z1QfsIBxO0LmQulcGjIDIcYhHTHcFWaDpt5xRk/
	 Ki9orsxcLtr3i+Y7XS1Z51gl0DVquTXvAJ2M64rjHnKkqKhSTnJNvJA5XjKlYjUXrSxpZ
	 dyXt7kZngDoYLEe8ni5luZCWDvshGvtqfAxpps7O4wJCqk7l5De8AMOATn66GhSMGZDm7
	 LVl3EdFstdNKKzome71idx+0bir+T8FELHpu0NpOo4hbd5hFdx4kjaJPEa1n4PaHCPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q+jwCZbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2D960A2633;
	Thu, 22 Oct 2026 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q+jwCZbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E3D1F000C4;
	Thu, 22 Oct 2026 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639051;
	bh=dK225VUR+EUBxsvk+oELfzwcLK98Tjy7MwIIXrjbeqQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q+jwCZbwr1vC2ZcjG5ndcAAcgAUbWHa0N1vvbIh46Gseynikx9DPzM0ye/oMU6J0x
	 ym1J4lIbumiVRsmgmwHB5lcivBCDQ5yuxOyobT9BHMQH+xs43t4rpgquWvM18x4S99
	 hHDdb52ovEtQaAsJtajGapq1VbWJL1AKAXsAVA8FQoMvpQbUTo1+rfxJMw+KFP4Mvo
	 9tEnVb8gJ9FrfUSDN5/dq4dUbaXKy+F43DJvmmjcqpoN5JAQd8z9aRtFMhcGSCSfnw
	 5vKyOpLGOx57uHiV2viu31ljPo2he8NctmL8gqng2vpZjsCqj8Hpa6xpac6ZOR/j5t
	 NplezptCChXSw==
Message-ID: <sashiko-outbox-180909@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 08/41] smb: client: use __kuid_val() for the unix
 SIDs of the caller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <89a8d25ee5266ebab437aed8d86cc5e41bad3965.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <89a8d25ee5266ebab437aed8d86cc5e41bad3965.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The S-1-5-88-1-<uid> and S-1-5-88-2-<gid> SIDs sent with a create
> request take the raw kernel ids from kuid_t.val, which is gone now that
> the ids can be UUIDs and GUIDs. Use __kuid_val()/__kgid_val(), the same
> value for classic ids and -1 for the others, which have no unix SID.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D8

