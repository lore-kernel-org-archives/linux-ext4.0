From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] mbcache: document that "find" functions only return
 reusable entries
Date: Sat, 3 Dec 2016 15:56:05 -0500
Message-ID: <20161203205605.3ar5m5ax2kyoitwm@thunk.org>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-5-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33666 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750888AbcLCU4Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 3 Dec 2016 15:56:25 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-5-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:18:01PM -0800, Eric Biggers wrote:
> mb_cache_entry_find_first() and mb_cache_entry_find_next() only return
> cache entries with the 'e_reusable' bit set.  This should be documented.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
