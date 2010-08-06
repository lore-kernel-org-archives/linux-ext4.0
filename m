From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/3] Batched discard support
Date: Fri, 6 Aug 2010 16:32:13 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008061624000.3645@localhost>
References: <1281094276-11377-1-git-send-email-lczerner@redhat.com> <87zkwzriwm.fsf@dmon-lap.sw.ru> <alpine.LFD.2.00.1008061539010.3645@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab0HFOc2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 10:32:28 -0400
In-Reply-To: <alpine.LFD.2.00.1008061539010.3645@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 6 Aug 2010, Lukas Czerner wrote:

> On Fri, 6 Aug 2010, Dmitry Monakhov wrote:
> 
> > Lukas Czerner <lczerner@redhat.com> writes:
> > 
> > > Hi, all
> > >
> > > because people were worried about possibly long stalls appearing
> > > when FITRIM ioctl is working, I have changed the FITRIM interface
> > > as Dimitry suggested. Now you can choose whether to trim whole
> > > file system or just a part of it, resp. you can specify the range
> > > of Bytes to trim.
> > Agree with whole patch-set, except minor note for ext4'th path.
> > Please feel free to add
> > Reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org> to the series
> > 
> > The only thing what is still not obvious for me is that, there are
> > several types of discard request possible
> > 1) Simple discard 
> > 2) Secure discard which was proposed here http://lkml.org/lkml/2010/6/24/71
> > Should we specify which type should be used in ioctl flags?
> > But i hope that we can just stick maximum security scenario
> > Use secure discard if possible.
> 
> First of all, thanks for you review Dimitry. And second, to be honest I
> am not entirely familiar with the Secure discard implementation. Right
> now it just doing the simple discard like "send TRIM command", so it
> does work just for devices which supports it. I suppose we can just
> check blk_queue_discard() at some level and then decide whether to do
> simple discard (TRIM), or secure discard "Write zeroes", when the device
> does not support TRIM - if it is what you mean by secure discard.
> 
> Regards
> -Lukas
> 

When I am thinking about this, it may not be a bad idea to create a
completely new ioctl for this purpose of "zeroing all free space". We
do the trimming for completely different reasons, and the "secure"
thing is just an side effect, so we probably should not mix it together.

The new ioclt (FISECER ?) and FITRIM can use the same infrastructure in
ext3/4, but we should add a flag to distinguish what we need to do -
TRIM or secure erase. What do you think ?

Regards
-lukas
