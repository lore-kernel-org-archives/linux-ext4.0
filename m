From: Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 3/4] ext4: use direct_IO_no_locking in ext4 DIO read
Date: Tue, 15 Dec 2009 17:40:54 -0800
Message-ID: <5df78e1d0912151740m53995bcck3dd6e1b68684f73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:43769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZLPBk7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 20:40:59 -0500
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id nBG1ewR1019583
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:40:58 -0800
Received: from pxi5 (pxi5.prod.google.com [10.243.27.5])
	by wpaz9.hot.corp.google.com with ESMTP id nBG1ePre012209
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:40:56 -0800
Received: by pxi5 with SMTP id 5so343088pxi.12
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:40:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: use direct_IO_no_locking in ext4 dio read.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: git-ext4/fs/ext4/inode.c
===================================================================
--- git-ext4.orig/fs/ext4/inode.c       2009-12-15 16:03:15.000000000 -0800
+++ git-ext4/fs/ext4/inode.c    2009-12-15 16:04:03.000000000 -0800
@@ -3580,7 +3580,15 @@ static ssize_t ext4_ind_direct_IO(int rw
       }

 retry:
-       ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+       if (rw == READ && test_opt(inode->i_sb, DIOREAD_NOLOCK)
+                       && (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+               ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
+                                inode->i_sb->s_bdev, iov,
+                                offset, nr_segs,
+                                ext4_get_block, NULL);
+       else
+               ret = blockdev_direct_IO(rw, iocb, inode,
+                                inode->i_sb->s_bdev, iov,
                                offset, nr_segs,
                                ext4_get_block, NULL);
       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
