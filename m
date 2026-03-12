Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735A3B27C4
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349180; cv=none; b=b/QKPAszkSZS4iIp2AeNwKcBbFlscui/HaaiLA8jrtYp/3WkJ0u4vJOZvkaymQ31PSQmLkVfxudfUejt8e5JcYj+nv1MSpe7TsvAmVS2HxgpgvdDNw2HqiWkMsV8x7bnmaOdk98SUphPzfFo/RIud5ffrhS86n8a71AG9eBy3Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349180; c=relaxed/simple;
	bh=lpG9Gp66v9gjkYzKSy4yYXRK+KSURUnY612WorBDsr0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=PjvMRyYGVTzBhV1spzkc841IpogS0mEpcOcX6bPDxPHSNWn5eHyYEqGq2jzJM62/Hy9yriS6K7/WEI+a0ZBmDPo76KBxSzXOGz0OwgWV60due2m7nFhOEbYTFk4c6fmiMO55dJgBdsWmHamEPmzdWkMMBu1s/6qODSlbNFxk51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3IMJXDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3IMJXDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60521C4AF09;
	Thu, 12 Mar 2026 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349180;
	bh=lpG9Gp66v9gjkYzKSy4yYXRK+KSURUnY612WorBDsr0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y3IMJXDGhJwhXkMXiV3Ev9qoxJp7priuqNa9hEj7WWpFCyayC7FKeb5CRPLDUgLcw
	 vBOB3eh0aCep54RtsnP9S0JwF5dm+wCOqkKIqQMP/mLIkFyB0tPgMI/kToXkDH4iwA
	 5NSeAw+tg2qxJfE4FcOCRgaWbd6ILbPONoA4f+wE5krZH8okbZXSNAEZUAsPrisb8C
	 P4UldIV4eHCDDnXXYs/D0+VVJ//FKIxCzCRxCz7HyU3RnS0EiJUcMPnRzKo45IoVQh
	 eBts/35I13fSClZVjmgtkk2+yNjGtzLkPqVH7IFT+JMNrqkHqnZyuylxyauksuSCjX
	 ZqCI2ZW2LQz2A==
Date: Thu, 12 Mar 2026 13:59:39 -0700
Subject: [GIT PULL 1/9] fuse2fs: fix locking problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916459.3254574.17133177610807268883.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 7ee1d505ef3b37831215f490411f346fe57e9053:

Update release notes, etc., for the 1.47.4 release (2026-03-06 12:17:36 -0500)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-locking_2026-03-12

for you to fetch changes up to b22ae270a1016c158a434c6bc601ba623e17a361:

fuse2fs: try to grab block device O_EXCL repeatedly (2026-03-08 19:14:02 -0700)

----------------------------------------------------------------
fuse2fs: fix locking problems [01/18]

Teach fuse2fs to flock the file(s) underlying the filesystem if the fs
is stored in a regular file, so that we don't have to create and
maintain separate lockfiles.

For block devices, fix a weird race between mount and unmount that is
causing testing failures by waiting a small amount of time to grab a
lock.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
libext2fs: add POSIX advisory locking to the unix IO manager
fuse2fs: try to lock filesystem image files before using them
fuse2fs: quiet down write-protect warning
fuse2fs: try to grab block device O_EXCL repeatedly

lib/ext2fs/ext2_io.h         |  12 +++-
debian/libext2fs2t64.symbols |   2 +
lib/ext2fs/io_manager.c      |  16 +++++
lib/ext2fs/unix_io.c         |  71 +++++++++++++++++++++
misc/fuse2fs.c               | 144 +++++++++++++++++++++++++++++++++++++++----
5 files changed, 232 insertions(+), 13 deletions(-)

