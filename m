From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: ext4_ext_convert_to_initialized bug found in extended FSX testing
Date: Tue, 10 May 2011 10:56:02 -0700
Message-ID: <4DC97C32.2020203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52267 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1EJR4R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 13:56:17 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4AHaLKS010340
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 13:36:21 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4AHu4Vf078916
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 13:56:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4AHu4BD012019
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 13:56:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

We've been trying to get punch hole through some extended fsx tests, and I ran across some other tests that were failing because the test file contained zeros where it shouldn't.  I made this fix to the ext4_ext_convert_to_initialized and the test has been running smooth for about an hour now.  Yongqiang, this one looks like it may have been associated with the split extents clean up patch.  Would you mind taking a look at this fix and giving it your ok if it looks good?  Thx!

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 e363f21... ce69450... M	fs/ext4/extents.c
 fs/ext4/extents.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..ce69450 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2819,7 +2819,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* case 3 */
 			zero_ex.ee_block =
 					 cpu_to_le32(map->m_lblk + map->m_len);
-			zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
+			zero_ex.ee_len = cpu_to_le16(ee_len -
+						allocated - map->m_len);
 			ext4_ext_store_pblock(&zero_ex,
 				ext4_ext_pblock(ex) + map->m_lblk - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex);
-- 
1.7.1

