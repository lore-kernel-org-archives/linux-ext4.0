From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: hole-punch use truncate_pagecache_range
Date: Fri, 1 Jun 2012 00:17:42 -0400
Message-ID: <20120601041742.GG7897@thunk.org>
References: <alpine.LSU.2.00.1205131342420.1547@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46898 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2FAERq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 00:17:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205131342420.1547@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 13, 2012 at 01:47:00PM -0700, Hugh Dickins wrote:
> When truncating a file, we unmap pages from userspace first, as that's
> usually more efficient than relying, page by page, on the fallback in
> truncate_inode_page() - particularly if the file is mapped many times.
> 
> Do the same when punching a hole: 3.4 added truncate_pagecache_range()
> to do the unmap and trunc, so use it in ext4_ext_punch_hole(), instead
> of calling truncate_inode_pages_range() directly.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Applied, thanks.

					- Ted
