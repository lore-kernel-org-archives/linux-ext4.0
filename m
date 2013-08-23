From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 7/7] xfs: Defer mmap cmtime updates
Date: Thu, 22 Aug 2013 17:03:23 -0700
Message-ID: <67df6fbc92d9b92a8301b4ad72e2a760d5e662df.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
	Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51796 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3HWADx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Aug 2013 20:03:53 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so2580584pdj.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Aug 2013 17:03:53 -0700 (PDT)
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This involves a change to block_page_mkwrite.  xfs is the only user.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/buffer.c       | 7 -------
 fs/xfs/xfs_aops.c | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..408677c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2431,13 +2431,6 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
 
 	sb_start_pagefault(sb);
-
-	/*
-	 * Update file times before taking page lock. We may end up failing the
-	 * fault so this update may be superfluous but who really cares...
-	 */
-	file_update_time(vma->vm_file);
