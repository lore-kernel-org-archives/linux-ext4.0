Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1511534C9AB
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349212; cv=none; b=TJDWZ0rHzUU+vhFFyHa0Im9WXzsx58Oub5Vs9YEC2kAUgkGgv3rrPdxMsyFOaE5Ow4aS9KAfeHTj9DkOq2tgP5QZhhkUgkpVHQJGwiMKuU4l6NQ64LAZbqxwppbWQov7Un0poZdYJL48WxX83M9KebpUgT1isz0fcrP/+5C/BAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349212; c=relaxed/simple;
	bh=w61ttQAN4i2ettq9frxr9BzshEmyLWKBoBRH5Mru/dw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=TfyMacMmP4eFKrrQ/MIragtO19zKk2B5J3ufAzv2lCwlOS1vHZl9zC1dAmXqmnr+Jy1esYFu9FhgeG7O3IbtY2Si2wc7eiBuEk/GMgd6suBy/i3QO+yJe+X9TtEgcp/rebC843I/n/iOJPShFDlW7bErsa4qxnHrvTz/0bR1Hqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3LWA2s1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3LWA2s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B793CC4CEF7;
	Thu, 12 Mar 2026 21:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349211;
	bh=w61ttQAN4i2ettq9frxr9BzshEmyLWKBoBRH5Mru/dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X3LWA2s1QrTw7314yBIkA6f49EeH6djKgUHNP4D1MdqI0L6oVaTaLAbe1uqJ4ecE+
	 L5CU1ORBO8NvhVTKLC3cm+IsFgO+ucHjGdSrTBVoNPzgz9gq/wUdjkEhuc3pZz77wW
	 /JOqZpL/MXLIW/FA//UE79C+hqCPlFi84Rfrjg7CPtVeGjo3iPULfg/DIOZR0oeCLk
	 p0av9ESexDBGoDDLuLRfD9Ve+FvrMzAEWo/9pcVicKPXMePTRGS78Go27vLAqJnFWW
	 +XSmfQaonCEQ6Nn4xIjO7Dgytn0rJcAST3lk2alhdgiTmKiSZl+RGzofmgxTFEHCm6
	 LpfwGdjdzreYQ==
Date: Thu, 12 Mar 2026 14:00:11 -0700
Subject: [GIT PULL 3/9] fuse2fs: clean up operation startup
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916519.3254574.10658825847200071665.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit a4fc4817e3072cb19f481da24d4520671a174fff:

fuse2fs: implement MMP updates (2026-03-08 19:14:04 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-refactor-operation-startup_2026-03-12

for you to fetch changes up to f5c46155c79cccd46e047d732063c7f21db35c8e:

fuse2fs: collect runtime of various operations (2026-03-08 19:14:05 -0700)

----------------------------------------------------------------
fuse2fs: clean up operation startup [03/18]

Reduce the amount of boilerplate in fuse2fs by creating helper functions
to start and finish a file operation instead of open-coding the logic
all over the place.  This also fixes a couple of theoretical races.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
fuse2fs: rework FUSE2FS_CHECK_CONTEXT not to rely on global_fs
fuse2fs: rework checking file handles
fuse2fs: rework fallocate file handle extraction
fuse2fs: consolidate file handle checking in op_ioctl
fuse2fs: move fs assignment closer to locking the bfl
fuse2fs: clean up operation startup
fuse2fs: clean up operation completion
fuse2fs: clean up more boilerplate
fuse2fs: collect runtime of various operations

configure       |  38 +++++
configure.ac    |  19 +++
lib/config.h.in |   3 +
misc/fuse2fs.c  | 475 +++++++++++++++++++++++++++++---------------------------
4 files changed, 304 insertions(+), 231 deletions(-)

