From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/26] ext4: Restructure writeback path
Date: Tue, 4 Jun 2013 13:18:24 -0400
Message-ID: <20130604171824.GF3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-16-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54779 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3FDRS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 13:18:29 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-16-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:48AM +0200, Jan Kara wrote:
> There are two issues with current writeback path in ext4. For one we
> don't necessarily map complete pages when blocksize < pagesize and thus
> needn't do any writeback in one iteration. We always map some blocks
> though so we will eventually finish mapping the page. Just if writeback
> races with other operations on the file, forward progress is not really
> guaranteed. The second problem is that current code structure makes it
> hard to associate all the bios to some range of pages with one io_end
> structure so that unwritten extents can be converted after all the bios
> are finished. This will be especially difficult later when io_end will
> be associated with reserved transaction handle.
> 
> We restructure the writeback path to a relatively simple loop which
> first prepares extent of pages, then maps one or more extents so that
> no page is partially mapped, and once page is fully mapped it is
> submitted for IO. We keep all the mapping and IO submission information
> in mpage_da_data structure to somewhat reduce stack usage. Resulting
> code is somewhat shorter than the old one and hopefully also easier to
> read.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
