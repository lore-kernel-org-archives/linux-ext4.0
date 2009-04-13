From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC 2/2] ext4: Convert instrumentation from markers to
	tracepoints
Date: Mon, 13 Apr 2009 12:29:10 +0530
Message-ID: <20090413065910.GA23795@skywalker>
References: <1239479167-804-1-git-send-email-tytso@mit.edu> <1239479167-804-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48141 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZDMG7R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2009 02:59:17 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3D6vPvn010486
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2009 16:57:25 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3D6xFXG1396928
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2009 16:59:15 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3D6xExE004297
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2009 16:59:15 +1000
Content-Disposition: inline
In-Reply-To: <1239479167-804-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 11, 2009 at 03:46:07PM -0400, Theodore Ts'o wrote:
.....
......

> diff --git a/include/linux/ext4_trace_types.h b/include/linux/ext4_trace_types.h
> new file mode 100644
> index 0000000..229a2dd
> --- /dev/null
> +++ b/include/linux/ext4_trace_types.h
> @@ -0,0 +1,108 @@
> +/*
> + * ext4_trace_types.h -- these data structures are needed by the
> + *	tracing infrastructure
> + */
> +
> +#ifndef _EXT4_TRACE_TYPES_H
> +#define _EXT4_TRACE_TYPES_H
> +
> +/* data type for block offset of block group */
> +typedef int ext4_grpblk_t;
> +
> +/* data type for filesystem-wide blocks number */
> +typedef unsigned long long ext4_fsblk_t;
> +
> +/* data type for file logical block number */
> +typedef __u32 ext4_lblk_t;
> +
> +/* data type for block group number */
> +typedef unsigned int ext4_group_t;
> +
> +struct ext4_allocation_request {
> +	/* target inode for block we're allocating */
> +	struct inode *inode;
> +	/* logical block in target inode */
> +	ext4_lblk_t logical;
> +	/* phys. target (a hint) */
> +	ext4_fsblk_t goal;
> +	/* the closest logical allocated block to the left */
> +	ext4_lblk_t lleft;
> +	/* phys. block for ^^^ */
> +	ext4_fsblk_t pleft;
> +	/* the closest logical allocated block to the right */
> +	ext4_lblk_t lright;
> +	/* phys. block for ^^^ */
> +	ext4_fsblk_t pright;
> +	/* how many blocks we want to allocate */
> +	unsigned int len;
> +	/* flags. see above EXT4_MB_HINT_* */
> +	unsigned int flags;
> +};
> +
> +struct ext4_free_extent {
> +	ext4_lblk_t fe_logical;
> +	ext4_grpblk_t fe_start;
> +	ext4_group_t fe_group;
> +	int fe_len;
> +};
> +
> +struct ext4_allocation_context {
> +	struct inode *ac_inode;
> +	struct super_block *ac_sb;
> +
> +	/* original request */
> +	struct ext4_free_extent ac_o_ex;
> +
> +	/* goal request (after normalization) */
> +	struct ext4_free_extent ac_g_ex;
> +
> +	/* the best found extent */
> +	struct ext4_free_extent ac_b_ex;
> +
> +	/* copy of the bext found extent taken before preallocation efforts */
> +	struct ext4_free_extent ac_f_ex;
> +
> +	/* number of iterations done. we have to track to limit searching */
> +	unsigned long ac_ex_scanned;
> +	__u16 ac_groups_scanned;
> +	__u16 ac_found;
> +	__u16 ac_tail;
> +	__u16 ac_buddy;
> +	__u16 ac_flags;		/* allocation hints */
> +	__u8 ac_status;
> +	__u8 ac_criteria;
> +	__u8 ac_repeats;
> +	__u8 ac_2order;		/* if request is to allocate 2^N blocks and
> +				 * N > 0, the field stores N, otherwise 0 */
> +	__u8 ac_op;		/* operation, for history only */
> +	struct page *ac_bitmap_page;
> +	struct page *ac_buddy_page;
> +	/*
> +	 * pointer to the held semaphore upon successful
> +	 * block allocation
> +	 */
> +	struct rw_semaphore *alloc_semp;
> +	struct ext4_prealloc_space *ac_pa;
> +	struct ext4_locality_group *ac_lg;
> +};
> +
> +struct ext4_prealloc_space {
> +	struct list_head	pa_inode_list;
> +	struct list_head	pa_group_list;
> +	union {
> +		struct list_head pa_tmp_list;
> +		struct rcu_head	pa_rcu;
> +	} u;
> +	spinlock_t		pa_lock;
> +	atomic_t		pa_count;
> +	unsigned		pa_deleted;
> +	ext4_fsblk_t		pa_pstart;	/* phys. block */
> +	ext4_lblk_t		pa_lstart;	/* log. block */
> +	unsigned short		pa_len;		/* len of preallocated chunk */
> +	unsigned short		pa_free;	/* how many blocks are free */
> +	unsigned short		pa_type;	/* pa type. inode or group */
> +	spinlock_t		*pa_obj_lock;
> +	struct inode		*pa_inode;	/* hack, for history only */
> +};
> +
> +#endif /* _EXT4_TRACE_TYPES_H */

We moved all the ext4 headers to fs/ext4/  Can this be
fs/ext4/ext4_trace_types.h ?

-aneesh
