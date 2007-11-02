From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Thu, 01 Nov 2007 17:40:35 -0700
Message-ID: <1193964035.4014.23.camel@localhost.localdomain>
References: <46D7097F.4020501@linux.vnet.ibm.com>
	 <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56666 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbXKBAkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2007 20:40:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA20eZ4a008906
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2007 20:40:35 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA20eZPG484094
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2007 20:40:35 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA20eYU0011508
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2007 20:40:35 -0400
In-Reply-To: <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

JBD2: Fix NULL pointer bh->b_data on NUMA box with journal checksumming.

Current journal checksumming patch failed fsstress test on NUMA. The 
bh->b_data passed to the crc32_be () function could be NULL pointer, 
which caused kernel oops immediately when running fsstress with -o 
journal_checksum. It is because the page is part of highmem on NUMA box.
We need to kmap the page before access the bh->b_data to calculate
the checksums.
 
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/jbd2/commit.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.24-rc1/fs/jbd2/commit.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/jbd2/commit.c	2007-11-01 11:15:08.000000000 -0700
+++ linux-2.6.24-rc1/fs/jbd2/commit.c	2007-11-01 12:27:02.000000000 -0700
@@ -352,6 +352,20 @@ write_out_data:
 	journal_do_submit_data(wbuf, bufs);
 }
 
+static inline __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
+{
+	struct page *page = bh->b_page;
+	char *addr;
+	__u32 checksum;
+
+	addr = kmap(page);
+	checksum = crc32_be(crc32_sum,
+		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
+	kunmap(page);
+
+	return checksum;
+}
+
 static inline void write_tag_block(int tag_bytes, journal_block_tag_t *tag,
 				   unsigned long long block)
 {
@@ -715,9 +729,8 @@ start_journal_io:
 				 */
 				if (JBD2_HAS_COMPAT_FEATURE(journal,
 					JBD2_FEATURE_COMPAT_CHECKSUM)) {
-					crc32_sum = crc32_be(crc32_sum,
-							(void *)bh->b_data,
-							bh->b_size);
+					crc32_sum =
+					    jbd2_checksum_data(crc32_sum, bh);
 				}
 
 				lock_buffer(bh);
