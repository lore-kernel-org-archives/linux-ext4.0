From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 2/2] tests: quiet "make check" gcc -Wall warnings
Date: Mon, 28 May 2012 23:19:20 -0600
Message-ID: <1338268760-12882-2-git-send-email-adilger@whamcloud.com>
References: <1338268760-12882-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44022 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2E2FTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 01:19:24 -0400
In-Reply-To: <1338268760-12882-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quiet a number of GCC compiler warnings about unused variables,
use of uninitialized variables, and function return without value
hit when running "make check".

In a number of places, the output format from "make check" is
incorrectly interpreted as compiler warning output (triggered by
the presence of colons and parenthesis in the output).  Convert
these lines to similar output that does not trigger false build
warnings.

In the case of the tst_uuid.c program, the "ctime()" output was
difficult to change, but in fact it is better to actually compare
the time-based UUID against wallclock time instead of just printing
the formatted time as a string, so this test is improved.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/problem.c         |    2 +-
 e2fsck/region.c          |    2 +-
 lib/ext2fs/crc32c.c      |    5 +++--
 lib/ext2fs/csum.c        |    9 +++------
 lib/ext2fs/inline.c      |    2 +-
 lib/ext2fs/tst_bitmaps.c |   13 ++++++-------
 lib/uuid/tst_uuid.c      |   28 +++++++++++++++++++++-------
 7 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0948bdb..ca3fa01 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1816,7 +1816,7 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 		return 0;
 	}
 	if (!(ptr->flags & PR_CONFIG)) {
-		char	key[9], *new_desc;
+		char	key[9], *new_desc = NULL;
 
 		sprintf(key, "0x%06x", code);
 
diff --git a/e2fsck/region.c b/e2fsck/region.c
index e9abb56..4b669f0 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -171,7 +171,7 @@ void region_print(region_t region, FILE *f)
 
 int main(int argc, char **argv)
 {
-	region_t	r;
+	region_t	r = NULL;
 	int		pc = 0, ret;
 	region_addr_t	start, end;
 
diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
index da2c60b..d8034c4 100644
--- a/lib/ext2fs/crc32c.c
+++ b/lib/ext2fs/crc32c.c
@@ -1113,15 +1113,16 @@ static int test_crc32c(void)
 
 	while (t->length) {
 		uint32_t be, le;
+
 		le = ext2fs_crc32c_le(t->crc, test_buf + t->start, t->length);
 		be = ext2fs_crc32c_be(t->crc, test_buf + t->start, t->length);
 		if (le != t->crc_le) {
-			printf("Test %d LE fails, %x != %x\n",
+			printf("Test %ld LE fails, %x != %x\n",
 			       (t - test), le, t->crc_le);
 			failures++;
 		}
 		if (be != t->crc_be) {
-			printf("Test %d BE fails, %x != %x\n",
+			printf("Test %ld BE fails, %x != %x\n",
 			       (t - test), be, t->crc_be);
 			failures++;
 		}
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 9fa3f24..4788a6c 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -39,10 +39,6 @@ __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 	size = fs->super->s_desc_size;
 	if (size < EXT2_MIN_DESC_SIZE)
 		size = EXT2_MIN_DESC_SIZE;
-	if (size > sizeof(struct ext4_group_desc)) {
-		printf("%s: illegal s_desc_size(%zd)\n", __func__, size);
-		size = sizeof(struct ext4_group_desc);
-	}
 
 	desc = ext2fs_group_desc(fs, fs->group_desc, group);
 
@@ -166,7 +162,7 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc1, crc2, crc3;
 	dgrp_t swabgroup;
- 	struct ext2_group_desc *desc = ext2fs_group_desc(fs, fs->group_desc, group);
+	struct ext2_group_desc *desc;
 	size_t size;
 	struct ext2_super_block *sb = fs->super;
 	int offset = offsetof(struct ext2_group_desc, bg_checksum);
@@ -174,6 +170,7 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
 	struct ext4_group_desc swabdesc;
 #endif
 
+	desc = ext2fs_group_desc(fs, fs->group_desc, group);
 	size = fs->super->s_desc_size;
 	if (size < EXT2_MIN_DESC_SIZE)
 		size = EXT2_MIN_DESC_SIZE;
@@ -198,7 +195,7 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
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
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 22346a2..b49111b 100644
--- a/lib/ext2fs/tst_bitmaps.c
+++ b/lib/ext2fs/tst_bitmaps.c
@@ -193,8 +193,7 @@ errout:
 
 void setup_cmd(int argc, char **argv)
 {
-	errcode_t	retval;
-	int		i, c, err;
+	int		c, err;
 	unsigned int	blocks = 128;
 	unsigned int	inodes = 0;
 	unsigned int	type = EXT2FS_BMAP64_BITARRAY;
@@ -372,7 +371,7 @@ void do_testb(int argc, char *argv[])
 {
 	unsigned int block, num;
 	int err;
-	int test_result, op_result;
+	int test_result;
 
 	if (check_fs_open(argv[0]))
 		return;
@@ -508,7 +507,7 @@ void do_testi(int argc, char *argv[])
 {
 	unsigned int inode;
 	int err;
-	int test_result, op_result;
+	int test_result;
 
 	if (check_fs_open(argv[0]))
 		return;
@@ -588,13 +587,13 @@ int main(int argc, char **argv)
 			blocks = parse_ulong(optarg, argv[0],
 					     "number of blocks", &err);
 			if (err)
-				return;
+				return err;
 			break;
 		case 'i':
 			inodes = parse_ulong(optarg, argv[0],
 					     "number of blocks", &err);
 			if (err)
-				return;
+				return err;
 			break;
 		case 'l':	/* Legacy bitmaps */
 			flags = 0;
@@ -603,7 +602,7 @@ int main(int argc, char **argv)
 			type = parse_ulong(optarg, argv[0],
 					   "bitmap backend type", &err);
 			if (err)
-				return;
+				return err;
 			break;
 		case 'R':
 			request = optarg;
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

