From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: fix race in xattr block allocation path
Date: Sat, 29 Oct 2011 10:12:45 -0400
Message-ID: <20111029141245.GI19536@thunk.org>
References: <4EA5E702.8030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40636 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933746Ab1J2SMj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:39 -0400
Content-Disposition: inline
In-Reply-To: <4EA5E702.8030303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 24, 2011 at 05:30:26PM -0500, Eric Sandeen wrote:
> Ceph users reported that when using Ceph on ext4, the filesystem
> would often become corrupted, containing inodes with incorrect
> i_blocks counters.
> 
> ...
>
> In other words, the sync/flush thread pops in and sets
> i_delalloc_reserved_flag on the inode, which makes the xattr thread
> think that it's in a delalloc path in ext4_new_meta_blocks(),
> and add the block for a second time, after already having added
> it once in the !i_delalloc_reserved_flag case in ext4_mb_new_blocks
> 
> I think this can be as simple as taking i_data_sem before we
> go down the new metablock path, so that we won't be testing
> i_delalloc_reserved_flag in a race with xt4_get_blocks setting it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied for now.

> 
> This seems like slight abuse of i_data_sem though, since we are
> not modifying i_data[] in the inode on the xattr path.  But nothing
> else protects readers of i_delalloc_reserved_flag in other
> threads.  Thoughts?

Agreed, we really should be depending on the
EXT4_GET_BLOCK_DELALLOC_RESERVE and EXT4_MB_DELALLOC_RESERVED flags.
I can't remember what caused us to plumb in the i_state flag, but
that's clearly a hack which is biting us hard.

I'll take this patch for now since it fixes a real problem, but we
should figure out a better way of fixing this, hopefully that results
in the i_state flag going away.

						- Ted
