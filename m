From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 barrier on SCSI vs SATA?
Date: Mon, 14 May 2012 11:02:30 +0200
Message-ID: <20120514090230.GA5353@quack.suse.cz>
References: <4FA7A584.5060902@pocock.com.au>
 <20120509195056.GH5092@quack.suse.cz>
 <4FAC9EC4.1000906@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab2ENJCr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 05:02:47 -0400
Content-Disposition: inline
In-Reply-To: <4FAC9EC4.1000906@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 11-05-12 07:08:20, Asdo wrote:
> On 05/09/12 21:50, Jan Kara wrote:
> I have some troubles understanding the barriers thing, can you help me?
> 
> In the past some blockdevices would not provide / propagate the
> barriers, e.g. MD raid 5 would not.  So filesystems during mount
> would try the barrier operation and see that it wouldn't work, so
> they would disable barrier option and mount as nobarrier.
  Correct.

> However the flush was always available (I think), in fact databases
> would not corrupt (not even above ext4 nobarrier, above a raid5
> without barriers) if fsync was called at proper times.
  This is not true. Both cache flushes and barriers were implemented by
the same mechanism in older kernels. Thus if the device did not properly
propagate the barrier capability, then fsync did not provide any guarantees
in case of power failure (if there are volalile write caches in the storage
device).

> So first question is : why filesystems were not using the flush as a
> barrier like databases did?
  The above explains that I guess.

> Second question is : was a nobarrier mount (ext4) more risky in
> terms of data or metadata lost on sudden power loss?
  Sure, if you have volatile write caches (normal situation on all disk
drives when you don't have UPS), then nobarrier can cause filesystem
corruption on power failure. It was like that before and it is still true.
Nobarrier is there for cases like - you are sure you won't have unexpected
power failure (you have UPS or laptop with working battery and everything
is setup to shutdown the system cleanly when the battery gets low), or you
have disabled write caches on the device, or the device itself has battery
backed caches (the case of higher grade storage cards or NAS).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
