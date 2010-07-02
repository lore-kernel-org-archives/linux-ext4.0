From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 6/6] block: remove RQ_NOIDLE from WRITE_SYNC
Date: Fri,  2 Jul 2010 15:58:19 -0400
Message-ID: <1278100699-24132-7-git-send-email-jmoyer@redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	tao.ma@oracle.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921Ab0GBT6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 15:58:33 -0400
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In trying to get fsync-ing processes to perform as well under CFQ as they
do in deadline, I found (with the current blk_yield approach) that it was
necessary to get rid of the RQ_NOIDLE flag for WRITE_SYNC I/O.  Instead,
we do explicit yielding of the I/O scheduler.

Comments, as always, are greatly appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..da34297 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -152,12 +152,12 @@ struct inodes_stat_t {
 #define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
-#define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
+#define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO))
 #define WRITE_SYNC	(WRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
 #define WRITE_ODIRECT_PLUG	(WRITE | (1 << BIO_RW_SYNCIO))
 #define WRITE_META	(WRITE | (1 << BIO_RW_META))
 #define SWRITE_SYNC_PLUG	\
-			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
+			(SWRITE | (1 << BIO_RW_SYNCIO))
 #define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
 
-- 
1.6.5.2

