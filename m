From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 3/4] filefrag: reserve fields and new extent flags
Date: Mon, 16 Dec 2013 18:05:30 -0700
Message-ID: <1387242331-29227-3-git-send-email-adilger@dilger.ca>
References: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:58496 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3LQBPL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 20:15:11 -0500
In-Reply-To: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reserve the FIEMAP_EXTENT_DATA_COMPRESSED flag to allow reporting
extents with physical length different than logical length.  This
also sets the FIEMAP_EXTENT_ENCODED flag to indicate that the data
cannot be accessed directly.  This adds a new fe_phys_length field
to struct fiemap_extent which specifies the physical extent length
in bytes when DATA_COMPRESSED is set.  Linux 3.14 and later kernels
will fill out the fe_phys_length field, but in older kernels the
contents are undefined (though typically zero).

Reserve the FIEMAP_EXTENT_NET flag, which indicates that the data
is on a network filesystem.  This also sets FIEMAP_EXTENT_ENCODED
flag to indicate the data cannot be accessed directly.

Print out these flags in filefrag if detected.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/fiemap.h |   14 ++++++++++----
 misc/filefrag.c     |    2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index 30bf555..df973da 100644
--- a/lib/ext2fs/fiemap.h
+++ b/lib/ext2fs/fiemap.h
@@ -17,15 +17,17 @@ struct fiemap_extent {
 	__u64 fe_physical; /* physical offset in bytes for the start
 			    * of the extent from the beginning of the disk */
 	__u64 fe_length;   /* length in bytes for this extent */
-	__u64 fe_reserved64[2];
+	__u64 fe_phys_length; /* physical length in bytes for this extent,
+			       * undefined if DATA_COMPRESSED not set */
+	__u64 fe_reserved64;
 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
 	__u32 fe_reserved[3];
 };
 
 struct fiemap {
-	__u64 fm_start;		/* logical offset (inclusive) at
+	__u64 fm_start;		/* logical offset in bytes (inclusive) at
 				 * which to start mapping (in) */
-	__u64 fm_length;	/* logical length of mapping which
+	__u64 fm_length;	/* logical length in bytes of mapping which
 				 * userspace wants (in) */
 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
 	__u32 fm_mapped_extents;/* number of extents that were mapped (out) */
@@ -51,8 +53,10 @@ struct fiemap {
 						    * Sets EXTENT_UNKNOWN. */
 #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
 						    * while fs is unmounted */
+#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
+						    * Sets EXTENT_ENCODED. */
 #define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
-						    * Sets EXTENT_NO_BYPASS. */
+						    * Sets EXTENT_ENCODED. */
 #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
 						    * block aligned. */
 #define FIEMAP_EXTENT_DATA_INLINE	0x00000200 /* Data mixed with metadata.
@@ -64,5 +68,7 @@ struct fiemap {
 #define FIEMAP_EXTENT_MERGED		0x00001000 /* File does not natively
 						    * support extents. Result
 						    * merged for efficiency. */
+#define FIEMAP_EXTENT_NET		0x80000000 /* Data stored remotely.
+						    * Sets EXTENT_ENCODED. */
 
 #endif /* _LINUX_FIEMAP_H */
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 6289899..7096abb 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -158,12 +158,14 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 
 	print_flag(&flags, FIEMAP_EXTENT_UNKNOWN, buf, "unknown,");
 	print_flag(&flags, FIEMAP_EXTENT_DELALLOC, buf, "delalloc,");
+	print_flag(&flags, FIEMAP_EXTENT_DATA_COMPRESSED, buf, "compressed,");
 	print_flag(&flags, FIEMAP_EXTENT_DATA_ENCRYPTED, buf, "encrypted,");
 	print_flag(&flags, FIEMAP_EXTENT_NOT_ALIGNED, buf, "not_aligned,");
 	print_flag(&flags, FIEMAP_EXTENT_DATA_INLINE, buf, "inline,");
 	print_flag(&flags, FIEMAP_EXTENT_DATA_TAIL, buf, "tail_packed,");
 	print_flag(&flags, FIEMAP_EXTENT_UNWRITTEN, buf, "unwritten,");
 	print_flag(&flags, FIEMAP_EXTENT_MERGED, buf, "merged,");
+	print_flag(&flags, FIEMAP_EXTENT_NET, buf, "net,");
 	print_flag(&flags, FIEMAP_EXTENT_LAST, buf, "last,");
 	/* Print unknown flags in hex format.  Known flags are already printed
 	 * above and will have their bit cleared from "flags". */
-- 
1.7.3.4

