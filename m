From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Track lifetime disk writes
Date: Mon, 30 Mar 2009 15:38:31 +0530
Message-ID: <20090330100831.GA4796@skywalker>
References: <E1LdHKi-0000Zm-Mv@closure.thunk.org> <20090323155024.GA27876@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57038 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757AbZC3KIi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 06:08:38 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2UA8XKq016128
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:38:33 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2UA4tOv4194522
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:34:55 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2UA8WEm023788
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:08:32 +1100
Content-Disposition: inline
In-Reply-To: <20090323155024.GA27876@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 23, 2009 at 09:20:24PM +0530, Aneesh Kumar K.V wrote:
> On Sat, Feb 28, 2009 at 12:01:52AM -0500, Theodore Ts'o wrote:
> > 
> > Add a new superblock value which tracks the lifetime amount of writes
> > to the filesystem.  This is useful in estimating the amount of wear on
> > solid state drives (SSD's) caused by writes to the filesystem.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/ext4.h    |    3 ++-
> >  fs/ext4/ext4_sb.h |    4 ++++
> >  fs/ext4/super.c   |    7 +++++++
> >  3 files changed, 13 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 8599e37..f9a3bc3 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -685,7 +685,8 @@ struct ext4_super_block {
> >  	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
> >  	__u8	s_reserved_char_pad2;
> >  	__le16  s_reserved_pad;
> > -	__u32   s_reserved[162];        /* Padding to the end of the block */
> > +	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
> > +	__u32   s_reserved[160];        /* Padding to the end of the block */
> >  };
> > 
> >  #ifdef __KERNEL__
> > diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
> > index 4e4d9cc..50ab116 100644
> > --- a/fs/ext4/ext4_sb.h
> > +++ b/fs/ext4/ext4_sb.h
> > @@ -142,6 +142,10 @@ struct ext4_sb_info {
> >  	/* locality groups */
> >  	struct ext4_locality_group *s_locality_groups;
> > 
> > +	/* for write statistics */
> > +	unsigned long s_sectors_written_start;
> > +	u64 s_kbytes_written;
> > +
> >  	unsigned int s_log_groups_per_flex;
> >  	struct flex_groups *s_flex_groups;
> >  };
> 
> Do we need this change ? We don't seems to be using it anywhere.
> 

Looked at the patchqueue and found that you have users in sysfs-support
patch. I guess it would be better if you put this patch after
sysfs-support and moved  session_write_kbytes_show and others to this
patch.

-aneesh
