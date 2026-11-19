Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061408;
	b=gvO0h25lNJ7L93ImplZf0xF1oMMofZSuwzs2Axnrko4U1K92FDOmR35oYfkSs2+2LnN/
	 n/OpDmluKKRnFmFi/J+Lmf3aCA8pBF5agqSvNuN9VnWVnX5YmtZDrigab3k1Zg8/i8Ms1
	 glP3PwvPXK/tSt70bDfUAPdwAmJIWbZvXlXqgdwQX9ykilOItPQgALFcrEVAnCm4fbUQR
	 d4M6WRjzaNwI9TOpYhoW3nuBbipb7gNOmozPCOtY3rgXuU6tZBvTX2o4/DeRxe9xtI3mu
	 5Zch9EXjEwrDla9M9xT4D4TeqZzL1APH8UQSQLhNUKNhH+tkxCJVgQdYQuL0KGyXpyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061408;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=jqBOKNtRPzNoyjEfKN96F5ibqNgGCLHesS720EM0VMY=;
	b=bAWLdSgUAr++be0CaQrWsXwPzLWo4Z4QUs6us9EbYlvHleiecfiR2YYrOvd35PSXLz0V
	 GEvFKPY23TtAiZ9nCd73J+RzWMYLCmYIPZXh9ycsg7LRiKZhAIji4Km+PYwCRqrZxgFtW
	 aSTJqKAurLAS1ayVEFRv6A8uts+lUCLMcVl4yvuS8TrYVWtUGS2+iHjF2UFdZqEFPSUNJ
	 8Bt/dAnRLI4xP3tFe45LJKBJ1+g6YNE+KXLbojCedNcqJXxHD5weHDKMBbqeX8l6qAhfC
	 Usm0tTDd+pv3B2e5DfFsd9I6+T+0hEl1MAnCIi9Qj4YdwEYCqm7pzum+y3+zBoWWuPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvo4Usrd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8666D606A32F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 04:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvo4Usrd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D671F000C6
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 04:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795061408;
	bh=jqBOKNtRPzNoyjEfKN96F5ibqNgGCLHesS720EM0VMY=;
	h=Subject:From:Date:To;
	b=Jvo4Usrdmco0Cx7T4woHc3vaF8caLCUVH60q7UuArEuSfO1D91LqxGyvcJ+0QrdHf
	 k380w+vfWos7ZFHjzdf3CS3lWTOymC2vdJRXtYFJcvUq/MgyJ4oaO/hq1JLpgaxQHh
	 aXCbwBSfKkpXokN+m2FhDGLSVvBuKL3H0In9l4KM0TxMYt9sfINoMx+4VRyU9Flhxn
	 6C+Y/xYOtMIvlfcXxpJom9+0PcjxWaWo2sQtYoZzIvKHlxC1ouxlfZAV8kJ9pvxKt3
	 je7SIhh+UpETHuEnqoKeaDe+77p80UQEVWOmjvvWE0qG1e3jPpVwHP9XJ43IuQuyjx
	 G13pINJJcf4sg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F3BC53808210
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 04:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Patchwork summary for: ext4
From: patchwork-bot+linux-ext4@kernel.org
Message-Id: 
 <179506140642.2830130.7337523425530552495.git-patchwork-summary@kernel.org>
Date: Thu, 19 Nov 2026 04:10:06 +0000
To: linux-ext4@vger.kernel.org

Hello:

The following patches were marked "queued", because they were applied to
tytso/ext4.git (dev):

Patch: jbd2: document the h_invalid handle flag
  Submitter: Amit Patole <amit.patole@gmail.com>
  Committer: Theodore Ts'o <tytso@mit.edu>
  Patchwork: https://patchwork.kernel.org/series/1203183/
  Lore link: https://lore.kernel.org/r/20261105-kdoc-jbd2-h_invalid-v1-1-4bc224f7d0a2@gmail.com


Total patches: 1

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


