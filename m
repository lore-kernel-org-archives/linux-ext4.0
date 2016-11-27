From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/5] mbcache: remove unnecessary module_get/module_put
Date: Sat, 26 Nov 2016 22:17:59 -0800
Message-ID: <1480227481-98535-3-git-send-email-ebiggers@google.com>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33648 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbcK0GSd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:18:33 -0500
Received: by mail-pf0-f171.google.com with SMTP id d2so19603561pfd.0
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:18:29 -0800 (PST)
In-Reply-To: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When mbcache is built as a module, any modules that use it (ext2 and/or
ext4) will depend on its symbols directly, incrementing its reference
count.  Therefore, there is no need to do module_get/module_put.

Also note that since the module_get/module_put were in the mbcache
module itself, executing those lines of code was already dependent on
another reference to the mbcache module being held.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/mbcache.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index c56ab21..07c5d7d 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -344,9 +344,6 @@ struct mb_cache *mb_cache_create(int bucket_bits)
 	int bucket_count = 1 << bucket_bits;
 	int i;
 
-	if (!try_module_get(THIS_MODULE))
-		return NULL;
