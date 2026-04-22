Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4EC3451DA
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 23:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776899946; cv=none; b=bVS86z0ftWBskiOWfi81qUBAeVmm38scLR09GctO4fYS72YSookZt5MXFmIUcscMuoT7x1kIOPIPQzwQHJpoKFWH8ogqZtP5WpQ+3tuTFDNEj3oaaVD2TFe/Pqo0cQQ7gjBULW3+O+MUte7HQDldIuszevSphH0hsHLPnpK1ZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776899946; c=relaxed/simple;
	bh=Xoq4a1WV30tzAIc3wtqPdKH4JNoKiOYZ8bvT/lD8bc0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZFpSUs4OFzAyM2dyq0XX3+nqaZpPUS4YSICUDDH8oef0eB2iuT2uZZP4AB4Xc/6d9xa45LDfT9pyFOWL6DWUgaLoUw0VxRXG/knz4HUBWOafc3jbmLnV7G1XJt1Gt3G1GMsFDVaz2ufr/BBN4/bzgsfjk5DOsU4DMnnx0zQMkGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5AJBLXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5AJBLXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A03C19425;
	Wed, 22 Apr 2026 23:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776899946;
	bh=Xoq4a1WV30tzAIc3wtqPdKH4JNoKiOYZ8bvT/lD8bc0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E5AJBLXrzl+t4leTv/fGLg5xxlTQ84WYda6rq9k/iESvVDW7wuXeIErVNEkNDO7ZB
	 HqAgKA0j3MAJojniNCRTym0rlqOUCo3APWUX3Se5/QILM+4pnq5dZpbSWrnHuf6Nzc
	 9IPWBirPhELFUbuxGDJD0V6wlAwSPinWDoSpZy/oHS4ngIV7HGS+g/9K4CDVLeQsLX
	 oJoPxowZv3BMrnGdE+cLepu6ERqWHuL+eFXjlMcGmtypdYog0yb9zEDdBFJ8ScfHNM
	 /4Rf5f4oCVWZGp8rN2mXDuNahC7FwVK6ChLhogBE3KHSiLuR6yjSBElD+EOshyA0et
	 7x5HGGug4UdqA==
Date: Wed, 22 Apr 2026 16:19:05 -0700
Subject: [PATCHSET 1/2] libext2fs: fix some missed fsync calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <177689989303.3821152.12873703999139555043.stgit@frogsfrogsfrogs>
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

Fix a few places (like device closing) where we really ought to tell the
block device to flush whatever's dirty to disk, even if we've failed to
flush all our cached buffers out to disk.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=libext2fs-flushing-fixes
---
Commits in this patchset:
 * libext2fs: always fsync the device when flushing the cache
 * libext2fs: always fsync the device when closing the unix IO manager
 * libext2fs: only fsync the unix fd if we wrote to the device
---
 lib/ext2fs/unix_io.c |   83 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 69 insertions(+), 14 deletions(-)

