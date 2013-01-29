From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ocfs2: Fix possible use-after-free with AIO
Date: Wed, 30 Jan 2013 00:28:00 +0100
Message-ID: <1359502081-20240-4-git-send-email-jack@suse.cz>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>,
	stable@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3A2X2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 18:28:17 -0500
In-Reply-To: <1359502081-20240-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel@oss.oracle.com
CC: stable@vger.kernel.org
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..340bd02 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -593,9 +593,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
 
+	inode_dio_done(inode);
 	if (is_async)
 		aio_complete(iocb, ret, 0);
-	inode_dio_done(inode);
 }
 
 /*
-- 
1.7.1

