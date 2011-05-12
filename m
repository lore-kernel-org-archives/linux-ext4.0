From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH v2] NULL pointer when make_indexed_dir returns -ENOSPC
Date: Thu, 12 May 2011 10:59:20 -0700
Message-ID: <4DCC1FF8.6040103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:58685 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223Ab1ELR7t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 13:59:49 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4CHhUkX028488
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 11:43:31 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4CHxOvp336408
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 11:59:36 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4CHxMJu010494
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 11:59:22 -0600
Received: from [9.11.169.103] (IBM-3CEFE379E05.tucson.ibm.com [9.11.169.103])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p4CHxMES010485
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 11:59:22 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I wasnt sure if people were expecting a v2 for this one, but I noticed 
the modified version of v1 was removed from the tree, so I am assuming 
we needed v2?  This one handles marking the buffer dirty before calling 
do split to avoid the null pointer.  It introduces a little overhead, 
but the only other option would be to introduce a new flag set to 
do_split.  But if there's any one that would prefer the flags to this 
solution, please let me know.  Thx! :)

Allison Henderson


Signed-off-by: Allison Henderson <achender@us.ibm.com>

---
:100644 100644 3c7a06e... b754b77... M	fs/ext4/namei.c
  fs/ext4/namei.c |    6 ++++--
  1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3c7a06e..b754b77 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1413,6 +1413,10 @@ static int make_indexed_dir(handle_t *handle, 
struct dentry *dentry,
  	frame->at = entries;
  	frame->bh = bh;
  	bh = bh2;
+
+	ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	ext4_handle_dirty_metadata(handle, dir, bh);
+
  	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
  	if (!de) {
  		/*
@@ -1421,8 +1425,6 @@ static int make_indexed_dir(handle_t *handle, 
struct dentry *dentry,
  		 * with corrupted filesystem.
  		 */
  		ext4_mark_inode_dirty(handle, dir);
-		ext4_handle_dirty_metadata(handle, dir, frame->bh);
-		ext4_handle_dirty_metadata(handle, dir, bh);
  		dx_release(frames);
  		return retval;
  	}
-- 
1.7.1

