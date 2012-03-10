From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 6/6] Rename de patch6 from de to se scheme
Date: Fri,  9 Mar 2012 21:41:25 -0700
Message-ID: <1331354485-18515-7-git-send-email-achender@linux.vnet.ibm.com>
References: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46091 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab2CJEkz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 23:40:55 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 21:40:55 -0700
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 59AFFC40001
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 21:40:53 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2A4erAb235292
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:53 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2A4eqcc030622
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:52 -0700
In-Reply-To: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renames changes introduced by patch
"[PATCH_V3_6_6]_ext4_reimplement_ext4_find_delay_alloc_range_on_delayed_extent_tree"

All code referencing "delayed extents" or "de" are changed to
"status extents" or "se"

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 3f76625... bfcbde3... M	fs/ext4/extents.c
 fs/ext4/extents.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3f76625..bfcbde3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3268,11 +3268,11 @@ static int ext4_find_delalloc_range(struct inode *inode,
 				    ext4_lblk_t lblk_start,
 				    ext4_lblk_t lblk_end)
 {
-	struct delayed_extent de;
+	struct status_extent se;
 
-	de.start = lblk_start;
-	ext4_de_find_extent(inode, &de);
-	return (de.start + de.len) >= lblk_end && de.start <= lblk_start;
+	se.start = lblk_start;
+	ext4_se_find_extent(inode, &se);
+	return (se.start + se.len) >= lblk_end && se.start <= lblk_start;
 }
 
 int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk)
-- 
1.7.1

