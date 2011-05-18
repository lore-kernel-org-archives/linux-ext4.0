From: Jan Kara <jack@suse.cz>
Subject: Re: JBD commmit : Get list of all 'to be written' buffers in
 advance
Date: Wed, 18 May 2011 14:38:54 +0200
Message-ID: <20110518123854.GF25632@quack.suse.cz>
References: <4DCBED1D.2010109@gmail.com>
 <20110517180930.GC30519@quack.suse.cz>
 <BANLkTinfoPksqnnVPSfSqnaY33=Y76Djhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: niraj kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012Ab1ERMjQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 08:39:16 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinfoPksqnnVPSfSqnaY33=Y76Djhg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-05-11 13:38:47, niraj kulkarni wrote:
> Thanks for the reply. That solves most of the problem.
> 
> So now all I need is to gather information of all submitted buffers in
> current transactions, and pass it through ioctl to lower layer.
> What I am currently doing is adding buffer  to a list instead of submitting
> them straightaway, and side by side constructing an array holding these
> buffer numbers. So i submit this buffer number array through ioctl, and then
> actually submit buffer.
> 
> This needs a few kmallocs while I am holding buffer_lock() on few buffers.
> So is it potentially deadlocking situation?
  It shouldn't be if you use proper gfp mask - like GFP_NOFS should be OK.

									Honza
> On Tue, May 17, 2011 at 11:39 PM, Jan Kara <jack@suse.cz> wrote:
> 
> >  Hello,
> >
> > On Thu 12-05-11 19:52:21, Niraj Kulkarni wrote:
> > >          I am trying to implement a concept called Transactional
> > > Flash (
> > http://www.usenix.org/event/osdi08/tech/full_papers/prabhakaran/prabhakaran_html/
> > )
> > >
> > >          in which all writes are flushed to disk (in this case
> > > Flash) as a circular linked list of pages. No journaling mechanisms
> > > are used.
> > >           For that I am trying to get list of all buffers to be
> > > written (metadata or data) before actually writing them. I thought
> > > of 2 approaches :
> > >
> > > 1. Get conservative list of all buffers before flushing any of them
> > > (before commit phase 2) in journal_commit_transaction function.
> > >      Problem : Metadata writes use temporary buffers which are
> > > allocated just before write.
> >   Well, if I understand the transactional flash concept right, what you
> > should do is to replace code committing metadata to the journal by
> > something which writes metadata directly to final location. That should be
> > relatively easy modification of loops in journal_commit_transaction(). BTW,
> > you might want to use ext4/jbd2 instead of ext3/jbd as a base for your
> > experiments since ext3 is basically deprecated.
> >
> > > 2. Instead of submitting buffers straightaway, collect all of them (
> > > data + metadata ) and flush them in end.
> > >      Problem :  i.   Possibility of blocking after data buffers are
> > > collected but before metadata buffer collection.
> > >                            Since data buffers are locked, this may
> > > lead to deadlock. (I am not sure if it is spinlock)
> > >
> > >                       ii.   Not able to differentiate between
> > > metadata buffers and Descriptor buffers.
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> >
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
