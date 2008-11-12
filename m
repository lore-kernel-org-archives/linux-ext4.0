From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 03/17] Add 64-bit bitops
Date: Tue, 11 Nov 2008 19:42:56 -0800
Message-ID: <1226461390-5502-4-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbYKLDnx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:53 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hqg2007427
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:52 -0500
In-Reply-To: <1226461390-5502-3-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 lib/ext2fs/bitops.c     |   39 +++++++++++++++
 lib/ext2fs/bitops.h     |   22 +++++++++
 lib/ext2fs/tst_bitops.c |  120 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
index 485e997..36901b2 100644
--- a/lib/ext2fs/bitops.c
+++ b/lib/ext2fs/bitops.c
@@ -76,3 +76,42 @@ void ext2fs_warn_bitmap(errcode_t errcode, unsigned long arg,
 		com_err(0, errcode, "#%lu", arg);
 #endif
 }
+
+/*
+ * C-only 64 bit ops.
+ */
+
+int ext2fs_set_bit64(__u64 nr, void * addr)
+{
+	int		mask, retval;
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	retval = mask & *ADDR;
+	*ADDR |= mask;
+	return retval;
+}
+
+int ext2fs_clear_bit64(__u64 nr, void * addr)
+{
+	int		mask, retval;
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	retval = mask & *ADDR;
+	*ADDR &= ~mask;
+	return retval;
+}
+
+int ext2fs_test_bit64(__u64 nr, const void * addr)
+{
+	int			mask;
+	const unsigned char	*ADDR = (const unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	return (mask & *ADDR);
+}
+
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 82ca138..d681778 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -19,6 +19,11 @@ extern int ext2fs_clear_bit(unsigned int nr, void * addr);
 extern int ext2fs_test_bit(unsigned int nr, const void * addr);
 extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
 extern void ext2fs_fast_clear_bit(unsigned int nr, void * addr);
+extern int ext2fs_set_bit64(__u64 nr,void * addr);
+extern int ext2fs_clear_bit64(__u64 nr, void * addr);
+extern int ext2fs_test_bit64(__u64 nr, const void * addr);
+extern void ext2fs_fast_set_bit64(__u64 nr,void * addr);
+extern void ext2fs_fast_clear_bit64(__u64 nr, void * addr);
 extern __u16 ext2fs_swab16(__u16 val);
 extern __u32 ext2fs_swab32(__u32 val);
 extern __u64 ext2fs_swab64(__u64 val);
@@ -165,6 +170,23 @@ _INLINE_ void ext2fs_fast_clear_bit(unsigned int nr, void * addr)
 }
 
 
+_INLINE_ void ext2fs_fast_set_bit64(__u64 nr, void * addr)
+{
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	*ADDR |= (1 << (nr & 0x07));
+}
+
+_INLINE_ void ext2fs_fast_clear_bit64(__u64 nr, void * addr)
+{
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	*ADDR &= ~(1 << (nr & 0x07));
+}
+
+
 #if ((defined __GNUC__) && !defined(_EXT2_USE_C_VERSIONS_) && \
      (defined(__i386__) || defined(__i486__) || defined(__i586__)))
 
diff --git a/lib/ext2fs/tst_bitops.c b/lib/ext2fs/tst_bitops.c
index 6febe68..0f0a425 100644
--- a/lib/ext2fs/tst_bitops.c
+++ b/lib/ext2fs/tst_bitops.c
@@ -169,5 +169,125 @@ int main(int argc, char **argv)
 
 	printf("ext2fs_fast_set_bit big_test successful\n");
 
+	/* Repeat foregoing tests for 64-bit bitops */
+
+	/* Test test_bit */
+	for (i=0,j=0; i < size; i++) {
+		if (ext2fs_test_bit64(i, bitarray)) {
+			if (bits_list[j] == i) {
+				j++;
+			} else {
+				printf("64-bit: Bit %d set, not expected\n",
+				       i);
+				exit(1);
+			}
+		} else {
+			if (bits_list[j] == i) {
+				printf("64-bit: "
+				       "Expected bit %d to be clear.\n", i);
+				exit(1);
+			}
+		}
+	}
+	printf("64-bit: ext2fs_test_bit appears to be correct\n");
+
+	/* Test ext2fs_set_bit */
+	memset(testarray, 0, sizeof(testarray));
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_set_bit64(bits_list[i], testarray);
+	}
+	if (memcmp(testarray, bitarray, sizeof(testarray)) == 0) {
+		printf("64-bit: ext2fs_set_bit test succeeded.\n");
+	} else {
+		printf("64-bit: ext2fs_set_bit test failed.\n");
+		for (i=0; i < sizeof(testarray); i++) {
+			printf("%02x ", testarray[i]);
+		}
+		printf("\n");
+		exit(1);
+	}
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_clear_bit64(bits_list[i], testarray);
+	}
+	for (i=0; i < sizeof(testarray); i++) {
+		if (testarray[i]) {
+			printf("64-bit: ext2fs_clear_bit failed, "
+			       "testarray[%d] is %d\n", i, testarray[i]);
+			exit(1);
+		}
+	}
+	printf("64-bit: ext2fs_clear_bit test succeed.\n");
+
+	/* Do bigarray test */
+	bigarray = malloc(1 << 29);
+	if (!bigarray) {
+		fprintf(stderr, "Failed to allocate scratch memory!\n");
+		exit(1);
+	}
+
+        bigarray[BIG_TEST_BIT >> 3] = 0;
+
+	ext2fs_set_bit64(BIG_TEST_BIT, bigarray);
+	printf("64-bit: big bit number (%u) test: %d, expected %d\n",
+	       BIG_TEST_BIT, bigarray[BIG_TEST_BIT >> 3],
+	       (1 << (BIG_TEST_BIT & 7)));
+	if (bigarray[BIG_TEST_BIT >> 3] != (1 << (BIG_TEST_BIT & 7)))
+		exit(1);
+
+	ext2fs_clear_bit64(BIG_TEST_BIT, bigarray);
+
+	printf("64-bit: big bit number (%u) test: %d, expected 0\n",
+	       BIG_TEST_BIT,
+	       bigarray[BIG_TEST_BIT >> 3]);
+	if (bigarray[BIG_TEST_BIT >> 3] != 0)
+		exit(1);
+
+	printf("64-bit: ext2fs_set_bit big_test successful\n");
+
+	/* Now test ext2fs_fast_set_bit */
+	memset(testarray, 0, sizeof(testarray));
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_fast_set_bit64(bits_list[i], testarray);
+	}
+	if (memcmp(testarray, bitarray, sizeof(testarray)) == 0) {
+		printf("64-bit: ext2fs_fast_set_bit test succeeded.\n");
+	} else {
+		printf("64-bit: ext2fs_fast_set_bit test failed.\n");
+		for (i=0; i < sizeof(testarray); i++) {
+			printf("%02x ", testarray[i]);
+		}
+		printf("\n");
+		exit(1);
+	}
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_clear_bit64(bits_list[i], testarray);
+	}
+	for (i=0; i < sizeof(testarray); i++) {
+		if (testarray[i]) {
+			printf("64-bit: ext2fs_clear_bit failed, "
+			       "testarray[%d] is %d\n", i, testarray[i]);
+			exit(1);
+		}
+	}
+	printf("64-bit: ext2fs_clear_bit test succeed.\n");
+
+        bigarray[BIG_TEST_BIT >> 3] = 0;
+
+	ext2fs_fast_set_bit64(BIG_TEST_BIT, bigarray);
+	printf("64-bit: big bit number (%u) test: %d, expected %d\n",
+	       BIG_TEST_BIT, bigarray[BIG_TEST_BIT >> 3],
+	       (1 << (BIG_TEST_BIT & 7)));
+	if (bigarray[BIG_TEST_BIT >> 3] != (1 << (BIG_TEST_BIT & 7)))
+		exit(1);
+
+	ext2fs_fast_clear_bit64(BIG_TEST_BIT, bigarray);
+
+	printf("64-bit: big bit number (%u) test: %d, expected 0\n",
+	       BIG_TEST_BIT, bigarray[BIG_TEST_BIT >> 3]);
+	if (bigarray[BIG_TEST_BIT >> 3] != 0)
+		exit(1);
+
+	printf("64-bit: ext2fs_fast_set_bit big_test successful\n");
+
 	exit(0);
 }
-- 
1.5.6.5

