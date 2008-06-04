From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: Fix memory leak when verifying checksums in the journal
Date: Wed,  4 Jun 2008 19:56:33 -0400
Message-ID: <1212623794-10183-1-git-send-email-tytso@mit.edu>
References: <20080604234057.GA9641@mit.edu>
Cc: Girish.Shilamkar@Sun.COM, adilger@sun.com,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Girish Shilamkar <girish@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51199 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762961AbYFDX4g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 19:56:36 -0400
In-Reply-To: <20080604234057.GA9641@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Girish Shilamkar <girish@clusterfs.com>
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

