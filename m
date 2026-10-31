Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405408;
	b=mP/7WYsGkdqgB26bRFAIvDJSny1HfsOlJHIpEUmD4A4kDCvw1+AvlNyiVjQY9UcdHwVz
	 1N/DYxnJ7qSn4bDqPmAaCzOJjAkSoVS7jPANrYvyJXM45kToj5tDixRhsaJn9hnxYM35m
	 DszTMm81vxWOlh6REi1udJfnHOrYPIUQEH/jO3aPdD6JhMC7nH/PTuqyWqoPce6ySwxH6
	 TIA38Xllc6A7LgR+J1WyeUgCjX7nL5UjZ8xAc8xbRgIqnGbXYh5EzQ+Cfr8rtpugu6rX/
	 41yVaJryVJITZT3fuV4dOQe8CV623QwUar2RCwccfy7bN9xSYd46tuzggjkF+uviQSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405408;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=9dOo8f0mm9iy1zykchLuzHF6Nx8+3yNprn2jaHbfBqA=;
	b=qAce6fN+LyjcilZDK0fM2GjNDNSjxkr4BX3Bw3T/nM9hrDV8jebtHjybztQZnGxyAe7q
	 cBgHR+One0hb1hRdMjZam4IE/6ub9hh5V9tEyWAY3nFi+reUGMT9E8ivORkv7ujRXx/3t
	 DN0YmZAJdOQq5Dg7Ii/gzhRKXrUH6ItAkVDXOd62P5quqvCrS90feTxk1GN6ED1OJl43N
	 CvDXafSnN917DE8LDAAtVMRjJcV9a0IwePenFFeNLUCilYT7Hby/uxTGUQA5Sml4cn2DZ
	 OJMpmuKBRf+5CiYuzn/qnx+2j4Pfwj15wfiVkxqDRB+1pLr7bQi4H4zPrNtuBb0VuKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mcFiRucI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF815606A31E;
	Sat, 31 Oct 2026 00:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mcFiRucI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8837D1F0093A;
	Sat, 31 Oct 2026 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793405407;
	bh=9dOo8f0mm9iy1zykchLuzHF6Nx8+3yNprn2jaHbfBqA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=mcFiRucI8TySqH1olgcgVYbeD151DeNnotmVz1EVcPK5Xrh9rY4cld/vDj1Au0K+z
	 7zNcqp4wlxsYFXyJU/Gk4ZluMkIgEoCr8mYGQqVOsqRs/L8v/wNhW9N26XtyfrVRPn
	 23SwPS/Y/trSZNz4RZ8js6vsFRK5Cf6cE6zeQTCPPUoINHOE1SZQedEOZOvc96wnI7
	 h1K8LYWz5TcHJ9NnwctKbMWdAXhuvGz1sjFU84kNqoWBIId33+Jlsp9WeSZOpfzDmy
	 KIQmcjuH/FDpaLGtbPnfG8neqR+ShnWRtIB/E9IrtgPRgWiT21WGGRgi4GbURJ3wm0
	 t/TzNsZti7iSw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D3643800478;
	Sat, 31 Oct 2026 00:10:07 +0000 (UTC)
Subject: Re: [GIT PULL] fsverity fixes for v7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261030202415.GA1967@quark>
References: <20261030202415.GA1967@quark>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261030202415.GA1967@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus
X-PR-Tracked-Commit-Id: c349b233d6ab0fc3517401a1e2d36f5f90eb8c9b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 69eac8481741b1474eac7c459768c94bb94430e1
Message-Id: <179340540592.1842115.685865378245125650.pr-tracker-bot@kernel.org>
Date: Sat, 31 Oct 2026 00:10:05 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-security-module@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Fan Wu <wufan@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Fri, 30 Oct 2026 13:24:15 -0700:

> https://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/69eac8481741b1474eac7c459768c94bb94430e1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
