From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 41/49] ext4: Add multi block allocator for ext4
Date: Wed, 23 Jan 2008 14:07:27 -0800
Message-ID: <20080123140727.f47e9c9d.akpm@linux-foundation.org>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-26-git-send-email-tytso@mit.edu>
	<1200970948-17903-27-git-send-email-tytso@mit.edu>
	<1200970948-17903-28-git-send-email-tytso@mit.edu>
	<1200970948-17903-29-git-send-email-tytso@mit.edu>
	<1200970948-17903-30-git-send-email-tytso@mit.edu>
	<1200970948-17903-31-git-send-email-tytso@mit.edu>
	<1200970948-17903-32-git-send-email-tytso@mit.edu>
	<1200970948-17903-33-git-send-email-tytso@mit.edu>
	<1200970948-17903-34-git-send-email-tytso@mit.edu>
	<1200970948-17903-35-git-send-email-tytso@mit.edu>
	<1200970948-17903-36-git-send-email-tytso@mit.edu>
	<1200970948-17903-37-git-send-email-tytso@mit.edu>
	<1200970948-17903-38-git-send-email-tytso@mit.edu>
	<1200970948-17903-39-git-send-email-tytso@mit.edu>
	<1200970948-17903-40-git-send-email-tytso@mit.edu>
	<1200970948-17903-41-git-send-email-tytso@mit.edu>
	<1200970948-17903-42-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, alex@clusterfs.com,
	adilger@clusterfs.com, aneesh.kumar@linux.vnet.ibm.com,
	sandeen@redhat.com, tytso@MIT.EDU,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbYAWWIS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 17:08:18 -0500
In-Reply-To: <1200970948-17903-42-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, 21 Jan 2008 22:02:20 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> From: Alex Tomas <alex@clusterfs.com>
> 
> Signed-off-by: Alex Tomas <alex@clusterfs.com>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> ...
>
> +#if BITS_PER_LONG == 64
> +#define mb_correct_addr_and_bit(bit, addr)		\
> +{							\
> +	bit += ((unsigned long) addr & 7UL) << 3;	\
> +	addr = (void *) ((unsigned long) addr & ~7UL);	\
> +}
> +#elif BITS_PER_LONG == 32
> +#define mb_correct_addr_and_bit(bit, addr)		\
> +{							\
> +	bit += ((unsigned long) addr & 3UL) << 3;	\
> +	addr = (void *) ((unsigned long) addr & ~3UL);	\
> +}
> +#else
> +#error "how many bits you are?!"
> +#endif

Why do these exist?

> +static inline int mb_test_bit(int bit, void *addr)
> +{
> +	mb_correct_addr_and_bit(bit, addr);
> +	return ext4_test_bit(bit, addr);
> +}

ext2_test_bit() already handles bitnum > wordsize.

If mb_correct_addr_and_bit() is actually needed then some suitable comment
would help.

> +static inline void mb_set_bit(int bit, void *addr)
> +{
> +	mb_correct_addr_and_bit(bit, addr);
> +	ext4_set_bit(bit, addr);
> +}
> +
> +static inline void mb_set_bit_atomic(spinlock_t *lock, int bit, void *addr)
> +{
> +	mb_correct_addr_and_bit(bit, addr);
> +	ext4_set_bit_atomic(lock, bit, addr);
> +}
> +
> +static inline void mb_clear_bit(int bit, void *addr)
> +{
> +	mb_correct_addr_and_bit(bit, addr);
> +	ext4_clear_bit(bit, addr);
> +}
> +
> +static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
> +{
> +	mb_correct_addr_and_bit(bit, addr);
> +	ext4_clear_bit_atomic(lock, bit, addr);
> +}
> +
> +static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)

uninlining this will save about eighty squigabytes of text.

Please review all of ext4/jbd2 with a view to removig unnecessary and wrong
inlings.

> +{
> +	char *bb;
> +
> +	/* FIXME!! is this needed */
> +	BUG_ON(EXT4_MB_BITMAP(e4b) == EXT4_MB_BUDDY(e4b));
> +	BUG_ON(max == NULL);
> +
> +	if (order > e4b->bd_blkbits + 1) {
> +		*max = 0;
> +		return NULL;
> +	}
> +
> +	/* at order 0 we see each particular block */
> +	*max = 1 << (e4b->bd_blkbits + 3);
> +	if (order == 0)
> +		return EXT4_MB_BITMAP(e4b);
> +
> +	bb = EXT4_MB_BUDDY(e4b) + EXT4_SB(e4b->bd_sb)->s_mb_offsets[order];
> +	*max = EXT4_SB(e4b->bd_sb)->s_mb_maxs[order];
> +
> +	return bb;
> +}
> +
>
> ...
>
> +#else
> +#define mb_free_blocks_double(a, b, c, d)
> +#define mb_mark_used_double(a, b, c)
> +#define mb_cmp_bitmaps(a, b)
> +#endif

Please use the do{}while(0) thing.  Or, better, proper C functions which
have typechecking (unless this will cause undefined-var compile errors,
which happens sometimes)

> +/* find most significant bit */
> +static int fmsb(unsigned short word)
> +{
> +	int order;
> +
> +	if (word > 255) {
> +		order = 7;
> +		word >>= 8;
> +	} else {
> +		order = -1;
> +	}
> +
> +	do {
> +		order++;
> +		word >>= 1;
> +	} while (word != 0);
> +
> +	return order;
> +}

Did we just reinvent fls()?

> +/* FIXME!! need more doc */
> +static void ext4_mb_mark_free_simple(struct super_block *sb,
> +				void *buddy, unsigned first, int len,
> +					struct ext4_group_info *grp)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	unsigned short min;
> +	unsigned short max;
> +	unsigned short chunk;
> +	unsigned short border;
> +
> +	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> +
> +	border = 2 << sb->s_blocksize_bits;

Won't this explode with >= 32k blocksize?

> +	while (len > 0) {
> +		/* find how many blocks can be covered since this position */
> +		max = ffs(first | border) - 1;
> +
> +		/* find how many blocks of power 2 we need to mark */
> +		min = fmsb(len);
> +
> +		if (max < min)
> +			min = max;
> +		chunk = 1 << min;
> +
> +		/* mark multiblock chunks only */
> +		grp->bb_counters[min]++;
> +		if (min > 0)
> +			mb_clear_bit(first >> min,
> +				     buddy + sbi->s_mb_offsets[min]);
> +
> +		len -= chunk;
> +		first += chunk;
> +	}
> +}
> +
> 
> ...
>
> +static int ext4_mb_init_cache(struct page *page, char *incore)
> +{
> +	int blocksize;
> +	int blocks_per_page;
> +	int groups_per_page;
> +	int err = 0;
> +	int i;
> +	ext4_group_t first_group;
> +	int first_block;
> +	struct super_block *sb;
> +	struct buffer_head *bhs;
> +	struct buffer_head **bh;
> +	struct inode *inode;
> +	char *data;
> +	char *bitmap;
> +
> +	mb_debug("init page %lu\n", page->index);
> +
> +	inode = page->mapping->host;
> +	sb = inode->i_sb;
> +	blocksize = 1 << inode->i_blkbits;
> +	blocks_per_page = PAGE_CACHE_SIZE / blocksize;
> +
> +	groups_per_page = blocks_per_page >> 1;
> +	if (groups_per_page == 0)
> +		groups_per_page = 1;
> +
> +	/* allocate buffer_heads to read bitmaps */
> +	if (groups_per_page > 1) {
> +		err = -ENOMEM;
> +		i = sizeof(struct buffer_head *) * groups_per_page;
> +		bh = kmalloc(i, GFP_NOFS);
> +		if (bh == NULL)
> +			goto out;
> +		memset(bh, 0, i);

kzalloc()

> +	} else
> +		bh = &bhs;
> +
> +	first_group = page->index * blocks_per_page / 2;
> +
> +	/* read all groups the page covers into the cache */
> +	for (i = 0; i < groups_per_page; i++) {
> +		struct ext4_group_desc *desc;
> +
> +		if (first_group + i >= EXT4_SB(sb)->s_groups_count)
> +			break;
> +
> +		err = -EIO;
> +		desc = ext4_get_group_desc(sb, first_group + i, NULL);
> +		if (desc == NULL)
> +			goto out;
> +
> +		err = -ENOMEM;
> +		bh[i] = sb_getblk(sb, ext4_block_bitmap(sb, desc));
> +		if (bh[i] == NULL)
> +			goto out;
> +
> +		if (buffer_uptodate(bh[i]))
> +			continue;
> +
> +		lock_buffer(bh[i]);
> +		if (buffer_uptodate(bh[i])) {
> +			unlock_buffer(bh[i]);
> +			continue;
> +		}

Didn't we just add a helper in fs/buffer.c to do this?

> +		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> +			ext4_init_block_bitmap(sb, bh[i],
> +						first_group + i, desc);
> +			set_buffer_uptodate(bh[i]);
> +			unlock_buffer(bh[i]);
> +			continue;
> +		}
> +		get_bh(bh[i]);
> +		bh[i]->b_end_io = end_buffer_read_sync;
> +		submit_bh(READ, bh[i]);
> +		mb_debug("read bitmap for group %lu\n", first_group + i);
> +	}
> +
> +	/* wait for I/O completion */
> +	for (i = 0; i < groups_per_page && bh[i]; i++)
> +		wait_on_buffer(bh[i]);
> +
> +	err = -EIO;
> +	for (i = 0; i < groups_per_page && bh[i]; i++)
> +		if (!buffer_uptodate(bh[i]))
> +			goto out;
> +
> +	first_block = page->index * blocks_per_page;
> +	for (i = 0; i < blocks_per_page; i++) {
> +		int group;
> +		struct ext4_group_info *grinfo;
> +
> +		group = (first_block + i) >> 1;
> +		if (group >= EXT4_SB(sb)->s_groups_count)
> +			break;
> +
> +		/*
> +		 * data carry information regarding this
> +		 * particular group in the format specified
> +		 * above
> +		 *
> +		 */
> +		data = page_address(page) + (i * blocksize);
> +		bitmap = bh[group - first_group]->b_data;
> +
> +		/*
> +		 * We place the buddy block and bitmap block
> +		 * close together
> +		 */
> +		if ((first_block + i) & 1) {
> +			/* this is block of buddy */
> +			BUG_ON(incore == NULL);
> +			mb_debug("put buddy for group %u in page %lu/%x\n",
> +				group, page->index, i * blocksize);
> +			memset(data, 0xff, blocksize);
> +			grinfo = ext4_get_group_info(sb, group);
> +			grinfo->bb_fragments = 0;
> +			memset(grinfo->bb_counters, 0,
> +			       sizeof(unsigned short)*(sb->s_blocksize_bits+2));
> +			/*
> +			 * incore got set to the group block bitmap below
> +			 */
> +			ext4_mb_generate_buddy(sb, data, incore, group);
> +			incore = NULL;
> +		} else {
> +			/* this is block of bitmap */
> +			BUG_ON(incore != NULL);
> +			mb_debug("put bitmap for group %u in page %lu/%x\n",
> +				group, page->index, i * blocksize);
> +
> +			/* see comments in ext4_mb_put_pa() */
> +			ext4_lock_group(sb, group);
> +			memcpy(data, bitmap, blocksize);
> +
> +			/* mark all preallocated blks used in in-core bitmap */
> +			ext4_mb_generate_from_pa(sb, data, group);
> +			ext4_unlock_group(sb, group);
> +
> +			/* set incore so that the buddy information can be
> +			 * generated using this
> +			 */
> +			incore = data;
> +		}
> +	}
> +	SetPageUptodate(page);

Is the page locked here?

> +out:
> +	if (bh) {
> +		for (i = 0; i < groups_per_page && bh[i]; i++)
> +			brelse(bh[i]);

put_bh()

> +		if (bh != &bhs)
> +			kfree(bh);
> +	}
> +	return err;
> +}
> +
>
> ...
>
> +static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
> +{
> +	__u32 *addr;
> +
> +	len = cur + len;
> +	while (cur < len) {
> +		if ((cur & 31) == 0 && (len - cur) >= 32) {
> +			/* fast path: clear whole word at once */

s/clear/set/

> +			addr = bm + (cur >> 3);
> +			*addr = 0xffffffff;
> +			cur += 32;
> +			continue;
> +		}
> +		mb_set_bit_atomic(lock, cur, bm);
> +		cur++;
> +	}
> +}
> +
>
> ...
>
> +static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
> +					struct ext4_buddy *e4b)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
> +	int ret;
> +
> +	BUG_ON(ac->ac_b_ex.fe_group != e4b->bd_group);
> +	BUG_ON(ac->ac_status == AC_STATUS_FOUND);
> +
> +	ac->ac_b_ex.fe_len = min(ac->ac_b_ex.fe_len, ac->ac_g_ex.fe_len);
> +	ac->ac_b_ex.fe_logical = ac->ac_g_ex.fe_logical;
> +	ret = mb_mark_used(e4b, &ac->ac_b_ex);
> +
> +	/* preallocation can change ac_b_ex, thus we store actually
> +	 * allocated blocks for history */
> +	ac->ac_f_ex = ac->ac_b_ex;
> +
> +	ac->ac_status = AC_STATUS_FOUND;
> +	ac->ac_tail = ret & 0xffff;
> +	ac->ac_buddy = ret >> 16;
> +
> +	/* XXXXXXX: SUCH A HORRIBLE **CK */
> +	/*FIXME!! Why ? */

?

> +	ac->ac_bitmap_page = e4b->bd_bitmap_page;
> +	get_page(ac->ac_bitmap_page);
> +	ac->ac_buddy_page = e4b->bd_buddy_page;
> +	get_page(ac->ac_buddy_page);
> +
> +	/* store last allocated for subsequent stream allocation */
> +	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
> +		spin_lock(&sbi->s_md_lock);
> +		sbi->s_mb_last_group = ac->ac_f_ex.fe_group;
> +		sbi->s_mb_last_start = ac->ac_f_ex.fe_start;
> +		spin_unlock(&sbi->s_md_lock);
> +	}
> +}
>
> ...
>
> +static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
> +					ext4_group_t group)
> +{
> +	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
> +	struct ext4_prealloc_space *pa;
> +	struct list_head *cur;
> +	ext4_group_t groupnr;
> +	ext4_grpblk_t start;
> +	int preallocated = 0;
> +	int count = 0;
> +	int len;
> +
> +	/* all form of preallocation discards first load group,
> +	 * so the only competing code is preallocation use.
> +	 * we don't need any locking here
> +	 * notice we do NOT ignore preallocations with pa_deleted
> +	 * otherwise we could leave used blocks available for
> +	 * allocation in buddy when concurrent ext4_mb_put_pa()
> +	 * is dropping preallocation
> +	 */
> +	list_for_each_rcu(cur, &grp->bb_prealloc_list) {
> +		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
> +		spin_lock(&pa->pa_lock);
> +		ext4_get_group_no_and_offset(sb, pa->pa_pstart,
> +					     &groupnr, &start);
> +		len = pa->pa_len;
> +		spin_unlock(&pa->pa_lock);
> +		if (unlikely(len == 0))
> +			continue;
> +		BUG_ON(groupnr != group);
> +		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
> +						bitmap, start, len);
> +		preallocated += len;
> +		count++;
> +	}

Seems to be missing rcu_read_lock()

> +	mb_debug("prellocated %u for group %lu\n", preallocated, group);
> +}
> +
> +static void ext4_mb_pa_callback(struct rcu_head *head)
> +{
> +	struct ext4_prealloc_space *pa;
> +	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
> +	kmem_cache_free(ext4_pspace_cachep, pa);
> +}
> +#define mb_call_rcu(__pa)	call_rcu(&(__pa)->u.pa_rcu, ext4_mb_pa_callback)

Is there any reason why this had to be implemented as a macro?

>
> ...
>
> +static int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
> +{
> +	struct super_block *sb = ac->ac_sb;
> +	struct ext4_prealloc_space *pa;
> +	struct ext4_group_info *grp;
> +	struct ext4_inode_info *ei;
> +
> +	/* preallocate only when found space is larger then requested */
> +	BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
> +	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
> +	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
> +
> +	pa = kmem_cache_alloc(ext4_pspace_cachep, GFP_NOFS);

Do all the GFP_NOFS's in this code really need to be GFP_NOFS?

> +	if (pa == NULL)
> +		return -ENOMEM;
> +
> +	if (ac->ac_b_ex.fe_len < ac->ac_g_ex.fe_len) {
> +		int winl;
> +		int wins;
> +		int win;
> +		int offs;
> +
> +		/* we can't allocate as much as normalizer wants.
> +		 * so, found space must get proper lstart
> +		 * to cover original request */
> +		BUG_ON(ac->ac_g_ex.fe_logical > ac->ac_o_ex.fe_logical);
> +		BUG_ON(ac->ac_g_ex.fe_len < ac->ac_o_ex.fe_len);
> +
> +		/* we're limited by original request in that
> +		 * logical block must be covered any way
> +		 * winl is window we can move our chunk within */
> +		winl = ac->ac_o_ex.fe_logical - ac->ac_g_ex.fe_logical;
> +
> +		/* also, we should cover whole original request */
> +		wins = ac->ac_b_ex.fe_len - ac->ac_o_ex.fe_len;
> +
> +		/* the smallest one defines real window */
> +		win = min(winl, wins);
> +
> +		offs = ac->ac_o_ex.fe_logical % ac->ac_b_ex.fe_len;
> +		if (offs && offs < win)
> +			win = offs;
> +
> +		ac->ac_b_ex.fe_logical = ac->ac_o_ex.fe_logical - win;
> +		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
> +		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
> +	}
> +
> +	/* preallocation can change ac_b_ex, thus we store actually
> +	 * allocated blocks for history */
> +	ac->ac_f_ex = ac->ac_b_ex;
> +
> +	pa->pa_lstart = ac->ac_b_ex.fe_logical;
> +	pa->pa_pstart = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
> +	pa->pa_len = ac->ac_b_ex.fe_len;
> +	pa->pa_free = pa->pa_len;
> +	atomic_set(&pa->pa_count, 1);
> +	spin_lock_init(&pa->pa_lock);
> +	pa->pa_deleted = 0;
> +	pa->pa_linear = 0;
> +
> +	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
> +			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
> +
> +	ext4_mb_use_inode_pa(ac, pa);
> +	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
> +
> +	ei = EXT4_I(ac->ac_inode);
> +	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
> +
> +	pa->pa_obj_lock = &ei->i_prealloc_lock;
> +	pa->pa_inode = ac->ac_inode;
> +
> +	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
> +	list_add_rcu(&pa->pa_group_list, &grp->bb_prealloc_list);
> +	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
> +
> +	spin_lock(pa->pa_obj_lock);
> +	list_add_rcu(&pa->pa_inode_list, &ei->i_prealloc_list);
> +	spin_unlock(pa->pa_obj_lock);

hm.  Strange to see list_add_rcu() inside spinlock like this.

> +	return 0;
> +}
> +
>
> ...
>
> +static int ext4_mb_discard_group_preallocations(struct super_block *sb,
> +					ext4_group_t group, int needed)
> +{
> +	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
> +	struct buffer_head *bitmap_bh = NULL;
> +	struct ext4_prealloc_space *pa, *tmp;
> +	struct list_head list;
> +	struct ext4_buddy e4b;
> +	int err;
> +	int busy = 0;
> +	int free = 0;
> +
> +	mb_debug("discard preallocation for group %lu\n", group);
> +
> +	if (list_empty(&grp->bb_prealloc_list))
> +		return 0;
> +
> +	bitmap_bh = read_block_bitmap(sb, group);
> +	if (bitmap_bh == NULL) {
> +		/* error handling here */
> +		ext4_mb_release_desc(&e4b);
> +		BUG_ON(bitmap_bh == NULL);
> +	}
> +
> +	err = ext4_mb_load_buddy(sb, group, &e4b);
> +	BUG_ON(err != 0); /* error handling here */
> +
> +	if (needed == 0)
> +		needed = EXT4_BLOCKS_PER_GROUP(sb) + 1;
> +
> +	grp = ext4_get_group_info(sb, group);
> +	INIT_LIST_HEAD(&list);
> +
> +repeat:
> +	ext4_lock_group(sb, group);
> +	list_for_each_entry_safe(pa, tmp,
> +				&grp->bb_prealloc_list, pa_group_list) {
> +		spin_lock(&pa->pa_lock);
> +		if (atomic_read(&pa->pa_count)) {
> +			spin_unlock(&pa->pa_lock);
> +			busy = 1;
> +			continue;
> +		}
> +		if (pa->pa_deleted) {
> +			spin_unlock(&pa->pa_lock);
> +			continue;
> +		}
> +
> +		/* seems this one can be freed ... */
> +		pa->pa_deleted = 1;
> +
> +		/* we can trust pa_free ... */
> +		free += pa->pa_free;
> +
> +		spin_unlock(&pa->pa_lock);
> +
> +		list_del_rcu(&pa->pa_group_list);
> +		list_add(&pa->u.pa_tmp_list, &list);
> +	}

Strange to see rcu operations outside rcu_read_lock().

> +	/* if we still need more blocks and some PAs were used, try again */
> +	if (free < needed && busy) {
> +		busy = 0;
> +		ext4_unlock_group(sb, group);
> +		/*
> +		 * Yield the CPU here so that we don't get soft lockup
> +		 * in non preempt case.
> +		 */
> +		yield();

argh, no, yield() is basically unusable.  schedule_timeout(1) is preferable.

Please test this code whe there are lots of cpu-intensive tasks running.

> +		goto repeat;
> +	}
> +
> +	/* found anything to free? */
> +	if (list_empty(&list)) {
> +		BUG_ON(free != 0);
> +		goto out;
> +	}
> +
> +	/* now free all selected PAs */
> +	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
> +
> +		/* remove from object (inode or locality group) */
> +		spin_lock(pa->pa_obj_lock);
> +		list_del_rcu(&pa->pa_inode_list);
> +		spin_unlock(pa->pa_obj_lock);
> +
> +		if (pa->pa_linear)
> +			ext4_mb_release_group_pa(&e4b, pa);
> +		else
> +			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
> +
> +		list_del(&pa->u.pa_tmp_list);
> +		mb_call_rcu(pa);
> +	}
> +
> +out:
> +	ext4_unlock_group(sb, group);
> +	ext4_mb_release_desc(&e4b);
> +	brelse(bitmap_bh);

put_bh()

> +	return free;
> +}
> +
> +/*
> + * releases all non-used preallocated blocks for given inode
> + *
> + * It's important to discard preallocations under i_data_sem
> + * We don't want another block to be served from the prealloc
> + * space when we are discarding the inode prealloc space.
> + *
> + * FIXME!! Make sure it is valid at all the call sites
> + */
> +void ext4_mb_discard_inode_preallocations(struct inode *inode)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	struct super_block *sb = inode->i_sb;
> +	struct buffer_head *bitmap_bh = NULL;
> +	struct ext4_prealloc_space *pa, *tmp;
> +	ext4_group_t group = 0;
> +	struct list_head list;
> +	struct ext4_buddy e4b;
> +	int err;
> +
> +	if (!test_opt(sb, MBALLOC) || !S_ISREG(inode->i_mode)) {
> +		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
> +		return;
> +	}
> +
> +	mb_debug("discard preallocation for inode %lu\n", inode->i_ino);
> +
> +	INIT_LIST_HEAD(&list);
> +
> +repeat:
> +	/* first, collect all pa's in the inode */
> +	spin_lock(&ei->i_prealloc_lock);
> +	while (!list_empty(&ei->i_prealloc_list)) {
> +		pa = list_entry(ei->i_prealloc_list.next,
> +				struct ext4_prealloc_space, pa_inode_list);
> +		BUG_ON(pa->pa_obj_lock != &ei->i_prealloc_lock);
> +		spin_lock(&pa->pa_lock);
> +		if (atomic_read(&pa->pa_count)) {
> +			/* this shouldn't happen often - nobody should
> +			 * use preallocation while we're discarding it */
> +			spin_unlock(&pa->pa_lock);
> +			spin_unlock(&ei->i_prealloc_lock);
> +			printk(KERN_ERR "uh-oh! used pa while discarding\n");
> +			dump_stack();

WARN_ON(1) would be more conventional.

> +			current->state = TASK_UNINTERRUPTIBLE;
> +			schedule_timeout(HZ);

schedule_timeout_uninterruptible()

> +			goto repeat;
> +
> +		}
> +		if (pa->pa_deleted == 0) {
> +			pa->pa_deleted = 1;
> +			spin_unlock(&pa->pa_lock);
> +			list_del_rcu(&pa->pa_inode_list);
> +			list_add(&pa->u.pa_tmp_list, &list);
> +			continue;
> +		}
> +
> +		/* someone is deleting pa right now */
> +		spin_unlock(&pa->pa_lock);
> +		spin_unlock(&ei->i_prealloc_lock);
> +
> +		/* we have to wait here because pa_deleted
> +		 * doesn't mean pa is already unlinked from
> +		 * the list. as we might be called from
> +		 * ->clear_inode() the inode will get freed
> +		 * and concurrent thread which is unlinking
> +		 * pa from inode's list may access already
> +		 * freed memory, bad-bad-bad */
> +
> +		/* XXX: if this happens too often, we can
> +		 * add a flag to force wait only in case
> +		 * of ->clear_inode(), but not in case of
> +		 * regular truncate */
> +		current->state = TASK_UNINTERRUPTIBLE;
> +		schedule_timeout(HZ);

ditto

> +		goto repeat;
> +	}
> +	spin_unlock(&ei->i_prealloc_lock);
> +
> +	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
> +		BUG_ON(pa->pa_linear != 0);
> +		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
> +
> +		err = ext4_mb_load_buddy(sb, group, &e4b);
> +		BUG_ON(err != 0); /* error handling here */
> +
> +		bitmap_bh = read_block_bitmap(sb, group);
> +		if (bitmap_bh == NULL) {
> +			/* error handling here */
> +			ext4_mb_release_desc(&e4b);
> +			BUG_ON(bitmap_bh == NULL);
> +		}
> +
> +		ext4_lock_group(sb, group);
> +		list_del_rcu(&pa->pa_group_list);
> +		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
> +		ext4_unlock_group(sb, group);
> +
> +		ext4_mb_release_desc(&e4b);
> +		brelse(bitmap_bh);
> +
> +		list_del(&pa->u.pa_tmp_list);
> +		mb_call_rcu(pa);
> +	}
> +}

Would be nice to ask Paul to review all the rcu usage in here.  It looks odd.

>
> ...
>
> +#else
> +#define ext4_mb_show_ac(x)
> +#endif

static inlined C functions are preferred (+1e6 dittoes)

> +/*
> + * We use locality group preallocation for small size file. The size of the
> + * file is determined by the current size or the resulting size after
> + * allocation which ever is larger
> + *
> + * One can tune this size via /proc/fs/ext4/<partition>/stream_req
> + */
> +static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
> +	int bsbits = ac->ac_sb->s_blocksize_bits;
> +	loff_t size, isize;
> +
> +	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
> +		return;
> +
> +	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
> +	isize = i_size_read(ac->ac_inode) >> bsbits;
> +	if (size < isize)
> +		size = isize;

min()?

> +	/* don't use group allocation for large files */
> +	if (size >= sbi->s_mb_stream_request)
> +		return;
> +
> +	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
> +		return;
> +
> +	BUG_ON(ac->ac_lg != NULL);
> +	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
> +	put_cpu();

Strange-looking code.  I'd be interested in a description of the per-cou
design here.

> +	/* we're going to use group allocation */
> +	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
> +
> +	/* serialize all allocations in the group */
> +	down(&ac->ac_lg->lg_sem);

This should be a mutex, shouldn't it?

> +}
> +
>
> ...
>
> +static int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
> +			  ext4_group_t group, ext4_grpblk_t block, int count)
> +{
> +	struct ext4_group_info *db = e4b->bd_info;
> +	struct super_block *sb = e4b->bd_sb;
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_free_metadata *md;
> +	int i;
> +
> +	BUG_ON(e4b->bd_bitmap_page == NULL);
> +	BUG_ON(e4b->bd_buddy_page == NULL);
> +
> +	ext4_lock_group(sb, group);
> +	for (i = 0; i < count; i++) {
> +		md = db->bb_md_cur;
> +		if (md && db->bb_tid != handle->h_transaction->t_tid) {
> +			db->bb_md_cur = NULL;
> +			md = NULL;
> +		}
> +
> +		if (md == NULL) {
> +			ext4_unlock_group(sb, group);
> +			md = kmalloc(sizeof(*md), GFP_KERNEL);

Why was this one not GFP_NOFS?

> +			if (md == NULL)
> +				return -ENOMEM;

Did we just leak some memory?

> +			md->num = 0;
> +			md->group = group;
> +
> +			ext4_lock_group(sb, group);
> +			if (db->bb_md_cur == NULL) {
> +				spin_lock(&sbi->s_md_lock);
> +				list_add(&md->list, &sbi->s_active_transaction);
> +				spin_unlock(&sbi->s_md_lock);
> +				/* protect buddy cache from being freed,
> +				 * otherwise we'll refresh it from
> +				 * on-disk bitmap and lose not-yet-available
> +				 * blocks */
> +				page_cache_get(e4b->bd_buddy_page);
> +				page_cache_get(e4b->bd_bitmap_page);
> +				db->bb_md_cur = md;
> +				db->bb_tid = handle->h_transaction->t_tid;
> +				mb_debug("new md 0x%p for group %lu\n",
> +						md, md->group);
> +			} else {
> +				kfree(md);
> +				md = db->bb_md_cur;
> +			}
> +		}
> +
> +		BUG_ON(md->num >= EXT4_BB_MAX_BLOCKS);
> +		md->blocks[md->num] = block + i;
> +		md->num++;
> +		if (md->num == EXT4_BB_MAX_BLOCKS) {
> +			/* no more space, put full container on a sb's list */
> +			db->bb_md_cur = NULL;
> +		}
> +	}
> +	ext4_unlock_group(sb, group);
> +	return 0;
> +}
> +
>
> ...
>
> +		case Opt_mballoc:
> +			set_opt(sbi->s_mount_opt, MBALLOC);
> +			break;
> +		case Opt_nomballoc:
> +			clear_opt(sbi->s_mount_opt, MBALLOC);
> +			break;
> +		case Opt_stripe:
> +			if (match_int(&args[0], &option))
> +				return 0;
> +			if (option < 0)
> +				return 0;
> +			sbi->s_stripe = option;
> +			break;

These appear to be undocumented.

>  		default:
>  			printk (KERN_ERR
>  				"EXT4-fs: Unrecognized mount option \"%s\" "
> @@ -1742,6 +1762,33 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
>  	return (has_super + ext4_group_first_block_no(sb, bg));
>  }
>  
> +/**
> + * ext4_get_stripe_size: Get the stripe size.
> + * @sbi: In memory super block info
> + *
> + * If we have specified it via mount option, then
> + * use the mount option value. If the value specified at mount time is
> + * greater than the blocks per group use the super block value.
> + * If the super block value is greater than blocks per group return 0.
> + * Allocator needs it be less than blocks per group.
> + *
> + */
> +static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
> +{
> +	unsigned long stride = le16_to_cpu(sbi->s_es->s_raid_stride);
> +	unsigned long stripe_width =
> +			le32_to_cpu(sbi->s_es->s_raid_stripe_width);
> +
> +	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group) {
> +		return sbi->s_stripe;
> +	} else if (stripe_width <= sbi->s_blocks_per_group) {
> +		return stripe_width;
> +	} else if (stride <= sbi->s_blocks_per_group) {
> +		return stride;
> +	}

unneeded braces.

> +	return 0;
> +}
>  
>  ...
>
> +static inline
> +struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
> +							ext4_group_t group)
> +{
> +	 struct ext4_group_info ***grp_info;
> +	 long indexv, indexh;
> +	 grp_info = EXT4_SB(sb)->s_group_info;
> +	 indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
> +	 indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
> +	 return grp_info[indexv][indexh];
> +}

This should be uninlined.



Gosh what a lot of code.  Is it faster?
