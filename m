Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54E51B4156;
	Thu, 18 Jun 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802254; cv=none; b=OS88zEZetfon288BX/NYpfa2jT4e+YCCnKYv+mjHCWY04MsPGu7uoEMqVXAo9OYHJ2ZMCJt3YR8jI/HH6OAOOg4dLiCeMUX165woq2EuXSkI8bGolJ+rU1fEwvKxLI1ZjxJ7Vj2QocS8ICPAi76mkdhF6lo8+JzLMW7awhtvcO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802254; c=relaxed/simple;
	bh=P45AOWxKhr3WkjfHcb3WfNDGD50dWGG48yOVfKzi/mM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jNlVsyoqPWXyT0ZSf55i74o7xCxnkD5+GUCMHxUUnI9ZtSPuCK/+Q+xk/26VeIF0NKZhebgp4Xx+3V8nytShoAZglueUsrKtsy6fd+qVAkuc1TT47CXG2qI4taPJJ7FvEbN/lo115Wo7tScLiM695qr1HmcZWOIvBGh4qwwRd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD8mv/8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD8mv/8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603741F000E9;
	Thu, 18 Jun 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781802253;
	bh=J2bE2kOCYqKQLVr2aVAaT9ITKvBWmAvi3SjbzKdO7iQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=GD8mv/8V9H/8/6x9YsU0VFHc4xL41iWjB7kTAPG1PQgaUEQ0dExRpMmyeZRd1He5P
	 pV+BoHFkdfHaNtGy0R6an828pRFWpW/VvWJOsbNI0PVT6XYqK/4t7rtDHvm/X/JlNY
	 XSx1KHWE2Ojpj7Eaf8bWxqcr6MIz1T+p1Wf0Cma1DsEanX0WZSzXdbdHPsIvTgS/dr
	 em0UrGVEtiw4KIwUwbcRUxDVUS+SGvEjaEWVYiNDDFlQh0pY2BvdTrcHMZRcMjBbtZ
	 9jJ+TyqIZp7dno9Bb0+aQjqAxQn0Rt28JMohVnihBNxelcKTBgHWb+Glxz+UKaSYq2
	 AZ5aAgt1VPZZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19BA73A566ED;
	Thu, 18 Jun 2026 17:04:08 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 changes for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ajPrqTd4FaxlpYPs@mit.edu>
References: <ajPrqTd4FaxlpYPs@mit.edu>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <ajPrqTd4FaxlpYPs@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.2-rc1
X-PR-Tracked-Commit-Id: c143957520c6c9b5cd72e0de8b52b814f0c576fe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 83f1454877cc292b88baf13c829c16ce6937d120
Message-Id: <178180224662.2987783.2413369704861540188.pr-tracker-bot@kernel.org>
Date: Thu, 18 Jun 2026 17:04:06 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Jun 2026 09:00:01 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.2-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/83f1454877cc292b88baf13c829c16ce6937d120

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
