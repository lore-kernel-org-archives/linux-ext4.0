From: Jan Kara <jack@suse.cz>
Subject: Re: per inode fsync optimization question
Date: Wed, 3 Apr 2013 17:15:22 +0200
Message-ID: <20130403151522.GE14667@quack.suse.cz>
References: <8738v7r8xx.fsf@openvz.org>
 <20130403145055.GD14667@quack.suse.cz>
 <87zjxfps5u.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab3DCPPY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 11:15:24 -0400
Content-Disposition: inline
In-Reply-To: <87zjxfps5u.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 03-04-13 19:09:33, Dmitry Monakhov wrote:
> On Wed, 3 Apr 2013 16:50:55 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Wed 03-04-13 18:21:46, Dmitry Monakhov wrote:
> > > inode store i_sync_tid and i_datasync_tid  in order to optimize journal
> > > flushes and wait for commits only when necessary, but
> > > fields are declared as tid_t(not atomic_t as it done in ext3) so we
> > > have not synchronization between readers and writers, so gcc and cpu
> > > is allowed to perform prefetch, cache and other stuff.
> > > Looks like a bug, right?
> >   Reads and writes to atomic_t aren't guaranteed to be any kind of a
> > barrier (if fact they are compiled as simple stores and loads on x86). Only
> > arithmetic operations on atomic types are special. So using tid_t is just
> > fine.
> Ok but what about prefetching?
> Compiler is allowed to prefetch on early stage ?
> should we use ACCESS_ONCE() or wmb() and rmb() here?
  Yes, but prefetch can hardly happen before the syscall is started and
value from that time is enough. We just have to be sure that if user can
prove write(2) happened before fsync(2), then data written by write(2) are
on disk. So I don't think we need any barriers there.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
