From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 2/5] mbcache: don't BUG() if entry cache cannot be allocated
Date: Sat, 26 Nov 2016 22:17:58 -0800
Message-ID: <1480227481-98535-2-git-send-email-ebiggers@google.com>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34785 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbcK0GSe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:18:34 -0500
Received: by mail-pf0-f177.google.com with SMTP id c4so19597119pfb.1
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:18:27 -0800 (PST)
In-Reply-To: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mbcache can be a module that is loaded long after startup, when someone
asks to mount an ext2 or ext4 filesystem.  Therefore it should not BUG()
if kmem_cache_create() fails, but rather just fail the module load.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/mbcache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 31e54c2..c56ab21 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -420,7 +420,8 @@ static int __init mbcache_init(void)
 	mb_entry_cache = kmem_cache_create("mbcache",
 				sizeof(struct mb_cache_entry), 0,
 				SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
-	BUG_ON(!mb_entry_cache);
+	if (!mb_entry_cache)
+		return -ENOMEM;
 	return 0;
 }
 
-- 
2.8.0.rc3.226.g39d4020

