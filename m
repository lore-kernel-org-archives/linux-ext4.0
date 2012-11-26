From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/6 -v2] libext2fs: add ext2fs_bitcount() function
Date: Mon, 26 Nov 2012 09:10:35 -0500
Message-ID: <1353939035-31829-1-git-send-email-tytso@mit.edu>
References: <20121126140638.GC31891@thunk.org>
Cc: lczerner@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34817 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab2KZOKh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 09:10:37 -0500
In-Reply-To: <20121126140638.GC31891@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This function efficiently counts the number of bits in a block of
memory.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---

Renamed function signature to make it clear that ext2fs_bitcount takes
the number of bytes, not number of bits.

Enhance the unit test to make sure the popcount function is more
thoroughly tested.

 lib/ext2fs/bitops.c         | 35 ++++++++++++++++
 lib/ext2fs/bitops.h         |  1 +
 lib/ext2fs/tst_bitmaps.c    |  1 +
 lib/ext2fs/tst_bitmaps_cmds | 42 ++++++++++++++++++++
 lib/ext2fs/tst_bitmaps_exp  | 97 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 176 insertions(+)

diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
index 9322a35..7f5b66f 100644
--- a/lib/ext2fs/bitops.c
+++ b/lib/ext2fs/bitops.c
@@ -116,3 +116,38 @@ int ext2fs_test_bit64(__u64 nr, const void * addr)
 	return (mask & *ADDR);
 }
 
+static unsigned int popcount8(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55);
+	res = (res & 0x33) + ((res >> 2) & 0x33);
+	return (res + (res >> 4)) & 0x0F;
+}
+
+static unsigned int popcount32(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55555555);
+	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
+	res = (res + (res >> 4)) & 0x0F0F0F0F;
+	res = res + (res >> 8);
+	return (res + (res >> 16)) & 0x000000FF;
+}
+
+unsigned int ext2fs_bitcount(const void *addr, unsigned int count)
+{
+	const unsigned char *cp = addr;
+	const __u32 *p = addr;
+	unsigned int res = 0;
+
+	if ((((unsigned long) addr) & 3) == 0) {
+		while (count > 4) {
+			res += popcount32(*p++);
+			count -= 4;
+		}
+		cp = (const unsigned char *) p;
+	}
+	while (count > 0) {
+		res += popcount8(*cp++);
+		count--;
+	}
+	return res;
+}
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 526870f..17e707c 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -686,6 +686,7 @@ extern int ext2fs_test_bit(unsigned int nr, const void * addr);
 extern int ext2fs_set_bit64(__u64 nr,void * addr);
 extern int ext2fs_clear_bit64(__u64 nr, void * addr);
 extern int ext2fs_test_bit64(__u64 nr, const void * addr);
+extern unsigned int ext2fs_bitcount(const void *addr, unsigned int count);
 
 #ifdef NO_INLINE_FUNCS
 extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 5da3693..2a76292 100644
--- a/lib/ext2fs/tst_bitmaps.c
+++ b/lib/ext2fs/tst_bitmaps.c
@@ -270,6 +270,7 @@ void dump_bitmap(ext2fs_generic_bitmap bmap, unsigned int start, unsigned num)
 	for (i=0; i < len; i++)
 		printf("%02x", buf[i]);
 	printf("\n");
+	printf("bits set: %u\n", ext2fs_bitcount(buf, len));
 	free(buf);
 }
 
diff --git a/lib/ext2fs/tst_bitmaps_cmds b/lib/ext2fs/tst_bitmaps_cmds
index 9a4f3d0..31e2a60 100644
--- a/lib/ext2fs/tst_bitmaps_cmds
+++ b/lib/ext2fs/tst_bitmaps_cmds
@@ -53,5 +53,47 @@ cleari 5
 testi 17
 testi 6
 testi 4
+clearb 7 12
+dump_bb
+setb 1
+dump_bb
+setb 2
+dump_bb
+setb 3
+dump_bb
+setb 4
+dump_bb
+setb 5
+dump_bb
+setb 6
+dump_bb
+setb 7
+dump_bb
+setb 8
+dump_bb
+setb 10
+setb 12
+setb 14
+setb 17
+setb 19
+setb 24
+setb 26
+setb 27
+setb 30
+setb 31
+setb 32
+setb 35
+setb 39
+setb 40
+setb 44
+setb 46
+setb 47
+setb 49
+setb 51
+setb 52
+clearb 2
+clearb 3
+clearb 7
+dump_bb
 quit
 
diff --git a/lib/ext2fs/tst_bitmaps_exp b/lib/ext2fs/tst_bitmaps_exp
index 2d406ce..2d62b66 100644
--- a/lib/ext2fs/tst_bitmaps_exp
+++ b/lib/ext2fs/tst_bitmaps_exp
@@ -36,6 +36,7 @@ tst_bitmaps: testb 16
 Block 16 is set
 tst_bitmaps: dump_bb
 block bitmap: 00f80000000000000000000000000000
+bits set: 5
 tst_bitmaps: ffzb 11 16
 First unmarked block is 11
 tst_bitmaps: ffzb 12 16
@@ -64,6 +65,7 @@ tst_bitmaps: setb 12 7
 Marking blocks 12 to 18
 tst_bitmaps: dump_bb
 block bitmap: 00f80300000000000000000000000000
+bits set: 7
 tst_bitmaps: seti 2
 Setting inode 2, was clear before
 tst_bitmaps: seti 5
@@ -82,6 +84,7 @@ tst_bitmaps: testi 1
 Inode 1 is clear
 tst_bitmaps: dump_ib
 inode bitmap: 1e000000
+bits set: 4
 tst_bitmaps: ffzi 1 6
 First unmarked inode is 1
 tst_bitmaps: ffzi 2 5
@@ -110,5 +113,99 @@ tst_bitmaps: testi 6
 Inode 6 is clear
 tst_bitmaps: testi 4
 Inode 4 is clear
+tst_bitmaps: clearb 7 12
+Clearing blocks 7 to 18
+tst_bitmaps: dump_bb
+block bitmap: 00000000000000000000000000000000
+bits set: 0
+tst_bitmaps: setb 1
+Setting block 1, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 01000000000000000000000000000000
+bits set: 1
+tst_bitmaps: setb 2
+Setting block 2, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 03000000000000000000000000000000
+bits set: 2
+tst_bitmaps: setb 3
+Setting block 3, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 07000000000000000000000000000000
+bits set: 3
+tst_bitmaps: setb 4
+Setting block 4, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 0f000000000000000000000000000000
+bits set: 4
+tst_bitmaps: setb 5
+Setting block 5, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 1f000000000000000000000000000000
+bits set: 5
+tst_bitmaps: setb 6
+Setting block 6, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 3f000000000000000000000000000000
+bits set: 6
+tst_bitmaps: setb 7
+Setting block 7, was clear before
+tst_bitmaps: dump_bb
+block bitmap: 7f000000000000000000000000000000
+bits set: 7
+tst_bitmaps: setb 8
+Setting block 8, was clear before
+tst_bitmaps: dump_bb
+block bitmap: ff000000000000000000000000000000
+bits set: 8
+tst_bitmaps: setb 10
+Setting block 10, was clear before
+tst_bitmaps: setb 12
+Setting block 12, was clear before
+tst_bitmaps: setb 14
+Setting block 14, was clear before
+tst_bitmaps: setb 17
+Setting block 17, was clear before
+tst_bitmaps: setb 19
+Setting block 19, was clear before
+tst_bitmaps: setb 24
+Setting block 24, was clear before
+tst_bitmaps: setb 26
+Setting block 26, was clear before
+tst_bitmaps: setb 27
+Setting block 27, was clear before
+tst_bitmaps: setb 30
+Setting block 30, was clear before
+tst_bitmaps: setb 31
+Setting block 31, was clear before
+tst_bitmaps: setb 32
+Setting block 32, was clear before
+tst_bitmaps: setb 35
+Setting block 35, was clear before
+tst_bitmaps: setb 39
+Setting block 39, was clear before
+tst_bitmaps: setb 40
+Setting block 40, was clear before
+tst_bitmaps: setb 44
+Setting block 44, was clear before
+tst_bitmaps: setb 46
+Setting block 46, was clear before
+tst_bitmaps: setb 47
+Setting block 47, was clear before
+tst_bitmaps: setb 49
+Setting block 49, was clear before
+tst_bitmaps: setb 51
+Setting block 51, was clear before
+tst_bitmaps: setb 52
+Setting block 52, was clear before
+tst_bitmaps: clearb 2
+Clearing block 2, was set before
+tst_bitmaps: clearb 3
+Clearing block 3, was set before
+tst_bitmaps: clearb 7
+Clearing block 7, was set before
+tst_bitmaps: dump_bb
+block bitmap: b92a85e6c4680d000000000000000000
+bits set: 25
 tst_bitmaps: quit
 tst_bitmaps: 
-- 
1.7.12.rc0.22.gcdd159b

