Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2ED34029E;
	Wed, 22 Apr 2026 23:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776899962; cv=none; b=kqew8zts122F0Y8J8v22A9/EOKqNMta5vBSD6Wq29HDvs/CFSynr27E2YrnCbADbQ2qUuLD4Cmh+kFLRgvqXrEAo8BcyM4kzaBmdAWUCr9MTgsV76GCb7ZvNIb3DwFwR+MmFQefNnfgY5BuVyJkrBTLjcwyAjZ34KTNoimpicj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776899962; c=relaxed/simple;
	bh=l2JE0T6zXy6gkxMiCpRlTkBn2TeOTu+CcOr7KhtVTA0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CgsguEfVkUPunA6MO3318wpS05iIrpeQGlIEUvolMtcUHHgHwqfDIxVx1LHHwt+Asmqsd7fSirqqSPatZWN8FyMqbxlNCzc/s/iXKNKD/JD09TfZp9IhwPE41WrFZrJBlesSC5ALACA09WeTzXDDYkjdPIwPC3uWE89Qnekj+MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TT8P94rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TT8P94rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBE6C19425;
	Wed, 22 Apr 2026 23:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776899961;
	bh=l2JE0T6zXy6gkxMiCpRlTkBn2TeOTu+CcOr7KhtVTA0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TT8P94rhEo3Viu2qolnC/ypCjIaJrcZHPRq78S89u5+suFgkD4G5FWUkK6cJtD5l3
	 HRDrFARRYsNlDyKRY2engO++N4liXpGmGRSdCJNUmnZNf7+8yNF8wfVY8pALKfwkbi
	 wOfUlFfUpyMYO7xPrXoQSXlJhD9cHXoq7VxhtvbJCRu1NbIu5DYT+F0q68Iq4Ke9Kp
	 0OOM7pBFs/NjvVchbku69nSHgG8n1gwasSCdkSqLWXvr3A7GiejWmd9WZwAbxVZqhk
	 SyjVLN2sNZtJToc5lvnvVyteLntJaXfwiPqM+b7K91DoLbW09fJXZVWkEgfoJekOVF
	 3t51ixjsWOTxA==
Date: Wed, 22 Apr 2026 16:19:21 -0700
Subject: [PATCHSET v5 2/2] fuse4fs: run servers as a contained service
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-ext4@vger.kernel.org, neal@gompa.dev,
 joannelkoong@gmail.com, miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
In-Reply-To: <20260422231518.GA7717@frogsfrogsfrogs>
References: <20260422231518.GA7717@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series packages the newly created fuse4fs server into a systemd
socket service.  This service can be used by the "mount.service" helper
in libfuse to implement untrusted unprivileged mounts.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-service-container
---
Commits in this patchset:
 * libext2fs: make it possible to extract the fd from an IO manager
 * libext2fs: fix checking for valid fds in mmp.c
 * unix_io: allow passing /dev/fd/XXX paths to the unixfd IO manager
 * libext2fs: fix MMP code to work with unixfd IO manager
 * libext2fs: bump libfuse API version to 3.19
 * fuse4fs: hoist some code out of fuse4fs_main
 * fuse4fs: enable safe service mode
 * fuse4fs: set proc title when in fuse service mode
 * fuse4fs: make MMP work correctly in safe service mode
 * debian: update packaging for fuse4fs service
---
 lib/ext2fs/ext2_io.h         |    4 
 lib/ext2fs/ext2fs.h          |    1 
 lib/ext2fs/ext2fsP.h         |    4 
 MCONFIG.in                   |    2 
 configure                    |  303 +++++++++++++++++++++++++++
 configure.ac                 |  131 +++++++++++-
 debian/e2fsprogs.install     |    7 +
 debian/fuse4fs.install       |    3 
 debian/libext2fs2t64.symbols |    1 
 debian/rules                 |    3 
 fuse4fs/Makefile.in          |   42 +++-
 fuse4fs/fuse4fs.c            |  466 +++++++++++++++++++++++++++++++++++-------
 fuse4fs/fuse4fs.socket.in    |   17 ++
 fuse4fs/fuse4fs@.service.in  |  102 +++++++++
 lib/config.h.in              |   12 +
 lib/ext2fs/io_manager.c      |    8 +
 lib/ext2fs/mmp.c             |  101 +++++++++
 lib/ext2fs/openfs.c          |    1 
 lib/ext2fs/unix_io.c         |   50 ++++-
 util/subst.conf.in           |    3 
 20 files changed, 1164 insertions(+), 97 deletions(-)
 mode change 100644 => 100755 debian/fuse4fs.install
 create mode 100644 fuse4fs/fuse4fs.socket.in
 create mode 100644 fuse4fs/fuse4fs@.service.in

