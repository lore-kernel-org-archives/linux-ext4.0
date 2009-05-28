From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Date: Thu, 28 May 2009 11:36:01 +0200
Message-ID: <20090528093601.GF29199@duck.suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <20090527153358.GA19989@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	npiggin@suse.de, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZE1JgH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 05:36:07 -0400
Content-Disposition: inline
In-Reply-To: <20090527153358.GA19989@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Wed 27-05-09 21:03:58, Aneesh Kumar K.V wrote:
> On Wed, May 27, 2009 at 03:00:57PM +0200, Jan Kara wrote:
> > 
> > patches below are an attempt to solve problems filesystems have with
> > page_mkwrite() when blocksize < pagesize (see the changelog of the third patch
> > for details).
> > 
> > The series is against 2.6.30-rc7. The first two patches are just small cleanup
> > and should be merged separately (Ted should have the ext4 cleanup rebased on
> > top of current ext4 tree). For ext3 the fix is done in two phases, in the first
> > we make it to correctly allocate space at page-fault time from page_mkwrite().
> > This has the disadvantage that under random mmaped writes, the file gets much
> > more fragmented and performance of e.g. Berkeley DB drops by ~20%. Therefore
> > in the second phase I've implemented delayed allocation for ext3 and blocks
> > are just reserved during page_mkwrite time and really allocated only during
> > writepage. This gets the performance back to original numbers for me.
> > 
> > The patches should be fairly complete and sustained quite some testing. OTOH
> > the area is kind of complex so please review them so that they can get merged.
> > Thanks.
> 
> Can you move patch 7 and patch 11 as the last two patches. That would
> make sure we can push rest of the patches earlier. Rest of the patches
> are needed for ext4 to fix some of the bugs we are seeing. For eg:
> http://bugzilla.kernel.org/show_bug.cgi?id=12624
> http://bugzilla.kernel.org/show_bug.cgi?id=13369
  OK, I think I can just move patches 3 and 5 to the beginning. That's all
that should be needed for ext4.

> I have few writepage patches also on top of your last series. Having
> patch 7 and patch 11 as last two patches make sure we can get the rest
> of the patches in ext4 patchqueue and get wider testing.
  Good point. I think Ted did the right thing and took just patches 3 and 5
to ext4 patch queue but I can reorder the patches for next time...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
