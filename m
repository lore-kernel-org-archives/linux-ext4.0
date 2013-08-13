From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Date: Tue, 13 Aug 2013 10:11:40 +1000
Message-ID: <20130813001140.GR12779@dastard>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
 <20130712004421.GE3438@dastard>
 <20130716210027.GA9595@quack.suse.cz>
 <20130812161455.GA19471@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	Jeff Moyer <jmoyer@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:61008 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756038Ab3HMAMy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Aug 2013 20:12:54 -0400
Content-Disposition: inline
In-Reply-To: <20130812161455.GA19471@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 12, 2013 at 06:14:55PM +0200, Jan Kara wrote:
>   Hi Dave,
> 
>   I remembered about this patch set and realized I didn't get reply from
> you regarding the following question (see quoted email below for details):
> Do you really need to defer completion of appending direct IO? Because
> generic code makes sure appending direct IO isn't async and thus
> dio_complete() -> xfs_end_io_direct_write() gets called directly from
> do_blockdev_direct_IO(). I.e. from a normal context and not from interrupt.

Hi Jan, sorry I haven't got back to you sooner - I've had a lot
of stuff to deal with over the past couple of weeks.

The issue is that one part of the code expects deferral , and the
other part of the code isn't doing a deferral, and I never got
around to determining which was correct. I didn't connect the dots
between aio/appending and sync dispatch meaning that the way it is
operating now is fine - i.e. that the fact it doesn't call the
deferral completion path is OK and was intended to operate that
way by Christoph.

So leaving the code as it is without a deferal is fine.

> I've already addressed rest of your comments so this is the only item that
> is remaining.

Great :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
