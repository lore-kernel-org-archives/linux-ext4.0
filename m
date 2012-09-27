From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: jbd2: Fix assertion failure in commit code due to lacking
 transaction credits
Date: Wed, 26 Sep 2012 23:13:06 -0400
Message-ID: <20120927031306.GA16520@thunk.org>
References: <1345494123-4500-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52630 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2I0DNK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 23:13:10 -0400
Content-Disposition: inline
In-Reply-To: <1345494123-4500-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 20, 2012 at 10:22:03AM -0000, Jan Kara wrote:
> ext4 users of data=journal mode with blocksize < pagesize were occasionally
> hitting assertion failure in jbd2_journal_commit_transaction() checking whether
> the transaction has at least as many credits reserved as buffers attached.  The
> core of the problem is that when a file gets truncated, buffers that still need
> checkpointing or that are attached to the committing transaction are left with
> buffer_mapped set. When this happens to buffers beyond i_size attached to a
> page stradding i_size, subsequent write extending the file will see these
> buffers and as they are mapped (but underlying blocks were freed) things go
> awry from here.
> 
> The assertion failure just coincidentally (and in this case luckily as we would
> start corrupting filesystem) triggers due to journal_head not being properly
> cleaned up as well.
> 
> We fix the problem by unmapping buffers if possible (in lots of cases we just
> need a buffer attached to a transaction as a place holder but it must not be
> written out anyway). And in one case, we just have to bite the bullet and wait
> for transaction commit to finish.
> 
> CC: Josef Bacik <jbacik@fusionio.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks!

						- Ted
