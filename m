From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/3] filefrag: reserve fields and new extent flags
Date: Wed, 30 Jul 2014 14:25:50 -0600
Message-ID: <1406751951-23059-2-git-send-email-adilger@dilger.ca>
References: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, David Sterba <dsterba@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-03.shaw.ca ([64.59.136.139]:1790 "EHLO
	smtp-out-03.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaG3UZy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 16:25:54 -0400
In-Reply-To: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reserve the FIEMAP_EXTENT_PHYS_LENGTH flag to indicate that the new
fe_phys_length field contains valid data.  This is introduced to
allow different fe_phys_length and fe_logi_length values for
compressed extents, but it is also valid to set PHYS_LENGTH and set
fe_phys_length for regular files to simplify userspace codes.  If
PHYS_LENGTH is not set, then applications should set fe_phys_length
equal to fe_logi_length, since fe_phys_length is undefined (though
typically zero).

Reserve the FIEMAP_EXTENT_DATA_COMPRESSED flag to allow reporting
extents with physical length different than logical length.  This
also sets the FIEMAP_EXTENT_ENCODED flag to indicate that the data
cannot be accessed directly.

Reserve the FIEMAP_EXTENT_NET flag, which indicates that the data
is on a network filesystem that does not have local storage devices.
This also sets FIEMAP_EXTENT_ENCODED flag to indicate the data cannot
be accessed directly.

Print out DATA_COMPRESSED and EXTENT_NET flags in filefrag if detected.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/fiemap.h |   17 +++++++++++++----
 misc/filefrag.c     |    7 ++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index 895cd0b..30103e2 100644
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
@@ -51,8 +53,13 @@ struct fiemap {
 						    * Sets EXTENT_UNKNOWN. */
 #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
 						    * while fs is unmounted */
+#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010 /* Physical length of extent
+						    * in fe_phys_length valid */
+#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
+						    * Sets EXTENT_ENCODED and
+						    * PHYS_LENGTH. */
 #define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
-						    * Sets EXTENT_NO_BYPASS. */
+						    * Sets EXTENT_ENCODED. */
 #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
 						    * block aligned. */
 #define FIEMAP_EXTENT_DATA_INLINE	0x00000200 /* Data mixed with metadata.
@@ -66,5 +73,7 @@ struct fiemap {
 						    * merged for efficiency. */
 #define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with other
 						    * files. */
+#define FIEMAP_EXTENT_NET		0x80000000 /* Data stored remotely.
+						    * Sets EXTENT_ENCODED. */
 
 #endif /* _LINUX_FIEMAP_H */
diff --git a/misc/filefrag.c b/misc/filefrag.c
index d71bf43..7bd100c 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -164,6 +164,8 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	print_flag(&fe_flags, FIEMAP_EXTENT_UNKNOWN, flags, "unknown_loc,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_DELALLOC, flags, "delalloc,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_ENCODED, flags, "encoded,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_COMPRESSED, flags,
+								"compressed,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_ENCRYPTED, flags,"encrypted,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_NOT_ALIGNED, flags, "not_aligned,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_INLINE, flags, "inline,");
@@ -171,7 +173,10 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	print_flag(&fe_flags, FIEMAP_EXTENT_UNWRITTEN, flags, "unwritten,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_MERGED, flags, "merged,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_SHARED, flags, "shared,");
-	/* print any unknown flags as hex values */
+	print_flag(&fe_flags, FIEMAP_EXTENT_NET, flags, "net,");
+
+	/* Print unknown flags in hex format.  Known flags are already
+	 * printed above and will have their bit cleared from "fe_flags". */
 	for (mask = 1; fe_flags != 0 && mask != 0; mask <<= 1) {
 		char hex[6];
 
-- 
1.7.3.4

