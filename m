From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 2/4] ext3: truncate block allocated on a failed ext3_write_begin
Date: Sat, 13 Sep 2008 11:32:49 -0400
Message-ID: <1221319971-29879-2-git-send-email-tytso@mit.edu>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51022 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbYIMPds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 11:33:48 -0400
In-Reply-To: <1221319971-29879-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For blocksize < pagesize we need to remove blocks that got allocated in
block_write_begin() if we fail with ENOSPC for later blocks.
block_write_begin() internally does this if it allocated page
locally. This makes sure we don't have blocks outside inode.i_size
during ENOSPC.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 507d868..bff22b9 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1178,6 +1178,13 @@ write_begin_failed:
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-- 
1.5.6.1.205.ge2c7.dirty

