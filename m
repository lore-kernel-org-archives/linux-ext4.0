From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ext4: Mark the buffer_heads as dirty and uptodate after prepare_write
Date: Fri,  7 Nov 2008 15:12:28 +0530
Message-ID: <1226050948-32221-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	vallesroc@gmail.com, Solofo.Ramangalahy@bull.net,
	cryptooctoploid@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57594 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKGJpP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 04:45:15 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA79i32t003022
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:44:03 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA79gglu065032
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:42:42 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA79gfYB028126
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:42:42 +1100
In-Reply-To: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure we mark the buffer_heads as dirty and uptodate
so that block_write_full_page write them correctly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 95d0d12..d986018 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2351,6 +2351,8 @@ static int ext4_da_writepage(struct page *page,
 			unlock_page(page);
 			return 0;
 		}
+		/* now mark the buffer_heads as dirty and uptodate */
+		block_commit_write(page, 0, PAGE_CACHE_SIZE);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-- 
1.6.0.3.640.g6331a

