From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/26] ext4: Defer clearing of PageWriteback after extent
 conversion
Date: Tue, 4 Jun 2013 14:24:37 -0400
Message-ID: <20130604182437.GJ3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-20-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54803 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3FDSYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:24:39 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-20-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:52AM +0200, Jan Kara wrote:
> Currently PageWriteback bit gets cleared from put_io_page() called from
> ext4_end_bio(). This is somewhat inconvenient as extent tree is not
> fully updated at that time (unwritten extents are not marked as written)
> so we cannot read the data back yet. This design was dictated by lock
> ordering as we cannot start a transaction while PageWriteback bit is set
> (we could easily deadlock with ext4_da_writepages()). But now that we
> use transaction reservation for extent conversion, locking issues are
> solved and we can move PageWriteback bit clearing after extent
> conversion is done. As a result we can remove wait for unwritt en extent
> conversion from ext4_sync_file() because it already implicitely happe ns
> through wait_on_page_writeback().
> 
> We implement deferring of PageWriteback clearing by queueing completed
> bios to appropriate io_end and processing all the pages when io_end is
> going to be freed instead of at the moment ext4_io_end() is called.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
