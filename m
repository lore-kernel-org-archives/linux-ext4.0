From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv3 0/3] new APIs to allocate buffer-cache with user
 specific flag
Date: Thu, 28 Aug 2014 09:48:04 -0400
Message-ID: <20140828134804.GC21925@thunk.org>
References: <53FE9357.6000505@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53896 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaH1NsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2014 09:48:25 -0400
Content-Disposition: inline
In-Reply-To: <53FE9357.6000505@lge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2014 at 11:26:31AM +0900, Gioh Kim wrote:
> 
> I have 3 patchs:
> 
> 1. Patch 1/3: introduce a new API that create page cache with allocation flag
> 2. Patch 2/3: have ext4 use the new API to read superblock
> 3. Patch 3/3: have jbd/jbd2 use the new API to make journaling of superblock
> 
> This patchset is based on linux-next-20140814.

Looks good.  Unless there are any objections from the mm folks, since
the nearly all of the changes are in fs/buffer.c and in ext4/jbd2
code, I plan to carry this in the ext4 tree.

I do plan to clean up the patch titles a little; from:

fs/buffer.c: allocate buffer cache with user specific flag
ext4: allocate buffer-cache for superblock in, non-movable area
jbd/jbd2: allocate buffer-cache for superblock inode in non-movable area

to:

fs.c: support buffer cache allocations with gfp modifiers
ext4: use non-movable memory for the ext4 superblock
jbd/jbd2: use non-movable memory for the jbd superblock

And do some minor english grammar/spelling cleanups in the commit
description when I apply the patch.

Thanks for this work; I'm going to need to use the interfaces you
introduced in fs/buffer.c to guarantee that certain directory reads
can be done with GFP_NOFAIL (since under heavy memory pressure,
allocation failures there can currently lead to the file system
getting declared corrupt.  Interestingly, this bug has been around for
a long time, and hasn't been noticed in over two cycles of enterprise
distro qualifications by either RHEL or SLES, which leads me to wonder
if there are other places where the error paths for GFP_NOFS
allocations haven't been well tested....)

						- Ted
