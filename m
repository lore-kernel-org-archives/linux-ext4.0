From: Jan Kara <jack@suse.cz>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Mon, 27 Jun 2011 22:27:51 +0200
Message-ID: <20110627202751.GJ5597@quack.suse.cz>
References: <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
 <20110627140251.GI5597@quack.suse.cz>
 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
 <20110627160140.GC2729@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
	"Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
	Sean Ryle <seanbo@gmail.com>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab1F0U15 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 16:27:57 -0400
Content-Disposition: inline
In-Reply-To: <20110627160140.GC2729@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 27-06-11 12:01:40, Ted Tso wrote:
> On Mon, Jun 27, 2011 at 05:30:11PM +0200, Lukas Czerner wrote:
> > > I've found some. So although data=journal users are minority, there are
> > > some. That being said I agree with you we should do something about it
> > > - either state that we want to fully support data=journal - and then we
> > > should really do better with testing it or deprecate it and remove it
> > > (which would save us some complications in the code).
> > > 
> > > I would be slightly in favor of removing it (code simplicity, less options
> > > to configure for admin, less options to test for us, some users I've come
> > > across actually were not quite sure why they are using it - they just
> > > thought it looks safer).
> 
> Hmm...  FYI, I hope to be able to bring on line automated testing for
> ext4 later this summer (there's a testing person at Google is has
> signed up to work on setting this up as his 20% project).  The test
> matrix that I have him included data=journal, so we will be getting
> better testing in the near future.
  Good! 

> At least historically, data=journalling was the *simpler* case, and
> was the first thing supported by ext4.  (data=ordered required revoke
> handling which didn't land for six months or so).  So I'm not really
> that convinced that removing really buys us that much code
> simplification.
  It does buy us some reduction in number of variants (e.g. write_begin,
write_end, writepage), we also wouldn't have to care about journalled data
during invalidatepage() or releasepage() calls. 
 
> That being siad, it is true that data=journalled isn't necessarily
> faster.  For heavy disk-bound workloads, it can be slower.  So I can
> imagine adding some documentation that warns people not to use
> data=journal unless they really know what they are doing, but at least
> personally, I'm a bit reluctant to dispense with a bug report like
> this by saying, "oh, that feature should be deprecated".
  No, I didn't want to dispense the bug report - we should definitely fix
the bug. I just remarked that data=journal is currently not well tested and
thus using it in production has its problems.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
