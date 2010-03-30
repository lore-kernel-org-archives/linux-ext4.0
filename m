From: Jan Kara <jack@suse.cz>
Subject: Re: Should journaled quota be default for ext4?
Date: Tue, 30 Mar 2010 03:17:50 +0200
Message-ID: <20100330011750.GC18791@atrey.karlin.mff.cuni.cz>
References: <4BAC3860.7010905@redhat.com> <20100326142626.GI21658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36761 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753288Ab0C3BRv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 21:17:51 -0400
Content-Disposition: inline
In-Reply-To: <20100326142626.GI21658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Mar 25, 2010 at 11:30:24PM -0500, Eric Sandeen wrote:
> > Ted's email about quotacheck made me think:
> > 
> > Is there a reason that journaled quota is not default for ext4?
> > (or ext3 for that matter, but we're not messing with that now)
> > 
> > IOW - if we do mount -o quota, is there any reason that we should
> > also need more options to journal that quota?  When would we not
> > want journaled quota?
> > 
> > (Forgive me if it's a dumb question, I'm not as well versed in
> > extN quota as I probably should be).
> 
> Part of the problem is that these mount options matter to various init
> scripts (and possibly to quotatools?).  So for example, the usrquota
  Yes, quota-tools currently use these options as well to detect whether they
should run the command on the filesystem or not. The problem is that at least
"quotaon -a" needs to know on which filesystem it should run and currently it
uses quota mount options to decide. I can change quota tools to just look for
quota files but that's not guaranteed to succeed because for unjournaled
quotas, quota files could be anywhere - even on a different filesystem - and I
really know admins who use such setup. And for journaled quotas, file name
of the quota file is the one given in the {usr,grp}jquota mount option
so without it it's impossible to locate the quota file as well.
  So I think the easiest way out of this is really to make quota files hidden
as we discussed in another thread. Then kernel always knows whether the
filesystem accounts quotas or not and quota tools can ask it with GETFMT
quotactl.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
