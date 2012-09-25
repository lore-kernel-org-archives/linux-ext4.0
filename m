From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 01/10] vfs: introduce private rb structures
Date: Tue, 25 Sep 2012 17:37:29 +1000
Message-ID: <20120925073729.GA29154@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-2-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348404995-14372-2-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 23, 2012 at 08:56:26PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   One root structure hot_info is defined, is hooked
> up in super_block, and will be used to hold rb trees
> root, hash list root and some other information, etc.
>   Adds hot_inode_tree struct to keep track of
> frequently accessed files, and be keyed by {inode, offset}.
> Trees contain hot_inode_items representing those files
> and ranges.
>   Having these trees means that vfs can quickly determine the
> temperature of some data by doing some calculations on the
> hot_freq_data struct that hangs off of the tree item.
>   Define two items hot_inode_item and hot_range_item,
> one of them represents one tracked file
> to keep track of its access frequency and the tree of
> ranges in this file, while the latter represents
> a file range of one inode.
>   Each of the two structures contains a hot_freq_data
> struct with its frequency of access metrics (number of
> {reads, writes}, last {read,write} time, frequency of
> {reads,writes}).
>   Also, each hot_inode_item contains one hot_range_tree
> struct which is keyed by {inode, offset, length}
> and used to keep track of all the ranges in this file.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Just a coupl eof minor formatting things first up - I'll have more
comments as I get deeper into the series.

....
> +/*
> + * Initialize the inode tree. Should be called for each new inode
> + * access or other user of the hot_inode interface.
> + */
> +static void hot_rb_inode_tree_init(struct hot_inode_tree *tree)

The names of these are a bit clunky. You probably don't need the
"_rb_" in the function name. i.e. hot_inode_tree_init() is
sufficient, and if we every want to change in the tree type we don't
have to rename every single function...

.....
> +/*
> + * Initialize a new hot_inode_item structure. The new structure is
> + * returned with a reference count of one and needs to be
> + * freed using free_inode_item()
> + */
> +void hot_rb_inode_item_init(void *_item)
> +{

The usual naming convention for slab initialiser functions is to use
a suffix of "_once" to indicate it is only ever called once per
slab object instantiation, not every time the object is allocated
fom the slab. See, for example, inode_init_once() and
inode_init_always().

so, that would make this function hot_inode_item_init_once().

....
> +/* init hot_inode_item and hot_range_item kmem cache */
> +static int __init hot_rb_item_cache_init(void)
> +{
> +	hot_inode_item_cache = kmem_cache_create("hot_inode_item",
> +			sizeof(struct hot_inode_item), 0,
> +			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
> +			hot_rb_inode_item_init);
> +	if (!hot_inode_item_cache)
> +		goto inode_err;
> +
> +	hot_range_item_cache = kmem_cache_create("hot_range_item",
> +					sizeof(struct hot_range_item), 0,
> +					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
> +					hot_rb_range_item_init);
> +	if (!hot_range_item_cache)
> +		goto range_err;
> +
> +	return 0;
> +
> +range_err:
> +	kmem_cache_destroy(hot_inode_item_cache);
> +inode_err:
> +	return -ENOMEM;
> +}
> +
> +/*
> + * Initialize kmem cache for hot_inode_item
> + * and hot_range_item
> + */
> +void __init hot_track_cache_init(void)
> +{
> +	if (hot_rb_item_cache_init())
> +		return;

No real need to have a hot_rb_item_cache_init() function here - just
open code it all in the hot_track_cache_init() function.

> +}
> diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
> new file mode 100644
> index 0000000..269b67a
> --- /dev/null
> +++ b/fs/hot_tracking.h
> @@ -0,0 +1,27 @@
> +/*
> + * fs/hot_tracking.h
> + *
> + * Copyright (C) 2012 IBM Corp. All rights reserved.
> + * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> + *            Ben Chociej <bchociej@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + */
> +
> +#ifndef __HOT_TRACKING__
> +#define __HOT_TRACKING__
> +
> +#include <linux/rbtree.h>
> +#include <linux/hot_tracking.h>
> +
> +/* values for hot_freq_data flags */
> +/* freq data struct is for an inode */
> +#define FREQ_DATA_TYPE_INODE (1 << 0)
> +/* freq data struct is for a range */
> +#define FREQ_DATA_TYPE_RANGE (1 << 1)

The comments are redundant - the name of the object documents it's
use sufficiently.  ie.

/* values for hot_freq_data flags */
#define FREQ_DATA_TYPE_INODE (1 << 0)
#define FREQ_DATA_TYPE_RANGE (1 << 1)

is just fine by itself.

....
> +/* A frequency data struct holds values that are used to
> + * determine temperature of files and file ranges. These structs
> + * are members of hot_inode_item and hot_range_item
> + */

/*
 * This is a
 * multiline comment. ;)
 */

> +struct hot_freq_data {
> +	struct timespec last_read_time;
> +	struct timespec last_write_time;
> +	u32 nr_reads;
> +	u32 nr_writes;
> +	u64 avg_delta_reads;
> +	u64 avg_delta_writes;
> +	u8 flags;
> +	u32 last_temperature;

may as well make the flags a u32 - the compiler will ues that much
space anyway as it aligned the u32 last_temperature variable after
it.

> +};
> +
> +/* An item representing an inode and its access frequency */
> +struct hot_inode_item {
> +	/* node for hot_inode_tree rb_tree */
> +	struct rb_node rb_node;
> +	/* tree of ranges in this inode */
> +	struct hot_range_tree hot_range_tree;
> +	/* frequency data for this inode */
> +	struct hot_freq_data hot_freq_data;
> +	/* inode number, copied from inode */
> +	unsigned long i_ino;
> +	/* used to check for errors in ref counting */
> +	u8 in_tree;
> +	/* protects hot_freq_data, i_no, in_tree */
> +	spinlock_t lock;
> +	/* prevents kfree */
> +	struct kref refs;

It's hard to see the code in the commentsi, and some of comments are
redundant.. It's easier to read if you do this:

struct hot_inode_item {
	struct rb_node node;			/* hot_inode_tree index */
	struct hot_range_tree hot_range_tree;	/* tree of ranges */
	struct hot_freq_data hot_freq_data;	/* frequency data */
	unsigned long i_ino;			/* inode number from inode */
	u8 in_tree;				/* ref counting check */
	spinlock_t lock;			/* protects object data */
	struct kref refs;			/* prevents kfree */
}

Also: 
	- i_ino really needs to be a 64 bit quantity as some
	  filesystems can use 64 bit inode numbers even on 32
	  bit systems (e.g. XFS).
	- in_tree can be u32 or a flags field if it is boolean. if
	  it is just debug, then maybe it can be removed whenteh
	  code is ready for commit.

> +};
> +
> +/*
> + * An item representing a range inside of an inode whose frequency
> + * is being tracked
> + */
> +struct hot_range_item {
> +	/* node for hot_range_tree rb_tree */
> +	struct rb_node rb_node;
> +	/* frequency data for this range */
> +	struct hot_freq_data hot_freq_data;
> +	/* the hot_inode_item associated with this hot_range_item */
> +	struct hot_inode_item *hot_inode;
> +	/* starting offset of this range */
> +	u64 start;
> +	/* length of this range */
> +	u64 len;

What units?
	u64 start;	/* start offset in bytes */
	u64 len		/* length in bytes */

> +	/* used to check for errors in ref counting */
> +	u8 in_tree;
> +	/* protects hot_freq_data, start, len, and in_tree */
> +	spinlock_t lock;
> +	/* prevents kfree */
> +	struct kref refs;
> +};
> +
> +struct hot_info {
> +	/* red-black tree that keeps track of fs-wide hot data */
> +	struct hot_inode_tree hot_inode_tree;
> +};

The comment is redundant...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
