Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795715911;
	b=elh80Fu5SUgP7cx2udys9TONKl25nJ8j0IZuwfhfIKK6ciSst3z4e9m+y51idMyym66L
	 Fsfu/ZMkzranEhc9G+TR2kK+jucpbrqFRHx5/gT+E38Ybk2IidiPlSaOtMOLEdL7yHpx4
	 SxNzgLmDw31MVgUp5RK7HAqka/yL2WUjoN64+ipIC+gwAfPtBl9jVDgbNiD0QvuuvXg+Y
	 qM5YiDGS3k/k54dt4/OrRxwjGNvp2WHkMbO5FEJw8RkOxUxRLYM+Cl2AjoVaTpgzrzLcD
	 1mKsLXMluX6EcjHmVEHrcS2rUQw5L0OgQE0OZK69MfJaixfow+SqmioYcthmo5IABrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795715911;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=x6I7KcFrdZgI4ebYkIJF91XcGCKi12e7dls4bCTLclc=;
	b=wE/x1rizIvjqmvAT+93pVg3h5ZRn1M383KL1YAC8ytetQninkjIAqyeaB3cxaLEZl35J
	 GXvbXma9KrPH2LirRHkKzKw7YLHlF8jnQ6J9A1mZ1O8I571vSPGM3VFB4IS8U1/aAqSoK
	 3HhbVIaQNA4AWwRAuSlKhFXKyOIezH+4PLI9znn4oHkmwk3Xfu13uNtuLolwoqK0EdRE9
	 2W6Dc0HFP7r/CueiNE4Fe/PcUGNUZjWCc9sb/rku75wxhWkLQeA+dH42w0YnVeWmO0nyD
	 bc8ZHOu7o/Fa3VOt5lMi9WlTtvgLBVMK1MDNI4gy7DBL7bNJ91+gB4FwFRoopSPsybg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gb8ECwum;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6128B606A31C;
	Thu, 26 Nov 2026 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gb8ECwum
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2D81F000C4;
	Thu, 26 Nov 2026 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795715911;
	bh=x6I7KcFrdZgI4ebYkIJF91XcGCKi12e7dls4bCTLclc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=gb8ECwumCvU/8ECogM4N8vpDO24y8hlaCcP+omZAcJZLfT5wejl51X0cBWSONrm7J
	 neV73AYViYLNLMxHZ5tr80bZGSLRqX1NFkmPdOD3nnGNdP8DF9dE2R0eVUjd2TEOFJ
	 DvAnqYWz0wz/C5ltAAEFvAlF0KIAl0WYV9qPKvrIpdz23+68OsKCG28rm1BNpzxxQT
	 w448jmrxT3nxqkQ4sMVVDsoieyt6J3I0lvFOZL20cXzwq+yC24x3tr1KtrZt11nLkq
	 d5FAyaETVG220//B7e8R38xH/q63ebbzsLg+GhY9LFYuNa+wULBWJmLTyIqvKA5FuC
	 Dljp/cl6e6Czw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 349893805D92;
	Thu, 26 Nov 2026 17:58:31 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 post-7.4-rc5 merge fixups
From: pr-tracker-bot@kernel.org
In-Reply-To: <awhRbTWsHzW4U7Lp@mit.edu>
References: <awhRbTWsHzW4U7Lp@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <awhRbTWsHzW4U7Lp@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for-linus-7.4-rc5-postmerge
X-PR-Tracked-Commit-Id: aceadbccd428fb8e6593b27a3091d961f80225d1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: df99e82b36ff3c243ec3a06afc0ccaa4866a5a41
Message-Id: <179571590980.542934.10079177941406328530.pr-tracker-bot@kernel.org>
Date: Thu, 26 Nov 2026 17:58:29 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Thu, 26 Nov 2026 10:38:09 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for-linus-7.4-rc5-postmerge

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/df99e82b36ff3c243ec3a06afc0ccaa4866a5a41

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
