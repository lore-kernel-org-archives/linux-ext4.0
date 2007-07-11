From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and powerpc
Date: Wed, 11 Jul 2007 13:41:41 +0530
Message-ID: <20070711081141.GA25383@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710202000.GB8797@amitarora.in.ibm.com> <20070711121034.a3b925b9.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43472 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbXGKIL2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 04:11:28 -0400
Content-Disposition: inline
In-Reply-To: <20070711121034.a3b925b9.sfr@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 12:10:34PM +1000, Stephen Rothwell wrote:
> On Wed, 11 Jul 2007 01:50:00 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> >
> > --- linux-2.6.22.orig/arch/x86_64/ia32/sys_ia32.c
> > +++ linux-2.6.22/arch/x86_64/ia32/sys_ia32.c
> > @@ -879,3 +879,11 @@ asmlinkage long sys32_fadvise64(int fd, 
> >  	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
> >  				len, advice);
> >  }
> > +
> > +asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
> > +				unsigned offset_hi, unsigned len_lo,
> > +				unsigned len_hi)
> 
> Please call this compat_sys_fallocate in line with the powerpc version -
> it gives us a hint that maybe we should think about how to consolidate
> them.  I know other stuff in that file is called sys32_ ... but it is time
> for a change :-)

I think this can be handled as a separate patch once this patchset
is in mainline. Since, anyhow we will need to do this for other sys32_
calls which are already there...

--
Regards,
Amit Arora
