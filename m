Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AE223C39A;
	Mon, 11 May 2026 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778463725; cv=none; b=ikdIkBYYXtJq0owfxA/JKewB1/uWPq1A3q3B5A0LimTS9wbKrxTI/HmGpVhTx8AQSyFXH9+0enhqUibjgPpONeIEacIfh39k8U81aOowICZSKMc9Awgi4BuAKWfxE9Wg8zicJfL326wqlySveAXCjVtBZTpSwx6lZMrp4jhJ0eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778463725; c=relaxed/simple;
	bh=l1dMEIH4cxx+wnZB0tqVb04wT+dwsZ6juwhVU7G3jEA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Zmh7hCgGh9UoOvOnhulQfDoXa4MkGFX3Jd7DJ+IIEAjVxKZk4LbA+lJ7vfWl5QgAlb61jQm2LmoyRl3Vn5Q70n4YAshLXiZb1kLyk1aUcR7mPMrMBb7w9utnnEwPFOQPs32LkDaIUFcrfOq2DgRapF9uWrxPbrBpoQeClvQYWmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=At5Qb51+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="At5Qb51+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70196C2BCB8;
	Mon, 11 May 2026 01:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778463725;
	bh=l1dMEIH4cxx+wnZB0tqVb04wT+dwsZ6juwhVU7G3jEA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=At5Qb51+LYJ397XHy123a03vgbfslynusNYk8Un6LteRrhANlCZmNOpF0hmW5zWj8
	 dc/3bPYQb0oqwKrzX1MyX8rfT5JvNbaPHoZv7e65SNH8XEnwAUG4bARnNyrjl9lnPM
	 FJe+CD5yG2/rzGA6wdRGJKLD11OLhel/+Iq5r01AFeJA3Ky6gzxaOiDLWA/es2UBH7
	 +jIkEy958guv630flGvAUiaIo9nNta7ZYseUXPwLJC8bQd1HMJXgikZHTDI3O/v43/
	 v1jxMR6zyiLs4hyD0XFnEeBuwoUNJjwWJqEvzQ6trlCPynD1rA6qXtuohjMSPzrUTa
	 wHseFHy4SMfjg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E393930039;
	Mon, 11 May 2026 01:41:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [GIT PULL] fsverity updates for 7.0
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <177846367229.1975880.775776220391157336.git-patchwork-notify@kernel.org>
Date: Mon, 11 May 2026 01:41:12 +0000
References: <20260212012652.GA8885@sol>
In-Reply-To: <20260212012652.GA8885@sol>
To: Eric Biggers <ebiggers@kernel.org>
Cc: torvalds@linux-foundation.org, fsverity@lists.linux.dev, tytso@mit.edu,
 djwong@kernel.org, aalbersh@redhat.com, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, dsterba@suse.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org,
 hch@lst.de, linux-btrfs@vger.kernel.org

Hello:

This pull request was applied to jaegeuk/f2fs.git (dev)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Wed, 11 Feb 2026 17:26:52 -0800 you wrote:
> The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd377:
> 
>   Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,GIT,PULL] fsverity updates for 7.0
    https://git.kernel.org/jaegeuk/f2fs/c/1bfaee9d3351

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


