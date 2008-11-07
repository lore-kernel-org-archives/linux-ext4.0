From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] ext4: Mark the buffer_heads as dirty and uptodate after prepare_write
Date: Fri,  7 Nov 2008 18:42:43 +0530
Message-ID: <1226063563-16220-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	vallesroc@gmail.com, Solofo.Ramangalahy@bull.net,
	cryptooctoploid@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:54595 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYKGNMx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 08:12:53 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA7DC6Tc005867
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 00:12:06 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA7DCuOV4882546
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 00:12:56 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA7DCox4031555
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 00:12:51 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure we mark the buffer_heads as dirty and uptodate
so that block_write_full_page write them correctly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 95d0d12..f9461d7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2333,6 +2333,15 @@ static int ext4_da_writepage(struct page *page,
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
 						ext4_normal_get_block_write);
 		if (!ret) {
+			/*
+			 * We mark the buffer_head dirty and uptodate even
+			 * if we are not doing a block_write_full_page. This
+			 * make sure when writeback see the page again with
+			 * buffer_head present the buffer_head would have
+			 * the right flags
+			 */
+			block_commit_write(page, 0, PAGE_CACHE_SIZE);
+
 			page_bufs = page_buffers(page);
 			/* check whether all are mapped and non delay */
 			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-- 
1.6.0.3.640.g6331a

