From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 1/4][e2fsprogs] Reserve the INCOMPAT feature number for FLEX_BG.
Date: Thu, 02 Aug 2007 23:00:47 -0500
Message-ID: <20070803040047.29456.49873.stgit@gara>
References: <20070803040041.29456.31454.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60216 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbXHCEDO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2007 00:03:14 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7343DaL026852
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:13 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7343D9b533602
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:13 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7343D5C014339
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:13 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7343A4T014153
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:10 -0400
Received: from [127.0.1.1] (sig-9-65-28-26.mts.ibm.com [9.65.28.26])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l73439wO062352
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 23:03:10 -0500
In-Reply-To: <20070803040041.29456.31454.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Reserve the INCOMPAT feature number for FLEX_BG.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..2394857 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -640,6 +640,7 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
