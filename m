From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/26] ext4: Remove ext4_ioend_wait()
Date: Tue, 4 Jun 2013 14:47:54 -0400
Message-ID: <20130604184754.GQ3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-27-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54833 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab3FDSr4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:47:56 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-27-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:59AM +0200, Jan Kara wrote:
> Now that we clear PageWriteback after extent conversion, there's no need
> to wait for io_end processing in ext4_evict_inode(). Running AIO/DIO
> keeps file reference until aio_complete() is called so ext4_evict_inode()
> cannot be called. For io_end structures resulting from buffered IO
> waiting is happening because we wait for PageWriteback in
> truncate_inode_pages().
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
