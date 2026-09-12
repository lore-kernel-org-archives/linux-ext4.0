Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A6E35F184
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2026 06:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195321; cv=none; b=NQ5U7bV0tz9yslmXnyakUvvlEp1XQ2BceRcFCmIPR4ppQU36vXIokYNUiL2DrhCja8/n9EJqDchd7Jw2Tzz2RdyfijurT3IPn6gAHOjJgFxT5M94Ml0RuCoD0AjAlkdGW0HMPsJcOFKWqQXeZTxoPUonyEKHeuraP2zTRr/TbJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195321; c=relaxed/simple;
	bh=Y+D+gL95jh7bRWEUQYgZmO0fg9c8dpx0FlC5aQHVt70=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=l2vnHbDqdOxcbCa5C90e75Olvc3GfYFEz/CmdzQhON3bDleo0HR+FiuzGyaVMn2iuor71/uizOhAw9CsqvyGxpMujy5j2Iu3bWS1GRYSqViqfvRuNg0KIBIV4XgFFa2UoTmGEpl72s4nvEOo9e+7DQmfzYJqkJ/coGILBU9RaOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcnS7FZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcnS7FZ9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE1C51F000FF;
	Sat, 12 Sep 2026 06:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195319;
	bh=9EpZDaQ2wydbm2c5qsziQ+PoCLDc3UfmP72/7l8U4YE=;
	h=Date:Subject:From:To:Cc;
	b=CcnS7FZ9GowTGPZUd18iiCuIEiLkvT6xXrmYTbctbgAVaP+5dr0qYcdb61IiUBhka
	 UmcAhl5Y8+49+pf1/ufFG39C2mGlIgP9lcGkw8rjjrqlOr+TRa6B9HeD3FsJGIFPa4
	 RF1gOTugfuEHGYQEjysWBIFj4nYwjt4weSti6hEQolwpU++gAfgcoLVPxu7BQOHMwl
	 ZJPfQCm+ytVpDFJkSk7vK4SvqwITFvCrY4c1FkHkpmT7AeNeeM0A6uIGqd+mUNnZ1a
	 yUmsMVb0h7CGtzLVFbScQuvb6eBCxPB3h0x+YtfRYJvP4sQ3iRaR6kgb4vzXt97qQ9
	 aefBKz+VIeZ9Q==
Date: Fri, 11 Sep 2026 23:41:59 -0700
Subject: [GIT PULL 2/4] fuse4fs: run servers as a contained service
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178919524467.1033422.11195342952336631864.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 9199d64a91ea1cc8779cdc0289a79d50e6fe0ee2:

libext2fs: fix count recomputation in ext2fs_punch_ind (2026-09-11 23:34:15 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse4fs-service-container_2026-09-11

for you to fetch changes up to 8bf9ced74cb6f7cfc26dfbe0f8fff5ed13f51c90:

debian: update packaging for fuse4fs service (2026-09-11 23:35:02 -0700)

----------------------------------------------------------------
fuse4fs: run servers as a contained service [v6 2/4]

This series packages the newly created fuse4fs server into a systemd
socket service.  This service can be used by the "mount.service" helper
in libfuse to implement untrusted unprivileged mounts.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
libext2fs: make it possible to extract the fd from an IO manager
libext2fs: fix checking for valid fds in mmp.c
unix_io: allow passing /dev/fd/XXX paths to the unixfd IO manager
libext2fs: fix MMP code to work with unixfd IO manager
libext2fs: bump libfuse API version to 3.19
fuse4fs: hoist some code out of fuse4fs_main
fuse4fs: enable safe service mode
fuse4fs: set proc title when in fuse service mode
fuse4fs: make MMP work correctly in safe service mode
debian: update packaging for fuse4fs service

lib/ext2fs/ext2_io.h         |   4 +-
lib/ext2fs/ext2fs.h          |   1 +
lib/ext2fs/ext2fsP.h         |   4 +
MCONFIG.in                   |   2 +
configure                    | 303 ++++++++++++++++++++++++++-
configure.ac                 | 131 +++++++++++-
debian/e2fsprogs.install     |   7 +-
debian/fuse4fs.install       |   3 +
debian/libext2fs2t64.symbols |   1 +
debian/rules                 |   3 +
fuse4fs/Makefile.in          |  42 +++-
fuse4fs/fuse4fs.c            | 479 ++++++++++++++++++++++++++++++++++++-------
fuse4fs/fuse4fs.socket.in    |  17 ++
fuse4fs/fuse4fs@.service.in  | 102 +++++++++
lib/config.h.in              |  12 ++
lib/ext2fs/io_manager.c      |   8 +
lib/ext2fs/mmp.c             | 101 ++++++++-
lib/ext2fs/openfs.c          |   1 +
lib/ext2fs/unix_io.c         |  50 ++++-
util/subst.conf.in           |   3 +
20 files changed, 1177 insertions(+), 97 deletions(-)
mode change 100644 => 100755 debian/fuse4fs.install
create mode 100644 fuse4fs/fuse4fs.socket.in
create mode 100644 fuse4fs/fuse4fs@.service.in

