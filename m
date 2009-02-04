From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 1/3] ext4: Add EXT4_IOC_DEFRAG ioctl and basic
	defrag functions
Date: Wed, 4 Feb 2009 09:54:41 -0500
Message-ID: <20090204145441.GC14762@mit.edu>
References: <49829A37.8050701@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49829A37.8050701@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 30, 2009 at 03:12:07PM +0900, Akira Fujita wrote:
> ext4: online defrag -- Add EXT4_IOC_DEFRAG ioctl and basic defrag functions.
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks, this patch is much better.  Eventually I suspect you'll want
to add an ioctl to control the allocation of blocks to the donor
inode, but that can certainly come later.

I would combine the two kernel patches into one.  There's no point
separating them into separate patches; the maximum message size
through the vger mailing lists is something like 100k, and the two
patches combined are under 43k.  The first patch won't function very
well with two key functions stubbed out with "return 0;", anyway....

Also, I note that you are moving pages from the donor inode to the
target inode one page at a time.  It would be faster and involve less
journal activity to move an extent at a time; after all, the donor fd
should be no more fragmented than the source fd, or the userspace
program shoudl have noticed and not attempted to call the defrag
ioctl.  Therefore, nearly all of the time, it should be possible to
move a contiguous range of blocks at a time from the donor to the
source without increasing the number of extents in the target inode's
leaf node.

You may also want to consider whether it is truly worth it to swap the
block assignments between the donor and the target inode, and whether
it might be easier simply to release the blocks that had previously
belonged to the target inode, and simply decrement the length of the
extent and/or delete the extent from the donor inode altogether.  That
removes the need to split any leaf blocks in the donor inode's extent
tree, since it is guaranteed to always stay the same size or become
smaller.

> +{
> +	if (!S_ISREG(org_inode->i_mode) || !S_ISREG(dest_inode->i_mode)) {
> +		printk(KERN_ERR "ext4 defrag: "
> +			"The argument files should be regular file\n");
> +		return -EINVAL;
> +	}

Random printks is probably a bad idea; this should only be done if
debugging is enabled, and if the goal is debugging, it would be more
useful if the code printed more information that might be useful to
someone trying to debug the userspaceprogram (such as the inode
numbers passed to the ioctl, in the above example).

> +		if (start + len > i_size_read(org_inode)) {
> +			printk(KERN_ERR "ext4 defrag: Adjust defrag length "
> +				" because it[%u] is larger than original "
> +				"file size\n", len);
> +			len = i_size_read(org_inode) - start;
> +		}

The function ext4_defrag_check_arguments() is called before any
locking is done.  So you could potentially have a race where target
inode gets truncated by another process between when the userspace
program determined the parameters to the defrag ioctl and when the
defrag ioctl starts executing.

> +/**
> + * ext4_defrag_lock_two - acquire two inodes' lock
> + *
> + * @first:		inode structure to be locked first
> + * @second:		inode structure to be locked second
> + *
> + * Lock mutex and semaphore of the two inodes (@first and @second). First
> + * @first is locked and then @second is locked. Note that we *must* set
> + * arguments in order of small address.
> + */
> +static void ext4_defrag_lock_two(struct inode *first, struct inode *second)

This function only gets called once, so it doesn't matter that much,
but you can reduce the stack space in the caller (ext4_defrag()) by
doing the comparison in the function, and not saving the result.
i.e., change this:

+     /* Lock the lower address inode first */
+     if (ip > tip) {
+     	 ip = dest_inode;
+	 tip = org_inode;
+     }
+     ext4_defrag_lock_two(ip, tip);

to this:

      ext4_defrag_lock_two(org_inode, dest_inode);

Note that you don't need to save ip and tip on the stack, because it
is the _locking_ order which matters in order to prevent deadlocks.
The order in which the two inodes are unlocked doesn't matter.  So you
can drop the ip and tip variables from ext4_defrag(), and just arrange
to use a stable locking order in ext4_defrag_lock_two().  Personally,
I'd prefer to use the inode number (target_inode->i_ino and
donor_inode->i_ino) to provide the stable locking order, but using the
address does work.  The C language doesn't guarantee you can compare
pointers that don't come from the same array, but it's not like the
Linux kernel is likely to be ported to a architecture such as the
Honeywell DPS8 (which ran Multics :-).

							- Ted
