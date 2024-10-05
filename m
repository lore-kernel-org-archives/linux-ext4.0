Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986A0159217;
	Sat,  5 Oct 2024 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728151652; cv=none; b=MPILTE2nLXrFJnPcnOhNpkTnjxg9L0khJMAogw0DHW433suQWdrjMKSdrxbh8v9e6lyxjH4oAThvRLpbxJ/cp2r8qX/1hcC+X6cDtvBe400qePp2IJ7Hv1fmUshGOP/2f8CPitYcpkqHV13QBTSPFmP8avKQiKrOTxs0kpXoZGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728151652; c=relaxed/simple;
	bh=/JlTSfGrnXqdJ0nf2ulR80GQdIdbD2AXr78xZZZ4teI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lkHgSEAlT/KcVkg3r1MHDvwjpC+2sl2lawQQkWQMhPFZpV22QoXjWSr3peUI5h/V246XUiNHPXLFOXuhSmWN+GiFnKnqy5/+z4vcXHtKSKLAQUWwtlirXsgGDlLHtW0g3PIsbX6PQW4qYjKdq3v7+C/et1W7fSMriUTSUx7ZMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVNoFD8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVNoFD8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C112C4CED0;
	Sat,  5 Oct 2024 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728151652;
	bh=/JlTSfGrnXqdJ0nf2ulR80GQdIdbD2AXr78xZZZ4teI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IVNoFD8xYP4EFgBCjozPFPGaAsFE4ZUjGFLOIfWKnksPW/3r19JWZJObD1JJn/Djp
	 HOCeAcF6W828G+uz07fxeXxKbMzJypRczJgFy66oYJguobvW0pQwXuNnGAlk9jzQbG
	 3+BHpzCB6lf3gW7p567BG+oNCQgGItH47RUW2I3/6lCjdtUiwbxGWUKQrY7aa3ogwt
	 dHRQ1P0/119kOscnIzKELKv/Ydmbz+eDsZ+6NLk38HZWdOMl5frp885Kd95mSM/6hT
	 H6ehDvf4CyC1Oy4+Oyw05agcyFtCYpv+fy6nN9cqsosK4rpdLdrlmatbhqTS8CRTJs
	 HynhoWfbkK38Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D7A3806656;
	Sat,  5 Oct 2024 18:07:37 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 bug fixes for 6.12-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241005024221.GA505880@mit.edu>
References: <20241005024221.GA505880@mit.edu>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241005024221.GA505880@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-5.12-rc2
X-PR-Tracked-Commit-Id: 6121258c2b33ceac3d21f6a221452692c465df88
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fdd0a94dcf7fdebaebe1b9c59614a41b6f9aa651
Message-Id: <172815165590.3145223.959801043461109774.pr-tracker-bot@kernel.org>
Date: Sat, 05 Oct 2024 18:07:35 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 4 Oct 2024 22:42:21 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-5.12-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fdd0a94dcf7fdebaebe1b9c59614a41b6f9aa651

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
