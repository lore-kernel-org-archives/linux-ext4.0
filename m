From: David Howells <dhowells@redhat.com>
Subject: (unknown)
Date: Wed, 1 Apr 2009 19:10:01 -0400
Message-ID: <200904012310.n31NA1Y5004845@ns3.rdu.redhat.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38489 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934849AbZDAXLL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2009 19:11:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From dhowells  Thu Apr  2 00: 05:30 2009
Return-Path: dhowells@redhat.com
Received: from localhost.localdomain [127.0.0.1]
	by warthog.procyon.org.uk with IMAP (fetchmail-6.3.8)
	for <dhowells@localhost> (single-drop); Thu, 02 Apr 2009 00:05:30 +0100 (BST)
Received: from zmta02.collab.prod.int.phx2.redhat.com (LHLO
 zmta02.collab.prod.int.phx2.redhat.com) (10.5.5.32) by
 mail06.corp.redhat.com with LMTP; Wed, 1 Apr 2009 19:05:13 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 579379DA49
	for <dhowells@redhat.com>; Wed,  1 Apr 2009 19:05:13 -0400 (EDT)
Received: from zmta02.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta02.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WdDUt3-6Hr9d for <dhowells@redhat.com>;
	Wed,  1 Apr 2009 19:05:13 -0400 (EDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 2FF169DA44
	for <dhowells@mail.corp.redhat.com>; Wed,  1 Apr 2009 19:05:13 -0400 (EDT)
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n31N5C1O024798;
	Wed, 1 Apr 2009 19:05:12 -0400
Received: from warthog.cambridge.redhat.com (kibblesnbits.boston.devel.redhat.com [10.16.60.12])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n31N5B5i004590;
	Wed, 1 Apr 2009 19:05:11 -0400
Received: from [127.0.0.1] (helo=warthog.procyon.org.uk)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.69 #1 (Red Hat Linux))
	id 1Lp9Uc-0007SA-3u; Thu, 02 Apr 2009 00:05:10 +0100
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/43] CacheFiles: Be consistent about the use of mapping vs
	file->f_mapping in Ext3 [ver #46]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org,
    linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 02 Apr 2009 00:05:10 +0100
Message-ID: <20090401230510.28177.98253.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.58 on 172.16.27.26
Resent-To: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Resent-cc: linux-ext4@vger.kernel.org
Resent-Date: Thu, 02 Apr 2009 00:10:00 +0100
Resent-Message-ID: <29219.1238627400@redhat.com>
Resent-From: David Howells <dhowells@redhat.com>

Change all the usages of file->f_mapping in ext3_*write_end() functions to use
the mapping argument directly.  This has two consequences:

 (*) Consistency.  Without this patch sometimes one is used and sometimes the
     other is.

 (*) A NULL file pointer can be passed.  This feature is then made use of by
     the generic hook in the next patch, which is used by CacheFiles to write
     pages to a file without setting up a file struct.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/ext3/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4a09ff1..d897033 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1231,7 +1231,7 @@ static int ext3_generic_write_end(struct file *file,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
@@ -1256,7 +1256,7 @@ static int ext3_ordered_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	unsigned from, to;
 	int ret = 0, ret2;
 
@@ -1298,7 +1298,7 @@ static int ext3_writeback_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 

