From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH] ext4: Fix memory leak when verifying checksums in the journal
Date: Fri, 23 May 2008 22:48:08 -0400
Message-ID: <1211597288-1326-1-git-send-email-tytso@mit.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37299 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYEXMdH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2008 08:33:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/recovery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 5d0405a..7199db5 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -344,6 +344,7 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
 				     obh->b_size);
 		}
+		put_bh(obh);
 	}
 	return 0;
 }
-- 
1.5.4.1.144.gdfee-dirty

