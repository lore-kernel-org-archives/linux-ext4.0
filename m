From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH] fs: ext4: don't trap kswapd and allocating tasks on
 ext4 inode IO
Date: Tue, 16 May 2017 11:41:05 -0400
Message-ID: <20170516154105.GA22633@cmpxchg.org>
References: <20170515154634.19733-1-hannes@cmpxchg.org>
 <20170516143645.GA7316@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gum.cmpxchg.org ([85.214.110.215]:50206 "EHLO gum.cmpxchg.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbdEPPlS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 May 2017 11:41:18 -0400
Content-Disposition: inline
In-Reply-To: <20170516143645.GA7316@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 16, 2017 at 04:36:45PM +0200, Jan Kara wrote:
> On Mon 15-05-17 11:46:34, Johannes Weiner wrote:
> > We have observed across several workloads situations where kswapd and
> > direct reclaimers get stuck in the inode shrinker of the ext4 / mount,
> > causing allocation latencies across tasks in the system, while there
> > are dozens of gigabytes of clean page cache covering multiple disks.
> > 
> > The stack traces of such an instance looks like this:
> > 
> > [<ffffffff812b3225>] jbd2_log_wait_commit+0x95/0x110
> > [<ffffffff812b4f29>] jbd2_complete_transaction+0x59/0x90
> > [<ffffffff812668da>] ext4_evict_inode+0x2da/0x480
> > [<ffffffff811f2230>] evict+0xc0/0x190
> > [<ffffffff811f2339>] dispose_list+0x39/0x50
> > [<ffffffff811f323b>] prune_icache_sb+0x4b/0x60
> > [<ffffffff811dba71>] super_cache_scan+0x141/0x190
> > [<ffffffff8116e755>] shrink_slab+0x235/0x440
> > [<ffffffff81172b48>] shrink_zone+0x268/0x2d0
> > [<ffffffff81172f04>] do_try_to_free_pages+0x164/0x410
> > [<ffffffff81173265>] try_to_free_pages+0xb5/0x160
> > [<ffffffff811656b6>] __alloc_pages_nodemask+0x636/0xb30
> > [<ffffffff811acac8>] alloc_pages_current+0x88/0x120
> > [<ffffffff816d4e46>] skb_page_frag_refill+0xc6/0xf0
> > [<ffffffff816d4e8d>] sk_page_frag_refill+0x1d/0x80
> > [<ffffffff8173f86b>] tcp_sendmsg+0x28b/0xb10
> > [<ffffffff81769727>] inet_sendmsg+0x67/0xa0
> > [<ffffffff816d0488>] sock_sendmsg+0x38/0x50
> > [<ffffffff816d0518>] sock_write_iter+0x78/0xd0
> > [<ffffffff811d774e>] do_iter_readv_writev+0x5e/0xa0
> > [<ffffffff811d8468>] do_readv_writev+0x178/0x210
> > [<ffffffff811d871c>] vfs_writev+0x3c/0x50
> > [<ffffffff811d8782>] do_writev+0x52/0xd0
> > [<ffffffff811d9810>] SyS_writev+0x10/0x20
> > [<ffffffff81002910>] do_syscall_64+0x50/0xa0
> > [<ffffffff817eed3c>] return_from_SYSCALL_64+0x0/0x6a
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > The inode shrinker has provisions to skip any inodes that require
> > writeback, to avoid tarpitting the entire system behind a single
> > object when there are many other pools to recycle memory from. But
> > that logic doesn't cover the situation where an ext4 inode is clean
> > but journaled and tied to a commit that yet needs to hit the platter.
> > 
> > Add a superblock operation that lets the generic inode shrinker query
> > the filesystem whether evicting a given inode will require any IO; add
> > an ext4 implementation that checks whether the journal is caught up to
> > the commit id associated with the inode.
> > 
> > Fixes: 2d859db3e4a8 ("ext4: fix data corruption in inodes with journalled data")
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> OK. I have to say I'm somewhat surprised you use data journalling on some
> of your files / filesystems but whatever - maybe these are long symlink
> after all which would make sense.

The filesystem is actually mounted data=ordered and we didn't catch
anyone in userspace enabling journaling on individual inodes. So we
assumed this must be from symlinks.

> And I'm actually doubly surprised you can see these stack traces as
> these days inode_lru_isolate() checks inode->i_data.nrpages and
> uncommitted pages cannot be evicted from pagecache
> (ext4_releasepage() will refuse to free them) so I don't see how
> such inode can get to dispose_list(). But maybe the inode doesn't
> really have any pages and i_datasync_tid just happens to be set to
> the current transaction because it is initialized that way and we
> are evicting inode that was recently read from disk.

Hm, we're running 4.6, but that already has the nrpages check in
inode_lru_isolate(). There couldn't be any pages in those inodes by
the time the shrinker gets to them.

> Anyway if you add: "&& inode->i_data.nrpages" to the test in
> ext4_evict_inode() do the stalls go away?

Want me to still test this?
