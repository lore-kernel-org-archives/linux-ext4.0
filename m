From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: delayed allocation i_blocks fix for stat(2)
Date: Tue, 8 Jul 2008 22:02:35 +0200
Message-ID: <20080708200235.GC22477@atrey.karlin.mff.cuni.cz>
References: <1215473799.6702.9.camel@mingming-laptop> <4872BEAC.7010007@redhat.com> <48735A66.2040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Peter Staubach <staubach@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52787 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbYGHUCg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 16:02:36 -0400
Content-Disposition: inline
In-Reply-To: <48735A66.2040006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Eric Sandeen wrote:
> >Mingming Cao wrote:
> >  
> >>ext4: delayed allocation i_blocks fix for stat(2)
> >>
> >>From: Mingming Cao <cmm@us.ibm.com>
> >>
> >>Right now i_blocks is not getting updated until the disks are actually
> >>allocaed on disk.  This means with delayed allocation, right after files
> >>are copied, "ls -sF" shoes the file as taking 0 blocks on disk.  "du"
> >>also shows the files taking zero space, which is highly confusing to the 
> >>user.
> >>
> >>Since current delayed allocation already keep track of per-inode total 
> >>number
> >>of blocks that are subject to delayed allocation, this patch fix this by 
> >>using
> >>that to adjust the value returned by stat(2). When real block allocation
> >>is done, the i_blocks will get updated. Since the reserved blocks for 
> >>delayed
> >>allocation will be decreased, this will be keep value returned by stat(2)
> >>consistent.
> >>
> >>Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> >>    
> >
> >Thanks Mingming, looks like just the right approach.
> >
> >Something about the spinlock for every stat seems heavy-handed to me but
> >I'll have to give that more thought.  :)
> >
> >  
> 
> Since i_reserved_blocks is an unsigned long, it should be possible
> to atomically fetch it on all of the supported architectures,
> without the use of the spinlock.  It seems to me that this spinlock
> is not required here.
  Well, it's certainly not nice to rely on this. The clean solution
would be to convert i_reserved_blocks to atomic_t or atomic64_t on archs
that have it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
