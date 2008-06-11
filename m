From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: return error when calling ext4_ext_split failed
Date: Wed, 11 Jun 2008 13:58:02 +0800
Message-ID: <484F696A.4070703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62230 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYFKGB3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 02:01:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext4_ext_create_new_leaf must return error when its
calling to ext4_ext_split failed.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ff609df..177345d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -981,6 +981,8 @@ repeat:
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
 		err = ext4_ext_split(handle, inode, path, newext, i);
+		if (err)
+			goto out;
 
 		/* refill path */
 		ext4_ext_drop_refs(path);
-- 
1.5.4.5

