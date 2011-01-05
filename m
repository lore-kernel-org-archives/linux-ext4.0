From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 6/6] ext4: Dynamically allocate the jbd2_inode in ext4_inode_info as necessary
Date: Wed, 5 Jan 2011 12:26:33 -0700
Message-ID: <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu> <1294189270-16733-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:4786 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1AET0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jan 2011 14:26:34 -0500
In-Reply-To: <1294189270-16733-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-04, at 18:01, Theodore Ts'o wrote:
> Replace the jbd2_inode structure (which is 48 bytes) with a pointer
> and only allocate the jbd2_inode when it is needed --- that is, when
> the file system has a journal present and the inode has been opened
> for writing.  This allows us to further slim down the ext4_inode_info
> structure.

How does this change impact the majority of users that are running with a journal?  It is clearly a win for a small percentage of users with no-journal mode, but it may be a net increase in memory usage for the majority of the users (with journal).  There will now be two allocations for every inode, and the extra packing these allocations into slabs will increase memory usage for an inode, and would definitely result in more allocation/freeing overhead.

The main question is how many files are ever opened for write?  It isn't just the number of currently-open files for write, because the jinfo isn't released until the inode is cleared from memory.  While I suspect that most inodes in cache are never opened for write, it would be worthwhile to compare the ext4_inode_cache object count against the jbd2_inode object count, and see how the total memory compares to a before-patch system running different workloads (with journal).


> @@ -55,10 +55,17 @@ static inline int ext4_begin_ordered_truncate(struct inode *inode,
> 					      loff_t new_size)
> {
> 	trace_ext4_begin_ordered_truncate(inode, new_size);
> +	/* 
> +	 * If jinode is zero, then we never opened the file for
> +	 * writing, so there's no need to call
> +	 * jbd2_journal_begin_ordered_truncate() since there's no
> +	 * outstanding writes we need to flush.
> +	 */
> +	if (!EXT4_I(inode)->jinode)
> +		return 0;
> +	return jbd2_journal_begin_ordered_truncate(EXT4_JOURNAL(inode),
> +						   EXT4_I(inode)->jinode,
> +						   new_size);
> }

In fact, the only callsites of this function are protected with:

	if (ext4_should_order_data(inode))
		ext4_begin_ordered_truncate(inode, size)

which will skip the call to ext4_begin_ordered_truncate() if the filesystem is running in no-journal mode (EXT4_JOURNAL(inode) == NULL)).  That means the only reason this function could be called with jinode == NULL is due to memory corruption, and it makes sense to replace this with:

	BUG_ON(EXT4_I(inode)->jinode == NULL);

> @@ -832,6 +826,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
> #ifdef CONFIG_QUOTA
> 	ei->i_reserved_quota = 0;
> #endif
> +	ei->jinode = 0;

This should be "ei->jinode = NULL".

Cheers, Andreas






Cheers, Andreas





