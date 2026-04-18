Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C161A285;
	Sat, 18 Apr 2026 00:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471109; cv=none; b=X2zVlxt9N5Hv4iO5dMus9AIlHRHxX0yehk0DOWDmR6JUFm3ce4vvHV0dqntJK1/A4IWdQ7iCYnZT7NxRd9XX1b4+zvHrGLkjBswE3LxGR6VwBvCoDf4WCHQPwqbiLEW4S+B9izoHGcDEWEXv/kLfd1IO5WgD83A5xTqmtaLDvg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471109; c=relaxed/simple;
	bh=5M+VwXtRfb/WFK7sLYpTdearPqZOQ7QHSrxEUcvlpF4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YXtOwg2HV5oIALPNx2G7cYbDdkZlJgWfNnLvIF7oXaPyPapejJVoPoCZk6yhFrwulQ3eMMrCKNJiPIqQY2yZY2QM8I0NbvoH9VTGEK6WMEmKSreR9/KYKgFPVdwMFo7HvwLBqyZEXfvmO5QszCMrgJyn+iKtP/9Chk5K3oasxvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njd4sNXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njd4sNXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C563FC2BCB3;
	Sat, 18 Apr 2026 00:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776471108;
	bh=5M+VwXtRfb/WFK7sLYpTdearPqZOQ7QHSrxEUcvlpF4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=njd4sNXHgvSfjiMnh8NC8L3PlhzXeYVWJEZ/BswPTK42s9UHc0H5uUmg6CWzXk93y
	 8czntOljNaghFstAuyrgKu81DrfTjlkjioC2wk+h4MVxl/xCGdZRVCz9q88f80HfwM
	 xabsq7plH5H62LjGyTbkLAarZC+1vKAnry+QjOde5zE4o4RZguJonsKp6kyqR5Okqy
	 /DLoKzV2lDRA19hcYTVSTyTLzoEYeGe1boSv4Hj5F42s2W0bTfXa116EoFSYzz1NvW
	 agGos2kvfzrW3zdtA6Z/90KaOmMmj9AIg4DAmiUeHSl3bJGXnaSYqWx0G548wLEdp8
	 uKzML9eJArsGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD33380CEEE;
	Sat, 18 Apr 2026 00:11:17 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 changes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260417151423.GA1808289@mit.edu>
References: <20260417151423.GA1808289@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260417151423.GA1808289@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linux-7.0-rc1
X-PR-Tracked-Commit-Id: 981fcc5674e67158d24d23e841523eccba19d0e7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a436a0b847c0fef9ead14f99bc03d8adbf66f15b
Message-Id: <177647107586.210948.6244291520040367355.pr-tracker-bot@kernel.org>
Date: Sat, 18 Apr 2026 00:11:15 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 Apr 2026 11:14:23 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linux-7.0-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a436a0b847c0fef9ead14f99bc03d8adbf66f15b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
