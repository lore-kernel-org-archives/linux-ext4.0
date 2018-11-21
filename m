Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60458 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbeKUKjL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 05:39:11 -0500
Date: Tue, 20 Nov 2018 19:07:18 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Ext4: fix slow writeback under dioread_nolock and
 nodelalloc
Message-ID: <20181121000718.GC6401@thunk.org>
References: <1542694270-47732-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542694270-47732-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 20, 2018 at 02:11:10PM +0800, Liu Bo wrote:
> With "nodelalloc", blocks are allocated at the time of writing, and with
> "dioread_nolock", these allocated blocks are marked as unwritten as well,
> so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.

Hi Liu,

Could I ask a larger question, which is why is it that you find it
desirable to use both nodelalloc and dioread_nolock at the same time?
What's the use case which is causing you to want to do this?

One of the things which I have been thinking about doing to simplify
ext4's test matrix and so we can improve performance in a more direct
way --- and also so it would make it much easier for us to switch over
to using more of iomap --- was to consider deprecating and removing
some of ext4's flexibility.  This includes:

*) Making dioread_nolock the default for 4k --- and fixing
   dioread_nolock so it works for cases where page_size != block_size.
   Once that is done, we would use dioread_nolock everywhere and drop
   the older code path.

*) Drop support for data=journal mode (it could be specified, but it
   would be ignored).  It's not clear anyone is using it, since the
   double-write overhead is huge.  Furthermore, requiring the use of
   nodelalloc means is a further performance hit on data=journal mode.

*) Drop support for nodelalloc, and make delayed allocation the
   default.  (This requires dropping data=journal mode, since
   data=journal mode does not co-exist with delalloc.)

The last was assuming that there really wasn't good use cases where
people would really want to use nodelalloc, aside from ext3
bug-for-bug compatibility, and hopefully since most people are using
ext4 these days, it becomes easier to make the case tha we don't need
to support ext3's unusual performance attributes.

The fact that you have done work trying to improve dioread_nolock &&
nodelalloc implies that perhaps I'm wrong about my assumption.  So I'd
like to understand more about what it is that you're trying to do, and
to figure out of perhaps there's a better way to do it.  After all,
delalloc makes it a lot easier for the block allocator to do a good
job, and it also decreases the CPU overhead for the block allocator.
And while forcing writes to the disk every five seconds might be
advantageous for some application, it also can add significant latency
variability for file system operations during a commit.

What am I missing?

Cheers,

						- Ted
