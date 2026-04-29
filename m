Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698CA2C027A;
	Wed, 29 Apr 2026 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472497; cv=none; b=Qu8ZwB8hHTu0Qa0m5IkWY6+yXQo2eMFGlQwKL71n7vw8MAPqDyqPq+IAG63ETmeHW9nomh7BOI8gWZy0WztgKwbKtx4nKbHCYaTk2sfjhTDtMWBxEfzF+XHld6U+31V5ssCMcqyW09Nz/uAtJpH2hJ2dMF0bPYvZNDF7+9wPokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472497; c=relaxed/simple;
	bh=C94uLqXE2z/bylvwzdkrFjjaxmM8RLX8ugFKLL0sRdI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P379nt+9UrXoObKwqOKz8TgdStaj9wvkqe00jdv5hNJowLI7nVOUFLkcl8DkMdSWD7l5VMvZdGcLBGuZBIuU4xkChfL3k6ic0EwpdVLTWankKY0LWhbDDy9hAORi2WYatFcvpe/H90NzfopbzDOGoMfSUC6xwbK7prWicmE7EJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZNTWTZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZNTWTZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10966C19425;
	Wed, 29 Apr 2026 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472497;
	bh=C94uLqXE2z/bylvwzdkrFjjaxmM8RLX8ugFKLL0sRdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NZNTWTZL5/HxTCro5r+TWlZPQUoqE4y+DNZQE7ig3Mt0IUyQNMDrxaGZKXn26it4h
	 mLanIHYILdKRPQQQyfCP5eksnLp4kZPzqHTeoSgdoTWlMhhz8xNhb1f0bVkS/PXGwa
	 7exSbNg8sou2EwCQTBDkGPCmd/GD/UBchjix7gyBSIN8Hafqx/Y3pQbfHDxRFNXCny
	 kkfvpDNpYL/ZEGgAdpZEd59+dCF5DVejC5KZpV93RdFKSPaz7hA9o+PG5hVXP0OTFp
	 07fxrXgKUHHF+AySdIbT8mXBEmYlYzWcgqTf025QxVjQj7rga1sB+ASurUyZHRWNk+
	 t+hvOFFHxrpGg==
Date: Wed, 29 Apr 2026 07:21:36 -0700
Subject: [PATCHSET v8 6/6] fuse2fs: cache iomap mappings for even better file
 IO performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
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

This series improves the performance (and correctness for some
filesystems) by adding the ability to cache iomap mappings in the
kernel.  For filesystems that can change mapping states during pagecache
writeback (e.g. unwritten extent conversion) this is absolutely
necessary to deal with races with writes to the pagecache because
writeback does not take i_rwsem.  For everyone else, it simply
eliminates roundtrips to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse2fs-iomap-cache
---
Commits in this patchset:
 * fuse2fs: enable caching of iomaps
 * fuse2fs: constrain iomap mapping cache size
 * fuse4fs: upsert first file mapping to kernel on open
 * fuse2fs: enable iomap
---
 fuse4fs/fuse4fs.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 misc/fuse2fs.c    |   38 ++++++++++++++++++++++-----
 2 files changed, 101 insertions(+), 13 deletions(-)

