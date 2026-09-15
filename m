Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E683CF211
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437873; cv=none; b=C6vWlq6DDGgaLPy1uid6HQ2PY/u2gVJzndFvuUt0Pd2z19NSzbBEZxPI1zcb3um9S0IDMCFMSzfYXu3X/9bfyy5DzXA9hrM6vUarqUm6YXmQoM47s1qXWKi0qP8r0JEUSsd+B7aWQZZMgnuQmpGhXkLGPDzenrbROiYmhMgz7ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437873; c=relaxed/simple;
	bh=fVQtSsYbK1KpoWSf0lgcUhGLmmw5MFe8NZUThVncDWw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QXSeaPEHME3KNdazqS7fd1IVL9lLLB5amZgr5Pvj1l9aZIqZiPXIG6UQsN274RWN/4fyEZNsL9KAvXteWzRh1ewiZC/IVHTGfj5/hq2gqMk5g4vj2oWqIw6IxaWYb5XYjRbBUytisODPtW9s8fPAaBSdRTr/fBYwF4ctIznHViU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SG3NTjeq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SG3NTjeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0711F000FF;
	Tue, 15 Sep 2026 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437872;
	bh=fVQtSsYbK1KpoWSf0lgcUhGLmmw5MFe8NZUThVncDWw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SG3NTjeqIKwA7j1k1xdG3u980X6MbdoTOkXChrF/ZJ7jkYKyN3lduJksi06d9s6jG
	 jtCfFFFJxrRq5J7oYUd+cIJJU0ApYKUwzCcvZQ0Eq334h8cx4ew9jBXYq5DZWJwVB7
	 kwlvMOK85eqCEekmj+UPmZnIjiIKuJ5vJF/KJv7fS1tTpzVW0IbiSkMCu4SfBwt/Fi
	 obElVPlu0n78jGDWYEbvL8fRtbtrU9zMpBRfUyOy3tD/ppLmMyujy9gX4b5QtPNszN
	 XWh9OQArw9XSh6Y4lw1Rj05SrbnE2pfiZwzr5gWQGZC+GyEzOqgqBE0u8q37vXIbYD
	 BG9bSMhVCAnSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: propagate errors from fast commit i_blocks
 replay
Reply-To: sashiko-reviews@lists.linux.dev
To: 781735889@qq.com
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
References: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 02:04:31 +0000
Message-Id: <20260915020431.DC0711F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: lty <781735889@qq.com>
>=20
> ext4_ext_replay_set_iblocks() breaks out of its mapping loop when
> ext4_map_blocks() fails, but then continues with a partial block count
> and unconditionally returns success. The fast commit replay caller also
> ignores the helper return value.
>=20
> Stop the count immediately on mapping errors, leave i_blocks unchanged,
> and propagate the failure to abort inode replay.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: lty <781735889@qq.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_ECF4DA91837=
7A7A0D8863B860B0F3025C106@qq.com?part=3D1

