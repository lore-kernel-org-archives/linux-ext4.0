From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: discard_zeroes_data questions
Date: Mon, 9 Nov 2015 15:38:45 -0800
Message-ID: <20151109233845.GA31524@birch.djwong.org>
References: <56412776.6080604@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <mkp@mkp.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41763 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbKIXjA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2015 18:39:00 -0500
Content-Disposition: inline
In-Reply-To: <56412776.6080604@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:08:38PM -0600, Eric Sandeen wrote:
> Hi Martin (and linux-ext4 list...) 
> 
> tl;dr:
> 
> mke2fs today thinks that if discard_zeroes_data == 1 and a BLKDISCARD ioctl
> of the whole device succeeds, then we have guarantees that any blocks read
> back will be full of zero, and we don't need to initialize them to zero.  Is
> this ok?  (barring crappy hardware, that is).
> 
> slightly longer:
> 
> Does discard_zeroes_data == 1 mean that a discard *request* will guarantee
> zeroes on a read, or does it mean that a
> discard-request-which-actually-was-executed-and-not-ignored-as-just-a-hint
> will give us back zeroes on a read?  (because UNMAP is a hint, right?  I
> don't know about SATA trim ...)
> 
> I did see 7985090 sd: disable discard_zeroes_data for UNMAP - so I think that
> for v3.19+, on *scsi*, what e2fsprogs is doing is ok (now).
> 
> But I'm wondering about dm-thin and SATA, too, so trying to figure out what
> discard_zeroes_data really implies.  That after a BLKDISCARD, a read *will*
> return zeros, or that it'll return zeros *iff* the hint is taken?

Last winter I sent in a patch to invalidate the page cache after a discard:
https://marc.info/?l=linux-kernel&m=142249686225748&w=2

...because e2fsck gets confused it discards part of a d_z_d=1 device and gets
non-zeroed buffers back (from the page cache!) immediately after.

But it never went in.  Should I resend it?  Again?  Jens never acted on it.

--D

> I hope that made sense, but I've been communicating badly today.  ;)
> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
