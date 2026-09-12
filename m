Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D2C35F184
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2026 06:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195336; cv=none; b=XDy/ROdOjqIkDQh1wmUvCP7PoLwZbfc2wEzqUuaicIj8d5/gglpnVzBpzSxZEXolzvHOHffj+yRVdcBaSYUUzOK2q981OhcshdB9AAWKhXBbJrwUvmOGyOevmCOQeLB0aPc/fJZCS+74o1kbKtTRzWv+7fLNbA4k3ssXb8sochM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195336; c=relaxed/simple;
	bh=7rs8f4dRNVu/BpxnmPeNgzgKtlZSvSxuI+EzLQz4KCM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=U1wOxbAok09tKiQud1k4Oep6Qk9Ijt6QG0dwMpeIQLOdK/5Ce0jpiFm5SKvVVuswS/cLDuYR13jXmsr2xAu0Z5998K0W22BOz7+FfYG0hqY/dlsyMtY2tAd8OC85bai+16Vfgi9bkg1YwWCZmhLwBaFAL6NjvBlqmis0SASACc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dg0evtt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dg0evtt2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 690D01F000FF;
	Sat, 12 Sep 2026 06:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195335;
	bh=0E2zdM+YMdmr9LW1ZnRd4xzmGHFtS8/oasbt7ibLkd4=;
	h=Date:Subject:From:To:Cc;
	b=Dg0evtt2p4772YUMdT49QFRwvvW+l1MXEFvuDaxYB0PrkjTX8XmaEygNTTfkRAZtc
	 /Ku+c0xkpQTeBkNn02mfhjsSjj1AHhHyRt8GwNGn0YjH0zMdFrXdS/3hXs+8CcFw4+
	 NSBbPV1U8blIIpy4OuyPJdzrpRmwXcdgeaUN8bJ+SlG+pCM3ebbtjeuxrqI5D8sa8O
	 Gh2DHmCzHvo1wUuJUZ4FiwaIudhy5W10mxiMEK5zRxP08zpGEju/TCF7NKyUieWaqj
	 czm5NGfGe2uvc5DcVyjKItC0ml3blebxEqPJIByIv1sC4RlM4Hnzz8GrGBMJUk3myn
	 epPTEFVMG04+A==
Date: Fri, 11 Sep 2026 23:42:15 -0700
Subject: [GIT PULL 3/4] fuse2fs: improve block and inode caching
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178919524496.1033422.16170817413025710050.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 8bf9ced74cb6f7cfc26dfbe0f8fff5ed13f51c90:

debian: update packaging for fuse4fs service (2026-09-11 23:35:02 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-caching_2026-09-11

for you to fetch changes up to 348aa5ebbb5d52aecba07f6069be986be9bfc4fe:

libext2fs: improve caching for inodes (2026-09-11 23:35:03 -0700)

----------------------------------------------------------------
fuse2fs: improve block and inode caching [v6 3/4]

This series ports the libext2fs inode cache to the new cache.c hashtable
code that was added for fuse4fs unlinked file support and improves on
the UNIX I/O manager's block cache by adding a new I/O manager that does
its own caching.  Now we no longer have statically sized buffer caching
for the two fuse servers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
libsupport: add caching IO manager
iocache: add the actual buffer cache
iocache: bump buffer mru priority every 50 accesses
fuse2fs: enable caching IO manager
fuse2fs: increase inode cache size
libext2fs: improve caching for inodes

lib/ext2fs/ext2fsP.h     |  13 +-
lib/support/cache.h      |   1 +
lib/support/iocache.h    |  17 ++
debugfs/Makefile.in      |   8 +-
e2fsck/Makefile.in       |  12 +-
fuse4fs/Makefile.in      |  10 +-
fuse4fs/fuse4fs.c        |  15 +-
lib/ext2fs/Makefile.in   |  69 ++---
lib/ext2fs/inline_data.c |   4 -
lib/ext2fs/inode.c       | 215 +++++++++++---
lib/ext2fs/io_manager.c  |   3 +
lib/support/Makefile.in  |   6 +-
lib/support/cache.c      |  16 +
lib/support/iocache.c    | 751 +++++++++++++++++++++++++++++++++++++++++++++++
misc/Makefile.in         |  11 +-
misc/fuse2fs.c           |  11 +-
resize/Makefile.in       |  11 +-
tests/fuzz/Makefile.in   |   4 +-
tests/progs/Makefile.in  |   4 +-
19 files changed, 1057 insertions(+), 124 deletions(-)
create mode 100644 lib/support/iocache.h
create mode 100644 lib/support/iocache.c

