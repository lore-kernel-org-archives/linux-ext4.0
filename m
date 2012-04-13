From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH RESEND] ext4: change return value from int to ssize_t in ext4_file_write
Date: Fri, 13 Apr 2012 09:22:37 +0800
Message-ID: <1334280157-11630-1-git-send-email-wenqing.lz@taobao.com>
References: <20120412202029.GB19808@quack.suse.cz>
Cc: jouni.siren@iki.fi, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2DMBQg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2012 21:16:36 -0400
Received: by pbcun15 with SMTP id un15so3011855pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 Apr 2012 18:16:36 -0700 (PDT)
In-Reply-To: <20120412202029.GB19808@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 64-platform, when we do a write operation with a huge number of data, it
will cause that the ret variable overflows.  So it is replaced with ssize_t.

Reported-by: Jouni Siren <jouni.siren@iki.fi>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
Hi Jan,

You are right.  I have changed the commit log.  ;-)

Regards,
Zheng

 fs/ext4/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..8c7642a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -95,7 +95,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 	int unaligned_aio = 0;
-	int ret;
+	ssize_t ret;
 
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
-- 
1.7.4.1

