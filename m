From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] jbd2: Limit number of reserved credits
Date: Tue, 4 Aug 2015 11:45:35 -0400
Message-ID: <20150804154535.GA5219@thunk.org>
References: <1438355494-10566-1-git-send-email-lczerner@redhat.com>
 <20150803105434.GA9657@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40359 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbbHDPpk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2015 11:45:40 -0400
Content-Disposition: inline
In-Reply-To: <20150803105434.GA9657@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 03, 2015 at 12:54:34PM +0200, Jan Kara wrote:
> On Fri 31-07-15 17:11:34, Lukas Czerner wrote:
> > Currently there is no limitation on number of reserved credits we can
> > ask for. If we ask for more reserved credits than 1/2 of maximum
> > transaction size, or if total number of credits exceeds the maximum
> > transaction size per operation (which is currently only possible with
> > the former) we will spin forever in start_this_handle().
> > 
> > Fix this by adding this limitation at the start of start_this_handle().
> > 
> > This patch also removes the credit limitation 1/2 of maximum transaction
> > size, since we really only want to limit the number of reserved credits.
> > There is not much point to limit the credits if there is still space in
> > the journal.
> > 
> > This accidentally also fixes the online resize, where due to the
> > limitation of the journal credits we're unable to grow file systems with
> > 1k block size and size between 16M and 32M. It has been partially fixed
> > by 2c869b262a10ca99cb866d04087d75311587a30c, but not entirely.
> > 
> > Thanks Jan Kara for helping me getting the correct fix.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > v2: added wait event Jan suggested
> 
> The patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
