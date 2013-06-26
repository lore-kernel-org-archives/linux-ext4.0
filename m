From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH FOR DISCUSSION] add delalloc debugging
Date: Wed, 26 Jun 2013 23:18:23 +1000
Message-ID: <20130626131823.GA20140@dastard>
References: <20130620164249.GC4982@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:33406 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab3FZNS3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 09:18:29 -0400
Content-Disposition: inline
In-Reply-To: <20130620164249.GC4982@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 12:42:49PM -0400, Theodore Ts'o wrote:
> I've been carrying a patch in the unstable portion of the patch series
> for a while now to debug problems with delayed allocation.  This
> allows us to observe the state of which inodes have inodes subject for
> delayed allocation, and how many data/metadata blocks have been
> reserved.
> 
> I've finally cleaned it up enough that it's something where I wouldn't
> feel terrible dropping it into the mainline kernel.  (It's still a
> little gross, but it's not truly horrifying any more.)  
> 
> What do people think?  Is this something that's worth having in the
> kernel sources?  Or shall I continue carrying it as an out-of-tree
> debugging patch?
> 
> (Note: we can use similar technique to gain visibility into the status
> the extent status LRU list.)
> 
>       	          	       	      	  - Ted
> 
> From f6417debc1c96a9dfa6b9f19da14eff35bf0f504 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Thu, 20 Jun 2013 12:35:39 -0400
> Subject: [PATCH] ext4: add delalloc debugging
> 
> This adds a file in /proc/fs/ext4/<dev> which when opened for reading,
> will trigger debugging code that dumps a lot of information about
> inodes subject to delayed allocation to the console.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
.....

> +
> +#ifndef MODULE
> +	spin_lock(&inode_sb_list_lock);
> +	if (!list_empty(&sb->s_bdi->wb.b_dirty)) {

NACK. Do not use VFS level locks and list walks in filesystem code,
not even in debugging code. It's ok for you to do this in private
patches and maintain such abuses yourself, but it's not acceptible
for merging into the mainline tree...

Besides, you haven't even used the correct lock - these bdi
writeback lists are protected by the bdi writeback list lock, not
the superblock inode list lock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
