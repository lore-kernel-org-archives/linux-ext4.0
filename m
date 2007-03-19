From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Date: Mon, 19 Mar 2007 14:54:04 +0530
Message-ID: <20070319092404.GA12092@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316152103.GD8525@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:45350 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXCSJYP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2007 05:24:15 -0400
Content-Disposition: inline
In-Reply-To: <20070316152103.GD8525@osiris.boeblingen.de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 16, 2007 at 04:21:03PM +0100, Heiko Carstens wrote:
> On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> > First of all, thanks for the overwhelming response!
> > 
> > Based on the suggestions received, I have added a new parameter to the
> > sys_fallocate() system call - an interger called "mode", just after the
> > "fd". Now the system call looks like this:
> > 
> >  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > 
> > Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> > preallocation and deallocation of preallocated blocks respectively. More
> > modes can be added, when required. And these modes can be renamed, since
> > I am sure these are no way the best ones ! :)
> > 
> > Attached below is the patch which implements this system call. It has
> > been currently implemented and tested on i386, ppc64 and x86_64
> > architectures. I am facing some problems while trying to implement this
> > on s390, and thus the delay. While I try to get it right on s390(x), we
> > thought of posting this patch, so that we can save some time. Parallely
> > we will work on getting the patch work on s390, and probably it will
> > come as a separate patch.
> 
> What's the problem you face on s390? If it's just the compat wrapper, you
> may look at sys_sync_file_range_wrapper. Or I will send a patch if needed.

Hi Heiko,

Yes, the problem was adding compat wrapper for this. I will appreciate
your help in writing it. Only thing is that we might have to wait till
the order of the arguments is decided upon. Thanks!

--
Regards,
Amit Arora
