From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/25] libext2: Fix EXT2_LIB_SOFTSUPP masking
Date: Fri, 16 Sep 2011 15:49:16 -0500
Message-ID: <1316206180-6375-2-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46722 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab1IPUto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:44 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT2_LIB_SOFTSUPP_INCOMPAT_* are supposed to be bitmasks
of features which can be opened even though they are
under development.  The intent is that these are masked
out of the features list, so that they will be ignored
on open.

However, the code does a logical not vs. a bitwise not:

	features &= !EXT2_LIB_SOFTSUPP_INCOMPAT;

which will not have the desired effect...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/openfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index b13db77..0b4df38 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -214,7 +214,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		features = fs->super->s_feature_incompat;
 #ifdef EXT2_LIB_SOFTSUPP_INCOMPAT
 		if (flags & EXT2_FLAG_SOFTSUPP_FEATURES)
-			features &= !EXT2_LIB_SOFTSUPP_INCOMPAT;
+			features &= ~EXT2_LIB_SOFTSUPP_INCOMPAT;
 #endif
 		if (features & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 			retval = EXT2_ET_UNSUPP_FEATURE;
@@ -224,7 +224,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		features = fs->super->s_feature_ro_compat;
 #ifdef EXT2_LIB_SOFTSUPP_RO_COMPAT
 		if (flags & EXT2_FLAG_SOFTSUPP_FEATURES)
-			features &= !EXT2_LIB_SOFTSUPP_RO_COMPAT;
+			features &= ~EXT2_LIB_SOFTSUPP_RO_COMPAT;
 #endif
 		if ((flags & EXT2_FLAG_RW) &&
 		    (features & ~EXT2_LIB_FEATURE_RO_COMPAT_SUPP)) {
-- 
1.7.4.1

