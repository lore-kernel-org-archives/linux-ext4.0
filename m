Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A58F34CFC4;
	Mon, 23 Feb 2026 23:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887745; cv=none; b=VpsiU2qyEWb/0RezZJ26FLC9GTTq6SRdGoS9xFRpT3bPkSIRRHqJck0tKjwYxh6rgJEOKX+vXf//v5wtMHSUwP6yGNheLklz8Ht9zcRmb5nMv+NCND4t2meS+RApqpAX6iltpr9GD6cBhi3cJq5iMwX0rd6Cwdn0wfvGvHUsmMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887745; c=relaxed/simple;
	bh=6KaccDy0qc01Shk7Rw3tLKK0FXf7DHH/K1gRRlfPkvE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OxluZSlGzIvg/x2dtfpyZ192HDVsitLmMhnZJBfIClRqXeNeVtfxbHW8Ys/lOCSEwu56agfnsW1kA18PCOwahQbXxm/Dkq/KFN/LuTmsFa/RKMd0hhx5kMHFqFBJlg+qu98TAAXXuQ2sAY3kOx0F/iJ4Cx037OxaWVIyp59zA/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jR//bVeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jR//bVeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63794C116C6;
	Mon, 23 Feb 2026 23:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771887745;
	bh=6KaccDy0qc01Shk7Rw3tLKK0FXf7DHH/K1gRRlfPkvE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jR//bVeBA17kQaUZy4v7dbP22aqlwBQwRPSNFHHXnacdCcLVDur0P/f+Mmcf2f49p
	 IIrzYrg4qCGDhQL4AqJV5oEK7IjyYelxDlUC2mKQ03LFZ4hE57rpJV7rUpzrPLl7Pi
	 4HF7E8ONajVYvb2AWTXt+XZmvlcY2Vv+eEkgB/crnA+ICOYV72hKRkH828G2PpmGbR
	 CE9ZitXDj3vqtnJt3cxTg8snjNwRzEq/bLx/65fZvx7RqasNExCwFCPqOjkSmcAWHN
	 UoDapqKFV8gzNtt0kWXemLDv1yw5aXhcIUKhaGnP4bRr8IJqj1G/SwELxiGRYmSzKl
	 Ubj2vrsVdxxqg==
Date: Mon, 23 Feb 2026 15:02:24 -0800
Subject: [PATCHSET v7 8/9] fuse: run fuse servers as a contained service
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: joannelkoong@gmail.com, bpf@vger.kernel.org, bernd@bsbernd.com,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177188736492.3938056.12632921710724088507.stgit@frogsfrogsfrogs>
In-Reply-To: <20260223224617.GA2390314@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset defines the necessary communication protocols and library
code so that users can mount fuse servers that run in unprivileged
systemd service containers.  That in turn allows unprivileged untrusted
mounts, because the worst that can happen is that a malicious image
crashes the fuse server and the mount dies, instead of corrupting the
kernel.  As part of the delegation, add a new ioctl allowing any process
with an open fusedev fd to ask for permission for anyone with that
fusedev fd to use iomap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-service-container
---
Commits in this patchset:
 * fuse: allow privileged mount helpers to pre-approve iomap usage
 * fuse: set iomap backing device block size
---
 fs/fuse/fuse_dev_i.h      |   32 ++++++++++++++++++--
 fs/fuse/fuse_i.h          |    7 ++++
 fs/fuse/fuse_iomap.h      |    5 +++
 include/uapi/linux/fuse.h |    8 +++++
 fs/fuse/dev.c             |   13 ++++----
 fs/fuse/fuse_iomap.c      |   72 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/inode.c           |   18 ++++++++---
 7 files changed, 138 insertions(+), 17 deletions(-)

