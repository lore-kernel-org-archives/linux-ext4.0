Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576032;
	b=GpWYsDK4VXbBpeMH5g3WQ8Tata+hoaCce2E6S2Au7fxfMcSFygjUGAZZYzUAaH7kSilG
	 ntsTzAk3CTpfi0di5CSfcs2ivj6EHNQWWUuxlVoToSmihCZAKKJ1dToexQinl01aIBTYE
	 nOk9OvEZlkh2VbFjKppsG7E8PfwSgN+euT0RJPlcFUttgarWQhKmTTkKBVKJ7ypsGG98q
	 rK8EVePPOxSqU31Cb/677CCpLQO0HCbMvfDtYmR4qBUrlLF678tU6y522A2Nzb7Hylp9L
	 qMNwO10QVSgW3XsTQH12jj8SIganaAeNz7LAeIQZFDTw2YFXXiNqNXNtW4DSiHu69hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576032;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=SqTp51qV0X8eAq5Qypg926rmJ1q/rSZ+HuDrzqsal6Q=;
	b=Rwun1JhTSIsYGO/rOTGlTNEp25ttebEdLGcu38PsVBVVrCTWn5sWv/LRXCxO4l29f3Wb
	 y6O3A2TFmlJY/MgY4zXl31+YZlX9N+pkEAkVnGug6tZhgt1JZqjVFLbAJRCFKpTd98wiL
	 vcWvWsaVjlTZ3zvML/kCkENqprq8p8ybey7WcuUASe6PerSWoVdioYtbC3esQ2VXOc3U8
	 tdwwSUdjYuqGYIEQ+ku11FkbAnHVroaHudNK6jKz3/QLEtKEdol5cbJwY2hPUwuws6flb
	 bzalkmioREUyjDfQlap1i/qjCicK+qTDGnuqv1XlASSnL+0X1bHgO3cbIjfEM7wgJGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=icregnCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCF6606A31E;
	Wed, 25 Nov 2026 03:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=icregnCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA461F000CA;
	Wed, 25 Nov 2026 03:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795576031;
	bh=SqTp51qV0X8eAq5Qypg926rmJ1q/rSZ+HuDrzqsal6Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=icregnCctq5IuUmqgk2yfeuzaOz+CONzsSDflNMceFArGbqGBhiRS+yhArmUZuzkY
	 0YOPEA2qiwl8jmeAPmv/pMESpgHFjk49tCt6tvXSjT7KjfrB6md2CcJ5i32Wj6eZre
	 NfPG79C1aeB5uqi9Vtu0T6aK5NyueoxByRTy0DEMhw/N4RLazMO+OlzVCtjUgbHK9i
	 IJbHOhKuho3d/KZflvy2ovDjDUyFNSK61ld7Q+xjAzz0XNqHjYMjD5Gx6agdIHThRB
	 5Bda+y7vfCmkuvJA0L2N9WpjyMXRB0VApWL7ilzWbsHLgMBsLIBFqnT/+wXH1b8DbX
	 H+CX/4mm77anA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B45AA3808209;
	Wed, 25 Nov 2026 03:07:11 +0000 (UTC)
Subject: Re: [GIT PULL] updates for 7.4-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <awW86EI5fYafQx-o@mit.edu>
References: <awW86EI5fYafQx-o@mit.edu>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <awW86EI5fYafQx-o@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.4-rc5
X-PR-Tracked-Commit-Id: bae28a1b11f422d0214654800d9425e042295c71
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4dce97c6c265544342e716e62fd24bbb232590c5
Message-Id: <179557603037.190026.16193029745159421407.pr-tracker-bot@kernel.org>
Date: Wed, 25 Nov 2026 03:07:10 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Tue, 24 Nov 2026 11:36:25 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.4-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4dce97c6c265544342e716e62fd24bbb232590c5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
