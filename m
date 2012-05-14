From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 barrier on SCSI vs SATA?
Date: Mon, 14 May 2012 12:51:48 +0200
Message-ID: <20120514105148.GG5353@quack.suse.cz>
References: <4FA7A584.5060902@pocock.com.au>
 <20120509195056.GH5092@quack.suse.cz>
 <4FAC9EC4.1000906@shiftmail.org>
 <20120514090230.GA5353@quack.suse.cz>
 <4FB0DF5F.2060400@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab2ENKwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 06:52:00 -0400
Content-Disposition: inline
In-Reply-To: <4FB0DF5F.2060400@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-05-12 12:33:03, Asdo wrote:
> On 05/14/12 11:02, Jan Kara wrote:
> >>However the flush was always available (I think), in fact databases
> >>would not corrupt (not even above ext4 nobarrier, above a raid5
> >>without barriers) if fsync was called at proper times.
> >   This is not true. Both cache flushes and barriers were implemented by
> >the same mechanism in older kernels. Thus if the device did not properly
> >propagate the barrier capability, then fsync did not provide any guarantees
> >in case of power failure (if there are volalile write caches in the storage
> >device).
> 
> Oh! Thanks I had not realized this.
> 
> So, if barrier IS provided by the underlying blockdevice but
> filesystem is nevertheless mounted as nobarrier (as an explicit
> option) would database flushes (fsync) for files on THAT filesystem
> work properly or not?
  If you have volatile write caches, they would not. nobarrier option
means: "I *know* I don't need cache flushes for data integrity and I want
maximum performance."

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
