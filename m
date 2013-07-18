From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4: add new ioctl EXT4_IOC_PRECACHE_EXTENTS
Date: Wed, 17 Jul 2013 22:50:25 -0400
Message-ID: <20130718025025.GA30405@thunk.org>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <1373987883-4466-6-git-send-email-tytso@mit.edu>
 <20130718011940.GA8785@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38773 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab3GRCu2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jul 2013 22:50:28 -0400
Content-Disposition: inline
In-Reply-To: <20130718011940.GA8785@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 18, 2013 at 09:19:41AM +0800, Zheng Liu wrote:
> 
> If I understand correctly, we don't want to reclaim from an inode with
> EXT4_STATE_EXT_PRECACHED flag when __ratelimit() returns 0, right?  

No, the intent of the code was to make sure we don't trigger the
warning too often, in case the system is under massive memory
pressure.  In the original implementation of this ioctl which we used
at Google (with an extent cache that was much less functional than the
extent status tree we now have upstream), the extents were pinned in
memory permanently, until the inode is evicted from memory.

I thought about doing this, since normally the cached extents will
take less memory than the extent tree in the buffer cache (especially
in any sane setup where the large tablespace, etc., files are are
fallocated in advance and are largely contiguous).  But for upstream,
I was concerned that someone might deliberately create lots of
fragmented files, and then call the precache ioctl on all of them.

So what I did was to change the sort function such that the shrinker
would put those files at the end of the list.  And although it's not
in the patch that I've sent out, I've since changed it so that if the
head of the list is an precached inode, and it's been more than 5
seconds, we force a resort of the list.

That way if we are under heavy memory pressure, we will eventually get
rid of the precached extents --- but under normal circumstnaces, we
try very hard not to, at least via the es_shrinker.  (If the inode
gets closed, and then eventually the inode gets evicted, then of
course we'll drop all of the precached extents.)

So the ratelimited warning is so we can know if this has happened,
since it's probably a sign that something bad has happened.  Either a
process ran wild trying to precache too many extents, or the system
was under far more memory pressure, which is probably something that
needs to be fixed by changing some configuration parameter or by
tweaking the load balancer.

						- Ted
