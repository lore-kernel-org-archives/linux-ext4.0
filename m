From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Fri, 19 Jul 2013 10:22:35 -0400
Message-ID: <x498v12iq8k.fsf@segfault.boston.devel.redhat.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
	<51E8356C.9030603@redhat.com> <20130718185310.GA17548@thunk.org>
	<51E88ECD.3040806@redhat.com> <20130719025934.GE17938@thunk.org>
	<20130719033309.GQ11674@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab3GSOWm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jul 2013 10:22:42 -0400
In-Reply-To: <20130719033309.GQ11674@dastard> (Dave Chinner's message of "Fri,
	19 Jul 2013 13:33:09 +1000")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Jul 18, 2013 at 10:59:34PM -0400, Theodore Ts'o wrote:
>> On Thu, Jul 18, 2013 at 07:56:45PM -0500, Eric Sandeen wrote:
>> > > The problem is we don't know that we're doing AIO until we see the
>> > > first io_submit(2) call.  With this patch series, we'll pull the
>> > > contents of the entire leaf tree block into extent cache, but if the
>> > > extent tree is larger than that, if we read in the entire extent tree
>> > > on the first AIO request, then that first request will delayed even
>> > > more, and it's not clear that's a good thing.
>> > 
>> > Is blocking on a pre-AIO ioctl better than blocking on the
>> > first AIO?
>> 
>> The precache ioctl is something which the application is expecting to
>> block.  The question is, if we have a heavily fragmented extent tree,
>> is it better for the first AIO to block long enough to read in one
>> metadata block --- and then never block again, or to have that first
>> AIO request take a long, LONG time?  Especially if the application
>> isn't expecting it?
>> 
>> Also there are use cases for the precache ioctl even if you are not
>> using AIO.  If you've taken care to make sure the file is as
>> contiguous as possible, having the extents be cached will save a lot
>> of memory compared to if the buffer heads are always entering the
>> buffer cache.  So reading in all of the metadata can be a good thing
>> to do, especially if you can do this *before* you declare that the
>> server is healthy and is ready to start receiving traffic.
>
> An ioctl is kinda silly for this. Just use O_NONBLOCK when calling
> open() and do the prefetch right in the open call. The open() can
> block, anyway, and what you are trying to do is non-blocking IO with
> AIO, so it seems like we've already got a sensible, generic
> interface for triggering this sort of prefetch operation.

Hmm, O_NONBLOCK on regular files, eh?  That brings back memories:
  http://www.gossamer-threads.com/lists/linux/kernel/481855

I don't recall exactly how that ended, but I'm pretty sure the
conclusion was that it was a bad idea.

-Jeff
