From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: jbd2_cleanup_journal_tail fix gfp allocation
 context
Date: Mon, 15 Jun 2015 00:19:03 -0400
Message-ID: <20150615041903.GF15793@thunk.org>
References: <1433954007-32588-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35189 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbbFOETH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 00:19:07 -0400
Content-Disposition: inline
In-Reply-To: <1433954007-32588-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2015 at 08:33:27PM +0400, Dmitry Monakhov wrote:
> jbd2_cleanup_journal_tail() can be invoked by jbd2__journal_start()
> So allocations should be done with GFP_NOFS
>
> [Full stack trace snipped from 3.10-rh7]
> ....
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.

						- Ted
