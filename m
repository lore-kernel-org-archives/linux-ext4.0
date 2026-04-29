Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC972765D7;
	Wed, 29 Apr 2026 14:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472419; cv=none; b=mI9JEdpq5bI3R7fVAQrt7GvixC0woKqvdrdrz43ab2lodt/bg73kpEN+/9wvm8mlNvgFt+xoGtEMbgI6DS8/OpTFdmZX5TMLs8Ltb5ioMN7KkAwt7S8ATxz2EzmEt5AAGQGq0TJaY6r0VQRd4OAQ7Zv+vqbE8m67zH1+SHY2Dwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472419; c=relaxed/simple;
	bh=b/O9O3XMV/qSeGbrmi+yNvZdXxn6s3RgbEGRrCR9E9U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6hhRc5tVNNS1i+Yj+LZl5HQZxyBcGerI0EjlczAfdT5wAclsXyin9lR0RcrJ07KJuT5O3NNSToWGN1QC5TjsuU7rY0DbUYNgC8QOVz/UE2BfTDmHVKViY1yPHiwJJkt0zUl6nCNxgVLiBVyiwhUC1l/sj4OSqpkooUROUF+qSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7PwkUO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7PwkUO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B6CC19425;
	Wed, 29 Apr 2026 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472419;
	bh=b/O9O3XMV/qSeGbrmi+yNvZdXxn6s3RgbEGRrCR9E9U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a7PwkUO6p6crrruJ2cRftQNcueiz0o0NujNGMB7UHvy5HcoYO7xLKJzP0hK7Fjtbt
	 iy/6YtV9B06AsLADTpR27/cQxzBx+hMw+BsxRg43pufxd0tGuzRo0a3KBBFzqWxHk0
	 wrpfp9OKCu6thiPT5MUYasP/3eCNwzwx5bDfcG2tT/L7AoUA8tMQyATzd0qemO1Ckd
	 qbMdZbmRCS0EpzpzLGI9CvuXv97ZYZuN71VdSdXQOfRz5IRoge/RpfSlQujDKXwISL
	 yfSUTnkRrLbwof3ycMasT+jGO8qdX6t3MXjztHBfZuxJTPA+0fDQnbleCka40lbR38
	 Zt9EBhEv/MV+A==
Date: Wed, 29 Apr 2026 07:20:18 -0700
Subject: [PATCHSET v8 1/6] libext2fs: refactoring for fuse2fs iomap support
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214224.4107228.16300103064218258692.stgit@frogsfrogsfrogs>
In-Reply-To: <20260429141253.GQ7739@frogsfrogsfrogs>
References: <20260429141253.GQ7739@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

In preparation for connecting fuse, iomap, and fuse2fs for a much more
performant file IO path, make some changes to the Unix IO manager in
libext2fs so that we can have better IO.  First we start by making
filesystem flushes a lot more efficient by eliding fsyncs when they're
not necessary, and allowing library clients to turn off the racy code
that writes the superblock byte by byte but exposes stale checksums.

XXX: The second part of this series adds IO tagging so that we could tag
IOs by inode number to distinguish file data blocks in cache from
everything else.  This is temporary scaffolding whilst we're in the
middle adding directio and later buffered writes.  Once we can use the
pagecache for all file IO activity I think we could drop the back half
of this series.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=libext2fs-iomap-prep
---
Commits in this patchset:
 * libext2fs: invalidate cached blocks when freeing them
 * libext2fs: only flush affected blocks in unix_write_byte
 * libext2fs: allow unix_write_byte when the write would be aligned
 * libext2fs: allow clients to ask to write full superblocks
 * libext2fs: allow callers to disallow I/O to file data blocks
---
 lib/ext2fs/ext2_io.h         |    8 ++++++-
 lib/ext2fs/ext2fs.h          |    4 +++
 debian/libext2fs2t64.symbols |    1 +
 lib/ext2fs/alloc_stats.c     |    6 +++++
 lib/ext2fs/closefs.c         |    7 ++++++
 lib/ext2fs/fileio.c          |   12 +++++++++-
 lib/ext2fs/io_manager.c      |    9 +++++++
 lib/ext2fs/unix_io.c         |   51 ++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 93 insertions(+), 5 deletions(-)

