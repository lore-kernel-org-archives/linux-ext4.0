Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF643DD533
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937608; cv=none; b=iPdnJNsbQfesgvs4dDWdRLMnMFRd50cpx6pjLE/RCcq9Kfo7OPIeq5Hpmme0fw2v8QXrURoMVVowaRrCua92yxGU05XayZL8hUVQt2kUDJIGbW6taxdPVAKrdZizCgmrbj7150HQ92HhkpsKjx3G6jEFDpQ75ut0giHgGTlzvRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937608; c=relaxed/simple;
	bh=tCuLqV1gvmgd9ngvXvMrQah+jH8tXs/ln9fgj1pKRCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ApA0UOlUqJ3jw33o5US7TYZe+lh7sOy05HiIKZAVPIvvRxYcIwC/Vs+5qLpqJ3EfiQ7FMjfrkZd2GJxak9Us3FuVURalufd4qEVTQLKdwQkjMFXF6PDMId+zhLprKUcwJDJ/x97Q8n9L8WRZ8EmYEuYO7hMtJMoT/PE+utn7y9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RFVaswxB; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RFVaswxB"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX8sQ019533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937589; bh=1n1F3d1njX5kMMgZTKhifgnYGnfrbR/utFp4lHLsYog=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=RFVaswxBy/kqsMrJCFDjQpHHVXC/Y9WlpdDvAM6/SIdmPdeoolu3ttZjIxw+NnAi9
	 dkclBSY5ZaJsO0QwH5hlDHMA4/+34D79ffnLfrFDTkTY/w6uCb4m8WhpRJMMem947n
	 5gla4gCph7xdpNuAX/Vx2Riq6ql1mVixnLs0oIi6H+25p0kd55kuQAuzzVyyvQcAx0
	 6MoZoWVZbyn74VUvMEr744rcV1qKpYuF6CR+tmlXfmQ3Xf/Dr8UPottIX7kjcklVcf
	 blkl8vNx5+EMr8Qb1YUfnGlR8/EIuinDpwloYA+RjrbrzgYwc2y6iP8L2mk/xdCnMi
	 cLnsH7Gv61Qfg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id EBB662E00CE; Mon, 04 May 2026 19:33:07 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Date: Mon,  4 May 2026 19:32:54 -0400
Message-ID: <20260504233301.2345652-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are the patches that I've applied to the next branch to clean up
found when trying to compile e2fsprogs on MacOS and via the github's
continuous integration testing.

Note: See .github/workflows/ci.yaml; it's a good reason to get a
github account if you are doing a lot of e2fsprogs development.
If you fork my e2fsprogs repository and push your changes to your github
repo, you can get reports like the ones found here:
      https://github.com/tytso/e2fsprogs/actions


Anyway, with these patches, e2fsprogs builds on MacOS (both using the
github CI and on locally on my Macbook).  Unfortunately fuse2fs has
regressed in that non-root accesses are getting denied with a permission
denied on MacOS, and this worked with e2fsprogs v1.47.4.  Here's a
lightly edited transcript from my Macbook Air:

% uname -a
Darwin macsyma.local 25.4.0 Darwin Kernel Version 25.4.0: Thu Mar 19 19:33:09 PDT 2026; root:xnu-12377.101.15~1/RELEASE_ARM64_T8112 arm64 arm Darwin
% ./mke2fs -Fq -t ext4 -d . /tmp/foo.img  1G
% ./fuse2fs -o allow_other /tmp/foo.img /Users/tytso/mnt
FUSE2FS (foo.img): Warning: fuse2fs does not support using the journal.
There may be file system corruption or data loss if
the file system is not gracefully unmounted.
% stat /Users/tytso/mnt/revoke.o
stat: cannot stat '/Users/tytso/mnt/revoke.o': Permission denied
% sudo stat /Users/tytso/mnt/revoke.o
  File: /Users/tytso/mnt/revoke.o
  Size: 29728     	Blocks: 64         IO Block: 16384  regular file
Device: 55,270	Inode: 91          Links: 1
Access: (0644/-rw-r--r--)  Uid: (15806/   tytso)   Gid: (   20/   staff)
Access: 2026-05-05 00:21:50.000000000 +0200
Modify: 2026-05-05 00:21:50.000000000 +0200
Change: 2026-05-05 00:21:50.000000000 +0200
 Birth: -
% stat revoke.o
  File: revoke.o
  Size: 29728     	Blocks: 64         IO Block: 4096   regular file
Device: 1,18	Inode: 851374      Links: 1
Access: (0644/-rw-r--r--)  Uid: (15806/   tytso)   Gid: (   20/   staff)
Access: 2026-05-05 00:21:50.903084819 +0200
Modify: 2026-05-05 00:21:50.346338295 +0200
Change: 2026-05-05 00:21:50.346580544 +0200
 Birth: 2026-05-05 00:21:50.293229053 +0200
% sum revoke.o
45116    30 revoke.o
% sum /Users/tytso/mnt/revoke.o
sum: /Users/tytso/mnt/revoke.o: Permission denied

So fuse2fs is broken on MacOS, but it's not *totally* broken, since you
can still use it as root.  I'll want to fix this before updating the
master branch, but this is good enough for the next branch.



Theodore Ts'o (7):
  libsupport: drop xbitops.h and define fls() if necessary
  configure.ac: fix disable fuse2fs/fuse4fs by default path
  libsupport: don't use bzero in cache.c
  fuse[24]fs: suppress clang warnings which were breaking the github CI
  libsupport: remove the LIST_HEAD macro from list.h
  libsupport: fix gcc -Wall warnings
  fuse2fs: fix uninitialized variable warnings

 configure               |   8 +++
 configure.ac            |   3 +
 fuse4fs/Makefile.in     |  18 +++---
 fuse4fs/fuse4fs.c       |  29 +++++++--
 lib/config.h.in         |   3 +
 lib/support/Makefile.in |   2 +-
 lib/support/cache.c     |  49 ++++++++++++---
 lib/support/cache.h     |   2 +-
 lib/support/list.h      |  17 ++++--
 lib/support/xbitops.h   | 128 ----------------------------------------
 misc/fuse2fs.c          |  21 +++++++
 11 files changed, 125 insertions(+), 155 deletions(-)
 delete mode 100644 lib/support/xbitops.h

-- 
2.53.0

