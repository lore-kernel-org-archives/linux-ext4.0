Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E125C3438AA;
	Tue, 16 Jun 2026 07:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781593713; cv=none; b=YasqoVLbTggHV6YUk6RL1053MHKTMTnFvWfIDIdovKfkvZeWXlLcZBAgEs+pjBNCb/Z5F68Tbdwh+pYXqZsPxjh1BShelOzi03jDkKYVBtnWJQssJu/eyJWhcYIcJK150dKJAdfAgvBc9qpA4kOP9Qn3kiope4L+pZGeGOE1akk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781593713; c=relaxed/simple;
	bh=q2sbvjhRkpqXAPZF/+EWrxu/XNiiHucSNPhegY2l/qY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hbBGNOKBjkp6VtW42iusxOH4mjnCl4nFwRVMFo91l6xH1ovIuZ6SJVscAj0+QK3EWlzjnMbZoE1MfHqQY3zD3j8hDGEUEnx6JECCRpt1GqsLkGgdUM+deZSBXU/5l8HK0mgX83R0yYVpo02pnTsnlpZ9IgUlp7gt17gOZmQDHlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CS1JLUzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CS1JLUzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C885A1F000E9;
	Tue, 16 Jun 2026 07:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781593712;
	bh=T+TbPvLuJwHbQ+mdMg0fAVFcGCDrmMSNBG1l3EWPi/Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=CS1JLUzQZmJI5xbnAq3J6SvpVWfpEGJ04Un1AXqrvuIAKKEDw9vtLPlRAEhYsQR5w
	 6zdOBB7fQoHJB5SKzAu3ZgdTZUfROqTZLUT3s8ZKAIwSDbKMKx95JEiuTqW8pHFygA
	 AzJu+/Gc3z9yZhu0zyqoErisWxgJs+7Z4z/mN1usJqUfMUwCtsDVr2P27fbTRWgyyr
	 2/V5MdR4oJeWmovqgh9UVksfjRH211vYOTmdzsEgrtA2B7+ZlUoZgLr0txUlVW7sGJ
	 smHXRCfsfhokJtdgi5yY7TB0+lUDZhE+VnFcmL4tReJ7rApAk0JgKh8eacBuhfoOrq
	 ezKy9Cxc2pw1A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A0C383BF5B;
	Tue, 16 Jun 2026 07:08:28 +0000 (UTC)
Subject: Re: [GIT PULL] udf, isofs, ext2, quota fixes and cleanups for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <jpb2wjkfh7j73dpinuvwe5qddkr54px64vmvx6bclzd5ter6hk@mjwwwgohsyxy>
References: <jpb2wjkfh7j73dpinuvwe5qddkr54px64vmvx6bclzd5ter6hk@mjwwwgohsyxy>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <jpb2wjkfh7j73dpinuvwe5qddkr54px64vmvx6bclzd5ter6hk@mjwwwgohsyxy>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_v7.2-rc1
X-PR-Tracked-Commit-Id: 5163e6ee1ea744d412fe516235bfd9cab15141dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 974b3dec2bfb4b2726a6194105cb048a9dab0626
Message-Id: <178159370748.494683.5105954604731827249.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 07:08:27 +0000
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 16:51:01 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_v7.2-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/974b3dec2bfb4b2726a6194105cb048a9dab0626

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
