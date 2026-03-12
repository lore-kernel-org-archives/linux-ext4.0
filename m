Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1513451B2
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349274; cv=none; b=cDPzzS6lNfkyKXgreMok2fYvPKAT+pEsqSbGq/cLecrdGPCejLlhhOf7AlcFyt2YeehsYJynVxV4sOsWSR3kM1dAfj5/6Q6oi1llmttWEh1nsA7I4OpH7LS1C5cwfL07D/u6X7SGfkURoVrs6bFST7CyJc29SKm+8CDy9tHn3LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349274; c=relaxed/simple;
	bh=xC7ejgxB0vJNO4BErGRfeu4Km2lccQddsNjHESCVCiM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=mAw7MVUex/Xi3TQVS81ypZRl2R/wVRwSq5TfIwNTDskwLSq3ooNDM7E7AYMMFpAKFdw6Nce+QJQLnobr7AHNd/uScrWZLTa/am2+2EM7uf6VezpMsKAqeqPv0/eoUtdfcIEK9xkOswR9wgTpgddk5XmBmJUrgk5PI1l+ac270BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzvcJIfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzvcJIfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B81C4CEF7;
	Thu, 12 Mar 2026 21:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349274;
	bh=xC7ejgxB0vJNO4BErGRfeu4Km2lccQddsNjHESCVCiM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PzvcJIfpIimyp3uj2b3ILZQVA1bdhBbiW19GWDJ4jwSlMhw+w0mdiktxyBRU6Rnet
	 R5Tlc86za8WfnzPM3Upk2N6xnGSodq2ixRG1m2W1NvpSB1JzL3T3ymuCb1su+pWcE2
	 8lnWDdVr4vncZx1mPHZ6Ir1EV29H+c/m2nt4u25oosnvhf/gVWKvaD7ApnPa1w865s
	 rNwB4tTNag6uvfEvYvqOHKAgn97+8x6BGHyZ2jzUvQspPZJV1W6Xg4ypndmpopDIr4
	 dYErDjsSfh9Gt5jcRygNbXBshNX3SJztOOfXbeTT5m/mX8Ih3YpsW/18GifpgWLFOg
	 o0F4fCJmGVNwQ==
Date: Thu, 12 Mar 2026 14:01:13 -0700
Subject: [GIT PULL 7/9] fuse2fs: better tracking of writable state
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916629.3254574.9721669086227705727.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260312205728.GA6004@frogsfrogsfrogs>
References: <20260312205728.GA6004@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Ted,

Please pull this branch with changes for ext4.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit fe8281316fd37133eb78474040affabb3f060e24:

fuse2fs: record thread id in debug trace data (2026-03-08 19:14:06 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-writability_2026-03-12

for you to fetch changes up to f066b2d71d62705836e131bd03f71d42dd4f9376:

fuse2fs: enable the shutdown ioctl (2026-03-08 19:14:06 -0700)

----------------------------------------------------------------
fuse2fs: better tracking of writable state [07/18]

There are multiple mutability variables in play in fuse2fs -- first,
EXT2_FLAG_RW tracks whether or not we can write anything to the
filesystem.  However, there's a second state, which is whether or not
we actually want to write to the filesystem, regardless of the library
state.  This can happen if we open libext2fs for writing, but then
discover something about the filesystem that makes us not want to write
to it after all.

Split out this second variable into an explicit variable in fuse2fs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
fuse2fs: pass a struct fuse2fs to fs_writeable
fuse2fs: track our own writable state
fuse2fs: enable the shutdown ioctl

misc/fuse2fs.c | 102 +++++++++++++++++++++++++++++++++++++++++----------------
1 file changed, 73 insertions(+), 29 deletions(-)

