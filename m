From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 14:48:59 -0400
Message-ID: <20120619184858.GA8841@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
 <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
 <20120619131649.GA6811@redhat.com>
 <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
 <20120619133041.GB6811@redhat.com>
 <4FE0840F.2050704@shiftmail.org>
 <20120619144413.GA7225@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab2FSStL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 14:49:11 -0400
Content-Disposition: inline
In-Reply-To: <20120619144413.GA7225@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19 2012 at 10:44am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Jun 19 2012 at  9:52am -0400,
> Spelic <spelic@shiftmail.org> wrote:
>
> > I do not know what is the mechanism for which xfs cannot unmap
> > blocks from dm-thin, but it really can't.
> > If anyone has dm-thin installed he can try. This is 100%
> > reproducible for me.
> 
> I was initially surprised by this considering the thinp-test-suite does
> test a compilebench workload against xfs and ext4 using online discard
> (-o discard).
> 
> But I just modified that test to use a thin-pool with 'ignore_discard'
> and the test still passed on both ext4 and xfs.
> 
> So there is more work needed in the thinp-test-suite to use blktrace
> hooks to verify that discards are occuring when the compilebench
> generated files are removed.
> 
> I'll work through that and report back.

blktrace shows discards for both xfs and ext4.

But in general xfs is issuing discards with much smaller extents than
ext4 does, e.g.:

to the thin device:
+ 128 vs + 32

to the thin-pool's data device:
+ 120 vs + 16
