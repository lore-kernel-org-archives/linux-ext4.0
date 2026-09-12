Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3836E484
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2026 06:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195352; cv=none; b=sQrDxxAQC/JdovltDFPSBsIQcjJolPRPKwCR0r+KzS3AXnfS6DEoo1iL57RA9GNP2Vg5nBgVxOFt/uC3s8MaIsjKEBAEdkOyjEFP68VJ2KkA1x67iD8+tAvUeZ+FsK4nWyaeEnlHYq5oI+XAmolPPj55sir9KKbNFQnsmVJDU9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195352; c=relaxed/simple;
	bh=O7dkoaFcI2V9sSYLzUjIU0eVnQuTK2OPhsIQe2TO28s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Gx+bM4QIPHovSXdhhV4Pum6XVs6dbEKkdkGEwGZrWwTBtKSDlDzDr2aTHQCqBWoOA5RHGAXmml3KhNmLSUTUXjITWK8LLtcyrQpDC5Np+/xsQmkOZUaEBg/uYHQtiQNQZ9xfR8knQvGGx0N4JW1b5k3+DATO8uDR9fEWTk1W/KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1vEVJHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1vEVJHx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14D821F000FF;
	Sat, 12 Sep 2026 06:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195351;
	bh=2cK/4VDIu/GFUr3gdGQjL+uf3bQWraJQjtj/anq+gl8=;
	h=Date:Subject:From:To:Cc;
	b=S1vEVJHxDwukD525csRRV+lXKC1HDjw/uXM8iz9Ulehdbo/RItCoGiH4v1QF+gPwA
	 vpLKapVEJqhr8/H+QV/MpVSAX51MHNLuf7fq9KLxpXAkH9bZr8k1Iuu4z3WRT9juOq
	 scY/eCEsdCibn6XxZeTkdVQAT3E2QCgpGkYu7CKYAOAIlyBAEMm+BaBpBJOKKuLuSk
	 R7j8ySBWV5iKdRmUgTQFaHhNAABAjm/K5shr+9E94rX3LKy5HVtWQu7A+Lbd1tO5x1
	 AFPhZQoMegEthzeuCzQ7TDT7pdsx02MA9EBu963Lu96J3EQ8t0myh/DLYopAO19bwX
	 PlAvCE6ut2tXA==
Date: Fri, 11 Sep 2026 23:42:30 -0700
Subject: [GIT PULL 4/4] fuse4fs: reclaim buffer cache under memory pressure
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178919524526.1033422.4174224890210516955.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Ted,

Please pull this branch with changes for ext4.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 348aa5ebbb5d52aecba07f6069be986be9bfc4fe:

libext2fs: improve caching for inodes (2026-09-11 23:35:03 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse4fs-memory-reclaim_2026-09-11

for you to fetch changes up to 9fb92b58e1c74300262242812d53b84a7f5b51ac:

fuse2fs: flush dirty metadata periodically (2026-09-11 23:35:03 -0700)

----------------------------------------------------------------
fuse4fs: reclaim buffer cache under memory pressure [v6 4/4]

Having a static buffer cache limit of 32MB is very conservative.  When
there's plenty of free memory, evicting metadata from the cache isn't
actually a good idea, so we'd like to let it grow to handle large
working sets.  However, we also don't want to OOM the kernel or (in the
future) the fuse4fs container cgroup, so we need to listen for memory
reclamation events in the kernel.

The solution to this is to open the kernel memory pressure stall
indicator files, configure an event when too much time is spent waiting
for reclamation, and to trim the buffer cache when the events happen.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
libsupport: add pressure stall monitor
fuse2fs: only reclaim buffer cache when there is memory pressure
fuse4fs: enable memory pressure monitoring with service containers
fuse2fs: flush dirty metadata periodically

lib/support/list.h      |   6 +
lib/support/psi.h       |  66 ++++++
fuse4fs/Makefile.in     |   3 +-
fuse4fs/fuse4fs.c       | 258 +++++++++++++++++++++-
lib/support/Makefile.in |   4 +
lib/support/iocache.c   |  19 ++
lib/support/psi.c       | 557 ++++++++++++++++++++++++++++++++++++++++++++++++
misc/Makefile.in        |   3 +-
misc/fuse2fs.c          | 189 +++++++++++++++-
9 files changed, 1091 insertions(+), 14 deletions(-)
create mode 100644 lib/support/psi.h
create mode 100644 lib/support/psi.c

