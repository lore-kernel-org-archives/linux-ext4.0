From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ext4: fix callers of ext4_handle_release_buffer() API
Date: Tue, 1 Mar 2011 15:30:24 +0200
Message-ID: <AANLkTi=KXX9zjBKSGs18OpZUzOD-yyKj9hNVSBi_iBAB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48606 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1CANa0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 08:30:26 -0500
Received: by qyk7 with SMTP id 7so3243516qyk.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 05:30:26 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_handle_release_buffer() is an API, which is not being used properly.
This is not so bad considering that it calls jbd2_journal_release_buffer(),
which does nothing, but the snapshots implementation of this API does
something.

ext4_jbd2.h defines 2 identical wrapper functions:
ext4_journal_release_buffer() and ext4_handle_release_buffer().
The former has no callers, so it was removed.

There are 2 users of the API:
ext4_new_inode() calls ext4_handle_release_buffer() and
ext4_xattr_block_set() calls jbd2_journal_release_buffer() directly.
The latter was chagned to call the wrapper API.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/ext4_jbd2.h |    7 -------
 fs/ext4/xattr.c     |    2 +-
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d8b992e..e25e99b 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -202,13 +202,6 @@ static inline int
ext4_handle_has_enough_credits(handle_t *handle, int needed)
 	return 1;
 }

-static inline void ext4_journal_release_buffer(handle_t *handle,
-						struct buffer_head *bh)
-{
-	if (ext4_handle_valid(handle))
-		jbd2_journal_release_buffer(handle, bh);
-}
