From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Sat, 07 May 2011 16:54:27 -0700
Message-ID: <4DC5DBB3.9030207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54609 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab1EGXye (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 May 2011 19:54:34 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p47NXuEZ009595
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:33:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p47NsX99089342
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:33 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p47NsXaJ021649
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix for a null pointer bug found while running punch hole tests

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 3c7a06e... 3302a6c... M	fs/ext4/namei.c
 fs/ext4/namei.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3c7a06e..3302a6c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1422,7 +1422,8 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 */
 		ext4_mark_inode_dirty(handle, dir);
 		ext4_handle_dirty_metadata(handle, dir, frame->bh);
-		ext4_handle_dirty_metadata(handle, dir, bh);
+		if (bh)
+			ext4_handle_dirty_metadata(handle, dir, bh);
 		dx_release(frames);
 		return retval;
 	}
-- 
1.7.1

