From: tytso@mit.edu
Subject: Re: [PATCH] ext4: check for a good block group before loading
 buddy pages
Date: Thu, 20 May 2010 23:10:23 -0400
Message-ID: <20100521031023.GC11651@thunk.org>
References: <AANLkTikhy3LJl9vRhonzIP90tYmOsm98-B8VXPFAhPt5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58284 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0EUDKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 23:10:30 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikhy3LJl9vRhonzIP90tYmOsm98-B8VXPFAhPt5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 07, 2010 at 09:00:16AM -0700, Curt Wohlgemuth wrote:
> This adds a new field in ext4_group_info to cache the largest available
> block range in a block group; and don't load the buddy pages until *after*
> we've done a sanity check on the block group.
> 
> With large allocation requests (e.g., fallocate(), 8MiB) and relatively full
> partitions, it's easy to have no block groups with a block extent large
> enough to satisfy the input request length.  This currently causes the loop
> during cr == 0 in ext4_mb_regular_allocator() to load the buddy bitmap pages
> for EVERY block group.  That can be a lot of pages.  The patch below allows
> us to call ext4_mb_good_group() BEFORE we load the buddy pages.
> 
>Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Added to the ext4 patch queue.

					- Ted
