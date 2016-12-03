From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] mbcache: use consistent type for entry count
Date: Sat, 3 Dec 2016 15:54:09 -0500
Message-ID: <20161203205409.uexiy5fz7dhhgaof@thunk.org>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-4-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33620 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbcLCUyP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 3 Dec 2016 15:54:15 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-4-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:18:00PM -0800, Eric Biggers wrote:
> mbcache used several different types to represent the number of entries
> in the cache.  For consistency within mbcache and with the shrinker API,
> always use unsigned long.
> 
> This does not change behavior for current mbcache users (ext2 and ext4)
> since they limit the entry count to a value which easily fits in an int.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
