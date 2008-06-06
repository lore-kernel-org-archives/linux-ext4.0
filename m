From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] vfs: Don't flush delay buffer to disk
Date: Fri,  6 Jun 2008 23:54:50 +0530
Message-ID: <1212776693-435-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212776693-435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:33373 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYFFSZ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:25:28 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m56IOqJo024973
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:24:52 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56ITbxG283846
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:29:37 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56IPPRX031758
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:26 +1000
In-Reply-To: <1212776693-435-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

In block_write_full_page() error case, we need to check the
delayed flag before flush bh to disk when trying to recover from
error.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2f86ca5..06b887d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1775,7 +1775,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	bh = head;
 	/* Recovery: lock and submit the mapped buffers */
 	do {
-		if (buffer_mapped(bh) && buffer_dirty(bh)) {
+		if (buffer_mapped(bh) && buffer_dirty(bh) &&
+						!buffer_delay(bh)) {
 			lock_buffer(bh);
 			mark_buffer_async_write(bh);
 		} else {
-- 
1.5.5.1.357.g1af8b.dirty

