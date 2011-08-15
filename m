From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Tue, 16 Aug 2011 00:07:50 +0200
Message-ID: <201108160007.50528.rjw@sisk.pl>
References: <201108112329.23043.rjw@sisk.pl> <201108152009.13776.rjw@sisk.pl> <20110815205807.GC16369@quack.suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110815205807.GC16369@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Monday, August 15, 2011, Jan Kara wrote:
>   Hello,
> 
> On Mon 15-08-11 20:09:13, Rafael J. Wysocki wrote:
> > On Monday, August 15, 2011, Jan Kara wrote:
...
> > >   It's not so simple as this. Ext3 relies on the mutex (the one hidden in
> > > journal_lock_updates()) to make sure that new transaction cannot be started
> > > while the filesystem is frozen - that's essentially what makes the
> > > filesystem frozen. So if we want to get rid of the mutex we have to achieve
> > > blocking by something else - ext4 uses vfs_check_frozen() in
> > > ext4_journal_start().
> > 
> > I see.  Still, freeze_bdev() may be called by user space through a syscall,
> > as far as I can say, so it shouldn't leave the mutex locked.
>   Yes, I agree with you. That's an ugliness left over from a long time ago.
> I'll have a look at fixing this...

Thanks!

> > >   BTW,  filesystem freezing never really worked for mmaped writes under
> > > ext3 - ext3 would have to implement page_mkwrite() callback for that - so
> > > if you want to rely on it for suspending, this will be non-trivial.
> > 
> > At this point the purpose of freezing filesystems is basically to
> > prevent XFS from deadlocking with hibernation's memory preallocation.
> > For other filesystems it may or may not make a difference depending on
> > their implementation of freeze/unfreeze_super().
>   What's exactly the problem? Memory preallocation enters direct reclaim
> and that deadlocks in the filesystem?

Yes, that seems to be the case.

Thanks,
Rafael
