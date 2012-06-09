From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 1/9] string: introduce memweight
Date: Sat,  9 Jun 2012 09:50:30 +0900
Message-ID: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

memweight() is the function that counts the total number of bits set
in memory area.  Unlike bitmap_weight(), memweight() takes pointer
and size in bytes to specify a memory area which does not need to be
aligned to long-word boundary.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anders Larsen <al@alarsen.net>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <matthew@wil.cx>
---
v3: add comment for the last loop, adviced by Jan Kara
v2: simplify memweight(), adviced by Jan Kara

 include/linux/string.h |    3 +++
 lib/string.c           |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index e033564..ffe0442 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -145,4 +145,7 @@ static inline bool strstarts(const char *str, const char *prefix)
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 #endif
+
+extern size_t memweight(const void *ptr, size_t bytes);
+
 #endif /* _LINUX_STRING_H_ */
diff --git a/lib/string.c b/lib/string.c
index e5878de..e467186 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -26,6 +26,7 @@
 #include <linux/export.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/bitmap.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
@@ -824,3 +825,38 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
+
+/**
+ * memweight - count the total number of bits set in memory area
+ * @ptr: pointer to the start of the area
+ * @bytes: the size of the area
+ */
+size_t memweight(const void *ptr, size_t bytes)
+{
+	size_t w = 0;
+	size_t longs;
+	const unsigned char *bitmap = ptr;
+
+	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
+			bytes--, bitmap++)
+		w += hweight8(*bitmap);
+
+	longs = bytes / sizeof(long);
+	if (longs) {
+		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
+		w += bitmap_weight((unsigned long *)bitmap,
+				longs * BITS_PER_LONG);
+		bytes -= longs * sizeof(long);
+		bitmap += longs * sizeof(long);
+	}
+	/*
+	 * The reason that this last loop is distinct from the preceding
+	 * bitmap_weight() call is to compute 1-bits in the last region smaller
+	 * than sizeof(long) properly on big-endian systems.
+	 */
+	for (; bytes > 0; bytes--, bitmap++)
+		w += hweight8(*bitmap);
+
+	return w;
+}
+EXPORT_SYMBOL(memweight);
-- 
1.7.7.6

