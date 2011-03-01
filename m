From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] jbd2: add the h_cowing flag and debug counters to
 jbd2_journal_handle struct
Date: Tue, 1 Mar 2011 16:57:54 +0200
Message-ID: <AANLkTinXEtHBLH=aDt0tHZQfWFaU-38EGWDRLQJJ8nmM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44619 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1CAO5z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 09:57:55 -0500
Received: by qwd7 with SMTP id 7so3723184qwd.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 06:57:54 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The h_cowing flag is used by ext4 snapshots code to mark the task in COWING
state.

The h_XXX_credits fields are used to track buffer credits usage (accounted by
COW and non-COW operations).

The h_cow_XXX fields are used as per task debugging counters.

Merging this patch to kernel 2.6.39, will allow users to test ext4
snapshots as a standalone module (with debug counters enabled), without
the need to patch and install a development kernel.

With CONFIG_JBD2_DEBUG not defined, this patch doesn't change the size of
the struct.

With CONFIG_JBD2_DEBUG defined, the struct grows by 7 int fields, but since
CONFIG_JBD2_DEBUG is mostly defined on development kernels, and since the
size of objects associated with a task is much larger that 7 ints, that
doesn't seem to be a big problem.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 include/linux/jbd2.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 27e79c2..1f22e43 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -435,10 +435,32 @@ struct jbd2_journal_handle
 	unsigned int	h_sync:		1;	/* sync-on-close */
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+	unsigned int	h_cowing:	1;	/* COWing block to snapshot */
+
+	/* Number of buffers requested by user:
+	 * (before adding the COW credits factor) */
+	unsigned int	h_base_credits:	14;
+
+	/* Number of buffers the user is allowed to dirty:
+	 * (counts only buffers dirtied when !h_cowing) */
+	unsigned int	h_user_credits:	14;
+

 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	h_lockdep_map;
 #endif
+
+#ifdef CONFIG_JBD2_DEBUG
+	/* COW debugging counters: */
+	unsigned int h_cow_moved; /* blocks moved to snapshot */
+	unsigned int h_cow_copied; /* blocks copied to snapshot */
+	unsigned int h_cow_ok_jh; /* blocks already COWed during current
+				     transaction */
+	unsigned int h_cow_ok_bitmap; /* blocks not set in COW bitmap */
+	unsigned int h_cow_ok_mapped;/* blocks already mapped in snapshot */
+	unsigned int h_cow_bitmaps; /* COW bitmaps created */
+	unsigned int h_cow_excluded; /* blocks set in exclude bitmap */
+#endif
 };


-- 
1.7.0.4
