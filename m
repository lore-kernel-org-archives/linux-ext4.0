Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFCC1DDC28
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349290; cv=none; b=ZTfpKy6Hr3YIqQpfpW6o7A0rAjj+4Abh/aHO0U0KOjynKxvVJcWfYNZ4JojNMtJ05+OFc8pbMX9FCRwpVhzk8BWC625zPKrTWl49x57k+DsD/pcbYxcQGgZLqkB76JzfaVVQb/k/0t1B+Td+tI+iHuEOYFitj+OK+3LuvPNOwHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349290; c=relaxed/simple;
	bh=FZWhucvEGVIL+eOY+ZaTjF8eDRPH7/as64bb5uF5Q0I=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=U80Kbj2oh51CoqEo4L7z3ZmZMZDhR23VcUq8pNNPDZiW1aRM2NhI/x7mLuPSINbH4WqYCBehspbjW+fRxbjBJMU8xVR+bbC+lT7Lyxg/9dZiFxnUwYHmWmWyoMJyS5EpR+yX6gKtYRdDX11nmOdOCQgxKxOcwm/p6ky3oCOS7z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1bYUalF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1bYUalF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284B7C4CEF7;
	Thu, 12 Mar 2026 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349290;
	bh=FZWhucvEGVIL+eOY+ZaTjF8eDRPH7/as64bb5uF5Q0I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r1bYUalF2g13ATmQlnXlFNf9VzkbZdN5RzcGiWKVAM1n87GcjrGymqDg6A5PTcriU
	 UBrP9mGLQZLe7HZTifhVZyVcMMG+/3DKauJi7bLEX3R+dzywu+m6cShNdemSv1oug4
	 1vaYfR3nM+YxZy/9fpNj5sdVckdjyM5Ct5XyjcLwIIExW04AsoCmmjWRG0mbZvYrd7
	 g9kmam605m547UuF6Fv8jNu0KMjU3Ub0i82L0RUVlYVLhKlCb2eUisK/qTxHoO15GL
	 BAqt6BNi1parVCEzdPFuL203BYBpF7YA/boGp0kwdQt4O/n1BRlhGr3SnPktFRq93F
	 HWD/a6hBE9V0Q==
Date: Thu, 12 Mar 2026 14:01:29 -0700
Subject: [GIT PULL 8/9] fuse2fs: upgrade to libfuse 3.17
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: amir73il@gmail.com, djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916657.3254574.10857673722249647388.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit f066b2d71d62705836e131bd03f71d42dd4f9376:

fuse2fs: enable the shutdown ioctl (2026-03-08 19:14:06 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-library-upgrade_2026-03-12

for you to fetch changes up to 96ca2a29cc7dcb3100efa2efc3916aa8b66dcedc:

fuse2fs: drop fuse 2.x support code (2026-03-08 19:14:06 -0700)

----------------------------------------------------------------
fuse2fs: upgrade to libfuse 3.17 [08/18]

In preparation to start hacking on fuse2fs and iomap, upgrade fuse2fs
library support to 3.17, which is the latest upstream release as of this
writing.  Drop support for libfuse2, which is now very obsolete.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
fuse2fs: bump library version
fuse2fs: wrap the fuse_set_feature_flag helper for older libfuse
fuse2fs: disable nfs exports
fuse2fs: drop fuse 2.x support code

configure      | 358 +++++----------------------------------------------------
configure.ac   |  85 +++++---------
misc/fuse2fs.c | 252 +++++++++-------------------------------
3 files changed, 115 insertions(+), 580 deletions(-)

