Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56C330AABE
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775765688; cv=none; b=Z4+XuL6sQyb3XyVhkkmPIFVUJsWnbhWGw5eIgOGG6fv+2FxyG4WOR2SGES7OYJSSwRAOr2oA+bdxJCUTvBDATzC39BzDgH3qBD1n6J5WVhubVfdnBh38ryjDQ3QfxD6cXNXTX1qVQx38IfXaQiOiCYkz12o9AjkOm/ITzstTmyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775765688; c=relaxed/simple;
	bh=qD4oV/yHOlpIs5h+uDzJcFqquNFK6Ph4OboT6w3YfvM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=cHTvaocksqWetPB7ykFaEJt1Ahz49Fotow6cP0b53SBRjlv8V7S6W8ALi6vK1v1CxSDid2AiQll8G+lRwZZAYbO2vXcFOxZqoDdb22bBaWAivkN92BlrY6pQGp/GvD7nUhcKuwbRtR0Wx+2rFZdmmvrQzcz8CXhGaR9QS8pPMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7kJRT/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7kJRT/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F8AC4CEF7;
	Thu,  9 Apr 2026 20:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775765688;
	bh=qD4oV/yHOlpIs5h+uDzJcFqquNFK6Ph4OboT6w3YfvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V7kJRT/pXRA7L3G58COYG3+StqacqWFVZavw3pdVyhPbKdzA8zHQC0Kc4jlvvQ/fX
	 6acj7Au3TJieto31HPrNaMkZB4WpNduMBsgdVlE1oIkxn6C6cRT+NHhwXztazqpQu8
	 Plk/4q+/8bcaqUgfaupaCTDoeX8WnlY70E+Ibj6CTxis/4sSdcrv6gg6IYOxSfmsSf
	 LjyoTywSLnM2YiSJ9B3gbbMndAFBtbflG88/Bj6tcZsQej8lTyjJLt9X0hhkjab5M7
	 QRHCUjcDRUYqnINooj5h1ub7S/oKmN8JNgW0MPJnOrupoRZ4LF1CWQpBesrjg7aqLf
	 PmcU+zlB200Jg==
Date: Thu, 09 Apr 2026 13:14:47 -0700
Subject: [GIT PULL 1/2] fuse2fs: upgrade to libfuse 3.17
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: amir73il@gmail.com, djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177576561073.1959707.11474118496938381269.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 43643a57fb2d3368fbacd181a8cd713102d52a1a:

tests/f_opt_extent: use tune2fs from the build tree in the test script (2026-04-03 11:20:06 -0400)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-library-upgrade_2026-04-09

for you to fetch changes up to c137760397ef6671832548bcd256778f57f49c2d:

fuse2fs: drop fuse 2.x support code (2026-04-09 13:00:40 -0700)

----------------------------------------------------------------
fuse2fs: upgrade to libfuse 3.17 [01/11]

In preparation to start hacking on fuse2fs and iomap, upgrade fuse2fs
library support to 3.17, which is the latest upstream release as of this
writing.  Drop support for libfuse2, which is now very obsolete.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
libsupport: change get_thread_id return type to unsigned long long
fuse2fs: bump library version
fuse2fs: wrap the fuse_set_feature_flag helper for older libfuse
fuse2fs: disable nfs exports
fuse2fs: drop fuse 2.x support code

lib/support/thread.h |   2 +-
configure            | 358 +++++----------------------------------------------
configure.ac         |  85 +++++-------
lib/support/thread.c |   4 +-
misc/fuse2fs.c       | 252 ++++++++----------------------------
5 files changed, 118 insertions(+), 583 deletions(-)

