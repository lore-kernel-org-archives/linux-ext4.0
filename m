Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC8625771
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416159; cv=none; b=iUMsM95h/lEYUWi7pnWdbPRtudMMqTIpQDPB7c0gUcJjHuN1AO1w9XVodDCytjeALGVrqjw+JSrQ4IysXr7EOv/c0wzPyBlyFnJE3WcpgxBg83quYMz6Mpk0qjlTrwmFDrorqc9v7/N1idagXsIYypkfucdhnW4JCKKdnePs5Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416159; c=relaxed/simple;
	bh=0miVKQjoU1h9A2yD/zxXcTNCh0p6MTw2oKs/RRJFFyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJ2qITwTjkqH1jgm5F6z2ihrv0zVfsQbdW1npmooj6qroKZ/hitGwqLhruyId23VDrNXRBfXO8FvwsqZuTd7yo5AJSNsz1j2s0aP1bN5QqpXKam3OkVvojYUrcpd7VN98cC1C2O/x8FmbOdVIGpfF/3zM0Tk+Xpy+mYRJRwekgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLGwMQaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLGwMQaB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 832311F000E9;
	Thu, 25 Jun 2026 19:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416158;
	bh=/a39uv6bb3qTAD6DZ3SAEcWRz69VNBoWUrmCyeh99ts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VLGwMQaBdPvpEY7NMDSliREcHlQuZNMG5ZOatFFXAeKYoPWs27kUEcvZRF4XDUHmR
	 5kvXd7JXvkCil2DJVxpK3Y5RA0Vcd4mlOXhGhrTx1rTGn9a9Bn6PalbCOUebVgai1v
	 yQ7Mvfop49TgVZGKvOBAJzE5yVkHAo1ZK9K7oEDIf9B/Yfqdowe+bAciWFRuejfxfK
	 gHDn9QPPpJX8BdkwPnG1B0DmWZQ25j7+LG44vnhSQz0JRG+g7to/nOVP3q45EVD+qa
	 Jf/vlRcelbpwwgJTz0XlsQz0FdQhvYHOywms+X139bfVXAzA0qxTL9PMPApoWw3xj2
	 O2X24BBXa7Lpw==
Date: Thu, 25 Jun 2026 12:35:58 -0700
Subject: [PATCHSET v6 4/4] fuse4fs: reclaim buffer cache under memory pressure
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607392.1811120.7216807779096078422.stgit@frogsfrogsfrogs>
In-Reply-To: <20260625193302.GC6054@frogsfrogsfrogs>
References: <20260625193302.GC6054@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Having a static buffer cache limit of 32MB is very conservative.  When
there's plenty of free memory, evicting metadata from the cache isn't
actually a good idea, so we'd like to let it grow to handle large
working sets.  However, we also don't want to OOM the kernel or (in the
future) the fuse4fs container cgroup, so we need to listen for memory
reclamation events in the kernel.

The solution to this is to open the kernel memory pressure stall
indicator files, configure an event when too much time is spent waiting
for reclamation, and to trim the buffer cache when the events happen.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-memory-reclaim
---
Commits in this patchset:
 * libsupport: add pressure stall monitor
 * fuse2fs: only reclaim buffer cache when there is memory pressure
 * fuse4fs: enable memory pressure monitoring with service containers
 * fuse2fs: flush dirty metadata periodically
---
 lib/support/list.h      |    6 +
 lib/support/psi.h       |   66 ++++++
 fuse4fs/Makefile.in     |    3 
 fuse4fs/fuse4fs.c       |  258 +++++++++++++++++++++-
 lib/support/Makefile.in |    4 
 lib/support/iocache.c   |   19 ++
 lib/support/psi.c       |  557 +++++++++++++++++++++++++++++++++++++++++++++++
 misc/Makefile.in        |    3 
 misc/fuse2fs.c          |  189 +++++++++++++++-
 9 files changed, 1091 insertions(+), 14 deletions(-)
 create mode 100644 lib/support/psi.h
 create mode 100644 lib/support/psi.c

