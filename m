From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: fix data integrity for ext4_sync_fs
Date: Wed, 12 Jun 2013 22:32:38 -0400
Message-ID: <20130613023238.GA16959@thunk.org>
References: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
 <1370882461-12786-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57456 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab3FMCco (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 22:32:44 -0400
Content-Disposition: inline
In-Reply-To: <1370882461-12786-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 08:41:00PM +0400, Dmitry Monakhov wrote:
> Inode's data or non journaled quota may be written w/o jounral so we _must_
> send a barrier at the end of ext4_sync_fs. But it can be skipped if journal
> commit will do it for us.
> 
> Also fix data integrity for nojournal mode.
> changes from v2:
>  fix jbd2_get_latest_transaction() return correct transaction
> changes from v1:
>  skip barrier for async mode
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

						- Ted
