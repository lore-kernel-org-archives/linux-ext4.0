Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5D530CD81;
	Wed, 29 Apr 2026 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472466; cv=none; b=B6sq8CcMKBZnaa42raY1dzvtVaAZ7ya8MtiXkOVMjFqMwc+WSgovOckGLH+pgqrpdWDpOF81UjdgaOllHuMr+ah/TOzlnQf91vQWPZFUo31KFCBr1MJm9YwYeEWWgBnTmAk7S7PMEJLR5N/nMY0Kx9LsZm9DLUIqx/SlD8S+3so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472466; c=relaxed/simple;
	bh=A5SX0ZIHqUUP2L4EkgVnFOfyDtvRHf8NvM8FK3yMEIo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pl44z+MJMiWh6PkWhiX+bwMKY23Ugq1iECexBHmfIwGy3dDHxbpT8lcYLZK8ZimwVSTQY7W4apm8NEC+q7krSPOwNjdzFVHZedCHbrwQjkVtyWrtj3/8m0wRiVGpb2yZeGLzEBZJU8OLVJPofFhslmMssVhtx6/ngxMYXTzZmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keKm93C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keKm93C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E5EC2BCB8;
	Wed, 29 Apr 2026 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472465;
	bh=A5SX0ZIHqUUP2L4EkgVnFOfyDtvRHf8NvM8FK3yMEIo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=keKm93C58kYWVRv9k4upYn3Y7g5itEQpDNdxpLE6FSIUKmjpwq64S8ur+A4Vpz+RY
	 DaJW89YSdPOGKSVSj0rg/XEvzZKpjyk7tuFtC3yUJkgqtJ2+4ZYQrBznqLYW4icSvp
	 FwozPjEDYETOoMHBNpJ6pZyp//dvv9z6L8zTGBJGF1sK7qdhnrFi2//Kfdv1lyV6vp
	 O7z+RSaBMc0HJstyGVzfyAXPdJb7zoJhvzWTKGGw94tUUGKPYLiUfxaInULdiIA+Jh
	 vUleG2SD1QWSyYSKu87KbREuU4vZgiVBYMQGKEm2A76hH8XwoJoq198MFqZYVeD0rB
	 h/rjNJrtIVX4A==
Date: Wed, 29 Apr 2026 07:21:05 -0700
Subject: [PATCHSET v8 4/6] fuse4fs: specify the root node id
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215201.4110055.6021378863218591603.stgit@frogsfrogsfrogs>
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

This series adapts fuse4fs to have a 1:1 mapping of ext2_ino_t to fuse_ino_t
for slightly better performance and less confusing code interpretation.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse2fs-root-nodeid
---
Commits in this patchset:
 * fuse4fs: don't use inode number translation when possible
---
 fuse4fs/fuse4fs.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

