From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 12:00:52 +0100
Message-ID: <20100326110051.GD3055@quack.suse.cz>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <87ljdf7bc8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0CZLAj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 07:00:39 -0400
Content-Disposition: inline
In-Reply-To: <87ljdf7bc8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 26-03-10 11:09:59, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Thu 25-03-10 20:20:18, Theodore Ts'o wrote:
> >> This is something I whipped up last night to speed up quotacheck by
> >> doing the data collection in e2fsck.  If e2fsck runs and does a full
> >> check, it's likely that quotacheck needs to be run as well --- and it's
> >> faster if e2fsck does the dirty work of fetching the information since
> >> (1) it needs to paw through all of the inodes anyway, and (2) quotacheck
> >> has to go through the file system and iterate over the files in an
> >> non-optimal order.
> >> 
> >> What do folks think?  Obviously changes in quotacheck would be required
> >> before it could take advantage of these output files, but hopefully that
> >> shouldn't be hard...
> >> 
> >> To use, either use:
> >> 
> >>    e2fsck -E usrquota_check=/tmp/quota.user,grpquota_check=/tmp/quota.group
> >> 
> >> or you can edit /etc/e2fsck.conf and add:
> >> 
> >> [quota]
> >> 	directory = /var/e2fsck/quota
> >> 
> >> I still need to write documentation, update the man pages, and do some
> >> polishing, so this is still in a pretty rough state, but I'd appreciate
> >> comments.
> This is definitely right idea.
> >   This is definitely a move in the right direction. I'd be even happier
> > if e2fsck would write quota file directly - then we could just make
> > quota files hidden inodes, start doing quota accounting immediately
> Please excuse my naive question, but is it easy enough to allocate
> space during fsck?  If we allow to do this then each fsck will result
> in sb-changes because of new tmp quota-file creation/rename/deletion
> even if sb and quota is ok.
  Well, how e.g. OCFS2 does this is that if we do full fsck run, we first
load all information from quota file, then do the checking and count usage
and at the end, we write new quota file only if the usage for some user
/ group differs from the one loaded from disk (i.e. fsck changed something).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
