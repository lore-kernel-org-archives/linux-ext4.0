From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Avoid unnecessary stalls in ext4_evict_inode()
Date: Thu, 22 Jun 2017 23:50:25 -0400
Message-ID: <20170623035025.wqbu3ciyuo2242ug@thunk.org>
References: <20170612152013.4045-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34626 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754228AbdFWDu2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Jun 2017 23:50:28 -0400
Content-Disposition: inline
In-Reply-To: <20170612152013.4045-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 12, 2017 at 05:20:13PM +0200, Jan Kara wrote:
> These days inode reclaim calls evict_inode() only when it has no pages
> in the mapping. In that case it is not necessary to wait for transaction
> commit in ext4_evict_inode() as there can be no pages waiting to be
> committed. So avoid unnecessary transaction waiting in that case.
> 
> We still have to keep the check for the case where ext4_evict_inode()
> gets called from other paths (e.g. umount) where inode still can have
> some page cache pages.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
