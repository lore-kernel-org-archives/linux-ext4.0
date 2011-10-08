From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove deprecated oldalloc
Date: Sat, 8 Oct 2011 14:09:05 -0400
Message-ID: <20111008180905.GG7948@thunk.org>
References: <1307453714-2741-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111658520.29009@dhcp-27-109.brq.redhat.com>
 <BF21E0BA-332B-4ADD-901C-5B0E8590898A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58473 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab1JHSJK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 14:09:10 -0400
Content-Disposition: inline
In-Reply-To: <BF21E0BA-332B-4ADD-901C-5B0E8590898A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 03:05:55PM -0600, Andreas Dilger wrote:
> 
> That said, "orlov" is also mostly meaningless with flex_bg as well, since
> there is very little real benefit/affinity from inodes being "close" to
> their data blocks.  We gain far more benefit from keeping the inodes
> together than spreading them out and keeping them close to the data blocks.

I'm going to be applying the patch remove the oldalloc allocator, but
just for the record --- Orlov *does* matter (which is why it's a good
thing the default allocator also uses an Orlov-like approach that's
flex_bg aware).

In fact, we saw significant latency drops that grew over time as more
and more blocks got allocated.  I traced it back to using bigalloc,
which increased the average distance between the inode tables and the
data blocks.

So as you use larger bigalloc cluster sizes, which increases the block
group size, it's a good idea to decrease the flex_bg size.  Which is
another way of saying that Orlov matters.

						- Ted
