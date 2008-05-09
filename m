From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 1/9][e2fsprogs] Add ext2_off64_t type.
Date: Fri, 09 May 2008 11:39:34 -0500
Message-ID: <20080509163934.15484.77567.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57626 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbYEIQjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 May 2008 12:39:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GfFxr003595
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:41:15 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49Gd55B120480
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49Gd417006327
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:05 -0400
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
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

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7a1d966..4eb14d4 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -68,6 +68,7 @@ typedef __u32		blk_t;
 typedef __u64		blk64_t;
 typedef __u32		dgrp_t;
 typedef __u32		ext2_off_t;
+typedef __u64		ext2_off64_t;
 typedef __s64		e2_blkcnt_t;
 typedef __u32		ext2_dirhash_t;
 

