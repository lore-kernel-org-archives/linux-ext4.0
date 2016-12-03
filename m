From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] mbcache: don't BUG() if entry cache cannot be
 allocated
Date: Sat, 3 Dec 2016 15:30:03 -0500
Message-ID: <20161203203003.ahnus3cx4uyf5p7o@thunk.org>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33382 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbcLCUaG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 3 Dec 2016 15:30:06 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-2-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:17:58PM -0800, Eric Biggers wrote:
> mbcache can be a module that is loaded long after startup, when someone
> asks to mount an ext2 or ext4 filesystem.  Therefore it should not BUG()
> if kmem_cache_create() fails, but rather just fail the module load.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
