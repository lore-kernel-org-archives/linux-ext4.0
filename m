From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 5/6] ext4: use a list to track all reclaimable objects
 for extent status tree
Date: Tue, 2 Sep 2014 23:44:04 -0400
Message-ID: <20140903034404.GC2504@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-6-git-send-email-wenqing.lz@taobao.com>
 <20140827151354.GD22211@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34038 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbaICDoP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 23:44:15 -0400
Content-Disposition: inline
In-Reply-To: <20140827151354.GD22211@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2014 at 05:13:54PM +0200, Jan Kara wrote:
> 
> What we could do to limit latency caused by scanning of unreclaimable
> extents is to change the shrinker to really stop after inspecting
> nr_to_scan extents regardless of how many extents did we really reclaim -
> this is actually how slab shrinkers are designed to work.  We would also
> have to record the logical block where the shrinker stopped scanning the
> inode and the next shrinker invocation will start scanning at that offset -
> it is enough to store this offset in the superblock, we just have to zero
> it out when we remove the first inode from the list of inodes with cached
> extents.
> 
> What do people think about this?

Yes, I agree this would be a better approach.

					- Ted
