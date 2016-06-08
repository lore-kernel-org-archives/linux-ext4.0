From: mchristi@redhat.com
Subject: [PATCH 2/2] mg_disk: fix enum REQ_OP_ kbuild error
Date: Wed,  8 Jun 2016 15:49:41 -0500
Message-ID: <1465418981-7360-3-git-send-email-mchristi@redhat.com>
References: <1465418981-7360-1-git-send-email-mchristi@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
To: linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425323AbcFHUtr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2016 16:49:47 -0400
In-Reply-To: <1465418981-7360-1-git-send-email-mchristi@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mike Christie <mchristi@redhat.com>

Because we define WRITE/READ as REQ_OPs, we cannot do
switch (rq_data_dir(request))
case READ
....
case WRITE
...

without getting warnings about handling other REQ_OPs.

This just has mq_disk do a if/else like it does in other
places.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/mg_disk.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 145ce2a..1ee3918 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -687,15 +687,13 @@ static unsigned int mg_issue_req(struct request *req,
 		unsigned int sect_num,
 		unsigned int sect_cnt)
 {
-	switch (rq_data_dir(req)) {
-	case READ:
+	if (rq_data_dir(req) == READ) {
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
 				!= MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
-		break;
-	case WRITE:
+	} else {
 		/* TODO : handler */
 		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr)
@@ -714,7 +712,6 @@ static unsigned int mg_issue_req(struct request *req,
 		mod_timer(&host->timer, jiffies + 3 * HZ);
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
-		break;
 	}
 	return MG_ERR_NONE;
 }
-- 
2.7.2

