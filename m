From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [PATCH] jbd: remove unneeded semicolon
Date: Wed, 03 Jul 2013 13:52:21 -0700
Message-ID: <1372884741.11138.0.camel@lizardlounge>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: akpm@linux-foundation.org, jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch removes an unnecessary semicolon that was placed after the closing
bracket of an inline JBD wrapper function.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 7e0b622..9d789a9 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -78,7 +78,7 @@ static inline void *jbd_alloc(size_t size, gfp_t flags)
 static inline void jbd_free(void *ptr, size_t size)
 {
 	free_pages((unsigned long)ptr, get_order(size));
-};
+}
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
