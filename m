Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03C74DA535;
	Thu,  8 Oct 2026 15:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791474149; cv=none; b=a645HEV5DAkXLE/40aaXhyllFDWTNttlrKk3vMecZoyEzG4KicU0cUoXV+TLe5Jcq//MStudDca+hb8MJB3N0KomHe8aVF4uPUkp0TnxUTZLuw5Rm5QvLYBt4FCkYlOXan0ARSvEGS8duzm1zJsqbDCYUb4Jw78HMJ1r6n5EQmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791474149; c=relaxed/simple;
	bh=1qywYLD+zj+XOZIAMkXckzV3F6fdGbjzclFZ9/jP8pY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WbgrR8MqsjtbrnhVhZ6sY3JAIeClYKgy9YtRFkrf2ItCCwpI9lITUwK0Cw4gCW3embMuywYkyXC8DwpPAICix7A4FWjtqSdFxeLCVMbe1iWSiCL1GvZaVIMTuhudZRh8tov3+vS8MUC8BZopb4xI9SUjsP6bUMcBquXQHnLy29E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIYLMY1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIYLMY1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C5E1F000FF;
	Thu,  8 Oct 2026 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791474148;
	bh=M6EIpLAb2INYVFVewMzk+WzvdZ/Dly8RmM6QLOyGjF0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=CIYLMY1U+0Cul02NvZtEiiOQtrNBGdaAx2atMJgk2ZOR8J5f2DfVC31B/kof7+4lK
	 IFQEWVi831m1UQa30G5DjtIcLHy2tu2JhDjPLzdTlUTmZ64fCxBcc9pgte6P0J6TLS
	 8/RhzhLJQ5cvArx+8On8bMEd1zID91utsHVMYyHrFjCbLwpEzmH+erdOEKbBMsyC+9
	 0v41NIoks3JYbNFZpz3uzhjwX0HAYDhTfSbgxVj1Yi+g+8skNHjKb8hKAqhGrjro31
	 6MHhV4E+jdg0E31QSZ6lv22DsdVR+/pR/TNNibdleAYs2rG52M/DdKFQ/rYUVob8MH
	 nzDR0OJY8HVSw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A784380AA76;
	Thu,  8 Oct 2026 15:42:28 +0000 (UTC)
Subject: Re: [GIT PULL] last minute changes for ext4
From: pr-tracker-bot@kernel.org
In-Reply-To: <ase1cbY1IuELJ7jQ@mit.edu>
References: <ase1cbY1IuELJ7jQ@mit.edu>
X-PR-Tracked-List-Id: <linux-ext4.vger.kernel.org>
X-PR-Tracked-Message-Id: <ase1cbY1IuELJ7jQ@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.3-rc7
X-PR-Tracked-Commit-Id: 3e78d7b063230d39ffc42e80ee665b6c32a6adeb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6c377d19d4a5116d9bec5203aa3c6c11523e7898
Message-Id: <179147414682.324841.6555717347979947475.pr-tracker-bot@kernel.org>
Date: Thu, 08 Oct 2026 15:42:26 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 8 Oct 2026 11:31:14 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.3-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6c377d19d4a5116d9bec5203aa3c6c11523e7898

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
