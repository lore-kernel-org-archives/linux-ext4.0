Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFDD378D97;
	Mon, 23 Feb 2026 23:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887917; cv=none; b=h1QEvACgfk0JyudfPHBOKeRzOXMMX2bPDlBR2rwzjE1Sw/X/vi/AX2+/lHG9xQ+berQ/cryRSe50sP6v+lCuGAygcvT7HjgZq5V8nZEDbFWUd+8rEy6b1rhXJ6yaAp5U1R1heLTJyCWW/gEWBg5CbZOtqH0OEXKJFMQtNMbUpnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887917; c=relaxed/simple;
	bh=yBPKN+EjYK0Y/VaXzwl4UsIR6vZeEqSBTD8zM5Ud9gs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Px6iOnbJiiVbPNNycKhnOgTJ4Vpa/MazqXiYeVkKeCkNnf28tjNEQKHYDterEyhnn+/iUT/DsjxEZXrFRHjuMgW14ImpQ3JaVr06Hrj59ZOR8UdB2n6DfDS7N8rUHC4scK7iobEv7gK7WCWHt4LD0YGR5mor8i4RypRMvrcr1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NiagtkFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NiagtkFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682E5C116C6;
	Mon, 23 Feb 2026 23:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771887917;
	bh=yBPKN+EjYK0Y/VaXzwl4UsIR6vZeEqSBTD8zM5Ud9gs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NiagtkFvr16gk6O7jFasNVWF1BneLMjs4QhzFGMd5gCIXVe0pFOt8+/6KhgroEK1q
	 OzFs1nO4NR4mx/agYQCCWR2jm+X+l9LQszXgepyyIJYnv8kisO36OZatmYB864W/OH
	 0PTj/yIagkyYykxjKsjMmZBRoQjVjFzbtYKYf3ET2n8yYv38B2AAdEkWmF2SwMHmOz
	 G0oZ04gtTP8GwswPvF1fFrjkPWYcBV6/H264JgpMxsUgj/lHjrj3I7oSSU/s5inQNY
	 Q1eiDKGdHN1kIZchmWzcIGq50rNFA2Zr+AXqI2iXh+oSFawaxsLjOpixM/9aF9h4Ss
	 ZptLPrCi1CLXA==
Date: Mon, 23 Feb 2026 15:05:16 -0800
Subject: [PATCHSET v7 4/8] fuse2fs: cache iomap mappings for even better file
 IO performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, bernd@bsbernd.com,
 joannelkoong@gmail.com, neal@gompa.dev
Message-ID: <177188745484.3944453.12407213942915501693.stgit@frogsfrogsfrogs>
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
 * fuse2fs: enable iomap
---
 fuse4fs/fuse4fs.c |   44 +++++++++++++++++++++++++++++++++++++-------
 misc/fuse2fs.c    |   40 ++++++++++++++++++++++++++++++++++------
 2 files changed, 71 insertions(+), 13 deletions(-)

