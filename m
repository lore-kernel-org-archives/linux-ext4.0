From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH FOR DISCUSSION] add delalloc debugging
Date: Wed, 26 Jun 2013 10:41:42 -0400
Message-ID: <20130626144142.GA32092@thunk.org>
References: <20130620164249.GC4982@thunk.org>
 <20130626131823.GA20140@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33097 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3FZOlr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 10:41:47 -0400
Content-Disposition: inline
In-Reply-To: <20130626131823.GA20140@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 26, 2013 at 11:18:23PM +1000, Dave Chinner wrote:
> Do not use VFS level locks and list walks in filesystem code,
> not even in debugging code. It's ok for you to do this in private
> patches and maintain such abuses yourself, but it's not acceptible
> for merging into the mainline tree...

Well, that's why I wasn't proposing that the code be enabled by
default, and why I described it as "a little gross".

> Besides, you haven't even used the correct lock - these bdi
> writeback lists are protected by the bdi writeback list lock, not
> the superblock inode list lock....

Thanks for pointing that out.  I'll fix that.

Cheers,

						- Ted
