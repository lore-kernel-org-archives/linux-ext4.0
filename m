From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Review of mballoc-core.patch
Date: Thu, 27 Sep 2007 11:07:35 -0400
Message-ID: <E1Iauxj-0001fp-F4@candygram.thunk.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59073 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbXI0PHl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2007 11:07:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Here's an initial code review of the mballoc-core.patch.  As far as I
can tell, the patch sent by Aneesh doesn't address any of these.
Aneesh, assuming that you'll be fixing these, could you please combine
your last set of fixes with fixes to address these, and send out an
updated mballoc-core.patch?   Patches on top of patches are useful for
seeing what has changed, but for the patch queue I'd like to get the
patches folded into a single patch, since that's what we'd want to have
placed into the git tree.

Thanks!!

							- Ted


--- linux-2.6.23-rc6.orig/include/linux/ext4_fs.h	2007-09-20 17:26:20.000000000 -0700
+++ linux-2.6.23-rc6/include/linux/ext4_fs.h	2007-09-20 17:26:22.000000000 -0700

+/* mballoc.c */
+extern long ext4_mb_stats;
+extern long ext4_mb_max_to_scan;

These aren't being used anywhere; please delete.

--- linux-2.6.23-rc6.orig/fs/ext4/balloc.c	2007-09-20 17:25:36.000000000 -0700
+++ linux-2.6.23-rc6/fs/ext4/balloc.c	2007-09-20 17:26:22.000000000 -0700
+	ar.inode = inode;
+	ar.goal = goal;
+	ar.len = 1;
+	ar.logical = 0;
+	ar.lleft = 0;
+	ar.pleft = 0;
+	ar.lright = 0;
+	ar.pright = 0;
+	ar.flags = 0;
+	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	return ret;

My preference is to do the initialization via

	memset(&ar, 0, sizeof(ar));
	ar.inode = inode;
	ar.goal = goal;
	ar.len = 1;

Less screen lines used, and faster on most architectures.

Index: linux-2.6.23-rc6/fs/ext4/extents.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext4/extents.c	2007-09-20 17:26:18.000000000 -0700
+++ linux-2.6.23-rc6/fs/ext4/extents.c	2007-09-20 17:26:22.000000000 -0700
@@ -2510,6 +2520,7 @@ int ext4_ext_get_blocks(handle_t *handle
 		 create == EXT4_CREATE_UNINITIALIZED_EXT)
 		max_blocks = EXT_UNINIT_MAX_LEN;
 
+
 	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
 	newex.ee_block = cpu_to_le32(iblock);
 	newex.ee_len = cpu_to_le16(max_blocks);

Why add an extra blank line here?  Please remove.

@@ -2593,6 +2619,9 @@ void ext4_ext_truncate(struct inode * in
 	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 	ext4_ext_invalidate_cache(inode);
 
+	/* it's important to discard preallocations under truncate_mutex */
+	ext4_mb_discard_inode_preallocations(inode);
+

How about moving this comment to just before
ext4_mb_discard_inode_preallocations, and explain why?

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc6/fs/ext4/mballoc.c	2007-09-20 17:26:22.000000000 -0700
+#if BITS_PER_LONG == 64
+#define mb_correct_addr_and_bit(bit, addr)		\
+{							\
+	bit += ((unsigned long) addr & 7UL) << 3;	\
+	addr = (void *) ((unsigned long) addr & ~7UL);	\
+}
+#elif BITS_PER_LONG == 32
+#define mb_correct_addr_and_bit(bit, addr)		\
+{							\
+	bit += ((unsigned long) addr & 3UL) << 3;	\
+	addr = (void *) ((unsigned long) addr & ~3UL);	\
+}
+#else
+#error "how many bits you are?!"
+#endif

This is totally unnecessary; check out atomic.h and non-atomic.h
in include/linux/asm-generic/bitops/.  You'll see that test/set/clear
bit primitives all do this already.

+static inline int mb_test_bit(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	return ext4_test_bit(bit, addr);
+}

Just change the code to use ext2_test_bit directly.

Actually, I'm not at all fond of the fact that ext4_test_bit is
#define'd to be ext2_test_bit.  There's a more generic cleanup that
needs to be done cross kernel since a large number of users (ocfs2, md,
reiserfs, udf, ext4) are all using ext2_test_bit.  We should give the
generic bitops a cleaner name, and then fix all of the users; it's kind
of bogus that ocfs2, udf, dm, et.al are using a generic kernel-supplied
primitive named ext2_test_bit!

+static inline void mb_set_bit(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_set_bit(bit, addr);
+}

Not necessary

+static inline void mb_set_bit_atomic(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_set_bit_atomic(NULL, bit, addr);
+}

Not necessary

+static inline void mb_clear_bit(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_clear_bit(bit, addr);
+}

Not neecessary.

+static inline void mb_clear_bit_atomic(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_clear_bit_atomic(NULL, bit, addr);
+}

Not necessary.


+static inline int mb_find_next_zero_bit(void *addr, int max, int start)
+{
+	int fix;
+#if BITS_PER_LONG == 64
+	fix = ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
+#elif BITS_PER_LONG == 32
+	fix = ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
+#else
+#error "how many bits you are?!"
+#endif
+	max += fix;
+	start += fix;
+	return ext4_find_next_zero_bit(addr, max, start) - fix;
+}

Not necessary.

+static inline int mb_find_next_bit(void *addr, int max, int start)
+{
+	int fix;
+#if BITS_PER_LONG == 64
+	fix = ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
+#elif BITS_PER_LONG == 32
+	fix = ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
+#else
+#error "how many bits you are?!"
+#endif
+	max += fix;
+	start += fix;
+
+	return ext4_find_next_bit(addr, max, start) - fix;
+}

Not necessary.

+static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
+{
+	char *bb;
+
+	BUG_ON(EXT4_MB_BITMAP(e4b) == EXT4_MB_BUDDY(e4b));

Why would this ever be true?   Is this a realistic thing to test for?

+	BUG_ON(max == NULL);
+
+	if (order > e4b->bd_blkbits + 1) {
+		*max = 0;
+		return NULL;
+	}
+
+	/* at order 0 we see each particular block */
+	*max = 1 << (e4b->bd_blkbits + 3);
+	if (order == 0)
+		return EXT4_MB_BITMAP(e4b);
+
+	bb = EXT4_MB_BUDDY(e4b) + EXT4_SB(e4b->bd_sb)->s_mb_offsets[order];
+	*max = EXT4_SB(e4b->bd_sb)->s_mb_maxs[order];
+
+	return bb;
+}

I wouldn't do this function as an inline; it's a bit too big to be worth
it.  Modern architectures have optimized function call and returns, so
unless it's one or two instructions, C statements, probably not worth
it.


+/* find most significant bit */
+static inline int fmsb(unsigned short word)
+{
+	int order;
+
+	if (word > 255) {
+		order = 7;
+		word >>= 8;
+	} else {
+		order = -1;
+	}
+
+	do {
+		order++;
+		word >>= 1;
+	} while (word != 0);
+
+	return order;
+}

Again, a bit big to inline; I know it's used only once, so I won't
object too strenuously, as long as you add a comment to that effect.

+static inline void
+ext4_mb_mark_free_simple(struct super_block *sb, void *buddy, unsigned first,
+				int len, struct ext4_group_info *grp)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	unsigned short min;
+	unsigned short max;
+	unsigned short chunk;
+	unsigned short border;
+
+	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
+
+	border = 2 << sb->s_blocksize_bits;
+
+	while (len > 0) {
+		/* find how many blocks can be covered since this position */
+		max = ffs(first | border) - 1;
+
+		/* find how many blocks of power 2 we need to mark */
+		min = fmsb(len);
+
+		if (max < min)
+			min = max;
+		chunk = 1 << min;
+
+		/* mark multiblock chunks only */
+		grp->bb_counters[min]++;
+		if (min > 0)
+			mb_clear_bit(first >> min,
+				     buddy + sbi->s_mb_offsets[min]);
+
+		len -= chunk;
+		first += chunk;
+	}
+}

This function is absolutely huge to inline, and again it's only used
once.   So a comment is once again in order; a comment explaining what
this function does would also be a really good idea.

+static inline void mb_clear_bits(void *bm, int cur, int len)
+{
+	__u32 *addr;
+
+	len = cur + len;
+	while (cur < len) {
+		if ((cur & 31) == 0 && (len - cur) >= 32) {
+			/* fast path: clear whole word at once */
+			addr = bm + (cur >> 3);
+			*addr = 0;
+			cur += 32;
+			continue;
+		}
+		mb_clear_bit_atomic(cur, bm);
+		cur++;
+	}
+}

Lose the inline, or drop it into ext4_mb_free_blocks()

+static inline void mb_set_bits(void *bm, int cur, int len)
+{
+	__u32 *addr;
+
+	len = cur + len;
+	while (cur < len) {
+		if ((cur & 31) == 0 && (len - cur) >= 32) {
+			/* fast path: clear whole word at once */
+			addr = bm + (cur >> 3);
+			*addr = 0xffffffff;
+			cur += 32;
+			continue;
+		}
+		mb_set_bit_atomic(cur, bm);
+		cur++;
+	}
+}

Lose the inline (it's used twice, in mb_mark_used() and
ext4_mb_mark_diskspace_used(). 

+	if (likely(order == 0)) {
+		/* find actual order */
+		order = mb_find_order_for_block(e4b, block);
+		block = block >> order;
+	}

Not only is it likely, but it's guaranteed --- all of the callers the
static function mb_find_extent() pass in an order parameter of 0.  So
why not eliminate the parameter?  :-)

+	/* XXXXXXX: SUCH A HORRIBLE **CK */
+	ac->ac_bitmap_page = e4b->bd_bitmap_page;
+	get_page(ac->ac_bitmap_page);
+	ac->ac_buddy_page = e4b->bd_buddy_page;
+	get_page(ac->ac_buddy_page);

I'm sure I'm missing something here, but why is this considered a
horrible hack?

There are a bunch of FIXME's in this which I assume will get addressed
before we consider this ready to push to mainline?

       	  	   	      	      	 - Ted
