From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/26] ext4: Remove wait for unwritten extent conversion
 from ext4_truncate()
Date: Tue, 4 Jun 2013 14:30:59 -0400
Message-ID: <20130604183059.GL3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-22-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54810 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3FDSbC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:31:02 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-22-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:54AM +0200, Jan Kara wrote:
> Since PageWriteback bit is now cleared after extents are converted from
> unwritten to written ones, we have full exclusion of writeback path from
> truncate (truncate_inode_pages() waits for PageWriteback bits to get cleared
> on all invalidated pages). Exclusion from DIO path is achieved by
> inode_dio_wait() call in ext4_setattr(). So there's no need to wait for
> extent convertion in ext4_truncate() anymore.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

							- Ted
