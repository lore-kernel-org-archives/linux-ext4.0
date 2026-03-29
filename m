Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DED382372;
	Sun, 29 Mar 2026 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774802592; cv=none; b=qB6Q4neZNPyFMRpn5A7qm1ZCw3wcDEUPEMevVqi2dsaZ56vbqlvyPMZZF3ygNw5TckRsnAHkUnITyLSM7zKSM4zZn+aPD+HxjKY534gEjvpkW2vRyulKqqKTZu3ataHdeiCenncBkNNRFqhj8kLIzlgqlIBS7silCwLk5WwjocA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774802592; c=relaxed/simple;
	bh=IhwQ3EYmIKXm3UNqdThsQohSKRS3kAgaWt7Mo6l76SE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TMc4wIcj+jTf+i8H8En/nwuDaOsR6cydo8UM9ET70k9wzmeNIPaJolEf2zW7PG9ZdBAcXcPq4GCzqn+Nos4BZDUiDy0JeVIOZCUcuk+5RtnTY6sWuWNVm3x6FrHQaRL0EsKq8Nb54KjZuq91lA0CxZ8srIKIFZWw1+Xj4+WUgS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRs2wKis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRs2wKis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BBAC116C6;
	Sun, 29 Mar 2026 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774802592;
	bh=IhwQ3EYmIKXm3UNqdThsQohSKRS3kAgaWt7Mo6l76SE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WRs2wKisu7nuFXGEEMRqhXAs68flJ9hgVPH1tvT1Qhvb1nNx1MehZ4TnavSKiM1pI
	 PApRQEMX604Nx2Pirwcza4CkEVVcxnFm7+t/2Oogpb1cqvmiAP5ItgHcBWKnfJYARe
	 hmh/oIauJ3wpGs2b0E36AiGbHcGt08YkfRo+aKNvQAPfyHiEIS8G0ZHJXH241Os6Rw
	 Dnb/K9EEHubOuEAtJg4/0X6DIU5p8obTd8Y/SzmC6+YmLBc0FPFYvW0v8uZzwOaLxI
	 H1to6b+iX0oxdvfCJdFW3AyD6HUt8JKAgvrHoeVJQkFQJG2Wg+lWND6UPKtAUeDBmk
	 f7fVaIOIN7GYg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CFC8393000F;
	Sun, 29 Mar 2026 16:42:58 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 fixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260329045741.GA9694@Mac>
References: <20260329045741.GA9694@Mac>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260329045741.GA9694@Mac>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.0-rc6
X-PR-Tracked-Commit-Id: 9ee29d20aab228adfb02ca93f87fb53c56c2f3af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 241d4ca15de9bf2cc04bdec466a6a2b0bd5dbc19
Message-Id: <177480257710.408055.1284767822424464831.pr-tracker-bot@kernel.org>
Date: Sun, 29 Mar 2026 16:42:57 +0000
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Mar 2026 23:57:41 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.0-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/241d4ca15de9bf2cc04bdec466a6a2b0bd5dbc19

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
