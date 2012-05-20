From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 01/10] string: introduce memweight
Date: Sun, 20 May 2012 22:23:14 +0900
Message-ID: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

memweight() is the function that counts the total number of bits set
in memory area.  The memory area doesn't need to be aligned to
long-word boundary unlike bitmap_weight().

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
---
 include/linux/string.h |    3 +++
 lib/string.c           |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

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
index e5878de..c8b92a0 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -26,6 +26,7 @@
 #include <linux/export.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/bitmap.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
@@ -824,3 +825,39 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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
+	union {
+		const void *ptr;
+		const unsigned char *b;
+		unsigned long address;
+	} bitmap;
+
+	for (bitmap.ptr = ptr; bytes > 0 && bitmap.address % sizeof(long);
+			bytes--, bitmap.address++)
+		w += hweight8(*bitmap.b);
+
+	for (longs = bytes / sizeof(long); longs > 0; ) {
+		size_t bits = min_t(size_t, INT_MAX & ~(BITS_PER_LONG - 1),
+					longs * BITS_PER_LONG);
+
+		w += bitmap_weight(bitmap.ptr, bits);
+		bytes -= bits / BITS_PER_BYTE;
+		bitmap.address += bits / BITS_PER_BYTE;
+		longs -= bits / BITS_PER_LONG;
+	}
+
+	for (; bytes > 0; bytes--, bitmap.address++)
+		w += hweight8(*bitmap.b);
+
+	return w;
+}
+EXPORT_SYMBOL(memweight);
-- 
1.7.7.6
