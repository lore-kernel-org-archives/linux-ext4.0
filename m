From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Warn when page is dirtied without buffers
Date: Thu, 1 Dec 2016 11:47:24 -0500
Message-ID: <20161201164724.d7wyytkdbv5tbrdw@thunk.org>
References: <1479909702-21547-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50498 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758145AbcLAQr2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 11:47:28 -0500
Content-Disposition: inline
In-Reply-To: <1479909702-21547-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2016 at 03:01:42PM +0100, Jan Kara wrote:
> Warn when a page is dirtied without buffers (as that will likely lead to
> a crash in ext4_writepages()) or when it gets newly dirtied without the
> page being locked (as there is nothing that prevents buffers to get
> stripped just before calling set_page_dirty() under memory pressure).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
