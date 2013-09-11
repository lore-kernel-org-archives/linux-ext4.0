From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: add -i switch to filefrag to ignore inline data
Date: Wed, 11 Sep 2013 16:03:42 -0500
Message-ID: <5230DAAE.2040900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab3IKVDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 17:03:44 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8BL3h82013335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Sep 2013 17:03:43 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r8BL3hXs013064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Sep 2013 17:03:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sometimes we simply want to know what blocks are allocated to
a file.  By default, filefrag will show us inline data as well,
printing an extent record (and extent count) whether it's inline
or not.

Add an "-i" switch to Ignore Inline data, so that when
specified, the extent count & table output only reflects
normally allocated blocks.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.8.in b/misc/filefrag.8.in
index a6d7b27..6b2ce1d 100644
--- a/misc/filefrag.8.in
+++ b/misc/filefrag.8.in
@@ -8,7 +8,7 @@ filefrag \- report on file fragmentation
 .BI \-b blocksize
 ]
 [
-.B \-BeksvxX
+.B \-BeiksvxX
 ]
 [
 .I files...
@@ -43,6 +43,9 @@ is unspecified it defaults to 1024 bytes.
 .B \-e
 Print output in extent format, even for block-mapped files.
 .TP
+.B \-i
+Ignore all inline extent records in the extent table and counts.
+.TP
 .BI \-k
 Use 1024\-byte blocksize for output (identical to '\-b 1024').
 .TP
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 35b3544..4652606 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -50,6 +50,7 @@ int sync_file = 0;	/* fsync file before getting the mapping */
 int xattr_map = 0;	/* get xattr mapping */
 int force_bmap;	/* force use of FIBMAP instead of FIEMAP */
 int force_extent;	/* print output in extent format always */
+int no_inline;		/* do not show FIEMAP_EXTENT_DATA_INLINE, only blocks */
 int logical_width = 8;
 int physical_width = 10;
 const char *ext_fmt = "%4d: %*llu..%*llu: %*llu..%*llu: %6llu: %s\n";
@@ -135,8 +136,11 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	char flags[256] = "";
 
 	/* For inline data all offsets should be in bytes, not blocks */
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE) {
+		if (no_inline)
+			return;
 		blk_shift = 0;
+	}
 
 	ext_len = fm_extent->fe_length >> blk_shift;
 	ext_blks = (fm_extent->fe_length - 1) >> blk_shift;
@@ -229,6 +233,15 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 		}
 
 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+			/* Skip this extent if it's inline and we are ignoring */
+			if (no_inline &&
+			    (fm_ext[i].fe_flags & FIEMAP_EXTENT_DATA_INLINE)) {
+				n++;
+				continue;
+			}
+
 			if (fm_ext[i].fe_logical != 0 &&
 			    fm_ext[i].fe_physical != expected) {
 				tot_extents++;
@@ -242,8 +255,6 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 						  blk_shift, st);
 
 			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
-			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
-				last = 1;
 			n++;
 		}
 
@@ -445,7 +456,7 @@ out_close:
 
 static void usage(const char *progname)
 {
-	fprintf(stderr, "Usage: %s [-b{blocksize}] [-BeklsvxX] file ...\n",
+	fprintf(stderr, "Usage: %s [-b{blocksize}] [-BeiklsvxX] file ...\n",
 		progname);
 	exit(1);
 }
@@ -455,7 +466,7 @@ int main(int argc, char**argv)
 	char **cpp;
 	int c;
 
-	while ((c = getopt(argc, argv, "Bb::eksvxX")) != EOF)
+	while ((c = getopt(argc, argv, "Bb::eiksvxX")) != EOF)
 		switch (c) {
 		case 'B':
 			force_bmap++;
@@ -495,6 +506,9 @@ int main(int argc, char**argv)
 			if (!verbose)
 				verbose++;
 			break;
+		case 'i':
+			no_inline++;
+			break;
 		case 'k':
 			blocksize = 1024;
 			break;


