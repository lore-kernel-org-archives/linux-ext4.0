Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F2204F93
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778018696; cv=none; b=D6SAyiQmHU03sE07+2qynmUGyLquSx/vxLAkHzokhVOvZLWMvCUwu/iOo+HI49l8/tSvlEkitDcdpHBsJZN+lx/ITZ1XsMbai/yo7Js3BJwk+d9LDX2Nm+j/qZNDGoZ4Q+r2xEtY+HVg5/I7UDOGsfe+5BDek1qilUEEzfV1LXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778018696; c=relaxed/simple;
	bh=icyDpfTQY6Dqfs4zAz/KeIXJFMHOkeJyB8AccMQBfFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgf59RD8TlABJairUS+HG8iePhXhTdTb8lKS3rRfV9Vs9RiKibpxmAjYyKQOzGOfGvLgNWW9om1PVpIUZJGYIYko2ntPtqB0QZwYF4Hw8a+SjOHSu6GBysqNNp2py4iGznCpsrTtflrXzIG5R6TS4tMyKQAe/IwiAv7gISu0sps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cDsrwcND; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cDsrwcND"
Received: from macsyma.thunk.org ([173.239.240.156])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 645M4isj018659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 5 May 2026 18:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1778018687; bh=X42tqmPY4eWuZKGwBMBEOSjViUwqbkDjIuAwYNo9ch8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cDsrwcNDh04DJawB2hxsS2zlHkMCG8TMewG0fbcKWQgtlZN+0dOg9m8LL6+0YUDd+
	 tryTcDeLI2NXkSOwgIe7hUlE9dMS7OhqaSATSEemC3mVTtyMk4QERSH+jVsh5vrw9K
	 O+rBPdIBuxZ6XlM4zM1zrBou7CfI+OO2uFUWfuIB6uQjmpiwuZTnWYnb3/lE/M/SJ4
	 Rvx8OwgGXwaG5CtKxOMfSWejRxCJ377xhjDIKVoDcwKO3DToR/WxTjYoAYVQyXfhWW
	 cO5i6DnSlpAy1IryW3vRRG6Y8zpsah2/4DPBsdcyFLlm1vRKwzlVIR4P9sOTyxIe4X
	 hW+O+YeyeWyMw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C1D536659B75; Wed,  6 May 2026 00:04:41 +0200 (CEST)
Date: Wed, 6 May 2026 00:04:41 +0200
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260505220441.GB49070@macsyma.local>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
 <20260505155821.GI1101423@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FyaRhA02sXXozI22"
Content-Disposition: inline
In-Reply-To: <20260505155821.GI1101423@frogsfrogsfrogs>


--FyaRhA02sXXozI22
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 08:58:21AM -0700, Darrick J. Wong wrote:
> Hrm.  A bisect would be the best (but least conference-friendly) option
> to narrow things down.

Well, a bisect was a bit painful because I had to cherry-pick patches
so I could get a successfull build.  But I did finally come up with
the guilty commit, and it's.... surprising at least to me:

commit b0bd58062bbf645942ab4f0aced3bb229f462dde
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Thu Aug 28 10:30:40 2025 -0700

    fuse2fs: cache symlink targets in the kernel

    Speed up symlinks by allowing the kernel to cache them.

    Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

I don't know why it made a difference, but this attached patch appears
fix the MacOS regression.  Could this be a bug in MacFuse[1]?  FWIW, I'm
running MacFuse 5.2.0_1 from MacPorts.

[1] https://macfuse.github.io

I could condition the patch so that we only avoid setting
FUSE_CAP_CACHE_SYMLINKS on MacOS?  WDYT?

						- Ted

--FyaRhA02sXXozI22
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-Revert-fuse2fs-cache-symlink-targets-in-the-kernel.patch

From fb3d2fc975d17d97ed76b2ed76022462a3b329f1 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 5 May 2026 23:34:53 +0200
Subject: [PATCH] Revert "fuse2fs: cache symlink targets in the kernel"

This reverts commit b0bd58062bbf645942ab4f0aced3bb229f462dde.

This commit is apparently causing fuse2fs on MacOS to fail without "-o
default_permissions".  It's not clear why, but it was determined using
a git bisect, and reverting the commit addresses the regression.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/fuse2fs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index c46cfc23..0f9cefa6 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -1593,9 +1593,6 @@ static void *op_init(struct fuse_conn_info *conn,
 	if (ff->acl)
 		fuse_set_feature_flag(conn, FUSE_CAP_POSIX_ACL);
 #endif
-#ifdef FUSE_CAP_CACHE_SYMLINKS
-	fuse_set_feature_flag(conn, FUSE_CAP_CACHE_SYMLINKS);
-#endif
 #ifdef FUSE_CAP_NO_EXPORT_SUPPORT
 	fuse_set_feature_flag(conn, FUSE_CAP_NO_EXPORT_SUPPORT);
 #endif
-- 
2.50.1 (Apple Git-155)


--FyaRhA02sXXozI22--
