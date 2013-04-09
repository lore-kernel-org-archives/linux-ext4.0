From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Move quota initialization out of inode
 allocation transaction
Date: Tue, 9 Apr 2013 12:42:37 -0400
Message-ID: <20130409164237.GC5980@thunk.org>
References: <1365496448-9907-1-git-send-email-jack@suse.cz>
 <1365496448-9907-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60681 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936277Ab3DIQmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 12:42:43 -0400
Content-Disposition: inline
In-Reply-To: <1365496448-9907-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 10:34:08AM +0200, Jan Kara wrote:
> Inode allocation transaction is pretty heavy (246 credits with quotas
> and extents before previous patch, still around 200 after it).  This is
> mostly due to credits required for allocation of quota structures
> (credits there are heavily overestimated but it's difficult to make
> better estimates if we don't want to wire non-trivial assumptions about
> quota format into filesystem).
> 
> So move quota initialization out of allocation transaction. That way
> transaction for quota structure allocation will be started only if we
> need to look up quota structure on disk (rare) and furthermore it will
> be started for each quota type separately, not for all of them at once.
> This reduces maximum transaction size to 34 is most cases and to 73 in
> the worst case.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, added to the dev branch for testing.

	      	     	 	    - Ted
