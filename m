From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: mark inode dirty after converting inline directory
Date: Wed, 22 Feb 2017 13:22:46 -0800
Message-ID: <20170222212246.60931-1-ebiggers3@gmail.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        stable@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36128 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932669AbdBVVXJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Feb 2017 16:23:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If ext4_convert_inline_data() was called on a directory with inline
data, the filesystem was left in an inconsistent state (as considered by
e2fsck) because the file size was not increased to cover the new block.
This happened because the inode was not marked dirty after i_disksize
was updated.  Fix this by marking the inode dirty at the end of
ext4_finish_convert_inline_dir().

This bug was probably not noticed before because most users mark the
inode dirty afterwards for other reasons.  But if userspace executed
FS_IOC_SET_ENCRYPTION_POLICY with invalid parameters, as exercised by
'kvm-xfstests -c adv generic/396', then the inode was never marked dirty
after updating i_disksize.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inline.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3a1f2822541b..75b29c25313c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1169,10 +1169,9 @@ static int ext4_finish_convert_inline_dir(handle_t *handle,
 	set_buffer_uptodate(dir_block);
 	err = ext4_handle_dirty_dirent_node(handle, inode, dir_block);
 	if (err)
-		goto out;
+		return err;
 	set_buffer_verified(dir_block);
-out:
-	return err;
+	return ext4_mark_inode_dirty(handle, inode);
 }
 
 static int ext4_convert_inline_data_nolock(handle_t *handle,
-- 
2.11.0.483.g087da7b7c-goog
