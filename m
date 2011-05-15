From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH v3] ext4: ext4_ext_convert_to_initialized bug found in extended
 FSX testing
Date: Sun, 15 May 2011 08:08:29 -0700
Message-ID: <4DCFEC6D.1040508@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43865 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab1EOPIj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 May 2011 11:08:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4FEjX5h028825
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 10:45:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4FF8cQr082334
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 11:08:38 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4FF8cBR025478
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 11:08:38 -0400
Received: from [9.48.119.10] (sig-9-48-119-10.mts.ibm.com [9.48.119.10])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p4FF8c6v025432
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 11:08:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v1 -> v2
- Extent is now zeroed starting from map.m_len
- Return value changed to return the number of 
  blocks split out

v2 -> v3
- Corrected patch description

This patch addresses bugs found while testing punch hole 
with the fsx test.  The patch corrects the number of blocks
that are zeroed out while splitting an extent, and also corrects
the return value to return the number of blocks split out, instead
of the number of blocks zeroed out.

This patch has been tested in addition to the following patches: 
[Ext4 punch hole v7]
[XFS Tests Punch Hole 1/1 v2] Add Punch Hole Testing to FSX

The test ran successfully for 24 hours.

Signed-off-by: Allison Henderson <achender@us.ibm.com>

---
:100644 100644 e363f21... 5f243da... M	fs/ext4/extents.c
 fs/ext4/extents.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..5f243da 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2818,8 +2818,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 3 */
 			zero_ex.ee_block =
-					 cpu_to_le32(map->m_lblk + map->m_len);
-			zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
+					 cpu_to_le32(map->m_lblk);
+			zero_ex.ee_len = cpu_to_le16(allocated);
 			ext4_ext_store_pblock(&zero_ex,
 				ext4_ext_pblock(ex) + map->m_lblk - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex);
@@ -2842,10 +2842,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 					goto out;
 			}
 
-			allocated = map->m_lblk - ee_block + map->m_len;
