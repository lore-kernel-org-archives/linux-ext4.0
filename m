Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7463D8908;
	Thu, 20 Aug 2026 20:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787258671; cv=none; b=Q9dQ8tv7XBHCjsnF8txy2ROoVCoj/IDOTNqNTMEGwv1y4wHD3t93H66mn/L3WS3p1cGEgCbkMPS+9HfBLJUVEiQmHOH3VESydvc0GP7V5LPlxaQz6zc5KsZKCX7JTG0FQyffHaSjIAq11XhnA6URSoNPO+62Yki6DXBiGgMTC2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787258671; c=relaxed/simple;
	bh=rLRDuJk3iU2BnyxCZckb2IvoTgOb1/Dn9qp1p6eAC+k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pB1S9SZPWEgHwDAZY0DuQE0xx8lT/Ee94EZUp7WHTLhLyl478WGif1ylQCPQL1BxTegULPUPuk78RQyJrGlKxEs5wVsKolbMlVOYUIT/taI7lbwRZbkUwIf90WGE5+Z+hxFb9DICk+dEvNnHDBIrU0KNWzi6+JrxlQl2T80lWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbtH9ofj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbtH9ofj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E771F000E9;
	Thu, 20 Aug 2026 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787258662;
	bh=RHReuo16ibhaXEXNwpe10QZvAxGI5jjQHYty1fnU+Nk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=MbtH9ofjXLzrapk6P8B1dnhbu1yapSIIYBktO91YM0mycCR5IlFo0NX6Pg7DE/76O
	 S2/OUNX+srMYMoFCe1t6rDW4YKEahZDoRjb8307L5nodqEEdUVPL2+yzkVAK6DXdIx
	 LE60/cY1A+RYxvvvPiEvStdNcYh7h2NvBYZAG8smy3t0Nm8gE9khUY+X/pDrIFeqK8
	 7HZHnbyxOL3aziaMfJlakzdlhi8F7B+OBvN+v83mzxJ54j9cd1hABRmgJU7MIk4CVS
	 pzDIVpQRc5GWRYis1eo77Tsaf4vrKJNR1rIBgXj4YZALLs0gehUJ5JojbG5jXIDisX
	 b+653dkoFCJ7Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19AD2392445E;
	Thu, 20 Aug 2026 20:43:34 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 changes for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aoPivgtbvFQk6aYD@mit.edu>
References: <aoPivgtbvFQk6aYD@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aoPivgtbvFQk6aYD@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.3-rc1
X-PR-Tracked-Commit-Id: 9091c97be34083587a75db174aab51551d8e8543
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c84d3e3130dfe1058cb27dc78e7ad8bd36f0545a
Message-Id: <178725861268.477132.9277345525489366910.pr-tracker-bot@kernel.org>
Date: Thu, 20 Aug 2026 20:43:32 +0000
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 18 Aug 2026 00:43:18 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c84d3e3130dfe1058cb27dc78e7ad8bd36f0545a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
