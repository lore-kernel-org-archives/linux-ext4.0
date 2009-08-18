From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4] jbd2: Annotate transaction start also for
	jbd2_journal_restart()
Date: Mon, 17 Aug 2009 22:16:27 -0400
Message-ID: <20090818021627.GE498@mit.edu>
References: <1250252772-13302-1-git-send-email-jack@suse.cz> <1250252772-13302-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43587 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZHRCQc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 22:16:32 -0400
Content-Disposition: inline
In-Reply-To: <1250252772-13302-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 14, 2009 at 02:26:11PM +0200, Jan Kara wrote:
> lockdep annotation for a transaction start has been at the end of
> jbd2_journal_start(). But a transaction is also started from
> jbd2_journal_restart(). Move the lockdep annotation to start_this_handle()
> which covers both cases.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Added to the ext4 patch queue, thanks!!!

				- Ted
