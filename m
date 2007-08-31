From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] placate checkpatch.pl to some degree for mballoc.c
Date: Fri, 31 Aug 2007 14:57:23 -0700
Message-ID: <1188597443.3837.27.camel@localhost.localdomain>
References: <46D887F2.1040502@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46420 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXHaV5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2007 17:57:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7VLwXDE018121
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2007 17:58:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7VLv9po513790
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2007 17:57:09 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7VLv9m7028975
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2007 17:57:09 -0400
In-Reply-To: <46D887F2.1040502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-08-31 at 16:28 -0500, Eric Sandeen wrote:
> Here's a patch for mballoc.c, to make checkpatch happier with it.
> 
> I was about as pedantic as I could be, except for a few things it 
> complained about which I just could not agree with. :)
> 
> One of the comments in the series file in git says checkpatch doesn't like
> mballoc, so, here you go, if it's helpful.  

Very helpful, thanks!

> Applies to the bottom of the
> patch stack - should some of these mballoc patches get rolled together by
> now?
> 
Okay, will do.

There are still a issue with mballoc, it doesn't handle big endian  when
generating free extents map from on-disk bitmaps. Thus cause failure
compile on ppc64. ppc64 needs to implement generic_find_next_le_bit.

Andreas pointed a patch already in cfs bug report,
https://bugzilla.lustre.org/show_bug.cgi?id=10634, the patch for this is
in the last attachment. 


> -Eric
> 
> ----------------
> 
> Make checkpatch happier with mballoc.c
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: ext4.git/fs/ext4/mballoc.c
> ===================================================================
> --- ext4.git.orig/fs/ext4/mballoc.c
> +++ ext4.git/fs/ext4/mballoc.c
> @@ -247,9 +247,9 @@
>   */
>  #define MB_DEBUG__
>  #ifdef MB_DEBUG
> -#define mb_debug(fmt,a...)	printk(fmt, ##a)
> +#define mb_debug(fmt, a...)	printk(fmt, ##a)
>  #else
> -#define mb_debug(fmt,a...)
> +#define mb_debug(fmt, a...)
> 
>  #endif
> 
>  /*
> @@ -303,7 +303,7 @@
>   */
>  #define MB_DEFAULT_STRIPE		256
> 
> -static struct kmem_cache *ext4_pspace_cachep = NULL;
> +static struct kmem_cache *ext4_pspace_cachep;
> 
>  #ifdef EXT4_BB_MAX_BLOCKS
>  #undef EXT4_BB_MAX_BLOCKS
> @@ -353,7 +353,7 @@ struct ext4_prealloc_space {
>  	unsigned short		pa_len;		/* len of preallocated chunk */
>  	unsigned short		pa_free;	/* how many blocks are free */
>  	unsigned short		pa_linear;	/* consumed in one direction
> -						 * strictly, for group prealloc */
> +						 * strictly, for grp prealloc */
>  	spinlock_t		*pa_obj_lock;
>  	struct inode		*pa_inode;	/* hack, for history only */
>  };
> @@ -456,8 +456,8 @@ static void ext4_mb_store_history(struct
> 
>  static struct proc_dir_entry *proc_root_ext4;
> 
> -int ext4_create (struct inode *, struct dentry *, int, struct nameidata *);
> -struct buffer_head * read_block_bitmap(struct super_block *, unsigned int);
> +int ext4_create(struct inode *, struct dentry *, int, struct nameidata *);
> +struct buffer_head *read_block_bitmap(struct super_block *, unsigned int);
>  ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
>  void ext4_mb_release_blocks(struct super_block *, int);
> @@ -465,11 +465,13 @@ void ext4_mb_poll_new_transaction(struct
>  void ext4_mb_free_committed_blocks(struct super_block *);
>  void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group);
>  void ext4_mb_free_consumed_preallocations(struct ext4_allocation_context *ac);
> -void ext4_mb_return_to_preallocation(struct inode *inode, struct ext4_buddy *e3b,
> -					sector_t block, int count);
> +void ext4_mb_return_to_preallocation(struct inode *inode,
> +					struct ext4_buddy *e3b, sector_t block,
> +					int count);
>  void ext4_mb_show_ac(struct ext4_allocation_context *ac);
>  void ext4_mb_check_with_pa(struct ext4_buddy *e3b, int first, int count);
> -void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *, struct ext4_prealloc_space *pa);
> +void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *,
> +						struct ext4_prealloc_space *pa);
>  int ext4_mb_init_per_dev_proc(struct super_block *sb);
>  int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
> 
> @@ -507,13 +509,13 @@ unsigned long ext4_grp_offs_to_block(str
>  }
> 
>  #if BITS_PER_LONG == 64
> -#define mb_correct_addr_and_bit(bit,addr)		\
> +#define mb_correct_addr_and_bit(bit, addr)		\
>  {							\
>  	bit += ((unsigned long) addr & 7UL) << 3;	\
>  	addr = (void *) ((unsigned long) addr & ~7UL);	\
>  }
>  #elif BITS_PER_LONG == 32
> -#define mb_correct_addr_and_bit(bit,addr)		\
> +#define mb_correct_addr_and_bit(bit, addr)		\
>  {							\
>  	bit += ((unsigned long) addr & 3UL) << 3;	\
>  	addr = (void *) ((unsigned long) addr & ~3UL);	\
> @@ -524,31 +526,31 @@ unsigned long ext4_grp_offs_to_block(str
> 
>  static inline int mb_test_bit(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit,addr);
> +	mb_correct_addr_and_bit(bit, addr);
>  	return ext2_test_bit(bit, addr);
>  }
> 
>  static inline void mb_set_bit(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit,addr);
> +	mb_correct_addr_and_bit(bit, addr);
>  	ext2_set_bit(bit, addr);
>  }
> 
>  static inline void mb_set_bit_atomic(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit,addr);
> +	mb_correct_addr_and_bit(bit, addr);
>  	ext2_set_bit_atomic(NULL, bit, addr);
>  }
> 
>  static inline void mb_clear_bit(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit,addr);
> +	mb_correct_addr_and_bit(bit, addr);
>  	ext2_clear_bit(bit, addr);
>  }
> 
>  static inline void mb_clear_bit_atomic(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit,addr);
> +	mb_correct_addr_and_bit(bit, addr);
>  	ext2_clear_bit_atomic(NULL, bit, addr);
>  }
> 
> @@ -615,7 +617,7 @@ static inline void *mb_find_buddy(struct
> 
>  #ifdef DOUBLE_CHECK
>  void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e3b,
> -		           int first, int count)
> +			   int first, int count)
>  {
>  	int i;
>  	struct super_block *sb = e3b->bd_sb;
> @@ -671,9 +673,9 @@ void mb_cmp_bitmaps(struct ext4_buddy *e
>  }
> 
>  #else
> -#define mb_free_blocks_double(a,b,c,d)
> -#define mb_mark_used_double(a,b,c)
> -#define mb_cmp_bitmaps(a,b)
> +#define mb_free_blocks_double(a, b, c, d)
> +#define mb_mark_used_double(a, b, c)
> +#define mb_cmp_bitmaps(a, b)
>  #endif
> 
>  #ifdef AGGRESSIVE_CHECK
> @@ -681,7 +683,7 @@ void mb_cmp_bitmaps(struct ext4_buddy *e
>  #define MB_CHECK_ASSERT(assert)						\
>  do {									\
>  	if (!(assert)) {						\
> -		printk (KERN_EMERG					\
> +		printk(KERN_EMERG					\
>  			"Assertion failure in %s() at %s:%d: \"%s\"\n",	\
>  			function, file, line, # assert);		\
>  		BUG();							\
> @@ -693,11 +695,18 @@ static int __mb_check_buddy(struct ext4_
>  {
>  	struct super_block *sb = e3b->bd_sb;
>  	int order = e3b->bd_blkbits + 1;
> -	int max, max2, i, j, k, count;
> +	int max;
> +	int max2;
> +	int i;
> +	int j;
> +	int k;
> +	int count;
>  	struct ext4_group_info *grp;
> -	int fragments = 0, fstart;
> +	int fragments = 0;
> +	int fstart;
>  	struct list_head *cur;
> -	void *buddy, *buddy2;
> +	void *buddy;
> +	void *buddy2;
> 
>  	if (!test_opt(sb, MBALLOC))
>  		return 0;
> @@ -721,10 +730,13 @@ static int __mb_check_buddy(struct ext4_
> 
>  			if (mb_test_bit(i, buddy)) {
>  				/* only single bit in buddy2 may be 1 */
> -				if (!mb_test_bit(i << 1, buddy2))
> -					MB_CHECK_ASSERT(mb_test_bit((i<<1)+1, buddy2));
> -				else if (!mb_test_bit((i << 1) + 1, buddy2))
> -					MB_CHECK_ASSERT(mb_test_bit(i << 1, buddy2));
> +				if (!mb_test_bit(i << 1, buddy2)) {
> +					MB_CHECK_ASSERT(
> +						mb_test_bit((i<<1)+1, buddy2));
> +				} else if (!mb_test_bit((i << 1) + 1, buddy2)) {
> +					MB_CHECK_ASSERT(
> +						mb_test_bit(i << 1, buddy2));
> +				}
>  				continue;
>  			}
> 
> @@ -734,7 +746,8 @@ static int __mb_check_buddy(struct ext4_
> 
>  			for (j = 0; j < (1 << order); j++) {
>  				k = (i * (1 << order)) + j;
> -				MB_CHECK_ASSERT(!mb_test_bit(k, EXT4_MB_BITMAP(e3b)));
> +				MB_CHECK_ASSERT(
> +					!mb_test_bit(k, EXT4_MB_BITMAP(e3b)));
>  			}
>  			count++;
>  		}
> @@ -779,13 +792,13 @@ static int __mb_check_buddy(struct ext4_
>  	return 0;
>  }
>  #undef MB_CHECK_ASSERT
> -#define mb_check_buddy(e3b) __mb_check_buddy(e3b,__FILE__,__FUNCTION__,__LINE__)
> +#define mb_check_buddy(e3b) __mb_check_buddy(e3b, __FILE__, __FUNCTION__, __LINE__)
>  #else
>  #define mb_check_buddy(e3b)
>  #endif
> 
>  /* find most significant bit */
> -static int inline fmsb(unsigned short word)
> +static inline int fmsb(unsigned short word)
>  {
>  	int order;
> 
> @@ -804,12 +817,15 @@ static int inline fmsb(unsigned short wo
>  	return order;
>  }
> 
> -static void inline
> +static inline void
>  ext4_mb_mark_free_simple(struct super_block *sb, void *buddy, unsigned first,
>  				int len, struct ext4_group_info *grp)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	unsigned short min, max, chunk, border;
> +	unsigned short min;
> +	unsigned short max;
> +	unsigned short chunk;
> +	unsigned short border;
> 
>  	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> 
> @@ -829,7 +845,8 @@ ext4_mb_mark_free_simple(struct super_bl
>  		/* mark multiblock chunks only */
>  		grp->bb_counters[min]++;
>  		if (min > 0)
> -			mb_clear_bit(first >> min, buddy + sbi->s_mb_offsets[min]);
> +			mb_clear_bit(first >> min,
> +					buddy + sbi->s_mb_offsets[min]);
> 
>  		len -= chunk;
>  		first += chunk;
> @@ -842,8 +859,11 @@ ext4_mb_generate_buddy(struct super_bloc
>  {
>  	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
>  	unsigned short max = EXT4_BLOCKS_PER_GROUP(sb);
> -	unsigned short i = 0, first, len;
> -	unsigned free = 0, fragments = 0;
> +	unsigned short i = 0;
> +	unsigned short first;
> +	unsigned short len;
> +	unsigned free = 0;
> +	unsigned fragments = 0;
>  	unsigned long long period = get_cycles();
> 
>  	/* initialize buddy from bitmap which is aggregation
> @@ -882,13 +902,19 @@ ext4_mb_generate_buddy(struct super_bloc
> 
>  static int ext4_mb_init_cache(struct page *page, char *incore)
>  {
> -	int blocksize, blocks_per_page, groups_per_page;
> -	int err = 0, i, first_group, first_block;
> +	int blocksize;
> +	int blocks_per_page;
> +	int groups_per_page;
> +	int err = 0;
> +	int i;
> +	int first_group;
> +	int first_block;
>  	struct super_block *sb;
>  	struct buffer_head *bhs;
>  	struct buffer_head **bh;
>  	struct inode *inode;
> -	char *data, *bitmap;
> +	char *data;
> +	char *bitmap;
> 
>  	mb_debug("init page %lu\n", page->index);
> 
> @@ -916,7 +942,7 @@ static int ext4_mb_init_cache(struct pag
> 
>  	/* read all groups the page covers into the cache */
>  	for (i = 0; i < groups_per_page; i++) {
> -		struct ext4_group_desc * desc;
> +		struct ext4_group_desc *desc;
> 
>  		if (first_group + i >= EXT4_SB(sb)->s_groups_count)
>  			break;
> @@ -987,7 +1013,7 @@ static int ext4_mb_init_cache(struct pag
>  			ext4_lock_group(sb, group);
>  			memcpy(data, bitmap, blocksize);
> 
> -			/* mark all preallocated blocks used in in-core bitmap */
> +			/* mark all preallocated blks used in in-core bitmap */
>  			ext4_mb_generate_from_pa(sb, data, group);
>  			ext4_unlock_group(sb, group);
> 
> @@ -1011,7 +1037,10 @@ static int ext4_mb_load_buddy(struct sup
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct inode *inode = sbi->s_buddy_cache;
> -	int blocks_per_page, block, pnum, poff;
> +	int blocks_per_page;
> +	int block;
> +	int pnum;
> +	int poff;
>  	struct page *page;
> 
>  	mb_debug("load group %u\n", group);
> @@ -1159,8 +1188,11 @@ static inline void mb_set_bits(void *bm,
>  static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e3b,
>  			  int first, int count)
>  {
> -	int block = 0, max = 0, order;
> -	void *buddy, *buddy2;
> +	int block = 0;
> +	int max = 0;
> +	int order;
> +	void *buddy;
> +	void *buddy2;
>  	struct super_block *sb = e3b->bd_sb;
> 
>  	BUG_ON(first + count > (sb->s_blocksize << 3));
> @@ -1242,7 +1274,9 @@ static int mb_free_blocks(struct inode *
>  static int mb_find_extent(struct ext4_buddy *e3b, int order, int block,
>  				int needed, struct ext4_free_extent *ex)
>  {
> -	int next = block, max, ord;
> +	int next = block;
> +	int max;
> +	int ord;
>  	void *buddy;
> 
>  	BUG_ON(!ext4_is_group_locked(e3b->bd_sb, e3b->bd_group));
> @@ -1273,7 +1307,8 @@ static int mb_find_extent(struct ext4_bu
>  	ex->fe_len -= next;
>  	ex->fe_start += next;
> 
> -	while (needed > ex->fe_len && (buddy = mb_find_buddy(e3b, order, &max))) {
> +	while (needed > ex->fe_len &&
> +	       (buddy = mb_find_buddy(e3b, order, &max))) {
> 
>  		if (block + 1 >= max)
>  			break;
> @@ -1295,7 +1330,10 @@ static int mb_find_extent(struct ext4_bu
> 
>  static int mb_mark_used(struct ext4_buddy *e3b, struct ext4_free_extent *ex)
>  {
> -	int ord, mlen = 0, max = 0, cur;
> +	int ord;
> +	int mlen = 0;
> +	int max = 0;
> +	int cur;
>  	int start = ex->fe_start;
>  	int len = ex->fe_len;
>  	unsigned ret = 0;
> @@ -1517,7 +1555,9 @@ static int ext4_mb_try_best_found(struct
>  					struct ext4_buddy *e3b)
>  {
>  	struct ext4_free_extent ex = ac->ac_b_ex;
> -	int group = ex.fe_group, max, err;
> +	int group = ex.fe_group;
> +	int max;
> +	int err;
> 
>  	BUG_ON(ex.fe_len <= 0);
>  	err = ext4_mb_load_buddy(ac->ac_sb, group, e3b);
> @@ -1541,7 +1581,9 @@ static int ext4_mb_try_best_found(struct
>  static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
>  				struct ext4_buddy *e3b)
>  {
> -	int group = ac->ac_g_ex.fe_group, max, err;
> +	int group = ac->ac_g_ex.fe_group;
> +	int max;
> +	int err;
>  	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
>  	struct ext4_super_block *es = sbi->s_es;
>  	struct ext4_free_extent ex;
> @@ -1599,7 +1641,9 @@ static void ext4_mb_simple_scan_group(st
>  	struct super_block *sb = ac->ac_sb;
>  	struct ext4_group_info *grp = e3b->bd_info;
>  	void *buddy;
> -	int i, k, max;
> +	int i;
> +	int k;
> +	int max;
> 
>  	BUG_ON(ac->ac_2order <= 0);
>  	for (i = ac->ac_2order; i <= sb->s_blocksize_bits + 1; i++) {
> @@ -1640,7 +1684,8 @@ static void ext4_mb_complex_scan_group(s
>  	struct super_block *sb = ac->ac_sb;
>  	void *bitmap = EXT4_MB_BITMAP(e3b);
>  	struct ext4_free_extent ex;
> -	int i, free;
> +	int i;
> +	int free;
> 
>  	free = e3b->bd_info->bb_free;
>  	BUG_ON(free <= 0);
> @@ -1678,7 +1723,8 @@ static void ext4_mb_scan_aligned(struct 
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	void *bitmap = EXT4_MB_BITMAP(e3b);
>  	struct ext4_free_extent ex;
> -	unsigned long i, max;
> +	unsigned long i;
> +	unsigned long max;
> 
>  	BUG_ON(sbi->s_stripe == 0);
> 
> @@ -1707,7 +1753,10 @@ static int ext4_mb_good_group(struct ext
>  				int group, int cr)
>  {
>  	struct ext4_group_info *grp = EXT4_GROUP_INFO(ac->ac_sb, group);
> -	unsigned free, fragments, i, bits;
> +	unsigned free;
> +	unsigned fragments;
> +	unsigned i;
> +	unsigned bits;
> 
>  	BUG_ON(cr < 0 || cr >= 4);
>  	BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));
> @@ -1720,25 +1769,25 @@ static int ext4_mb_good_group(struct ext
>  		return 0;
> 
>  	switch (cr) {
> -		case 0:
> -			BUG_ON(ac->ac_2order == 0);
> -			bits = ac->ac_sb->s_blocksize_bits + 1;
> -			for (i = ac->ac_2order; i <= bits; i++)
> -				if (grp->bb_counters[i] > 0)
> -					return 1;
> -			break;
> -		case 1:
> -			if ((free / fragments) >= ac->ac_g_ex.fe_len)
> +	case 0:
> +		BUG_ON(ac->ac_2order == 0);
> +		bits = ac->ac_sb->s_blocksize_bits + 1;
> +		for (i = ac->ac_2order; i <= bits; i++)
> +			if (grp->bb_counters[i] > 0)
>  				return 1;
> -			break;
> -		case 2:
> -			if (free >= ac->ac_g_ex.fe_len)
> -				return 1;
> -			break;
> -		case 3:
> +		break;
> +	case 1:
> +		if ((free / fragments) >= ac->ac_g_ex.fe_len)
> +			return 1;
> +		break;
> +	case 2:
> +		if (free >= ac->ac_g_ex.fe_len)
>  			return 1;
> -		default:
> -			BUG();
> +		break;
> +	case 3:
> +		return 1;
> +	default:
> +		BUG();
>  	}
> 
>  	return 0;
> @@ -1746,7 +1795,10 @@ static int ext4_mb_good_group(struct ext
> 
>  int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  {
> -	int group, i, cr, err = 0;
> +	int group;
> +	int i;
> +	int cr;
> +	int err = 0;
>  	struct ext4_sb_info *sbi;
>  	struct super_block *sb;
>  	struct ext4_buddy e3b;
> @@ -1910,7 +1962,8 @@ static void *ext4_mb_seq_history_start(s
>  	return hs;
>  }
> 
> -static void *ext4_mb_seq_history_next(struct seq_file *seq, void *v, loff_t *pos)
> +static void *ext4_mb_seq_history_next(struct seq_file *seq, void *v,
> +				      loff_t *pos)
>  {
>  	struct ext4_mb_proc_session *s = seq->private;
>  	struct ext4_mb_history *hs = v;
> @@ -1990,7 +2043,8 @@ static int ext4_mb_seq_history_open(stru
>  	struct super_block *sb = PDE(inode)->data;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_mb_proc_session *s;
> -	int rc, size;
> +	int rc;
> +	int size;
> 
>  	s = kmalloc(sizeof(*s), GFP_KERNEL);
>  	if (s == NULL)
> @@ -2096,7 +2150,8 @@ static int ext4_mb_seq_groups_show(struc
>  {
>  	struct super_block *sb = seq->private;
>  	long group = (long) v;
> -	int i, err;
> +	int i;
> +	int err;
>  	struct ext4_buddy e3b;
>  	struct sg {
>  		struct ext4_group_info info;
> @@ -2174,8 +2229,7 @@ static void ext4_mb_history_release(stru
>  	remove_proc_entry("mb_groups", sbi->s_mb_proc);
>  	remove_proc_entry("mb_history", sbi->s_mb_proc);
> 
> -	if (sbi->s_mb_history)
> -		kfree(sbi->s_mb_history);
> +	kfree(sbi->s_mb_history);
>  }
> 
>  static void ext4_mb_history_init(struct super_block *sb)
> @@ -2248,7 +2302,10 @@ ext4_mb_store_history(struct ext4_alloca
>  int ext4_mb_init_backend(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	int i, j, len, metalen;
> +	int i;
> +	int j;
> +	int len;
> +	int metalen;
>  	int num_meta_group_infos =
>  		(sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) >>
>  			EXT4_DESC_PER_BLOCK_BITS(sb);
> @@ -2292,7 +2349,7 @@ int ext4_mb_init_backend(struct super_bl
>  	len = sizeof(struct ext4_group_info);
>  	len += sizeof(unsigned short) * (sb->s_blocksize_bits + 2);
>  	for (i = 0; i < sbi->s_groups_count; i++) {
> -		struct ext4_group_desc * desc;
> +		struct ext4_group_desc *desc;
> 
>  		meta_group_info =
>  			sbi->s_group_info[i >> EXT4_DESC_PER_BLOCK_BITS(sb)];
> @@ -2306,7 +2363,8 @@ int ext4_mb_init_backend(struct super_bl
>  		}
>  		desc = ext4_get_group_desc(sb, i, NULL);
>  		if (desc == NULL) {
> -			printk(KERN_ERR"EXT4-fs: can't read descriptor %u\n",i);
> +			printk(KERN_ERR
> +				"EXT4-fs: can't read descriptor %u\n", i);
>  			goto err_freebuddy;
>  		}
>  		memset(meta_group_info[j], 0, len);
> @@ -2356,7 +2414,9 @@ err_freesgi:
>  int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	unsigned i, offset, max;
> +	unsigned i;
> +	unsigned offset;
> +	unsigned max;
> 
>  	if (!test_opt(sb, MBALLOC))
>  		return 0;
> @@ -2391,7 +2451,8 @@ int ext4_mb_init(struct super_block *sb,
>  	} while (i <= sb->s_blocksize_bits + 1);
> 
>  	/* init file for buddy data */
> -	if ((i = ext4_mb_init_backend(sb))) {
> +	i = ext4_mb_init_backend(sb);
> +	if (i) {
>  		clear_opt(sbi->s_mount_opt, MBALLOC);
>  		kfree(sbi->s_mb_offsets);
>  		kfree(sbi->s_mb_maxs);
> @@ -2411,7 +2472,8 @@ int ext4_mb_init(struct super_block *sb,
>  	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
>  	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
> 
> -	i = sbi->s_mb_prealloc_table_size = 7;
> +	sbi->s_mb_prealloc_table_size = 7;
> +	i = sbi->s_mb_prealloc_table_size;
>  	sbi->s_mb_prealloc_table = kmalloc(sizeof(unsigned long) * i,
>  						GFP_NOFS);
>  	if (sbi->s_mb_prealloc_table == NULL) {
> @@ -2477,7 +2539,8 @@ void ext4_mb_cleanup_pa(struct ext4_grou
>  int ext4_mb_release(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	int i, num_meta_group_infos;
> +	int i;
> +	int num_meta_group_infos;
> 
>  	if (!test_opt(sb, MBALLOC))
>  		return 0;
> @@ -2507,34 +2570,35 @@ int ext4_mb_release(struct super_block *
>  			kfree(sbi->s_group_info[i]);
>  		kfree(sbi->s_group_info);
>  	}
> -	if (sbi->s_mb_offsets)
> -		kfree(sbi->s_mb_offsets);
> -	if (sbi->s_mb_maxs)
> -		kfree(sbi->s_mb_maxs);
> +	kfree(sbi->s_mb_offsets);
> +	kfree(sbi->s_mb_maxs);
>  	if (sbi->s_buddy_cache)
>  		iput(sbi->s_buddy_cache);
>  	if (sbi->s_mb_stats) {
> -		printk("EXT4-fs: mballoc: %u blocks %u reqs (%u success)\n",
> +		printk(KERN_INFO
> +		       "EXT4-fs: mballoc: %u blocks %u reqs (%u success)\n",
>  				atomic_read(&sbi->s_bal_allocated),
>  				atomic_read(&sbi->s_bal_reqs),
>  				atomic_read(&sbi->s_bal_success));
> -		printk("EXT4-fs: mballoc: %u extents scanned, %u goal hits, "
> +		printk(KERN_INFO
> +		      "EXT4-fs: mballoc: %u extents scanned, %u goal hits, "
>  				"%u 2^N hits, %u breaks, %u lost\n",
>  				atomic_read(&sbi->s_bal_ex_scanned),
>  				atomic_read(&sbi->s_bal_goals),
>  				atomic_read(&sbi->s_bal_2orders),
>  				atomic_read(&sbi->s_bal_breaks),
>  				atomic_read(&sbi->s_mb_lost_chunks));
> -		printk("EXT4-fs: mballoc: %lu generated and it took %Lu\n",
> +		printk(KERN_INFO
> +		       "EXT4-fs: mballoc: %lu generated and it took %Lu\n",
>  				sbi->s_mb_buddies_generated++,
>  				sbi->s_mb_generation_time);
> -		printk("EXT4-fs: mballoc: %u preallocated, %u discarded\n",
> +		printk(KERN_INFO
> +		       "EXT4-fs: mballoc: %u preallocated, %u discarded\n",
>  				atomic_read(&sbi->s_mb_preallocated),
>  				atomic_read(&sbi->s_mb_discarded));
>  	}
> 
> -	if (sbi->s_locality_groups)
> -		kfree(sbi->s_locality_groups);
> +	kfree(sbi->s_locality_groups);
> 
>  	ext4_mb_history_release(sb);
>  	ext4_mb_destroy_per_dev_proc(sb);
> @@ -2545,7 +2609,10 @@ int ext4_mb_release(struct super_block *
>  void ext4_mb_free_committed_blocks(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	int err, i, count = 0, count2 = 0;
> +	int err;
> +	int i;
> +	int count = 0;
> +	int count2 = 0;
>  	struct ext4_free_metadata *md;
>  	struct ext4_buddy e3b;
> 
> @@ -2612,7 +2679,9 @@ static int ext4_mb_read_prealloc_table(c
>  			off_t off, int count, int *eof, void *data)
>  {
>  	struct ext4_sb_info *sbi = data;
> -	int len = 0, i;
> +	int len = 0;
> +	int i;
> +
>  	*eof = 1;
>  	if (off != 0)
>  		return 0;
> @@ -2628,10 +2697,14 @@ static int ext4_mb_write_prealloc_table(
>  			const char *buf, unsigned long cnt, void *data)
>  {
>  	struct ext4_sb_info *sbi = data;
> -	unsigned long value, prev = 0;
> -	char str[128], *cur, *end;
> +	unsigned long value;
> +	unsigned long prev = 0;
> +	char str[128];
> +	char *cur;
> +	char *end;
>  	unsigned long *new_table;
> -	int num = 0, i = 0;
> +	int num = 0;
> +	int i = 0;
> 
>  	if (cnt >= sizeof(str))
>  		return -EINVAL;
> @@ -2715,6 +2788,7 @@ MB_PROC_VALUE_READ(group_prealloc);
>  MB_PROC_VALUE_WRITE(group_prealloc);
> 
>  #define	MB_PROC_HANDLER(name, var)					\
> +    do {								\
>  	proc = create_proc_entry(name, mode, sbi->s_mb_proc);		\
>  	if (proc == NULL) {						\
>  		printk(KERN_ERR "EXT4-fs: can't to create %s\n", name);	\
> @@ -2722,7 +2796,8 @@ MB_PROC_VALUE_WRITE(group_prealloc);
>  	}								\
>  	proc->data = sbi;						\
>  	proc->read_proc  = ext4_mb_read_##var ;				\
> -	proc->write_proc = ext4_mb_write_##var;
> +	proc->write_proc = ext4_mb_write_##var;				\
> +    } while (0)
> 
>  int ext4_mb_init_per_dev_proc(struct super_block *sb)
>  {
> @@ -2812,7 +2887,8 @@ void exit_ext4_proc(void)
>   * Check quota and mark choosed space (ac->ac_b_ex) non-free in bitmaps
>   * Returns 0 if success or error code
>   */
> -int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac, handle_t *handle)
> +int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
> +				handle_t *handle)
>  {
>  	struct buffer_head *bitmap_bh = NULL;
>  	struct ext4_super_block *es;
> @@ -2871,7 +2947,8 @@ int ext4_mb_mark_diskspace_used(struct e
>  		}
>  	}
>  #endif
> -	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
> +	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
> +						ac->ac_b_ex.fe_len);
> 
>  	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
>  	gdp->bg_free_blocks_count =
> @@ -2915,9 +2992,15 @@ void ext4_mb_normalize_request(struct ex
>  {
>  	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
>  	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
> -	loff_t start, end, size, orig_size, orig_start, wind;
> +	loff_t start;
> +	loff_t end;
> +	loff_t size;
> +	loff_t orig_size;
> +	loff_t orig_start;
> +	loff_t wind;
>  	struct list_head *cur;
> -	int bsbits, i;
> +	int bsbits;
> +	int i;
> 
>  	/* do normalize only data requests, metadata requests
>  	   do not need preallocation */
> @@ -2965,7 +3048,8 @@ void ext4_mb_normalize_request(struct ex
>  		do_div(start, wind);
>  		start = start * wind;
>  	}
> -	orig_size = size = wind;
> +	size = wind;
> +	orig_size = size;
>  	orig_start = start;
> 
>  	/* don't cover already allocated blocks in selected range */
> @@ -3042,7 +3126,7 @@ void ext4_mb_normalize_request(struct ex
> 
>  	if (start + size <= ac->ac_o_ex.fe_logical &&
>  			start > ac->ac_o_ex.fe_logical) {
> -		printk("start %lu, size %lu, fe_logical %lu\n",
> +		printk(KERN_ERR "start %lu, size %lu, fe_logical %lu\n",
>  			(unsigned long) start, (unsigned long) size,
>  			(unsigned long) ac->ac_o_ex.fe_logical);
>  	}
> @@ -3103,7 +3187,8 @@ void ext4_mb_collect_stats(struct ext4_a
>  void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
>  				struct ext4_prealloc_space *pa)
>  {
> -	unsigned long start, len;
> +	unsigned long start;
> +	unsigned long len;
> 
>  	/* found preallocated blocks, use them */
>  	start = pa->pa_pstart + (ac->ac_o_ex.fe_logical - pa->pa_lstart);
> @@ -3223,9 +3308,11 @@ void ext4_mb_generate_from_pa(struct sup
>  	struct list_head *cur;
>  	unsigned long groupnr;
>  	ext4_grpblk_t start;
> -	int preallocated = 0, count = 0, len;
> +	int preallocated = 0;
> +	int count = 0;
> +	int len;
> 
> - 	/* all form of preallocation discards first load group,
> +	/* all form of preallocation discards first load group,
>  	 * so the only competing code is preallocation use.
>  	 * we don't need any locking here
>  	 * notice we do NOT ignore preallocations with pa_deleted
> @@ -3236,7 +3323,8 @@ void ext4_mb_generate_from_pa(struct sup
>  	list_for_each_rcu(cur, &grp->bb_prealloc_list) {
>  		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
>  		spin_lock(&pa->pa_lock);
> -		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &groupnr, &start);
> +		ext4_get_group_no_and_offset(sb, pa->pa_pstart,
> +					     &groupnr, &start);
>  		len = pa->pa_len;
>  		spin_unlock(&pa->pa_lock);
>  		BUG_ON(groupnr != group);
> @@ -3247,7 +3335,7 @@ void ext4_mb_generate_from_pa(struct sup
>  	mb_debug("prellocated %u for group %u\n", preallocated, group);
>  }
> 
> -#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,5)
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 5)
>  static void ext4_mb_pa_callback(struct rcu_head *head)
>  {
>  	struct ext4_prealloc_space *pa;
> @@ -3333,7 +3421,10 @@ int ext4_mb_new_inode_pa(struct ext4_all
>  		return -ENOMEM;
> 
>  	if (ac->ac_b_ex.fe_len < ac->ac_g_ex.fe_len) {
> -		int winl, wins, win, offs;
> +		int winl;
> +		int wins;
> +		int win;
> +		int offs;
> 
>  		/* we can't allocate as much as normalizer wants.
>  		 * so, found space must get proper lstart
> @@ -3480,10 +3571,13 @@ int ext4_mb_release_inode_pa(struct ext4
>  	struct ext4_allocation_context ac;
>  	struct super_block *sb = e3b->bd_sb;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> -	unsigned long end, next, group;
> +	unsigned long end;
> +	unsigned long next;
> +	unsigned long group;
>  	ext4_grpblk_t bit;
>  	sector_t start;
> -	int err = 0, free = 0;
> +	int err = 0;
> +	int free = 0;
> 
>  	BUG_ON(pa->pa_deleted == 0);
>  	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
> @@ -3518,11 +3612,11 @@ int ext4_mb_release_inode_pa(struct ext4
>  		bit = next + 1;
>  	}
>  	if (free != pa->pa_free) {
> -		printk("pa %p: logic %lu, phys. %lu, len %lu\n",
> +		printk(KERN_ERR "pa %p: logic %lu, phys. %lu, len %lu\n",
>  			pa, (unsigned long) pa->pa_lstart,
>  			(unsigned long) pa->pa_pstart,
>  			(unsigned long) pa->pa_len);
> -		printk("free %u, pa_free %u\n", free, pa->pa_free);
> +		printk(KERN_ERR "free %u, pa_free %u\n", free, pa->pa_free);
>  	}
>  	BUG_ON(free != pa->pa_free);
>  	atomic_add(free, &sbi->s_mb_discarded);
> @@ -3574,7 +3668,9 @@ int ext4_mb_discard_group_preallocations
>  	struct ext4_prealloc_space *pa, *tmp;
>  	struct list_head list;
>  	struct ext4_buddy e3b;
> -	int err, busy, free = 0;
> +	int err;
> +	int busy;
> +	int free = 0;
> 
>  	mb_debug("discard preallocation for group %lu\n", group);
> 
> @@ -3600,11 +3696,12 @@ int ext4_mb_discard_group_preallocations
>  repeat:
>  	busy = 0;
>  	ext4_lock_group(sb, group);
> -	list_for_each_entry_safe (pa, tmp, &grp->bb_prealloc_list, pa_group_list) {
> +	list_for_each_entry_safe(pa, tmp,
> +				&grp->bb_prealloc_list, pa_group_list) {
>  		spin_lock(&pa->pa_lock);
>  		if (atomic_read(&pa->pa_count)) {
>  			spin_unlock(&pa->pa_lock);
> -			printk("uh! busy PA\n");
> +			printk(KERN_ERR "uh! busy PA\n");
>  			dump_stack();
>  			busy = 1;
>  			continue;
> @@ -3698,7 +3795,7 @@ repeat:
>  			 * use preallocation while we're discarding it */
>  			spin_unlock(&pa->pa_lock);
>  			spin_unlock(&ei->i_prealloc_lock);
> -			printk("uh-oh! used pa while discarding\n");
> +			printk(KERN_ERR "uh-oh! used pa while discarding\n");
>  			dump_stack();
>  			current->state = TASK_UNINTERRUPTIBLE;
>  			schedule_timeout(HZ);
> @@ -3729,7 +3826,7 @@ repeat:
>  		 * add a flag to force wait only in case
>  		 * of ->clear_inode(), but not in case of
>  		 * regular truncate */
> -		printk("uh-oh! some one just deleted it\n");
> +		printk(KERN_ERR "uh-oh! some one just deleted it\n");
>  		dump_stack();
>  		current->state = TASK_UNINTERRUPTIBLE;
>  		schedule_timeout(HZ);
> @@ -3771,7 +3868,8 @@ repeat:
>   * XXX: at the moment, truncate (which is the only way to free blocks)
>   * discards all preallocations
>   */
> -void ext4_mb_return_to_preallocation(struct inode *inode, struct ext4_buddy *e3b,
> +void ext4_mb_return_to_preallocation(struct inode *inode,
> +					struct ext4_buddy *e3b,
>  					sector_t block, int count)
>  {
>  	BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
> @@ -3796,7 +3894,7 @@ void ext4_mb_show_ac(struct ext4_allocat
>  			ac->ac_criteria);
>  	printk(KERN_ERR "EXT4-fs: %lu scanned, %d found\n", ac->ac_ex_scanned,
>  		ac->ac_found);
> -	printk("EXT4-fs: groups: ");
> +	printk(KERN_ERR "EXT4-fs: groups: ");
>  	for (i = 0; i < EXT4_SB(sb)->s_groups_count; i++) {
>  		struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, i);
>  		struct ext4_prealloc_space *pa;
> @@ -3806,17 +3904,19 @@ void ext4_mb_show_ac(struct ext4_allocat
>  			pa = list_entry(cur, struct ext4_prealloc_space,
>  					pa_group_list);
>  			spin_lock(&pa->pa_lock);
> -			ext4_get_group_no_and_offset(sb, pa->pa_pstart, NULL, &start);
> +			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
> +						     NULL, &start);
>  			spin_unlock(&pa->pa_lock);
> -			printk("PA:%u:%lu:%u ", i, start, pa->pa_len);
> +			printk(KERN_ERR "PA:%u:%lu:%u ", i, start, pa->pa_len);
>  		}
> 
>  		if (grp->bb_free == 0)
>  			continue;
> -		printk("%d: %d/%d ", i, grp->bb_free, grp->bb_fragments);
> +		printk(KERN_ERR "%d: %d/%d ",
> +		       i, grp->bb_free, grp->bb_fragments);
>  	}
> -	printk("\n");
> -	//dump_stack();
> +	printk(KERN_ERR "\n");
> +	/* dump_stack(); */
>  #endif
>  }
> 
> @@ -3854,7 +3954,9 @@ int ext4_mb_initialize_context(struct ex
>  	struct super_block *sb = ar->inode->i_sb;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_super_block *es = sbi->s_es;
> -	unsigned long group, len, goal;
> +	unsigned long group;
> +	unsigned long len;
> +	unsigned long goal;
>  	ext4_grpblk_t block;
> 
>  	/* we can't allocate > group size */
> @@ -3941,7 +4043,9 @@ int ext4_mb_release_context(struct ext4_
> 
>  int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
>  {
> -	int i, ret, freed = 0;
> +	int i;
> +	int ret;
> +	int freed = 0;
> 
>  	for (i = 0; i < EXT4_SB(sb)->s_groups_count && needed > 0; i++) {
>  		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
> @@ -3964,7 +4068,8 @@ unsigned long ext4_mb_new_blocks(handle_
>  	struct ext4_sb_info *sbi;
>  	struct super_block *sb;
>  	unsigned long block = 0;
> -	int freed, inquota;
> +	int freed;
> +	int inquota;
> 
>  	sb = ar->inode->i_sb;
>  	sbi = EXT4_SB(sb);
> @@ -3978,7 +4083,7 @@ unsigned long ext4_mb_new_blocks(handle_
>  		ar->len = 1;
>  #endif
>  		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
> -								&(ar->len), errp);
> +					    &(ar->len), errp);
>  		return block;
>  	}
> 
> @@ -3994,7 +4099,8 @@ unsigned long ext4_mb_new_blocks(handle_
> 
>  	ext4_mb_poll_new_transaction(sb, handle);
> 
> -	if ((*errp = ext4_mb_initialize_context(&ac, ar))) {
> +	*errp = ext4_mb_initialize_context(&ac, ar);
> +	if (*errp) {
>  		ar->len = 0;
>  		goto out;
>  	}
> @@ -4151,7 +4257,8 @@ void ext4_mb_free_blocks(handle_t *handl
>  	unsigned long block_group;
>  	struct ext4_sb_info *sbi;
>  	struct ext4_buddy e3b;
> -	int err = 0, ret;
> +	int err = 0;
> +	int ret;
> 
>  	*freed = 0;
> 
> @@ -4162,7 +4269,7 @@ void ext4_mb_free_blocks(handle_t *handl
>  	if (block < le32_to_cpu(es->s_first_data_block) ||
>  	    block + count < block ||
>  	    block + count > le32_to_cpu(es->s_blocks_count)) {
> -		ext4_error (sb, __FUNCTION__,
> +		ext4_error(sb, __FUNCTION__,
>  			    "Freeing blocks not in datazone - "
>  			    "block = %lu, count = %lu", block, count);
>  		goto error_return;
> @@ -4190,15 +4297,15 @@ do_more:
>  	bitmap_bh = read_block_bitmap(sb, block_group);
>  	if (!bitmap_bh)
>  		goto error_return;
> -	gdp = ext4_get_group_desc (sb, block_group, &gd_bh);
> +	gdp = ext4_get_group_desc(sb, block_group, &gd_bh);
>  	if (!gdp)
>  		goto error_return;
> 
> -	if (in_range (le32_to_cpu(gdp->bg_block_bitmap), block, count) ||
> -	    in_range (le32_to_cpu(gdp->bg_inode_bitmap), block, count) ||
> -	    in_range (block, le32_to_cpu(gdp->bg_inode_table),
> +	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), block, count) ||
> +	    in_range(le32_to_cpu(gdp->bg_inode_bitmap), block, count) ||
> +	    in_range(block, le32_to_cpu(gdp->bg_inode_table),
>  		      EXT4_SB(sb)->s_itb_per_group) ||
> -	    in_range (block + count - 1, le32_to_cpu(gdp->bg_inode_table),
> +	    in_range(block + count - 1, le32_to_cpu(gdp->bg_inode_table),
>  		      EXT4_SB(sb)->s_itb_per_group))
>  		ext4_error(sb, __FUNCTION__,
>  			   "Freeing blocks in system zone - "
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
