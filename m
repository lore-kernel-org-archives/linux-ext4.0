From: David Moore <dmoorefo@gmail.com>
Subject: [PATCH] ext4: BUG_ON assertion repeated for inode1, not done for
 inode2
Date: Tue, 26 May 2015 10:42:06 -0700
Message-ID: <5564B06E.6000604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35164 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbbEZRmO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2015 13:42:14 -0400
Received: by pdea3 with SMTP id a3so95731176pde.2
        for <linux-ext4@vger.kernel.org>; Tue, 26 May 2015 10:42:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During a source code review of fs/ext4/extents.c I noted identical
consecutive lines. An assertion is repeated for inode1 and never done
for inode2. This is not in keeping with the rest of the code in the
ext4_swap_extents function and appears to be a bug.

Assert that the inode2 mutex is not locked.

Signed-off-by: David Moore <dmoorefo@gmail.com>
---
  fs/ext4/extents.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e003a1e..f38a6d6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5542,7 +5542,7 @@ ext4_swap_extents(handle_t *handle, struct inode 
*inode1,
BUG_ON(!rwsem_is_locked(&EXT4_I(inode1)->i_data_sem));
BUG_ON(!rwsem_is_locked(&EXT4_I(inode2)->i_data_sem));
         BUG_ON(!mutex_is_locked(&inode1->i_mutex));
-       BUG_ON(!mutex_is_locked(&inode1->i_mutex));
+       BUG_ON(!mutex_is_locked(&inode2->i_mutex));

         *erp = ext4_es_remove_extent(inode1, lblk1, count);
         if (unlikely(*erp))

