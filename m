From: tytso@mit.edu
Subject: Re: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of
 external journal
Date: Sun, 21 Mar 2010 21:20:00 -0400
Message-ID: <20100322012000.GD11560@thunk.org>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51209 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0CVCMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Mar 2010 22:12:17 -0400
Content-Disposition: inline
In-Reply-To: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 12, 2010 at 08:26:49PM +0300, Dmitry Monakhov wrote:
>  start_journal_io:
> +			if (bufs)
> +				commit_transaction->t_flushed_data_blocks = 1;
> +

I'm not convinced this is right.

>From your test case, the problem isn't because we have journaled
metadata blocks (which is what bufs) counts, but because fsync()
depends on data blocks also getting flushed out to disks.

However, if we aren't closing the transaction because of fsync(), I
don't think we need to do a barrier in the case of an external
journal.  So instead of effectively unconditionally setting
t_flushed_data_blocks (since bufs is nearly always going to be
non-zero), I think the better fix is to test to see if the journal
device != to the fs data device in fsync(), and if so, start the
barrier operation there.

Do you agree?

Best regards,

						- Ted
