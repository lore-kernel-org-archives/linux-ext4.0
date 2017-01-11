From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Wed, 11 Jan 2017 10:34:49 -0500
Message-ID: <20170111153449.ourcta6jraxo4mzy@thunk.org>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
 <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong <darrick.wong@oracle.com>; Jan Kara" <jack@suse.cz>,
        Valdis.Kletnieks@vt.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca
To: "zhangyi (F)" <yi.zhang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 11, 2017 at 05:07:29PM +0800, zhangyi (F) wrote:
> 
> (1) The file we want to unlink have many hard links, but only one dcache entry in memory.
> (2) open this file, but it's inode->i_nlink read from disk was 1 (too low).
> (3) some one call rename and drop it's i_nlink to zero.
> (4) it's inode is still in use and do not destroy (not closed), at the same time,
>     some others open it's hard link and create a dcache entry.
> (5) call rename again and it's i_nlink will still underflow and cause memory corruption.

Do you have reproducers that make it easy to reproduce situations like
this?  (It shouldn't be hard to write, but if you have them already
will save me some effort.  :-)

If we ever get passed an inode to ext4_file_open() where i_nlink is
zero, we can declare the file system is corrupt by calling
ext4_error() to report the problem.

Similarly, whenever we are passed a dentry pointing to an inode for
link, unlink, rename, and other methods in the inode_operations
structure, by definition the file system is corrupt, and again we
should report this using ext4_error().

So I don't think we should think of this as adding "underflow
protection"; instead we should think of it as adding more aggressive
detection of file system inconsistencies.  If there is dentry which is
valid, and pointing at an inode where n_links is zero, something has
gone seriously wrong.  So we should call ext4_error() to report the
file system inconsistency, and then return EFSCORRUPTED (aka EUCLEAN).

Since we would be doing this in a number of places, we should probably
add an inline function:

static inline int ext4_validate_dentry(struct dentry *dentry);

which returns 0 if the dentry is valid, and calls ext4_error_inode()
and returns -EFSCORRUPTED if the dentry points to an inode with a zero
i_nlink.

(Note: it's valid for i_nlinks to be zero if the system call started
with a file descriptor, such as read(2) or write(2) operating on a
file which is still deleted but has open file descriptors.  But if the
user has passed a pathname to the system call, such as in the case of
open(), rename(), unlink(), rmdir(), etc, then the dentry had better
be pointing at an inode with a non-zero i_nlink call.  We need to be a
bit careful if the method function could be called by both a pathname
and file descriptor variant of the system call --- for example
fsetxattr(2) and setxattr(2); we won't be able to use
ext4_validate_dentry() for those inode_operations calls.)

Cheers,

					- Ted
