From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Wed, 20 Jun 2012 06:06:31 +1000
Message-ID: <20120619200631.GL25389@dastard>
References: <4FDF9EBE.2030809@shiftmail.org>
 <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
 <20120619131649.GA6811@redhat.com>
 <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
 <20120619133041.GB6811@redhat.com>
 <4FE0840F.2050704@shiftmail.org>
 <20120619144413.GA7225@redhat.com>
 <20120619184858.GA8841@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Spelic <spelic@shiftmail.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11718 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab2FSUGg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 16:06:36 -0400
Content-Disposition: inline
In-Reply-To: <20120619184858.GA8841@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19, 2012 at 02:48:59PM -0400, Mike Snitzer wrote:
> On Tue, Jun 19 2012 at 10:44am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Tue, Jun 19 2012 at  9:52am -0400,
> > Spelic <spelic@shiftmail.org> wrote:
> >
> > > I do not know what is the mechanism for which xfs cannot unmap
> > > blocks from dm-thin, but it really can't.
> > > If anyone has dm-thin installed he can try. This is 100%
> > > reproducible for me.
> > 
> > I was initially surprised by this considering the thinp-test-suite does
> > test a compilebench workload against xfs and ext4 using online discard
> > (-o discard).
> > 
> > But I just modified that test to use a thin-pool with 'ignore_discard'
> > and the test still passed on both ext4 and xfs.
> > 
> > So there is more work needed in the thinp-test-suite to use blktrace
> > hooks to verify that discards are occuring when the compilebench
> > generated files are removed.
> > 
> > I'll work through that and report back.
> 
> blktrace shows discards for both xfs and ext4.
> 
> But in general xfs is issuing discards with much smaller extents than
> ext4 does, e.g.:

THat's normal when you use -o discard - XFS sends extremely
fine-grained discards as the have to be issued during the checkpoint
commit that frees the extent. Hence they can't be aggregated like is
done in ext4.

As it is, no-one really should be using -o discard - it is extremely
inefficient compared to a background fstrim run given that discards
are unqueued, blocking IOs. It's just a bad idea until the lower
layers get fixed to allow asynchronous, vectored discards and SATA
supports queued discards...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
