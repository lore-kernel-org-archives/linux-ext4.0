From: Mingming <cmm@us.ibm.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Fri, 02 Oct 2009 16:26:05 -0700
Message-ID: <1254525965.4095.210.camel@mingming-laptop>
References: <20090826052505.GA22238@webber.adilger.int>
	 <20090929213859.GB13825@webber.adilger.int>
	 <20090929223938.GD3384@webber.adilger.int>
	 <1254523031.4095.208.camel@mingming-laptop>  <4AC6814C.7070305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:33579 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZJBX0I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 19:26:08 -0400
In-Reply-To: <4AC6814C.7070305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-10-02 at 17:40 -0500, Eric Sandeen wrote:
> Mingming wrote:
> > On Tue, 2009-09-29 at 16:39 -0600, Andreas Dilger wrote:
> >> I've done some work to merge some of the existing fsx.c mods into a
> >> single version.  Over & above the version that is in the LTP, I've
> >> included AKPM's O_DIRECT fixes (with a twist), the BSD mmap page and
> >> segfault handling, and per-write fsync.
> >>
> >> The twist for the O_DIRECT feature is that it will randomly open file
> >> descriptors with O_DIRECT, and if you use the Lustre-inspired multi-fd
> >> support (by specifying multiple pathnames for the output file) fsx will
> >> be testing buffered and O_DIRECT and mmap IO on the same file.
> >>
> >> Updated patch to have proper fallocate() handling in case glibc doesn't
> >> have this, for non-x86 architectures from MingMing Cao, based on code
> >> used by DB2.
> >>
> >> Signed-off-by: Andreas Dilger <adilger@sun.com>
> > 
> > On top of this, a little update to add O_DIRECT define.
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > 
> > --- fsx.c.orig	2009-10-02 14:22:12.299565348 -0700
> > +++ fsx.c	2009-10-01 16:36:17.271593794 -0700
> > @@ -78,6 +78,10 @@
> >  
> >  #define	LOGSIZE	100000
> >  
> > +#ifndef O_DIRECT
> > +#define O_DIRECT        040000  /* direct disk access hint */
> > +#endif
> > +
> >  struct log_entry	oplog[LOGSIZE];	/* the log */
> >  int			logptr = 0;	/* current position in log */
> >  int			logcount = 0;	/* total ops */
> > 
> > 
> 
> I think that
> 
> #define _GNU_SOURCE
> 
> will pull in the glibc headers' definition rather than doing our own....
> 

Oh? that's sounds good...

I tried to replace above with 
#define _GNU_SOURCE	1

gcc complained O_DIRECT is still not defined. what did I missing?

Mingming
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


