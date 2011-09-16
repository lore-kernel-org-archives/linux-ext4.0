From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/25] libext2fs: Potential null ptr deref in undo_err_handler_init
Date: Fri, 16 Sep 2011 15:49:21 -0500
Message-ID: <1316206180-6375-7-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46735 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the !undo_io_backing_manager case, undo_err_handler_init
will be passed a null data->real, which will be dereferenced.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/undo_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 454f3b6..da1cf45 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -400,7 +400,8 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 	 * setup err handler for read so that we know
 	 * when the backing manager fails do short read
 	 */
-	undo_err_handler_init(data->real);
+	if (data->real)
+		undo_err_handler_init(data->real);
 
 	*channel = io;
 	return 0;
-- 
1.7.4.1

