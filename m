From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] [PATCH] ext4: truncate the file properly if we
	fail to copy data from userspace.
Date: Mon, 6 Apr 2009 12:07:14 +0200
Message-ID: <20090406100714.GC31189@duck.suse.cz>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1238491766-13182-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090405032211.GH7553@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZDFKHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 06:07:17 -0400
Content-Disposition: inline
In-Reply-To: <20090405032211.GH7553@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 04-04-09 23:22:11, Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 02:59:26PM +0530, Aneesh Kumar K.V wrote:
> > In generic_perform_write if we fail to copy the user data we don't
> > update the inode->i_size. We should truncate the file in the above case
> > so that we don't have blocks allocated outside inode->i_size. Add
> > the inode to orphan list in the same transaction as block allocation
> > This ensures that if we crash in between the recovery would do the truncate.
> 
> Same problem as my comment in for the last patch; it seems rather
> dangerous to try to call ext4_orphan_add() outside of ext4_truncate().
> Can we instead call vmtruncate() inside the same transaction handle?
> i.e., figure out how many journal credits will be needed for the
> potential truncate, and add it to number of credits to reserve for the
> begin_write and/or write_end handle, and then call vmtruncate before
> calling ext4_journal_stop().  Can anyone see a problem with this
> approach?
  Just adding inode to orphan list seems more elegant to me and as I wrote
in my previous email, we already do it from a common path so if there are
bugs, we should fix them anyway ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
