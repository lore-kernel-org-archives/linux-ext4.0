From: Dmitry Monakhov <dmonakhov@sw.ru>
Subject: [PATCH 1/3] ext4 block reservation fix3
Date: Fri, 22 Jun 2007 16:17:10 +0400
Message-ID: <20070622121710.GB395@localhost.sw.ru>
References: <20070622121509.GA395@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, devel@openvz.org
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:32220 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbXFVMQG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 08:16:06 -0400
Content-Disposition: inline
In-Reply-To: <20070622121509.GA395@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If ext4_reserve_block has failed we have to drop quota.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a9655f1..eacffd3 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1467,7 +1467,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	if (!(EXT4_I(inode)->i_state & EXT4_STATE_BLOCKS_RESERVED)) {
 		*errp = ext4_reserve_blocks(sb, num);
 		if (*errp)
-			return 0;
+			goto out;
 		reserved = num;
 	}
 
-- 
1.5.2
