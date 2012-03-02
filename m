From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/4 v2] ext4: Always set then trimmed blocks count into len
Date: Fri,  2 Mar 2012 13:11:57 +0100
Message-ID: <1330690318-22627-3-git-send-email-lczerner@redhat.com>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854Ab2CBMMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 07:12:10 -0500
In-Reply-To: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently if the range to trim is too small, for example on 1K fs
the request to trim the first block, then the 'range->len' is not set
reporting wrong number of discarded block to the caller.

Fix this by always setting the 'range->len' before we return. Note that
when there is a failure (-EINVAL) caller can not depend on 'range->len'
being set properly.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: nothing changed

 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f20688e..8f817f2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5092,11 +5092,11 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		 */
 		first_cluster = 0;
 	}
-	range->len = trimmed * sb->s_blocksize;
 
 	if (!ret)
 		atomic_set(&EXT4_SB(sb)->s_last_trim_minblks, minlen);
 
 out:
+	range->len = trimmed * sb->s_blocksize;
 	return ret;
 }
-- 
1.7.4.4

