From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] xfs: Fix possible use-after-free with AIO
Date: Wed, 30 Jan 2013 00:27:59 +0100
Message-ID: <1359502081-20240-3-git-send-email-jack@suse.cz>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, Ben Myers <bpm@sgi.com>,
	stable@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3A2X2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 18:28:17 -0500
In-Reply-To: <1359502081-20240-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: xfs@oss.sgi.com
CC: Ben Myers <bpm@sgi.com>
CC: stable@vger.kernel.org
Reviewed-by: Ben Myers <bpm@sgi.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4111a40..5f707e5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -86,11 +86,11 @@ xfs_destroy_ioend(
 	}
 
 	if (ioend->io_iocb) {
+		inode_dio_done(ioend->io_inode);
 		if (ioend->io_isasync) {
 			aio_complete(ioend->io_iocb, ioend->io_error ?
 					ioend->io_error : ioend->io_result, 0);
 		}
-		inode_dio_done(ioend->io_inode);
 	}
 
 	mempool_free(ioend, xfs_ioend_pool);
-- 
1.7.1

