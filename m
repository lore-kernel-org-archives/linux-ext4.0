From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Ext4 tree backports for 2.6.27.19 and 2.6.28.7
Date: Tue, 24 Feb 2009 15:45:38 -0500
Message-ID: <20090224154538.6f57094a@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbZBXUqa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 15:46:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the 2.6.27 series, commit 19815ad26f2d60e3ce390fca4d18ad729c9f5f42
has an extra chunk. I applied this patch after the series to fix it:


In file included from fs/ocfs2/alloc.c:42:
fs/ocfs2/journal.h: In function 'ocfs2_jbd2_file_inode':
fs/ocfs2/journal.h:420: error: implicit declaration of function 'jbd2_journal_file_inode'
fs/ocfs2/journal.h:420: error: 'struct ocfs2_inode_info' has no member named 'ip_jinode'
fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
fs/ocfs2/journal.h:426: error: implicit declaration of function 'jbd2_journal_begin_ordered_truncate'
fs/ocfs2/journal.h:428: error: 'struct ocfs2_inode_info' has no member named 'ip_jinode'

[caused by the ext4 patch queue]

--- linux-2.6.27.noarch.orig/fs/ocfs2/journal.h
+++ linux-2.6.27.noarch/fs/ocfs2/journal.h
@@ -415,17 +415,4 @@ static inline int ocfs2_calc_tree_trunc_
 	return credits;
 }
 
-static inline int ocfs2_jbd2_file_inode(handle_t *handle, struct inode *inode)
-{
-	return jbd2_journal_file_inode(handle, &OCFS2_I(inode)->ip_jinode);
-}
