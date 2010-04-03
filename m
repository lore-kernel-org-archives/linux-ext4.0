From: tytso@mit.edu
Subject: Re: [PATCH] ext4: add rb_tree cache to struct ext4_group_info
Date: Sat, 3 Apr 2010 11:34:13 -0400
Message-ID: <20100403153413.GO8298@thunk.org>
References: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
 <x2tac8f92701003310726uf41823efz3d2ef98f438872b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41567 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0DCPeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 11:34:25 -0400
Content-Disposition: inline
In-Reply-To: <x2tac8f92701003310726uf41823efz3d2ef98f438872b6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 31, 2010 at 10:26:45PM +0800, jing zhang wrote:
> 
> With the added cache, there is over 50% probability that the operation,
>        rb_first(&(grp->bb_free_root));
> can be saved, when there are multiple nodes in tree.
> 
> It seems what is added is following what is called O(1), one of the
> works by Mr. Ingo Molnar, but I am not sure, and let's ask Mr. Ingo
> Molnar.

Sure, but does it matter?  The red-black tree is per-block group, and
rb_first() is O(ln n), and it's cleared after every transaction
commit.  Have you measured how deep it gets?  Have you measured how
much CPU time this would actually save?

I'm almost certiain the code complexity isn't worth it.  For example,
your patch is buggy.  There are places where the red black tree is
manipulated, and where the node pointed at by bb_free_cache could get
freed.  For example, see release_blocks_on_commit() and
ext4_mb_free_metadata().

That being said, I'm not convinced ext4_mb_generate_from_freelist() is
(a) necessary, or (b) bug-free, either.  The whole point of having
extents in bb_free_root tree is that those extents aren't safe to be
placed in the buddy bitmap.  And ext4_mb_generate_from_freelist()
isn't freeing the nodes from the rbtree.  Fortunately it looks like
ext4_mb_generate_from_freelist is only getting called when the buddy
bitmap is being set up, so the rbtree should be empty during those
times.

I need to do some more investigation, but I think the function can be
removed entirely.

						- Ted
