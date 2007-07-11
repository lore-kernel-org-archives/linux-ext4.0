From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and powerpc
Date: Wed, 11 Jul 2007 06:59:58 +0200
Message-ID: <20070711045958.GA12843@osiris.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710202000.GB8797@amitarora.in.ibm.com> <20070711121034.a3b925b9.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:25871 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXGKFAE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 01:00:04 -0400
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

Maybe it would be worth to finally consider this:

http://marc.info/?l=linux-kernel&m=118411511620432&w=2

?
