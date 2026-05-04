Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B263C3DD514
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937607; cv=none; b=CuVbj1bwR6PcBwVt8FLqzHZ/c4xEJAZAYon5jotVOAoWwBSs1Z6GY+2lfD2Mp+Rek70P+VklsEkwmAG6h+JnUX9E+gzVNXCaqRSm2fnmITCsVogwa6m7J9X2UK9aIgR9oKtTPXRLnazDPxuUKFQDPpMHSj8OGlorCmHVfNiFpWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937607; c=relaxed/simple;
	bh=iP5lGT4QV5ooUYTmeQda1LBwtcG31w4Q4ODjbD/Wh2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kabLSOxP4oB+D3KI1BUi1BVW5IGfZHsoF8mh9XUl5aoxJVFD2kCpT3KjirvXoL6kXBrZDLG/i3jLLT4nmTchlEXLeaZbFeCyRBbMhEA1GI5yGqU5lzTRiyDXZug7/arNdvpMOd0xjNpMQibKRSDDrKwc6YoCnZcocQLcTyTSiVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=d9e73sbR; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="d9e73sbR"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX8eO019532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937589; bh=HYRnFQCv7sIazzBRuIq8ijnPMNSjeZKSju+ZJcyeC+8=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=d9e73sbRly7trRIScKGKYB8WwFIw8lRILg0/gwktciYmZLe/dgcskWBC8zSGnVjDc
	 pv3ZKy1ScwU7ekalQxAan5HIerC40GI0m7660xvap1renM2DWqb21VgKB4kgbt7r33
	 YSDcDPqCcVSPdTjdd5Zl9RD6s+7MgbUyyZpsf+jiSo3b3LXu6hTKVEtahlIW5+F7AS
	 /lTioUQ0a3OKAhR6AWUktQ+DV0fNedmWHLYUXX6jABz96bt8HIDlQyV8i+BSN1LVsw
	 SkAMKEOYl1w9Ba933U2Q1uNqPJpYQ+3rLF49OWNfXgS7KABZzoVbJk2WvI5fzb2FCC
	 kAnog+mU94GFg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 036E92E00D3; Mon, 04 May 2026 19:33:08 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 4/7] fuse[24]fs: suppress clang warnings which were breaking the github CI
Date: Mon,  4 May 2026 19:32:58 -0400
Message-ID: <20260504233301.2345652-5-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504233301.2345652-1-tytso@mit.edu>
References: <20260504233301.2345652-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fuse[24]fs.c defines some functions which might or might not be used
depending on the version of the fuse library installed on the system.
Unfortunately while gcc won't complain if there are static inline
functions which are not used, clang will only suppress such complaints
if the static inline functions are in a header file.

Since the github CI runs a test build with -Wall -Werror this was
breaking the CI build.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fuse4fs/fuse4fs.c | 21 +++++++++++++++++++++
 misc/fuse2fs.c    | 21 +++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 13e1aae4b..b883083f8 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -502,6 +502,27 @@ static inline off_t FUSE4FS_FSB_TO_B(const struct fuse4fs *ff, blk64_t bno)
 	return bno << ff->blocklog;
 }
 
+#ifdef __clang__
+#define SUPPRESS_UNUSED_FUNCTION(func)    (void)func
+/*
+ * These functions might or might not be used depending on the version
+ * of the fuse library installed on the system.  Unfortunately while
+ * gcc won't complain if there are static inline functions which are
+ * not used, clang will only suppress such complaints if the static
+ * inline functions are in a header file.
+ */
+void fuse2fs_shut_up_stupid_clang_warnings(void)
+{
+	SUPPRESS_UNUSED_FUNCTION(fuse2fs_shut_up_stupid_clang_warnings);
+	SUPPRESS_UNUSED_FUNCTION(round_up);
+	SUPPRESS_UNUSED_FUNCTION(round_down);
+	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_B_TO_FSBT);
+	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_OFF_IN_FSB);
+	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_B_TO_FSB);
+	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_FSB_TO_B);
+}
+#endif
+
 static double gettime_monotonic(void)
 {
 #ifdef CLOCK_MONOTONIC
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 0f4781bc4..c46cfc236 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -339,6 +339,27 @@ static inline off_t FUSE2FS_FSB_TO_B(const struct fuse2fs *ff, blk64_t bno)
 	return bno << ff->blocklog;
 }
 
+#ifdef __clang__
+#define SUPPRESS_UNUSED_FUNCTION(func)    (void)func
+/*
+ * These functions might or might not be used depending on the version
+ * of the fuse library installed on the system.  Unfortunately while
+ * gcc won't complain if there are static inline functions which are
+ * not used, clang will only suppress such complaints if the static
+ * inline functions are in a header file.
+ */
+void fuse2fs_shut_up_stupid_clang_warnings(void)
+{
+	SUPPRESS_UNUSED_FUNCTION(fuse2fs_shut_up_stupid_clang_warnings);
+	SUPPRESS_UNUSED_FUNCTION(round_up);
+	SUPPRESS_UNUSED_FUNCTION(round_down);
+	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_B_TO_FSBT);
+	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_OFF_IN_FSB);
+	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_B_TO_FSB);
+	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_FSB_TO_B);
+}
+#endif
+
 static double gettime_monotonic(void)
 {
 #ifdef CLOCK_MONOTONIC
-- 
2.53.0

