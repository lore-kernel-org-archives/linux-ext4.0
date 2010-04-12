From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: mark sparse journal as invalid
Date: Mon, 12 Apr 2010 17:36:33 -0500
Message-ID: <4BC3A071.4030501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab0DLWgi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 18:36:38 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3CMacm0031044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 18:36:38 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o3CMaXGp029893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 18:36:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For a filesystem that fails with:

journal_bmap: journal block not found at offset 7334 on loop0
JBD: bad block at offset 7334

e2fsck won't actually fix this; it will mark the fs as clean,
so it will mount, but it does not fix that block, and when the
journal reaches this point again it will fail again.

The following simple change to process_journal_block() might be
a little drastic; it will clear & recreate the journal inode if
it's sparse - i.e. if it gets block 0.

I suppose we could be more complicated and try to replay the journal
up to the error, but I'm not sure it's worth it since we're fscking
it anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 57783eb..4e6a7c3 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -214,7 +214,7 @@ static int process_journal_block(ext2_filsys fs,
 
 	p = (struct process_block_struct *) priv_data;
 
-	if (blk < fs->super->s_first_data_block ||
+	if (!blk || blk < fs->super->s_first_data_block ||
 	    blk >= ext2fs_blocks_count(fs->super))
 		return BLOCK_ABORT;
 

