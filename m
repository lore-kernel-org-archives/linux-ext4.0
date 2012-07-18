From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH 2/2] ext4: Add missing space to trace message
Date: Wed, 18 Jul 2012 10:07:34 -0700
Message-ID: <1342631254-23891-2-git-send-email-anatol.pomozov@gmail.com>
References: <1342631254-23891-1-git-send-email-anatol.pomozov@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	Anatol Pomozov <anatol.pomozov@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:45829 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2GRRHq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jul 2012 13:07:46 -0400
Received: by yhl10 with SMTP id 10so186967yhl.1
        for <linux-ext4@vger.kernel.org>; Wed, 18 Jul 2012 10:07:46 -0700 (PDT)
In-Reply-To: <1342631254-23891-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 include/trace/events/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index db67c71..d49b285 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -320,7 +320,7 @@ TRACE_EVENT(ext4_da_writepages,
 	),
 
 	TP_printk("dev %d,%d ino %lu nr_to_write %ld pages_skipped %ld "
-		  "range_start %lld range_end %lld sync_mode %d"
+		  "range_start %lld range_end %lld sync_mode %d "
 		  "for_kupdate %d range_cyclic %d writeback_index %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->nr_to_write,
-- 
1.7.11.2

