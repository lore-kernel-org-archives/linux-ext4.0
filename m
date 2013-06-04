From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/26] ext4: Remove buffer_uninit handling
Date: Tue, 4 Jun 2013 13:20:06 -0400
Message-ID: <20130604172006.GG3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-17-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54782 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3FDRUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 13:20:09 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-17-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:49AM +0200, Jan Kara wrote:
> There isn't any need for setting BH_Uninit on buffers anymore. It was
> only used to signal we need to mark io_end as needing extent conversion
> in add_bh_to_extent() but now we can mark the io_end directly when
> mapping extent.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
