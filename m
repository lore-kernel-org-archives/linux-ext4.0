From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Correction to nanosecond timestamp patch for 64-bit arch
Date: Mon, 18 Jun 2007 04:49:14 -0600
Message-ID: <20070618104914.GH5181@schatzie.adilger.int>
References: <1182085374.4141.5.camel@garfield> <1182161379.8151.16.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, Andrew Morton <akpm@osdl.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46835 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXFRKtT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jun 2007 06:49:19 -0400
Content-Disposition: inline
In-Reply-To: <1182161379.8151.16.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 18, 2007  15:39 +0530, Kalpak Shah wrote:
> On Sun, 2007-06-17 at 18:32 +0530, Kalpak Shah wrote:
> > Index: linux-2.6.21/include/linux/ext4_fs.h
> > ===================================================================
> > --- linux-2.6.21.orig/include/linux/ext4_fs.h
> > +++ linux-2.6.21/include/linux/ext4_fs.h
> > @@ -366,9 +366,9 @@ static inline __le32 ext4_encode_extra_t
> >  static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> >  {
> >         if (sizeof(time->tv_sec) > 4)
> > -	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> > -			       << 32;
> > -       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
> > +	       time->tv_sec |= (__u64)((signed)le32_to_cpu(extra) &
> > +				       EXT4_EPOCH_MASK) << 32;
> > +       time->tv_nsec = ((signed)le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
> >  }
> >  
> 
> I am not too sure about the above hunk. tv_sec would not need any
> (signed) cast since it is being ORed. And nsec should always lie between
> 0 and 1e9.
> 
> But the following patch is definitely correct and needs to be applied.

Hmm, this makes me think that the shifting for the "epoch" needs to be 
done with 31 bits instead of 32, otherwise the time between 0x7fffffff
and 0xffffffff will always appear to be negative.

I'm beginning to wonder at the value of trying to save any times with
negative timestamp values.  That might have seemed useful in 1970 when
it was only a few weeks or months in the past, but it seems like a waste
of bits today.  It would seem prudent to just truncate times on disk to
0 if the timestamp is negative?  The original bug report was related to
setting the time to Jan 1 1970 in some timezone that causes this to be
a negative value, so limiting the timestamp to 0 in such cases wouldn't
be considered a limitation.

According to the original bug report, storing negative times isn't even
possible to do with some tools, and might be considered a bug in "date"
as much as anything.  If the problem is the inconsistency of times between
32-bit and 64-bit systems this could be resolved by always treating the
on-disk value as an unsigned integer, and it would be capped at +2^31
(2038) on 32-bit systems for the next couple of years until "date" is fixed.

>  #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                         \
>  do {                                                                          \
> -       (inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);               \
> +       (inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
>         if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
>                 ext4_decode_extra_time(&(inode)->xtime,                        \
>                                        raw_inode->xtime ## _extra);            \
> @@ -399,7 +399,8 @@ do {                                                                               \
>  #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                               \
>  do {                                                                          \
>         if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
> -               (einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
> +               (einode)->xtime.tv_sec =                                       \
> +                               (signed)le32_to_cpu((raw_inode)->xtime);       \
>         if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
>                 ext4_decode_extra_time(&(einode)->xtime,                       \
>                                        raw_inode->xtime ## _extra);            \

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
