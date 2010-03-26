From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 01:47:38 +0100
Message-ID: <20100326004738.GJ3145@quack.suse.cz>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0CZArZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Mar 2010 20:47:25 -0400
Content-Disposition: inline
In-Reply-To: <E1NuxHe-0005cj-JN@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

On Thu 25-03-10 20:20:18, Theodore Ts'o wrote:
> This is something I whipped up last night to speed up quotacheck by
> doing the data collection in e2fsck.  If e2fsck runs and does a full
> check, it's likely that quotacheck needs to be run as well --- and it's
> faster if e2fsck does the dirty work of fetching the information since
> (1) it needs to paw through all of the inodes anyway, and (2) quotacheck
> has to go through the file system and iterate over the files in an
> non-optimal order.
> 
> What do folks think?  Obviously changes in quotacheck would be required
> before it could take advantage of these output files, but hopefully that
> shouldn't be hard...
> 
> To use, either use:
> 
>    e2fsck -E usrquota_check=/tmp/quota.user,grpquota_check=/tmp/quota.group
> 
> or you can edit /etc/e2fsck.conf and add:
> 
> [quota]
> 	directory = /var/e2fsck/quota
> 
> I still need to write documentation, update the man pages, and do some
> polishing, so this is still in a pretty rough state, but I'd appreciate
> comments.
  This is definitely a move in the right direction. I'd be even happier
if e2fsck would write quota file directly - then we could just make
quota files hidden inodes, start doing quota accounting immediately
on mount and always do quota journaling. That would save us quite some
trouble in kernel. The only problem with this is that we'd need to pull
knowledge about quota formats in e2fsck...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
