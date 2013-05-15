From: Dave Chinner <david@fromorbit.com>
Subject: Re: Barriers
Date: Wed, 15 May 2013 15:43:53 +1000
Message-ID: <20130515054353.GO29466@dastard>
References: <C0F0BC787567C848B2C90989451123DAE3A619@ATLEXMBX4.ARRS.ARRISI.com>
 <20130514214158.GB10769@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28723 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab3EOFn6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 May 2013 01:43:58 -0400
Content-Disposition: inline
In-Reply-To: <20130514214158.GB10769@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 14, 2013 at 11:41:58PM +0200, Jan Kara wrote:
>   Hi,
> 
> On Mon 13-05-13 07:54:48, Sidorov, Andrei wrote:
> > I'm curious if anyone ever tried fua-only jbd? If done with fua's, there
> > will be no cache flushes at all, thus no occasional spikes. NCQ fua
> > journalling is potentially more efficient than cache flush.
>   If you have such HW, it may be an interesting thing to try.

Be careful there -  you still need to guarantee all metadata that is
being overwritten in the log has been flushed to stable storage, so
even when you are using FUA for the journal writes you still need a
pre-write flush to occur.

Another tricky case here is that if you are using an external log,
the flush needs to occur on the metadata device, not the log device,
and it needs to complete before you submit the FUA journal write.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
