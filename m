From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 1/4][e2fsprogs] Reserve the INCOMPAT feature number for FLEX_BG.
Date: Mon, 13 Aug 2007 23:32:51 -0500
Message-ID: <20070814043251.32206.86301.stgit@gara>
References: <20070814043245.32206.34785.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45358 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192AbXHNEdB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Aug 2007 00:33:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7E4X04U024271
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:00 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7E4X0iK206986
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 22:33:00 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7E4X0ZM001574
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 22:33:00 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7E4WxMk001565
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 22:32:59 -0600
Received: from [127.0.1.1] (sig-9-65-58-9.mts.ibm.com [9.65.58.9])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7E4WxSG040300
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 23:32:59 -0500
In-Reply-To: <20070814043245.32206.34785.stgit@gara>
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
