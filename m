Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863C5470E81
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 12:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390413; cv=none; b=qBaUL5aRcT/YWGny1L7yfVvzIvACKaXr7levS7Fp4nJw7iuJoeZRctF1MeO1peuIAPPQqUpUavzcBdsY/g21cCmywesACjc6gLBcTs5ROzp6ocB0SDHSc28ReUp3QCNZWeJrdbLJRBEKWjxQskpaGsNYmdHZLK/MNR9JGqie+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390413; c=relaxed/simple;
	bh=K/LdsdL7CahFYWlcLVDKtkGpG7mloWzZDSPmgsh/dlU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K3WdM2hlKa5FUFWiB9Dkj8e/lad0Vpwlox3lQNiMyhbZWx/rCDUe38OJe2Inr9/IRI0MfLK+igcyD+264DE6xn+SbpEpIPS3cCR0GigJRuZNUwPs3X69WVcanxdlPG3YsqJxdqiPPWfc5U1FjwUwiMC3Yy8801di9SSfoOba0AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhhXV1Tg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhhXV1Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E282F1F000FF;
	Mon, 14 Sep 2026 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390412;
	bh=K/LdsdL7CahFYWlcLVDKtkGpG7mloWzZDSPmgsh/dlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NhhXV1TgIQvv6pzu8JYAOHFfHZyht103knKjN2+wFvO7BLbX3ctYPh49xobNrzYlS
	 ODVa3DIfeJaULDhALz7XQidzTIthaIfx1WlDEvfwALifwVhqT8uskUH3sD6vq/+84k
	 3gfnh2FHzLEJVoFHzsTQCIyjiUoBpg3LGX0RjbV7KCxbNwMoRwbeuMkIzxLheitH4H
	 JLLWcRlgx2O2y3PEfyTuXVvUB3IHaIY+0HhWC8ti84rHbQlob0GhI/j4W1TvsQBCt6
	 1KZ2lH9RTc1u70xq8Tn83ELzslyoSf76zULczI9JYcpWgtwrnv2PxHYxaDKeK1wt1z
	 lMRuBR8t4RQEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit block cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: lty <781735889@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_FE3BBC743E8B31B9B7B928007B10E0AD750A@qq.com>
References: <tencent_FE3BBC743E8B31B9B7B928007B10E0AD750A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:53:31 +0000
Message-Id: <20260914125331.E282F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_FE3BBC743E8=
B31B9B7B928007B10E0AD750A@qq.com?part=3D1

