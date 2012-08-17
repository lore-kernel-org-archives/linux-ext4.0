From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] jbd: Fix assertion failure in commit code due to lacking
 transaction credits
Date: Fri, 17 Aug 2012 08:48:14 -0400
Message-ID: <20120817124814.GC2133@localhost.localdomain>
References: <1345154672-22795-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Josef Bacik <JBacik@fusionio.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57781 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2HQMsR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 08:48:17 -0400
Content-Disposition: inline
In-Reply-To: <1345154672-22795-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 04:04:32PM -0600, Jan Kara wrote:
> ext3 users of data=journal mode with blocksize < pagesize were occasionally
> hitting assertion failure in journal_commit_transaction() checking whether the
> transaction has at least as many credits reserved as buffers attached.  The
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
> Under some rare circumstances this bug could even hit data=ordered mode users.
> There the assertion won't trigger and we would end up corrupting the
> filesystem.
> 
> We fix the problem by unmapping buffers if possible (in lots of cases we just
> need a buffer attached to a transaction as a place holder but it must not be
> written out anyway). And in one case, we just have to bite the bullet and wait
> for transaction commit to finish.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

You are my hero Jan

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
