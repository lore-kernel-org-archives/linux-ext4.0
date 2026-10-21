Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792550212;
	b=a9FBG6svx1BfEj9CW2ZWIRsnzK1R5N3vVeB39vSlnKR5h03alzpR13xBUiogf0r+QbGA
	 bjVjRYtm26ejQG/EBjzEsL7qKs07Ge0+uTM3hy+3ji5MSiIwfxupf9xRa6a8ygpgf9kHJ
	 9j3JtQiJCJlRzbS8gHVCDP2dhXileK9k0adHfCPV/BmAoY/v0s2eSdxOwWaY8CL99VtT1
	 ZiBQowPTECNv/xk6mf61IdNLE7WtNAbsKOd96X5HJL9AKXrQk2ysK5F+Ls5dLQGwt7qzy
	 NyxMH5r6JtL1yARoWVj8bCB0/2tdoEDNL8utn4Tr4X90dTOxW5/QQ4QH/E5XlgOdbVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792550212;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=LaaESNT0GZ6QtkdRTP6pUbxwrc8SNQdzz8sUo2TZjLQ=;
	b=dV/2xFDY0t7sZ+5DFD7ltFMda2nIjFZjaZAi39+5mdJaZcksNtylQiWrfJZGcFWYYGhc
	 BiBPSafVKaHg6XIE2zVBWs4ijRTCfgiTgvV1AbI0z616UmrsVusR5ILY19FYmTktW0uez
	 0JpddYyUEzK8o/Tr5QNXuYA6CIqP6LjzafFCfOMtRpQ0Ayia4AxA3fltSBtkkxrHLRX31
	 Pd5rLo1pKdCSlFwTQTev0XFe45XUVslbkrD+1Mgs2DbTeVIKk8dkISTn0A9q4ZtGTE0Wo
	 xYMK13FUqnUIMbp8gzdc6mcpCWP+8BHlv3vK3VDCjtpwDtrxp8IsIrpRlFTZbWhCGOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ARgRHYd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65493606A319;
	Wed, 21 Oct 2026 02:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ARgRHYd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AE31F000C9;
	Wed, 21 Oct 2026 02:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792550212;
	bh=LaaESNT0GZ6QtkdRTP6pUbxwrc8SNQdzz8sUo2TZjLQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ARgRHYd8z9oB6EM9ka+RE0/HmSktPRBsvOjGF98J/AiMz8kpxTXBO95CH2BYCcJ01
	 /dPRRnKW6EBxWZVPhlno86yfJxs/mIHEGDG83SEA674HR/HUjTfS5dMN15/Xyh9AYV
	 mgWxfPfCTnrfs8JG8eGcOmKDTWsh/9plNRi/Ejej3HC5ZX8yjXG+VANTQtPFwX09pp
	 GrEq9XmSWR3xMCxOpwGnKNHSds774yJAOz4RksKEupishT5dc+qk9hUOdfY4sqYxji
	 MOjTpnwWpuqEeRnqwztkNIHBVWApbdvEEgtRIyKqWag6EkO7MVycITaxzvflNhfkC0
	 NT7dhnKOQQVkw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3583809A18;
	Wed, 21 Oct 2026 02:36:52 +0000 (UTC)
Subject: Re: [GIT PULL] ext2, isofs, udf and quota changes for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <7hq6kyrxt57gmxrdrqzgnkwh7ae3vhffao4m6elvxaqygeosxt@3d4qvzwsthgj>
References: <7hq6kyrxt57gmxrdrqzgnkwh7ae3vhffao4m6elvxaqygeosxt@3d4qvzwsthgj>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <7hq6kyrxt57gmxrdrqzgnkwh7ae3vhffao4m6elvxaqygeosxt@3d4qvzwsthgj>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_v7.4-rc1
X-PR-Tracked-Commit-Id: 0f242ca0878896df30292f4922700a32e8fdd039
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 744e5400b36f84b4816e3ff8531ec2dff52b474c
Message-Id: <179255021097.339009.6809427763674213048.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 02:36:50 +0000
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Mon, 19 Oct 2026 14:23:40 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_v7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/744e5400b36f84b4816e3ff8531ec2dff52b474c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
