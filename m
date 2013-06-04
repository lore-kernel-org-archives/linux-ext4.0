From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/26] ext4: Protect extent conversion after DIO with
 i_dio_count
Date: Tue, 4 Jun 2013 14:28:13 -0400
Message-ID: <20130604182813.GK3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-21-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54806 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3FDS2Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:28:16 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-21-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:53AM +0200, Jan Kara wrote:
> Make sure extent conversion after DIO happens while i_dio_count is still
> elevated so that inode_dio_wait() waits until extent conversion is done.
> This removes the need for explicit waiting for extent conversion in some
> cases.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
