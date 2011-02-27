From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ext4: nblocks arg to ext4_truncate_restart_trans() is ignored
Date: Sun, 27 Feb 2011 11:54:28 +0200
Message-ID: <AANLkTikjhsA0ooZAkS4zhaMrFidOgpjuk54cTxu30Xb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1B0Jy3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 04:54:29 -0500
Received: by qwd7 with SMTP id 7so2192408qwd.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Feb 2011 01:54:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

nblocks is passed into ext4_truncate_restart_trans() from
ext4_ext_truncate_extend_restart() with a value different from the default
blocks_for_truncate(), but is being ignored.

The two other calls to ext4_truncate_restart_trans() already pass the
default value, which is then being recalculated inside the function.

Fix the problem by using the passed argument.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..33b970c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -173,7 +173,7 @@ int ext4_truncate_restart_trans(handle_t *handle,
struct inode *inode,
        BUG_ON(EXT4_JOURNAL(inode) == NULL);
        jbd_debug(2, "restarting handle %p\n", handle);
        up_write(&EXT4_I(inode)->i_data_sem);
-       ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
+       ret = ext4_journal_restart(handle, nblocks);
        down_write(&EXT4_I(inode)->i_data_sem);
        ext4_discard_preallocations(inode);

--
1.7.0.4
