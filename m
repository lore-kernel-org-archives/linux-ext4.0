Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D161726ED25
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349227; cv=none; b=Vc4Ls/JkmBLanEVn1MQKX23X8ExBEelFENkL9bPn8vxxu/4jXDGRoWIZp3iKqEuXKz4vz3bCOqkCy3xviZgqyialWLsQHyN2jpusMmf9vK5zRaEy/YCParQKVL2ahYioJF+M5nizqg0GpNxGVayaEimCd5KztGleLejveFZmrzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349227; c=relaxed/simple;
	bh=3U/Hu1+jh2yMYzLLlUw623lt3B2OjQwnjV1x3Y1+arA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=aCZtHPtttwdNjP7pAnRhXlCUT1hV62EA7PK3cOQRFzv0nfgDOoXrjiVNMGrXomoFWemiQCLK7soqiRFjSUWzDjpvvP44+76phUGk1sM5mqvW1Ko9R6iz/SCVPMAO8cVF42kh6Fa7uJqDk8szvu2Ft6+iDXRulzLsHe88/GAIIhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPVwlCKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPVwlCKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D48C19425;
	Thu, 12 Mar 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349227;
	bh=3U/Hu1+jh2yMYzLLlUw623lt3B2OjQwnjV1x3Y1+arA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CPVwlCKXbdpp4+AAwZjOU7+Yo+PX4bK6mhTmMsCB7PIpl+RGL8dm/7bDSmFC+X05v
	 Pf9dmN+k9Se8ea9aZ6+wxj7EiTKC36+jqoKCTWsJVU3SHvD1AonRNmsc3sj/0FJwG0
	 vImveGtgc2u+lQ+7G5zbkmve2kUf2I8ohYVbKgPEfLox+qsis3KcBznNBMh0vI2m3H
	 HQq2IeR4pCz4hsNacDgxSTNFUmlwOoYvZtaveL2mBSyHLvxOUb4qlNOLmkb1l/DkVX
	 0UOGWebB6+1Yh4DLVydQe65+Ohxe1zOKjSwcgcXJCiP0MVzNVBV0R2h5CrsvsJCcWy
	 O8KJ4FzSsIOjg==
Date: Thu, 12 Mar 2026 14:00:26 -0700
Subject: [GIT PULL 4/9] fuse2fs: refactor unmount code
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916548.3254574.4332031441968487356.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit f5c46155c79cccd46e047d732063c7f21db35c8e:

fuse2fs: collect runtime of various operations (2026-03-08 19:14:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-refactor-unmounting_2026-03-12

for you to fetch changes up to 5d3394ff8d6f2e120be1343c1504831d9602a3b4:

fuse2fs: hoist unmount code from main (2026-03-08 19:14:05 -0700)

----------------------------------------------------------------
fuse2fs: refactor unmount code [04/18]

In this series, we refactor the code around ext2fs_close to get ready
for iomap mode.  The significant part of this series is moving the
unmount code to op_destroy, because we want to release the block device
as a part of the umount(2) process to maintain expected behavior of the
in-kernel local filesystem drivers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
fuse2fs: get rid of the global_fs variable
fuse2fs: hoist lockfile code
fuse2fs: hoist unmount code from main

misc/fuse2fs.c | 199 +++++++++++++++++++++++++++++++--------------------------
1 file changed, 108 insertions(+), 91 deletions(-)

