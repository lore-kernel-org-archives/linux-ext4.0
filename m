From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 04/11] jbd2:  use NULL instead of 0 when pointer is needed
Date: Fri, 30 Apr 2010 09:34:31 -0400
Message-ID: <1272634478-4127-5-git-send-email-wfp5p@virginia.edu>
References: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu>
Cc: linux-ext4@vger.kernel.org
To: trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:53042 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0D3SU6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 14:20:58 -0400
In-Reply-To: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes sparse warning:

fs/jbd2/journal.c:1892:9: warning: Using plain integer as NULL pointer

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
CC: linux-ext4@vger.kernel.org
---
 fs/jbd2/journal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c03d4dc..bc2ff59 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1889,7 +1889,7 @@ static struct kmem_cache *get_slab(size_t size)
 	BUG_ON(i >= JBD2_MAX_SLABS);
 	if (unlikely(i < 0))
 		i = 0;
-	BUG_ON(jbd2_slab[i] == 0);
+	BUG_ON(jbd2_slab[i] == NULL);
 	return jbd2_slab[i];
 }
 
-- 
1.7.0.6

