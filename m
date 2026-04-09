Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4113D3382F4
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775765704; cv=none; b=Zt2OPsueccU4Nks/JMrHwNeYn2G/VK0f++az5Zuobas3HQ0gedUJoy5Pfn2cos0c9XFnrcvbCmrwYhnCChh6uegYs6wCeVSmjcvfC/oyLlsqH3/ozqFMtTiESOTXvRgNDZjUeFfGaYCBAkfYhoxEDqGuuEaOAyz/enWC7x8ImOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775765704; c=relaxed/simple;
	bh=WJ/IEqRr63Mv8pW9rXFFW7XT9KeyYmRrKfV3P5ouf8s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=X505RKXWM9xpUS0R2irYzSG7pI4LKoA6C69+M0KaczffBzylxx/+Zr9KiF5JYm+oxBhuISrc02lZdcuCdMHotIx0orLTlryoEDoV4Z7n7AsRBzEkv8+h80XidN072OovdPcszOglqOf+NgqzkA4qiKB7XaESs65BsvhSov556J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcCqCNv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcCqCNv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DF2C2BC87;
	Thu,  9 Apr 2026 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775765703;
	bh=WJ/IEqRr63Mv8pW9rXFFW7XT9KeyYmRrKfV3P5ouf8s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZcCqCNv1xdGQFPO6iHpPE8gWwQuo3JtNdvbRoe6uGPqEoD7qGHDw3iY2iBXUWxV68
	 Bg8KuNG0bKCcGrlZ0mM/PFa2+ZnQTlvTCGKTdC0b45fGgHMvI1j4F+CHEBuBbOv7Jd
	 zBq45lWG0/jzgMzs3u8+A/TBxZZXpudfs/Ns4d+VUK7bm/Z4cDa3/0t1ea60HcWH88
	 boRj2ucO8YO4Mu3J7rQxXYxQnX/jUeOAoyByArbj0nmhYMJALLysSm75cPw/9f2lcQ
	 yZA0OPLsdI6kYavm3PLrMB9i63Rq03p9MYTtiP4r12oDbm6/QQgGwX34CFEwpDD0/S
	 QYojO+TJ6O36w==
Date: Thu, 09 Apr 2026 13:15:03 -0700
Subject: [GIT PULL 2/2] fuse4fs: fork a low level fuse server
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: amir73il@gmail.com, djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177576561103.1959707.10200829629012630842.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260409201302.GD6192@frogsfrogsfrogs>
References: <20260409201302.GD6192@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Ted,

Please pull this branch with changes for ext4.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit c137760397ef6671832548bcd256778f57f49c2d:

fuse2fs: drop fuse 2.x support code (2026-04-09 13:00:40 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse4fs-fork_2026-04-09

for you to fetch changes up to 951a10258cada0508e185c58ebec74c47b0eb774:

fuse4fs: create incore reverse orphan list (2026-04-09 13:00:42 -0700)

----------------------------------------------------------------
fuse4fs: fork a low level fuse server [02/11]

Whilst developing the fuse2fs+iomap prototype, I discovered a
fundamental design limitation of the upper-level libfuse API: hardlinks.
The upper level fuse library really wants to communicate with the fuse
server with file paths, instead of using inode numbers.  This works
great for filesystems that don't have inodes, create files dynamically
at runtime, or lack stable inode numbers.

Unfortunately, the libfuse path abstraction assigns a unique nodeid to
every child file in the entire filesystem, without regard to hard links.
In other words, a hardlinked regular file may have one ondisk inode
number but multiple kernel inodes.  For classic fuse2fs this isn't a
problem because all file access goes through the fuse server and the big
library lock protects us from corruption.

For fuse2fs + iomap this is a disaster because we rely on the kernel to
coordinate access to inodes.  For hardlinked files, we *require* that
there only be one in-kernel inode for each ondisk inode.

The path based mechanism is also very inefficient for fuse2fs.  Every
time a file is accessed, the upper level libfuse passes a new nodeid to
the kernel, and on every file access the kernel passes that same nodeid
back to libfuse.  libfuse then walks its internal directory entry cache
to construct a path string for that nodeid and hands it to fuse2fs.
fuse2fs then walks the ondisk directory structure to find the ext2 inode
number.  Every time.

Create a new fuse4fs server from fuse2fs that uses the lowlevel fuse
API.  This affords us direct control over nodeids and eliminates the
path wrangling.  Hardlinks can be supported when iomap is turned on,
and metadata-heavy workloads run twice as fast.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (23):
fuse2fs: separate libfuse3 and fuse2fs detection in configure
fuse2fs: start porting fuse2fs to lowlevel libfuse API
debian: create new package for fuse4fs
fuse4fs: namespace some helpers
fuse4fs: convert to low level API
libsupport: port the kernel list.h to libsupport
libsupport: add a cache
cache: disable debugging
cache: use modern list iterator macros
cache: embed struct cache in the owner
cache: pass cache pointer to callbacks
cache: pass a private data pointer through cache_walk
cache: add a helper to grab a new refcount for a cache_node
cache: return results of a cache flush
cache: add a "get only if incore" flag to cache_node_get
cache: support gradual expansion
cache: support updating maxcount and flags
cache: support channging flags
cache: implement automatic shrinking
fuse4fs: add cache to track open files
fuse4fs: use the orphaned inode list
fuse4fs: implement FUSE_TMPFILE
fuse4fs: create incore reverse orphan list

lib/ext2fs/jfs_compat.h  |    2 +-
lib/ext2fs/kernel-list.h |  111 -
lib/support/cache.h      |  184 ++
lib/support/list.h       |  901 +++++++
lib/support/xbitops.h    |  128 +
Makefile.in              |    3 +-
configure                |  441 ++--
configure.ac             |  156 +-
debian/control           |   12 +-
debian/fuse4fs.install   |    2 +
debian/fuse4fs.links     |    3 +
debian/rules             |   11 +
debugfs/Makefile.in      |   12 +-
e2fsck/Makefile.in       |   56 +-
fuse4fs/Makefile.in      |  193 ++
fuse4fs/fuse4fs.1.in     |  118 +
fuse4fs/fuse4fs.c        | 6451 ++++++++++++++++++++++++++++++++++++++++++++++
lib/config.h.in          |    3 +
lib/e2p/Makefile.in      |    4 +-
lib/ext2fs/Makefile.in   |   14 +-
lib/support/Makefile.in  |    8 +-
lib/support/cache.c      |  882 +++++++
misc/Makefile.in         |   18 +-
misc/tune2fs.c           |    4 -
24 files changed, 9248 insertions(+), 469 deletions(-)
delete mode 100644 lib/ext2fs/kernel-list.h
create mode 100644 lib/support/cache.h
create mode 100644 lib/support/list.h
create mode 100644 lib/support/xbitops.h
create mode 100644 debian/fuse4fs.install
create mode 100644 debian/fuse4fs.links
create mode 100644 fuse4fs/Makefile.in
create mode 100644 fuse4fs/fuse4fs.1.in
create mode 100644 fuse4fs/fuse4fs.c
create mode 100644 lib/support/cache.c

