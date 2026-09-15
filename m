Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656633CF208
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 02:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437837; cv=none; b=QYZ8AvNAcZ7vedmjwnkWFfPXdWu6XOCQ05FvFJ4KYzgEUTCYihKeVGp04uvn6/SwUhlMe7jHVI2sMNlda9rEPGO5OYRuFvNk7KzS5aVHv6e2acNMG+9CL1SzKBlAa+Lr6eR+BJvXmxF8ELeUrpe9jriAb4Ku4/xZT1zCLybQ8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437837; c=relaxed/simple;
	bh=E8FFH9AnueNyv5PBLrje2eAnGNtcaqxdwt83pFJhz1k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uD2Z0zUxYGmXElFILPYCd7BKKBw1RDiV+/E7InTzmFgPg1i8cr1rPbLgmv+43kYGNxhMSaJhxR/mHKjksY+oB0543CWfUD0Hf9xlhRqasUuJA95H4vw79tgkop5DWxjyLrvgOsQ02U/3ZLMT8/1pd0LIRToQzRxQ8qSHEKjq18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBeYCu2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBeYCu2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9361F000FF;
	Tue, 15 Sep 2026 02:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437836;
	bh=E8FFH9AnueNyv5PBLrje2eAnGNtcaqxdwt83pFJhz1k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jBeYCu2Qj414i8wtmufLsnTXao151QK78kHPzp0UCJaEodQtO/AdYKKK9zEGZN7xo
	 7bPsq7QaCb65wMI24fAlZwsWqrnTe/qvJ4VaXkbdRfDq7Idf/EqEnqU/IlfQfZL+fM
	 /NCnhty61RnpFJX4vCxcHsOEmFjCOY+7t6H+FmWn6Abh5Y4qhj67kJmKrSemNqNS9O
	 QBKPMt0r55dqfH9JJe/cGvTcuEmoLbi+9onOiqleoktz98cwGiUz3jvSOKY6hIpfL7
	 ne65LkqfQwgZnecgi/Wd7k0coV/+I46lwcROpo/84i+G1uFnoUcnfKbLpcD0Z9rqOb
	 bRHfgQV59GIlw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: propagate errors from fast commit block
 cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: 781735889@qq.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_FBD69AA6034FE7AF98BC3B90CB1EF012C106@qq.com>
References: <tencent_FBD69AA6034FE7AF98BC3B90CB1EF012C106@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 02:03:55 +0000
Message-Id: <20260915020356.1E9361F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: lty <781735889@qq.com>
>=20
> ext4_ext_clear_bb() stops scanning when ext4_map_blocks() fails, but it
> returns success to its caller. It also ignores failures from extent lookup
> and replay-region allocation. ext4_fc_replay_inode() ignores the helper
> result and continues replay with stale block bitmap accounting.
>=20
> Propagate all cleanup errors from ext4_ext_clear_bb() and abort inode
> replay when cleanup fails.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
>=20
> Testing: QEMU fast-commit replay with an injected -EIO at the
> ext4_ext_clear_bb() mapping call. The unpatched kernel completed recovery
> and e2fsck reported a free-block count mismatch; the patched kernel abort=
ed
> recovery with EIO. Also built the ext4 target objects with the expanded
> error paths.
>=20
> Signed-off-by: lty <781735889@qq.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_FBD69AA6034=
FE7AF98BC3B90CB1EF012C106@qq.com?part=3D1

