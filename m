From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/26] jbd2: Refine waiting for shadow buffers
Date: Tue, 4 Jun 2013 12:09:29 -0400
Message-ID: <20130604160929.GE25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54728 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab3FDQJb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:09:31 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:37AM +0200, Jan Kara wrote:
> Currently when we add a buffer to a transaction, we wait until the
> buffer is removed from BJ_Shadow list (so that we prevent any changes to
> the buffer that is just written to the journal). This can take
> unnecessarily long as a lot happens between the time the buffer is
> submitted to the journal and the time when we remove the buffer from
> BJ_Shadow list (e.g.  we wait for all data buffers in the transaction,
> we issue a cache flush etc.). Also this creates a dependency of
> do_get_write_access() on transaction commit (namely waiting for data IO
> to complete) which we want to avoid when implementing transaction
> reservation.
> 
> So we modify commit code to set new BH_Shadow flag when temporary
> shadowing buffer is created and we clear that flag once IO on that
> buffer is complete. This allows do_get_write_access() to wait only for
> BH_Shadow bit and thus removes the dependency on data IO completion.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
