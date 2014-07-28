From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: fix incorrect locking in move_extent_per_page
Date: Sun, 27 Jul 2014 22:33:18 -0400
Message-ID: <20140728023318.GK6725@thunk.org>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
 <1405955089-12777-3-git-send-email-dmonakhov@openvz.org>
 <20140721195102.GC19942@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59757 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaG1CdV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 22:33:21 -0400
Content-Disposition: inline
In-Reply-To: <20140721195102.GC19942@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2014 at 09:51:02PM +0200, Jan Kara wrote:
> On Mon 21-07-14 19:04:49, Dmitry Monakhov wrote:
> > If we have to copy data we must drop i_data_sem because of
> > get_blocks() will be called inside mext_page_mkuptodate(), but later we must
> > reacquire it again because we are about to change extent's tree
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
