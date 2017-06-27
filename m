From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: remove timebomb in ext4_decode_extra_time()
Date: Tue, 27 Jun 2017 11:35:43 -0700
Message-ID: <20170627183543.GA39374@gmail.com>
References: <20170614112238.14121-1-hch@lst.de>
 <20170627140326.GA25210@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32935 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdF0Sfr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 14:35:47 -0400
Received: by mail-pf0-f193.google.com with SMTP id e199so5783697pfh.0
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 11:35:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170627140326.GA25210@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 27, 2017 at 04:03:26PM +0200, Christoph Hellwig wrote:
> ping?
> 
> On Wed, Jun 14, 2017 at 01:22:38PM +0200, Christoph Hellwig wrote:
> > Changing behavior based on the version code is a timebomb waiting to
> > happen, and not easily bisectable.  Drop it and leave any removal
> > to explicit developer action. (And I don't think file system
> > should _ever_ remove backwards compatibility that has no explicit
> > flag, but I'll leave that to the ext4 folks).
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/ext4/ext4.h | 12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 32191548abed..d35749e7cf9f 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -838,21 +838,15 @@ static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> >  {
> >  	if (unlikely(sizeof(time->tv_sec) > 4 &&
> >  			(extra & cpu_to_le32(EXT4_EPOCH_MASK)))) {
> > -#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
> > +
> >  		/* Handle legacy encoding of pre-1970 dates with epoch
> > -		 * bits 1,1.  We assume that by kernel version 4.20,
> > -		 * everyone will have run fsck over the affected
> > -		 * filesystems to correct the problem.  (This
> > -		 * backwards compatibility may be removed before this
> > -		 * time, at the discretion of the ext4 developers.)
> > +		 * bits 1,1. (This backwards compatibility may be removed
> > +		 * at the discretion of the ext4 developers.)
> >  		 */
> >  		u64 extra_bits = le32_to_cpu(extra) & EXT4_EPOCH_MASK;
> >  		if (extra_bits == 3 && ((time->tv_sec) & 0x80000000) != 0)
> >  			extra_bits = 0;
> >  		time->tv_sec += extra_bits << 32;
> > -#else
> > -		time->tv_sec += (u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
> > -#endif
> >  	}
> >  	time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
> >  }

Looks good --- I agree that timebombs are a very bad idea.

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
