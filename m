Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBA730569B
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416144; cv=none; b=QHke81NabsV0HFC+rfcnp1z1vL7rD1M6Xl8D8Keyb42bIz2dUM5cSup9reDdD6l2bPXWWCDJOdUWI/ZuLBY5Db/s1noQwIHmPmwVFx91VXij/ypWr/GoS2LyolPy0cTioUEayFJ/29+0SM5cK69IMWufwoA7wRa0qKEQnkhFQL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416144; c=relaxed/simple;
	bh=AqA9NP/RD8flEoMs0fLOMqdo7LDPpycZftIA0TcWwhk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPHAMlo8I14dBGY2uRdPK7jVZL5BoMFDoQh0H9Jp6KcT+KPzA1OxaNnhb5JJrshxkseY46n29ZCHsUHqwLwYmmcyOLFRCNFii5oFELNqv7+8HxOGPEamlj4cQ1charKXI7/skpT3r5EXDzM6HHjIjgZxrfa/k8JGrJL1GNjz5co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO29lw9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO29lw9u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 083F81F000E9;
	Thu, 25 Jun 2026 19:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416143;
	bh=9i3x5TzZZ+8lkQc0cZX2wXWTZs755icYFmDg4fmrvfA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MO29lw9uSWMw+13gku2BV+B+1G4c8+mCIcvx3wgcQ/Ma5tHNs+v05Ghxbo/MXDvxm
	 QVPKk2cckCq8VWKPlM79wKw18j/bKkA6cFeoBj5hAAoVRSofQ5SoSmzi5/tdUx31zP
	 sRHpOpIHHztiA69VZOEvExG9TKeVFVb7/gperpPi+qLGgzcRPyW5wquCuU1Ia8YTJb
	 z9R21D/ErR+sYR9A/jQVz6BJyponcYbK4pgObZNZXa/f1fWhxwA7rhqghU4FkCvqHh
	 EEPCRZ7SJuFruKjieX4gSEO7gDKjFvcc0wz+BN63yyrYeZTRqQTrxGKbcZcQalj9kL
	 MkAk8cJhdvXQw==
Date: Thu, 25 Jun 2026 12:35:42 -0700
Subject: [PATCHSET v6 3/4] fuse2fs: improve block and inode caching
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
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

This series ports the libext2fs inode cache to the new cache.c hashtable
code that was added for fuse4fs unlinked file support and improves on
the UNIX I/O manager's block cache by adding a new I/O manager that does
its own caching.  Now we no longer have statically sized buffer caching
for the two fuse servers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse2fs-caching
---
Commits in this patchset:
 * libsupport: add caching IO manager
 * iocache: add the actual buffer cache
 * iocache: bump buffer mru priority every 50 accesses
 * fuse2fs: enable caching IO manager
 * fuse2fs: increase inode cache size
 * libext2fs: improve caching for inodes
---
 lib/ext2fs/ext2fsP.h     |   13 +
 lib/support/cache.h      |    1 
 lib/support/iocache.h    |   17 +
 debugfs/Makefile.in      |    8 
 e2fsck/Makefile.in       |   12 -
 fuse4fs/Makefile.in      |   10 -
 fuse4fs/fuse4fs.c        |   15 +
 lib/ext2fs/Makefile.in   |   69 ++--
 lib/ext2fs/inline_data.c |    4 
 lib/ext2fs/inode.c       |  215 ++++++++++---
 lib/ext2fs/io_manager.c  |    3 
 lib/support/Makefile.in  |    6 
 lib/support/cache.c      |   16 +
 lib/support/iocache.c    |  751 ++++++++++++++++++++++++++++++++++++++++++++++
 misc/Makefile.in         |   11 -
 misc/fuse2fs.c           |   11 +
 resize/Makefile.in       |   11 -
 tests/fuzz/Makefile.in   |    4 
 tests/progs/Makefile.in  |    4 
 19 files changed, 1057 insertions(+), 124 deletions(-)
 create mode 100644 lib/support/iocache.h
 create mode 100644 lib/support/iocache.c

