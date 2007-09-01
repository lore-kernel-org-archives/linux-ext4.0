From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC 1/2] JBD: slab management support for large block(>8k)
Date: Fri, 31 Aug 2007 17:12:18 -0700
Message-ID: <1188605538.3837.51.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: adilger@clusterfs.com, sho@tnes.nec.co.jp,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, clameter@sgi.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>From clameter:
Teach jbd/jbd2 slab management to support >8k block size. Without this, it refused to mount on >8k ext3.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: my2.6/fs/jbd/journal.c
===================================================================
--- my2.6.orig/fs/jbd/journal.c	2007-08-30 18:40:02.000000000 -0700
+++ my2.6/fs/jbd/journal.c	2007-08-31 11:01:18.000000000 -0700
@@ -1627,16 +1627,17 @@ void * __jbd_kmalloc (const char *where,
  * jbd slab management: create 1k, 2k, 4k, 8k slabs as needed
  * and allocate frozen and commit buffers from these slabs.
  *
- * Reason for doing this is to avoid, SLAB_DEBUG - since it could
- * cause bh to cross page boundary.
+ * (Note: We only seem to need the definitions here for the SLAB_DEBUG
+ * case. In non debug operations SLUB will find the corresponding kmalloc
+ * cache and create an alias. --clameter)
  */
-
-#define JBD_MAX_SLABS 5
-#define JBD_SLAB_INDEX(size)  (size >> 11)
+#define JBD_MAX_SLABS 7
+#define JBD_SLAB_INDEX(size)  get_order((size) << (PAGE_SHIFT - 10))
 
 static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
 static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd_1k", "jbd_2k", "jbd_4k", NULL, "jbd_8k"
+	"jbd_1k", "jbd_2k", "jbd_4k", "jbd_8k",
+	"jbd_16k", "jbd_32k", "jbd_64k"
 };
 
 static void journal_destroy_jbd_slabs(void)
Index: my2.6/fs/jbd2/journal.c
===================================================================
--- my2.6.orig/fs/jbd2/journal.c	2007-08-30 18:40:02.000000000 -0700
+++ my2.6/fs/jbd2/journal.c	2007-08-31 11:04:37.000000000 -0700
@@ -1639,16 +1639,18 @@ void * __jbd2_kmalloc (const char *where
  * jbd slab management: create 1k, 2k, 4k, 8k slabs as needed
  * and allocate frozen and commit buffers from these slabs.
  *
- * Reason for doing this is to avoid, SLAB_DEBUG - since it could
- * cause bh to cross page boundary.
+ * (Note: We only seem to need the definitions here for the SLAB_DEBUG
+ * case. In non debug operations SLUB will find the corresponding kmalloc
+ * cache and create an alias. --clameter)
  */
 
-#define JBD_MAX_SLABS 5
-#define JBD_SLAB_INDEX(size)  (size >> 11)
+#define JBD_MAX_SLABS 7
+#define JBD_SLAB_INDEX(size)  get_order((size) << (PAGE_SHIFT - 10))
 
 static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
 static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd2_1k", "jbd2_2k", "jbd2_4k", NULL, "jbd2_8k"
+	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
+        "jbd2_16k", "jbd2_32k", "jbd2_64k"
 };
 
 static void jbd2_journal_destroy_jbd_slabs(void)


