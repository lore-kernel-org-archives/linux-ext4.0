From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Thu, 5 Aug 2010 10:36:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008051009100.3063@localhost>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com> <8762zq8lxv.fsf@dmon-lap.sw.ru> <alpine.LFD.2.00.1008041704420.2932@localhost> <8739utfssc.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758810Ab0HEIg6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 04:36:58 -0400
In-Reply-To: <8739utfssc.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 5 Aug 2010, Dmitry Monakhov wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > On Wed, 4 Aug 2010, Dmitry Monakhov wrote:
> >
> >> Lukas Czerner <lczerner@redhat.com> writes:
> >> 
> >> > Adds an filesystem independent ioctl to allow implementation of file
> >> > system batched discard support.
> >> >
> >> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> >> > ---
> >> >  fs/ioctl.c         |   31 +++++++++++++++++++++++++++++++
> >> >  include/linux/fs.h |    2 ++
> >> >  2 files changed, 33 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> >> > index 2d140a7..6c01c3c 100644
> >> > --- a/fs/ioctl.c
> >> > +++ b/fs/ioctl.c
> >> > @@ -540,6 +540,33 @@ static int ioctl_fsthaw(struct file *filp)
> >> >  	return thaw_super(sb);
> >> >  }
> >> >  
> >> > +static int ioctl_fstrim(struct file *filp, unsigned long arg)
> >> BTW why do we have to trim fs in one shot ?
> >> IMHO it is much suitable to provide start,len parameters as we 
> >> do in most functions(truncate, bdevdiscard, getdents).
> >> It allow userspace caller to implement a fancy looking progress bars.
> >
> > Hi,
> >
> > do you think it is really needed when even with todays SSD's it takes
> > just a couple of seconds ? And I suppose it will improve in future. But
> > generally I think we can do that..I would like to hear some more
> > opinions before I start looking at this.
> Hi, Lukas
> we may face a really long delays due to bad layouts and slow devices
> Please read my response to Ted
> I'm agree with you what this interface is important, BTW i already
> enabled FITRIM support on my notebook, my speed difference is about 2-3%.
> But let's provide right user interface from very beginning.

Hi, Dimitry

I read the thread and really it makes sense to me. Sometimes it can be useful
to have more fine-grained control beside just specifying minlen argument,
which works quite well, however it is a little bit fuzzy because when you do
not know how much space was actually trimmed.

I think that there is no need to have two separate ioctls, even though
it would be more effective to specify block group instead of block range.
I am thinking about something like int optimize which will tell us to round
the range to block group boundaries. But I can not tell if it would
really help someone (probably not).

So I will try to do something to be able to break the FITRIM to smaller
pieces, uint64_t start, uint64_t len, uint64_t minlen seems good to me.

Thanks

-Lukas
