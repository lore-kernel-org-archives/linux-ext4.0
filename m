Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11EB30E0EE
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2026 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195305; cv=none; b=TIi85mFd1jrFgRI8W4pC9/miSzsSUA1g3IhcC+8vY7jvHNawnvYO+bnyUjRUFeeGuuLD92bHm5lS/kR91kcoLHei4VqywqksL737CiJQ4+Hmvnf0T3ra8HCRiB+X9G6QqVrZp0MtSEbslAG5d/nuhs1l6VUIh9BNFd7KlisyvFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195305; c=relaxed/simple;
	bh=p+jCy/UfuGua2uQiZ0SaDpyypMj+coB8DmNnulZNZm4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=C78ljSIAzdtU3N4NlO+QrxSRzQpaZ7wQRV/UMp/ap0tWHj7vkgESV2Al0hA3uKTEGJrxH/TS0eU3Iq4itMj5sjimjkXgzJG2855a46/3yZPHe+JmHvhRKt95kIriNxAFG1BPnII0JKvVlO1824hQw5KADuUeQ+G2gKiUoDdv6Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfM1PXA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfM1PXA8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2592A1F000FF;
	Sat, 12 Sep 2026 06:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195304;
	bh=d2Js42SDuaCBCDWuNywfmOLCCEVMe0/EFyiANOznpP4=;
	h=Date:Subject:From:To:Cc;
	b=lfM1PXA8i+kTkOzzMXfSSvbOxIqT/kUb639hMoH9on7gCm8/VbmW2BQ3eXqA1xoGZ
	 qv/06Oj8OgzYJNaPO0MB+MR0KAXgYJ6Rq1rLr/FoC86L2n0W0jlnCQyF//6/dHLIye
	 2lWxLiUcvS8bJ2o0xROpqsX5U/Cci6GkzVtG6wyYmbvrr8uZUacq6Or3yf7ZY2nK6x
	 FB2TOtlFAGvrkKTRIXZRZNU7j6dDQLqrJ6plV2LiwVDvvDybeeDe2IZs4FrAu9+7D3
	 5ISnLNSg4y2rYnOrgze6FGiihgDJTis6Jmu0m99/jGvOtOpe3NIcq87T4MxB+XhTIL
	 REC28v/rK+GbQ==
Date: Fri, 11 Sep 2026 23:41:43 -0700
Subject: [GIT PULL 1/4] libext2fs: fix some missed fsync calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178919524436.1033422.10456355774295658458.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 8fd79523d051d5ea881237f27eb1c664486e0078:

Merge branch 'maint' into next (2026-09-07 00:42:27 -0400)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/libext2fs-flushing-fixes_2026-09-11

for you to fetch changes up to 9199d64a91ea1cc8779cdc0289a79d50e6fe0ee2:

libext2fs: fix count recomputation in ext2fs_punch_ind (2026-09-11 23:34:15 -0700)

----------------------------------------------------------------
libext2fs: fix some missed fsync calls [1/4]

Fix a few places (like device closing) where we really ought to tell the
block device to flush whatever's dirty to disk, even if we've failed to
flush all our cached buffers out to disk.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
libext2fs: always fsync the device when flushing the cache
libext2fs: always fsync the device when closing the unix IO manager
libext2fs: only fsync the unix fd if we wrote to the device
libext2fs: fix count recomputation in ext2fs_punch_ind

lib/ext2fs/punch.c   |  2 +-
lib/ext2fs/unix_io.c | 83 +++++++++++++++++++++++++++++++++++++++++++---------
2 files changed, 70 insertions(+), 15 deletions(-)

