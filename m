From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 6/6] ext4: update extent status tree after an extent is zeroed out
Date: Thu, 28 Feb 2013 22:45:29 +0400
Message-ID: <87621cxoom.fsf@openvz.org>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com> <1362076004-10087-7-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62532 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759497Ab3B1Spf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:45:35 -0500
Received: by mail-lb0-f169.google.com with SMTP id m4so1642772lbo.14
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:45:33 -0800 (PST)
In-Reply-To: <1362076004-10087-7-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  1 Mar 2013 02:26:44 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When we try to split an extent, this extent could be zeroed out and mark
> as initialized.  But we don't know this in ext4_map_blocks because it
> only returns a allocated length of extent.  Meanwhile we will mark this
> extent as uninitialized because we only check m_flags.
> 
> This commit update extent status tree when we try to split an unwritten
> extent.  We don't need to worry about the status of this extent because
> we always mark it as initialized.
Your solution seems too complex, why not just update es_cache inside 
ext4_ext_zeroout() like this:

>From e0565336c9ea540b0297781196453b358c3c3313 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 28 Feb 2013 22:40:14 +0400
Subject: [PATCH] ext4: update status tree on extent zeroout


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c           |    4 ++++
 include/trace/events/ext4.h |   27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c89e850..15cc324 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2885,12 +2885,16 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 	unsigned int ee_len;
 	int ret;
 
+	trace_ext4_ext_zeroout(inode, ex);
 	ee_len    = ext4_ext_get_actual_len(ex);
 	ee_pblock = ext4_ext_pblock(ex);
 
 	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len, GFP_NOFS);
 	if (ret > 0)
 		ret = 0;
+	if (!ret)
+		ret = ext4_es_insert_extent(inode, le32_to_cpu(ex->ee_block),
+					    ee_len, ee_pblock, EXTENT_STATUS_WRITTEN);
 
 	return ret;
 }
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index c0457c0..cd750a6 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2092,6 +2092,33 @@ TRACE_EVENT(ext4_ext_remove_space_done,
 		  (unsigned short) __entry->eh_entries)
 );
 
+TRACE_EVENT(ext4_ext_zeroout,
+	TP_PROTO(struct inode *inode, struct ext4_extent *ex),
+
+	TP_ARGS(inode, ex),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev	)
+		__field(	ino_t,		ino	)
+		__field(	ext4_lblk_t,	u_lblk	)
+		__field(	unsigned,	u_len	)
+		__field(	ext4_fsblk_t,	u_pblk	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->u_lblk		= le32_to_cpu(ex->ee_block);
+		__entry->u_len		= ext4_ext_get_actual_len(ex);
+		__entry->u_pblk		= ext4_ext_pblock(ex);
+	),
+
+	TP_printk("dev %d,%d ino %lu ee_lblk %u ee_len %u ee_pblk %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->u_lblk, __entry->u_len, __entry->u_pblk)
+);
+
 TRACE_EVENT(ext4_es_insert_extent,
 	TP_PROTO(struct inode *inode, struct extent_status *es),
 
-- 
1.7.1


