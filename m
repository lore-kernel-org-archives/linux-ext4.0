From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC v2 01/10] vfs: introduce private rb structures
Date: Tue, 25 Sep 2012 18:20:59 +0800
Message-ID: <20120925102059.GB2456@ram-ThinkPad-T61>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-2-git-send-email-zwu.kernel@gmail.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	david@fromorbit.com, stroetmann@ontolinux.com, diegocg@gmail.com,
	chris@csamuel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44013 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2IYKVL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 06:21:11 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <linuxram@us.ibm.com>;
	Tue, 25 Sep 2012 04:21:10 -0600
Content-Disposition: inline
In-Reply-To: <1348404995-14372-2-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
> ---
> +
..snip..

> +/* A tree that sits on the hot_info */
> +struct hot_inode_tree {
> +	struct rb_root map;
> +	rwlock_t lock;
> +};
> +
> +/* A tree of ranges for each inode in the hot_inode_tree */
> +struct hot_range_tree {
> +	struct rb_root map;
> +	rwlock_t lock;
> +};

Can as well have a generic datastructure called hot_tree instead
of having two different datastructure which basically are the same.

> +
> +/* A frequency data struct holds values that are used to
> + * determine temperature of files and file ranges. These structs
> + * are members of hot_inode_item and hot_range_item
> + */
> +struct hot_freq_data {
> +	struct timespec last_read_time;
> +	struct timespec last_write_time;
> +	u32 nr_reads;
> +	u32 nr_writes;
> +	u64 avg_delta_reads;
> +	u64 avg_delta_writes;
> +	u8 flags;
> +	u32 last_temperature;
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
> +	/* used to check for errors in ref counting */
> +	u8 in_tree;
> +	/* protects hot_freq_data, start, len, and in_tree */
> +	spinlock_t lock;
> +	/* prevents kfree */
> +	struct kref refs;
> +};

might as well have just one generic datastructure called hot_item with 
all the common fields and then have 

	struct hot_inode_item  {
		struct hot_item hot_inode;
		struct hot_tree hot_range_tree;
		unsigned long i_ino;
	}

	and 

	struct hot_range_item {
		struct hot_item hot_range;
		u64 start;
		u64 len;	/* length of this range */
	}

This should help you eliminate some duplicate code as well.


RP

