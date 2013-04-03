From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: per inode fsync optimization question
Date: Wed, 03 Apr 2013 19:41:38 +0400
Message-ID: <87wqsjpqod.fsf@openvz.org>
References: <8738v7r8xx.fsf@openvz.org> <20130403145055.GD14667@quack.suse.cz> <87zjxfps5u.fsf@openvz.org> <20130403151522.GE14667@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52049 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572Ab3DCPlo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 11:41:44 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so1579764lab.19
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 08:41:42 -0700 (PDT)
In-Reply-To: <20130403151522.GE14667@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Apr 2013 17:15:22 +0200, Jan Kara <jack@suse.cz> wrote:
> On Wed 03-04-13 19:09:33, Dmitry Monakhov wrote:
> > On Wed, 3 Apr 2013 16:50:55 +0200, Jan Kara <jack@suse.cz> wrote:
> > > On Wed 03-04-13 18:21:46, Dmitry Monakhov wrote:
> > > > inode store i_sync_tid and i_datasync_tid  in order to optimize journal
> > > > flushes and wait for commits only when necessary, but
> > > > fields are declared as tid_t(not atomic_t as it done in ext3) so we
> > > > have not synchronization between readers and writers, so gcc and cpu
> > > > is allowed to perform prefetch, cache and other stuff.
> > > > Looks like a bug, right?
> > >   Reads and writes to atomic_t aren't guaranteed to be any kind of a
> > > barrier (if fact they are compiled as simple stores and loads on x86). Only
> > > arithmetic operations on atomic types are special. So using tid_t is just
> > > fine.
> > Ok but what about prefetching?
> > Compiler is allowed to prefetch on early stage ?
> > should we use ACCESS_ONCE() or wmb() and rmb() here?
>   Yes, but prefetch can hardly happen before the syscall is started and
> value from that time is enough. We just have to be sure that if user can
> prove write(2) happened before fsync(2), then data written by write(2) are
> on disk. So I don't think we need any barriers there.
Sorry for be annoying but what prevents us from following situation?:
DD:
fallocate(2)
write(2)

fsync(2)                       
 {prefetch}commit_tid = ie->i_sync_tid (T1)
                                               [flushd]
                                                ->convert_extents
                                                  -> ei->i_sync_tid = current_tid (T2)
 
 Observe that commit_tid == T1 (too old)
 issue a barrier and exit but
 data still in transaction which is not yet committed
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
