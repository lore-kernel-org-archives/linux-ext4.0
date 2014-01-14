From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] Add support for new compat feature "super_sparse"
Date: Tue, 14 Jan 2014 11:08:13 -0500
Message-ID: <20140114160813.GA11232@thunk.org>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu>
 <20140113132707.GA22358@orion.maiolino.org>
 <20140113140645.GC18029@thunk.org>
 <20140113161949.GB22541@thunk.org>
 <20140114055426.GB27083@thunk.org>
 <6C608D9A-AAAC-402D-BC7B-FC23EF9956BD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48418 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaANQIT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jan 2014 11:08:19 -0500
Content-Disposition: inline
In-Reply-To: <6C608D9A-AAAC-402D-BC7B-FC23EF9956BD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 14, 2014 at 04:21:52AM -0700, Andreas Dilger wrote:
> A few comments on this new patch:
> - I think the name will be confusing to users, especially non-native English
>   speakers. Is it "sparse_super" or "super_sparse" they want?

Yes, good point.  Maybe sparse_super2?  More generally, I don't think
we want most users of mke2fs ever needing or wanting to use these
features.  We can kind of handle this by using "mke2fs -T smr", or
some such, but this is related to something I've been thinking about
for a while, which is a way of collapsing the following from dumpe2fs:

Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize

... into something like this.

Filesystem features:      ext4_default_set needs_recovery


> - I would suspect that group #1 is not the best place to put the backup.
>   For very large filesystems, there is a conflict with the backup group
>   descriptors in group #0 and #1. It would be better to out the one
>   backup in group #3 or something.  I don't think this will be a problem
>   for SMR drives, since they will be so large that this will easily fit inside
>   (or close to) the flex_bg layout of the inode table.

I'm not sure what what you mean by "conflict with the backup
descriptors in #0 and #1"?

One reason why I'm inclined to leave a backup at group #1 is that for
most file systems, sysadmins are trained to know that there is a
backup at -b 32768.  If we change it to be something else, it makes it
a bit harder to find the backup sb, which is a consideration.

Yes, bigalloc does change the offset, but that's actually another
solution I had been looking at for our use case inside google for big
SMR drives.


> - To simplify matters, it makes sense that super_sparse supersedes
>   the sparse_super and meta_bg features. It doesn't make sense
>   to have both. Should it also require flex_bg?  Without it, it is mostly
>   useless. 

Actually, it doesn't supercede meta_bg.  Meta_bg is about where to put
the block group descriptors to allow for 64-bit online resize, such
that the bg descriptor blocks are no longer contiguous.  This is
separate and distinct from the question of which block group have a
superblock and the contiguous (aka "old-style") set of block group
descriptors as backup.

I agree that for the use case of keeping the data blocks contiguous,
it only makes sense to use it with flex_bg; but the file systems
options are largely orthogonal, and it doesn't actually simplify
anything from a code complexity standpoint to require them.  How we
make it easy for users to request a certain set of features is a
different question, and that's where I think ultimately mke2fs's -T
option is going to come in really handy.

					- Ted
