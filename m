From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/26] ext4: Better estimate credits needed for
 ext4_da_writepages()
Date: Tue, 4 Jun 2013 13:01:34 -0400
Message-ID: <20130604170134.GE3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-15-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54770 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab3FDRBh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 13:01:37 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-15-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:47AM +0200, Jan Kara wrote:
> We limit the number of blocks written in a single loop of
> ext4_da_writepages() to 64 when inode uses indirect blocks. That is
> unnecessary as credit estimates for mapping logically continguous run of
> blocks is rather low even for inode with indirect blocks. So just lift
> this limitation and properly calculate the number of necessary credits.
> 
> This better credit estimate will also later allow us to always write at
> least a single page in one iteration.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
