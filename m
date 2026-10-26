Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792981243;
	b=fy/ncqcrTkblqQ06I9i1AD6U7wfOAs8o6Hy3LD0zH8hZgSefiE6ht3vmyhl/a6VisQRC
	 XfkQa8ehZf6Iq5R/rN8DddsKiedilOkJ2Mu1z2FXyRZ/MN2td0T5huKKPp9KR2oz0iowz
	 pWZk6wBr3Dgx15knAaRnNV0oGFGN7Pgd0r2TNj1CVZmHVzYlaoZKbpwb+UUyyGEbXG7gh
	 x0lbzTZeBWxZmO+WzU4ybvo6haobYYH4JEc0k6tlATb0IxX/wgoqH+ZqwjzTCCVz7FOoQ
	 bKhGw66+jztQP4egXOEh0DFhYzmcVBezfRcBziw7nxsR9q42i0RKNxO8DcJrSLXUCAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792981243;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=whvXQDKSi6waauaG4lRgpbIAgIUYHfauD6WQmhre8Q0=;
	b=lpRjY4Alqh6zfOLG49tXlp6Au3YBt9l0KX9FirG7jR2Q13OmcFPwcsK0j7AISU7IXTib
	 xDMvJ0BbmhJU/7jxkS01AJcsTg1PigO2mE1mycB7+vuyElXemL3s3V0lDkp9kBFEeY7mJ
	 RNSs7Kci5dk0eBhqMis0L5vm1ezNHioVXpVhTgmFJqrfoVwmNu/FhKRxwShKlQWPebkXW
	 yuOopkZk1BbUs9yla8NDKnUqK57euKKhP3jDdD0JpUqEuxZtnPa8H5QdDALueARuahdpj
	 QxAw1PCJBmrT7LDe14ef4HIJf/B3OAj+zJshdD9XmgZDl88FzUfsmBVI2m7NuMlXTnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JOEvzFRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F65606A31A;
	Mon, 26 Oct 2026 02:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JOEvzFRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B401F01825;
	Mon, 26 Oct 2026 02:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792981243;
	bh=whvXQDKSi6waauaG4lRgpbIAgIUYHfauD6WQmhre8Q0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JOEvzFRXWaWQe13meppqAEnXv0Hwn6Xi2glZP4pUOUkJNuQMaOZkf0oEkXiCOh+gh
	 si6XutFL40T8xWgw9aEFtj01gnMPdl+jpoIKLOlFOwZS/B0gLlc42x4RKWOo1yhSC2
	 pkbXcKLwIEQRESD1bKaSIsai2CjBm7s/cp6JQXms4xCu2Bgo5VmfGvsWnRo5+aMIGe
	 ldoV6R2lA3rWUFl+Jbn8NAULgYmF8cnWb63qqD5XUSNiHG0k5aLokqQPF7W88OAWXB
	 75CMUJYTwgjmXi6qS3wf1cr7iBK5jLMP3zK10ipMZH2uIR9rEWRWEQ/K9y/16VARoS
	 pYnQvqvXAwgzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0751B39EA760;
	Mon, 26 Oct 2026 02:20:43 +0000 (UTC)
Subject: Re: [GIT PULL] ext4 updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <atoWDJDx6sFovvjp@mit.edu>
References: <atoWDJDx6sFovvjp@mit.edu>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <atoWDJDx6sFovvjp@mit.edu>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.4-rc1
X-PR-Tracked-Commit-Id: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ac5feaad48f0910b3db4047c298dd11157aef1f4
Message-Id: <179298124149.2366612.12689866261093531013.pr-tracker-bot@kernel.org>
Date: Mon, 26 Oct 2026 02:20:41 +0000
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Thu, 22 Oct 2026 09:56:59 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ac5feaad48f0910b3db4047c298dd11157aef1f4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
