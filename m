From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 02/15][e2fsprogs] Add ext2_off64_t type.
Date: Tue, 15 Jul 2008 11:50:16 -0500
Message-ID: <20080715165016.28567.55723.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59515 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYGOQuT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 12:50:19 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGoH8X007913
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:17 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGoH63222284
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:17 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGoGnl006631
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:17 -0400
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add ext2_off64_t type.

The ext2_off_t is u32.  Creating a new 64-bit ext2_off64_t for 64bit
offsets.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
--

 lib/ext2fs/ext2fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 04a95a2..d9337aa 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -68,6 +68,7 @@ typedef __u32		blk_t;
 typedef __u64		blk64_t;
 typedef __u32		dgrp_t;
 typedef __u32		ext2_off_t;
+typedef __u64		ext2_off64_t;
 typedef __s64		e2_blkcnt_t;
 typedef __u32		ext2_dirhash_t;
 

