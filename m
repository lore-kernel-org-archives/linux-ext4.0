From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] mbcache: correctly handle 'e_referenced' bit
Date: Sat, 3 Dec 2016 15:28:38 -0500
Message-ID: <20161203202838.ahd32zz3q7a5k4nr@thunk.org>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33324 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750754AbcLCU2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 3 Dec 2016 15:28:46 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:17:57PM -0800, Eric Biggers wrote:
> mbcache entries have an 'e_referenced' bit which users can set with
> mb_cache_entry_touch() to indicate that an entry should be given another
> pass through the LRU list before the shrinker can delete it.  However,
> mb_cache_shrink() actually would, when seeing an e_referenced entry at
> the front of the list (the least-recently used end), place it right at
> the front of the list again.  The next iteration would then remove the
> entry from the list and delete it.  Consequently, e_referenced had
> essentially no effect, so ext2/ext4 xattr blocks would sometimes not be
> reused as often as expected.
> 
> Fix this by making the shrinker move e_referenced entries to the back of
> the list rather than the front.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
