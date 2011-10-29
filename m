From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: fix block swap procedure on migration V2
Date: Sat, 29 Oct 2011 08:54:51 -0400
Message-ID: <20111029125451.GC19536@thunk.org>
References: <1316266379-18737-1-git-send-email-dmonakhov@openvz.org>
 <1316266379-18737-3-git-send-email-dmonakhov@openvz.org>
 <4CCE9F3D-0343-4FF2-A969-291335071D69@dilger.ca>
 <87wrd4zdjn.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40653 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761Ab1J2SMm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:42 -0400
Content-Disposition: inline
In-Reply-To: <87wrd4zdjn.fsf@dmbot.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 19, 2011 at 08:45:32PM +0400, Dmitry Monakhov wrote:
> > It would potentially be better to just leave the inode off the orphan
> > list, and in the _extremely_ rare case that there is a crash during
> > inode migration the inode is leaked until e2fsck is run.  The migrate
> > will happen at most once for any filesystem, so the loss of a single
> > inode per crash will not be a serious issue IMHO.
>
> But we still need to tell e2fsck that it is not just an average inode,
> and it should be cleaned up without touching it's data blocks. Otherwise
> fsck will complain about blocks are referenced by multiple inodes, which
> is really scary message. So IMHO we still need persistent flag. 

The simplest way to solve this is to keep the n_links count on the
inode to be zero.  That will prevent e2fsck from considering the inode
as being in use, so it will simply not consider the blocks owned by
the temporary inode.  What this would mean is that we will leak the
temporary inode as well as the newly allocated index blocks until the
next e2fsck, but that's not a disaster, and it is a very rare case.

If we wanted to optimize things further, we could also add support to
__ext4_get_inode_loc(), ext4_mark_inode_dirty(), and
ext4_write_inode() so that if the inode number is some magic number,
such as inode number 1 (which as the bad block inode we never touch
directly), that it is to be considered an in-memory inode only and so
we don't even bother writing it to do disk or journaling to it.  That
way the migration code can use an in-memory inode which is allocated
by ext4_ext_migrate(), and whose only existence is a pointer in that
kernel stack frame to an in-memory inode, which has no existence on
disk.

With this optimized approach, the only thing we will leak is one,
maybe two extent tree index blocks *if* we happen to be migrating an
inode during the time of a system crash.  We could even avoid that by
adding support for blocks which are allocated in memory, but not (yet)
pushed out to disk, which we may need for some of the write path
improvements.  But if we don't get to that right away, I think that's
fine....

						- Ted
