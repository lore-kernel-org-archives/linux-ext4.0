From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 02/15][e2fsprogs] Add ext2_off64_t type.
Date: Wed, 20 Aug 2008 12:32:49 -0500
Message-ID: <20080820173249.23412.53872.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35239 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYHTRcG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 13:32:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHW42w004695
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHVtHY188834
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:57 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHViGD015307
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:45 -0600
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
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
 

