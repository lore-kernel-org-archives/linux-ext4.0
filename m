From: "Amir G." <amir73il@users.sourceforge.net>
Subject: [PATCH] call ext4_forget() and ext4_free_blocks() in the same
	transaction
Date: Wed, 23 Jun 2010 22:01:44 +0300
Message-ID: <AANLkTinAEf7tTdc-XjcomfUX1gvltuWLjNP0kvJzYQhy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38169 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0FWTBq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jun 2010 15:01:46 -0400
Received: by bwz7 with SMTP id 7so117301bwz.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jun 2010 12:01:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We have experienced bitmap inconsistencies after crash during file
delete under heavy load.
The crash is not file system related and I the following patch in
ext4_free_branches() fixes the recovery problem.

If the transaction is restarted and there is a crash before the new
transaction is committed,
then after recovery, the blocks that this indirect block points to
have been freed, but the indirect block itself
has not been freed and may still point to some of the free blocks
(because of the ext4_forget()).

So ext4_forget() should be called inside ext4_free_blocks() to avoid
this problem.
Are there any consequences to this patch that I am not aware of?

Amir.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..682e2fa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4458,6 +4458,7 @@ static void ext4_free_branches(handle_t *handle,
struct inode *inode,
 {
        ext4_fsblk_t nr;
        __le32 *p;
+       int     flags;

        if (ext4_handle_is_aborted(handle))
                return;
@@ -4520,7 +4521,7 @@ static void ext4_free_branches(handle_t *handle,
struct inode *inode,
                         * revoke records must be emitted *before* clearing
                         * this block's bit in the bitmaps.
                         */
-                       ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
+                       flags =
EXT4_FREE_BLOCKS_METADATA|EXT4_FREE_BLOCKS_FORGET;

                        /*
                         * Everything below this this pointer has been
@@ -4546,8 +4547,7 @@ static void ext4_free_branches(handle_t *handle,
struct inode *inode,
                                            blocks_for_truncate(inode));
                        }

-                       ext4_free_blocks(handle, inode, 0, nr, 1,
-                                        EXT4_FREE_BLOCKS_METADATA);
+                       ext4_free_blocks(handle, inode, 0, nr, 1, flags);

                        if (parent_bh) {
                                /*
