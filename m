Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3C3D0907
	for <linux-ext4@vger.kernel.org>; Wed,  6 May 2026 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778080125; cv=none; b=qUjkHGuzVPC/Xgo0O3RYJ8Id4nEvvdSWFQ4r//XyS9A3/aXwdK/cT+42syQAN20rJEdD628Szke5SH33jPWTeb2vRU071CkH5GirtBtkNvZN7cEmyDDE9wQIxOxmtgXn1Veax5/xeumR+CD54ZnFmGXsGzwIsHBfLyq1eNtb09E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778080125; c=relaxed/simple;
	bh=eyv6Oi8ELO76ufpS0nEKBGprnuOkUL2evMt6kM+DFDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RvKYklq++kxefGxbRWVzx83F7iL+hc3tEAF8u14OapCqhVebn4hR9F7Xim5kBl/s0lJqwi/h5BLNfC5LQ5+lfy981bTNqKqybKunDuLpErRaTh3fTMe/zdcGebd4S8VKRCwAXD7y09csXJgSnMTw0cwBx0FijNxUjMBTytsGgVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=d+3+YlkK; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="d+3+YlkK"
Received: from macsyma.thunk.org ([136.144.35.157])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 646F8XKZ006997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 6 May 2026 11:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1778080117; bh=L0BsG1JgcDsgxZmbzt/1LSD6aBvNyZfvlYH7ChVUNRg=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=d+3+YlkKSGmD0njRI2lG6XtcUT29pVICZXUdJoKEG96wSJq+QBMXoNJNxuKJptZaN
	 8nSA1dSB+4TFZ5KGwbZaMbECPAyspTz0pzOzflbynxGroELwylt3pyXL7DfSl0QdX3
	 G0Ch5w+hQYDYUiG1mZ54RBGUqaL0tq2dWueyYUPfgEhHmS5tw6mCh+5MoKdges9+Vv
	 I6yLPdIPd1Jr7Kb01Q7+C4pgTYqUQiDCsjZG6qWDxX6bXkV4oWRXazCbgAJFZtMiKw
	 1p1psuR7SFT0kcKaf5LUtoIFxyWlWhiMR8Wqwg1L8ataZOi1r/+C5/W3qwUiKrmKBi
	 ZjzXKkhrvCOhg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 253B9666E9E7; Wed,  6 May 2026 17:08:33 +0200 (CEST)
Date: Wed, 6 May 2026 17:08:33 +0200
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260506150833.GD49070@macsyma.local>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
 <20260505155821.GI1101423@frogsfrogsfrogs>
 <20260505220441.GB49070@macsyma.local>
 <20260505225635.GT7765@frogsfrogsfrogs>
 <20260506092858.GC49070@macsyma.local>
 <20260506143413.GA2241589@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506143413.GA2241589@frogsfrogsfrogs>

On Wed, May 06, 2026 at 07:34:13AM -0700, Darrick J. Wong wrote:
> [cc fuse-devel]
> 
> TLDR for the fuse developers: Ted and I discovered a collision between
> the upstream libfuse feature bits and the MacFUSE feature bits, which
> causes macfuse to do the wrong thing if you try to enable symlink
> pagecache.

This is the patch for fuse2fs and fuse4fs in e2fsprogs which works
around the problem (tested on MacOS using macfuse 5.2.0_1 from
MacPorts).  More details about why it was needed is in the commit
description.

					- Ted

From 67f1ec55a1309abead16cad883e38b798a567191 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 6 May 2026 10:51:56 -0400
Subject: [PATCH] fuse2fs, fuse4fs: Fix MacFuse compatibility issue

Unfortunately, MacFuse is overloading the top bits of the flags field
in struct fuse_init_{out} for MacFuse-specific capability extensions.
This results in an attempt to use FUSE_CAP_CACHE_SYMLINKS when linking
with the libfuse in MacPorts will end up enabling
FUSE_DARWIN_CAP_ACCESS_EXT with MacFuse.  Hilarity then ensues with
all non-privileged access failing with permission denied.

The change which is needed in MacFuse is described in a TODO(bf)
statement:

https://github.com/macfuse/library/blob/ddb630db8327a50b6670ef5e4f5e6da82a549e99/lib/fuse_lowlevel.c#L3415

I plan to submit a bug report to MacFuse, but in the mean time, work around
the problem by disabling the overloaded capability flags on MacOS.

Link: https://lore.kernel.org/r/20260505225635.GT7765@frogsfrogsfrogs
Link: https://lore.kernel.org/r/20260506092858.GC49070@macsyma.local
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fuse4fs/fuse4fs.c | 18 ++++++++++++++++++
 misc/fuse2fs.c    | 18 ++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 92847326..2739da92 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -120,6 +120,24 @@
 #endif
 #endif /* !defined(ENODATA) */
 
+#ifdef __APPLE__
+/*
+ * Sigh.... MacFuse is overloading the top bits of the flags field in
+ * struct fuse_init_{out} for MacFuse-specific capability extensions.
+ * Avoid using these fuse3 capability flags until this gets fixed in
+ * MacFUSE
+ */
+#undef FUSE_CAP_CACHE_SYMLINKS
+#undef FUSE_CAP_NO_OPENDIR_SUPPORT
+#undef FUSE_CAP_EXPLICIT_INVAL_DATA
+#undef FUSE_CAP_EXPIRE_ONLY
+#undef FUSE_CAP_SETXATTR_EXT
+#undef FUSE_CAP_DIRECT_IO_ALLOW_MMAP
+#undef FUSE_CAP_PASSTHROUGH
+#undef FUSE_CAP_NO_EXPORT_SUPPORT
+#undef FUSE_CAP_OVER_IO_URING
+#endif
+
 #define FUSE4FS_ATTR_TIMEOUT	(0.0)
 
 static inline uint64_t round_up(uint64_t b, unsigned int align)
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index c46cfc23..0f2a3c35 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -116,6 +116,24 @@
 #endif
 #endif /* !defined(ENODATA) */
 
+#ifdef __APPLE__
+/*
+ * Sigh.... MacFuse is overloading the top bits of the flags field in
+ * struct fuse_init_{out} for MacFuse-specific capability extensions.
+ * Avoid using these fuse3 capability flags until this gets fixed in
+ * MacFUSE
+ */
+#undef FUSE_CAP_CACHE_SYMLINKS
+#undef FUSE_CAP_NO_OPENDIR_SUPPORT
+#undef FUSE_CAP_EXPLICIT_INVAL_DATA
+#undef FUSE_CAP_EXPIRE_ONLY
+#undef FUSE_CAP_SETXATTR_EXT
+#undef FUSE_CAP_DIRECT_IO_ALLOW_MMAP
+#undef FUSE_CAP_PASSTHROUGH
+#undef FUSE_CAP_NO_EXPORT_SUPPORT
+#undef FUSE_CAP_OVER_IO_URING
+#endif
+
 static inline uint64_t round_up(uint64_t b, unsigned int align)
 {
 	unsigned int m;
-- 
2.50.1 (Apple Git-155)

