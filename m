Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517C8376498
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349243; cv=none; b=M54dFAkK+6BWa94HDZRS/eGy6SNEZiu9hOHPCtIU/6Crz9RF5SbnUjgvYJeiYcoFBGAlFQBQKiCf6S6kSTHMB6joI21q5xUvftJq18sDT5/DwFAjDwkTKvLViGWwRdtHsXzftTAtzyy17lvYz35V7Yc1TtGv3wtLg/cJTY0mdgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349243; c=relaxed/simple;
	bh=VKVdkdyRyyGQVtsqQJbyruGOWSFCgrCstENolPQK4g0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Z98mEHronWNfhIeXrYLV58iz/Fum9C7MNYwZ6boMW8J1AMH/mDmcZuulARNH/Gi6b1m66f5zS2lMjEHLk9Y+2rxpa3jQCYi/VX645YVqF7JDIedIAj8om0VUz4PDXb2pOs/AOhoOf2eAsUGdtNXHxGMMbuO4F+bF+Bo6DctUKNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZO4OSRDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZO4OSRDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243C5C4CEF7;
	Thu, 12 Mar 2026 21:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349243;
	bh=VKVdkdyRyyGQVtsqQJbyruGOWSFCgrCstENolPQK4g0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZO4OSRDzcHO2ErLaADO2gpGoJrXm65BPg/g7BP1ZmF6L3VsSpWZUB1xr8xxMOUvpF
	 L60EMxcq8Qmp0HVW0oDeYXgC3gCRPdjMvv/eqHr/E1hM9WzqdXlIbtj8xA6h+8q76n
	 UQeBO7vzR5jUKH5lFsVgYrar29YMEV+NNw7Xir3iCe+HDMVWTk6sbqpjaxn3H2d8W6
	 QmSHfDK4NQQeBrLB35j4sDPcCpRDZ+hbVI9pC0ODnr/1HCUhUqQALgSZd2zXO7+VqN
	 yZ/CQ8f3XQn3NtTZvDboXlQ0KNIfj354fFYVHbKfwLYc5iYKDVEbIGyLTnbhPPXp3q
	 hjh4Qtqx05eeg==
Date: Thu, 12 Mar 2026 14:00:42 -0700
Subject: [GIT PULL 5/9] fuse2fs: refactor mount code
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916576.3254574.12995451033800002505.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 5d3394ff8d6f2e120be1343c1504831d9602a3b4:

fuse2fs: hoist unmount code from main (2026-03-08 19:14:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-refactor-mounting_2026-03-12

for you to fetch changes up to 9476b1377d887872f96d7144a81d2107cff3df1f:

fuse2fs: adjust OOM killer score if possible (2026-03-08 19:14:05 -0700)

----------------------------------------------------------------
fuse2fs: refactor mount code [05/18]

Here, we hoist the mounting code out of main() into a pile of separate
helper functions to reduce the complexity of understanding the mount
code.  This isn't strictly required for iomap, but it makes main() a lot
easier to understand.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
fuse2fs: split filesystem mounting into helper functions
fuse2fs: register as an IO flusher thread
fuse2fs: adjust OOM killer score if possible

configure       |  37 ++++
configure.ac    |  18 ++
lib/config.h.in |   3 +
misc/fuse2fs.c  | 634 +++++++++++++++++++++++++++++++-------------------------
4 files changed, 412 insertions(+), 280 deletions(-)

