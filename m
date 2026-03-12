Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAB73AC0FC
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 20:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349196; cv=none; b=h7U41al/k7aa2xhBfBrGShabN2y+1TfRglMOWYOzPKdgb5ZQMuMuLze0w321RDt0JnmtWz2BifT5iHoYLOSazgeelswG7gFILTFnwRdpMco4zSQDmgbIvb99nUj5RciL17xZ32q8EG8gzyLPMF62HaAnWUAT/iMFSsgYJxMVlDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349196; c=relaxed/simple;
	bh=IeA9dNknIOuMT5HXmgSHwzNhcEuFl8WHxTQm17gHN1E=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=NM3Yk7BKEIWqMUaEjXU1h7cgnJpzNiU6LwwpsxTTUgF7ctAW1sdkNt9H9DqfBWcwPl/xPZsAUy0GyvgMd8b+hhXq/fy247Gh36wL5OBO1ZaFaoXCfSR8pZPNpOI6xoWfWOqXvB/4GK+u2Zss052LVGiwmDlB6uSq+MVPIRmvpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4wnt7HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4wnt7HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12543C4CEF7;
	Thu, 12 Mar 2026 20:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349196;
	bh=IeA9dNknIOuMT5HXmgSHwzNhcEuFl8WHxTQm17gHN1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K4wnt7HXlt5FhGR1nNCrvOT+QZLdBKEuoIh3hL7nq4tAyFingFinwW3tTPtf9cVO0
	 O2SODEEgIkDDmerGNhf9KDY+QtKMh3+fSVW5sT7udDqs/hesEgy9n6KkZkPMAoe0Z5
	 2Iiyp9kLjhQsuranikDm7Ra3bkxuEX+jAsdvrZ8OJHqItkV2GcyKN5KRuoW4V+aDPh
	 SX6aZx/Yb1uWpbA7vpOM/3xDJT++XwI45hx039IpJuOc0o6veFK4qFJY6IbEPe4I0R
	 gTRRzAnBHYV0xUa1gC1nyaTR62bcn8j3uEIwdW99J0ea+yzyYrDWsBaCEY9h59Dn32
	 QRoKi79zpwRBg==
Date: Thu, 12 Mar 2026 13:59:55 -0700
Subject: [GIT PULL 2/9] fuse2fs: add some easy new features
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916488.3254574.394222234133985617.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit b22ae270a1016c158a434c6bc601ba623e17a361:

fuse2fs: try to grab block device O_EXCL repeatedly (2026-03-08 19:14:02 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-new-features_2026-03-12

for you to fetch changes up to a4fc4817e3072cb19f481da24d4520671a174fff:

fuse2fs: implement MMP updates (2026-03-08 19:14:04 -0700)

----------------------------------------------------------------
fuse2fs: add some easy new features [02/18]

As of 2025, libfuse is a lot more capable than it was in 2013.
Implement some new features such as readdirplus and directory seeking
for better directory performance, and reduce the amount of filesystem
flushing so that it only happens when userspace explicitly asks for it.
Now we also can add htree indices to large directories, support MMP in
fuse2fs, and link count overflows are handled correctly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (21):
libext2fs: initialize htree when expanding directory
libext2fs: create link count adjustment helpers for dir_nlink
libext2fs: fix ext2fs_mmp_update
libext2fs: refactor aligned MMP buffer allocation
libext2fs: always use ext2fs_mmp_get_mem to allocate fs->mmp_buf
fuse2fs: disable write access when cluster size > block size
fuse2fs: enable more caching
fuse2fs: check root directory while mounting
fuse2fs: read bitmaps asynchronously during initialization
fuse2fs: use file handles when possible
fuse2fs: implement dir seeking
fuse2fs: implement readdirplus
fuse2fs: implement dirsync mode
fuse2fs: only flush O_SYNC files on close
fuse2fs: improve want_extra_isize handling
fuse2fs: cache symlink targets in the kernel
fuse2fs: constrain worker thread count
fuse2fs: improve error handling behaviors
fuse2fs: fix link count overflows on dir_nlink filesystems
libsupport: add background thread manager
fuse2fs: implement MMP updates

lib/ext2fs/ext2fs.h          |   6 +
lib/support/bthread.h        |  27 ++
configure                    |  47 ++++
configure.ac                 |  29 ++
debian/libext2fs2t64.symbols |   6 +
e2fsck/unix.c                |   2 +-
lib/config.h.in              |   3 +
lib/ext2fs/dupfs.c           |   7 +-
lib/ext2fs/link.c            | 290 ++++++++++++++++++++
lib/ext2fs/mkdir.c           |   2 +-
lib/ext2fs/mmp.c             |  24 +-
lib/support/Makefile.in      |   6 +-
lib/support/bthread.c        | 201 ++++++++++++++
misc/dumpe2fs.c              |   2 +-
misc/fuse2fs.1.in            |   9 +
misc/fuse2fs.c               | 635 +++++++++++++++++++++++++++++++++++++------
16 files changed, 1191 insertions(+), 105 deletions(-)
create mode 100644 lib/support/bthread.h
create mode 100644 lib/support/bthread.c

