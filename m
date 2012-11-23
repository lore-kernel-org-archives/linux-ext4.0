From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: don't consider "make check" a compiler error
Date: Fri, 23 Nov 2012 13:31:45 -0700
Message-ID: <1353702705-2263-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49908 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab2KWUbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Nov 2012 15:31:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In a number of places, the output format from "make check" is
incorrectly interpreted as compiler warning output (triggered by
the presence of colons and parenthesis in the output).  Convert
these lines to similar output that does not trigger false build
warnings.

In the case of the tst_uuid.c program, the "ctime()" output was
difficult to change, but in fact it is better to actually compare
the time-based UUID against wallclock time instead of just printing
the formatted time as a string, so this test is improved.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/csum.c   |    5 +++--
 lib/ext2fs/inline.c |    2 +-
 lib/uuid/tst_uuid.c |   28 +++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 6c2e562..6c18513 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -870,7 +870,7 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc1, crc2, crc3;
 	dgrp_t swabgroup;
- 	struct ext2_group_desc *desc = ext2fs_group_desc(fs, fs->group_desc, group);
+	struct ext2_group_desc *desc;
 	size_t size;
 	struct ext2_super_block *sb = fs->super;
 	int offset = offsetof(struct ext2_group_desc, bg_checksum);
@@ -878,6 +878,7 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
 	struct ext4_group_desc swabdesc;
 #endif
 
+	desc = ext2fs_group_desc(fs, fs->group_desc, group);
 	size = fs->super->s_desc_size;
 	if (size < EXT2_MIN_DESC_SIZE)
 		size = EXT2_MIN_DESC_SIZE;
@@ -902,7 +903,7 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
 	if (offset < size)
 		crc3 = ext2fs_crc16(crc3, (char *)desc + offset, size - offset);
 
-	printf("%s: UUID %s(%04x), grp %u(%04x): %04x=%04x\n",
+	printf("%s UUID %s=%04x, grp %u=%04x: %04x=%04x\n",
 	       msg, e2p_uuid2str(sb->s_uuid), crc1, group, crc2, crc3,
 	       ext2fs_group_desc_csum(fs, group));
 }
diff --git a/lib/ext2fs/inline.c b/lib/ext2fs/inline.c
index eef3dda..05da1f7 100644
--- a/lib/ext2fs/inline.c
+++ b/lib/ext2fs/inline.c
@@ -99,7 +99,7 @@ static errcode_t test_memalign(unsigned long align)
 	if (!retval && !isaligned(ptr, align))
 		retval = EINVAL;
 	free(ptr);
-	printf("tst_memliagn(%lu): %s\n", align, 
+	printf("tst_memalign(%lu) is %s\n", align,
 	       retval ? error_message(retval) : "OK");
 	return retval;
 }
diff --git a/lib/uuid/tst_uuid.c b/lib/uuid/tst_uuid.c
index 5884ad9..2216970 100644
--- a/lib/uuid/tst_uuid.c
+++ b/lib/uuid/tst_uuid.c
@@ -74,7 +74,7 @@ main(int argc ATTR((unused)) , char **argv ATTR((unused)))
 	uuid_t		buf, tst;
 	char		str[100];
 	struct timeval	tv;
-	time_t		time_reg;
+	time_t		time_reg, time_gen;
 	unsigned char	*cp;
 	int i;
 	int failed = 0;
@@ -104,7 +104,8 @@ main(int argc ATTR((unused)) , char **argv ATTR((unused)))
 		printf("%02x", *cp++);
 	}
 	printf("\n");
-	type = uuid_type(buf); 	variant = uuid_variant(buf);
+	type = uuid_type(buf);
+	variant = uuid_variant(buf);
 	printf("UUID type = %d, UUID variant = %d\n", type, variant);
 	if (variant != UUID_VARIANT_DCE) {
 		printf("Incorrect UUID Variant; was expecting DCE!\n");
@@ -117,6 +118,7 @@ main(int argc ATTR((unused)) , char **argv ATTR((unused)))
 	}
 	printf("\n");
 
+	time_gen = time(0);
 	uuid_generate_time(buf);
 	uuid_unparse(buf, str);
 	printf("UUID string = %s\n", str);
@@ -125,7 +127,8 @@ main(int argc ATTR((unused)) , char **argv ATTR((unused)))
 		printf("%02x", *cp++);
 	}
 	printf("\n");
-	type = uuid_type(buf); 	variant = uuid_variant(buf);
+	type = uuid_type(buf);
+	variant = uuid_variant(buf);
 	printf("UUID type = %d, UUID variant = %d\n", type, variant);
 	if (variant != UUID_VARIANT_DCE) {
 		printf("Incorrect UUID Variant; was expecting DCE!\n");
@@ -136,15 +139,25 @@ main(int argc ATTR((unused)) , char **argv ATTR((unused)))
 		       "1 (time-based type)!\\n");
 		failed++;
 	}
+
 	tv.tv_sec = 0;
 	tv.tv_usec = 0;
 	time_reg = uuid_time(buf, &tv);
-	printf("UUID time is: (%ld, %ld): %s\n", tv.tv_sec, tv.tv_usec,
-	       ctime(&time_reg));
+	printf("UUID generated at %lu reports %lu (%ld.%ld)\n",
+	       time_gen, time_reg, tv.tv_sec, tv.tv_usec);
+	/* allow 1s margin in case of rollover between sampling
+	 * the current time and when the UUID is generated. */
+	if (time_reg > time_gen + 1) {
+		printf("UUID time comparison failed!\n");
+		failed++;
+	} else {
+		printf("UUID time comparison succeeded.\n");
+	}
+
 	uuid_parse(str, tst);
-	if (!uuid_compare(buf, tst))
+	if (!uuid_compare(buf, tst)) {
 		printf("UUID parse and compare succeeded.\n");
-	else {
+	} else {
 		printf("UUID parse and compare failed!\n");
 		failed++;
 	}
@@ -162,6 +175,7 @@ main(int argc ATTR((unused)) , char **argv ATTR((unused)))
 		printf("UUID copy and compare failed!\n");
 		failed++;
 	}
+
 	failed += test_uuid("84949cc5-4701-4a84-895b-354c584a981b", 1);
 	failed += test_uuid("84949CC5-4701-4A84-895B-354C584A981B", 1);
 	failed += test_uuid("84949cc5-4701-4a84-895b-354c584a981bc", 0);
-- 
1.7.3.4

