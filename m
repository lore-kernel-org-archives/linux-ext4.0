Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903143B19D0
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 07:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783496021; cv=none; b=iMx3/9omEQWf1aci69us4BeTzsrreq12miMTLPCMt+eP9WKLLfz/k9uiCW2lQ41oY0qeE3GeYELky/ew1BIpd5Lywe9DjxCorBOQIH7kRQtkaOg3tcN7RBnRZyFWkPrc+EvXu9FtJOpHPaqvoV80aMM6IUIWfL9Y7BOoOdrk34I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783496021; c=relaxed/simple;
	bh=HCW4TKCi65mgymYWwQoa6YWRcYP0Fry1G5zTZcCSzV8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Bvaalbu8FuYpZEqqH8gHWI2LpIh8MiF9gWPy9eIKUpQBgD0yO0Ydu8CCmzvw55q4csjvZB2CtelxmEUSLw+o1X/ZdO+9JMNv7Se1MrE7BI9IlIfCW98hnPKusVuqAyR5pLoGTGd+7mVzT6vwhTZBEgB2pO9vLMO9POaUn6IPntU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=VCN2XXqS; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="VCN2XXqS"
Received: from 10511-DT-003.. (unknown [10.17.46.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4gw8w71r1HzKXPXTQ;
	Wed, 08 Jul 2026 15:33:27 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1783496007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D23xn9YQU7NkkxIZlgmhqsEm2yeIZ87b8WkOzyJSWFk=;
	b=VCN2XXqSRCK5cqItfQ1IVd7JO6LYlDmHywTwDH3S5pMUUtIyI07R7HzMOkOSwu8c9zf756
	OHps+XnAN6bgJGbF4h772M2JKOyTx3rkn82ccdTm2QPf4oWL+xPJZFUbzMeX260x6dXKlm
	EB41r1i+S6d4jCVwwe24yRdawbitDxU=
From: Ting-Chang Hou <tchou@synology.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	Ting-Chang Hou <tchou@synology.com>
Subject: [PATCH] libext2fs: fix fullmap icount allocation overflow on huge inode counts
Date: Wed,  8 Jul 2026 15:33:22 +0800
Message-Id: <20260708073322.404521-1-tchou@synology.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Auth: pass
Content-Type: text/plain

alloc_icount() computes the EXT2_ICOUNT_OPT_FULLMAP allocation size
in an "unsigned int":

	unsigned sz = sizeof(*icount->fullmap) * icount->num_inodes;

num_inodes is a 32-bit ext2_ino_t taken from s_inodes_count, so for
file systems with s_inodes_count >= 2^31 the assignment truncates the
product: at s_inodes_count == 2^31 the allocation collapses to zero
bytes, and at the ext4 maximum of 2^32 - 1 (seen in the field on an
84 TiB file system created with a dense inode ratio) only half of the
array is allocated.  Running e2fsck -E inode_count_fullmap on such a
file system then reads and writes gigabytes past the end of the
buffer in pass 2 and pass 4, corrupting e2fsck's own heap while it
decides what to repair.

The array is also one element too small on every file system: valid
inode numbers run from 1 to num_inodes inclusive and fullmap is
indexed by inode number, but only num_inodes elements are allocated,
so fullmap[num_inodes] is out of bounds.  Pass 4 fetches the count of
every inode up to and including s_inodes_count, so every fullmap run
performs a 2-byte out-of-bounds access of the last element.

Compute the size in size_t, allocate num_inodes + 1 entries, and skip
the fullmap optimization (falling back to the bitmap + list variant)
when the size would not fit in the unsigned long taken by
ext2fs_get_mem(), which also keeps the computation from wrapping on
32-bit builds.

Signed-off-by: Ting-Chang Hou <tchou@synology.com>
---
 lib/ext2fs/icount.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index 888a90b2..08b6bb28 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -115,8 +115,19 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 	icount->num_inodes = fs->super->s_inodes_count;
 
 	if ((flags & EXT2_ICOUNT_OPT_FULLMAP) &&
-	    (flags & EXT2_ICOUNT_OPT_INCREMENT)) {
-		unsigned sz = sizeof(*icount->fullmap) * icount->num_inodes;
+	    (flags & EXT2_ICOUNT_OPT_INCREMENT) &&
+	    icount->num_inodes < ~0UL / sizeof(*icount->fullmap)) {
+		/*
+		 * fullmap is indexed by inode number, which runs from
+		 * 1 to num_inodes inclusive; allocate num_inodes + 1
+		 * entries.  num_inodes can be as large as 2^32 - 1, so
+		 * compute the size in size_t and skip fullmap (falling
+		 * back to the bitmap + list variant below) where the
+		 * result would not fit in the unsigned long taken by
+		 * ext2fs_get_mem().
+		 */
+		size_t sz = sizeof(*icount->fullmap) *
+			((size_t) icount->num_inodes + 1);
 
 		retval = ext2fs_get_mem(sz, &icount->fullmap);
 		/* If we can't allocate, fall back */
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
