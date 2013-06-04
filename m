From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/26] ext4: Remove i_mutex from ext4_file_sync()
Date: Tue, 4 Jun 2013 14:40:52 -0400
Message-ID: <20130604184052.GN3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-24-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54822 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FDSky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:40:54 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-24-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:56AM +0200, Jan Kara wrote:
> After removal of ext4_flush_unwritten_io() call, ext4_file_sync()
> doesn't need i_mutex anymore. Forcing of transaction commits doesn't
> need i_mutex as there's nothing inode specific in that code apart from
> grabbing transaction ids from the inode. So remove the lock.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

				- Ted
