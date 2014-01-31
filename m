From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] e4defrag: remove local sync_file_range and fallocate
Date: Fri, 31 Jan 2014 07:29:53 +0200
Message-ID: <20140131052953.GP5596@tarshish>
References: <f2848e6c0e067d62a4ee672f18364b20d4c901d9.1389083392.git.baruch@tkos.co.il>
 <20140120073123.GM12751@tarshish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:44360 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaAaF37 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jan 2014 00:29:59 -0500
Content-Disposition: inline
In-Reply-To: <20140120073123.GM12751@tarshish>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, Jan 20, 2014 at 09:31:23AM +0200, Baruch Siach wrote:
> On Tue, Jan 07, 2014 at 10:29:52AM +0200, Baruch Siach wrote:
> > The locally defined versions of both sync_file_range and fallocate are broken
> > on 32bit systems. On these systems two 32bit registers are needed for each
> > 64bit parameter. Also, sync_file_range on MIPS32 needs a dummy parameters
> > after the fd parameter. Just leave all these subtleties to the C library.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> 
> Ping? Any alternatives?

Just one last reminder.

baruch

> > ---
> >  misc/e4defrag.c | 50 +++-----------------------------------------------
> >  1 file changed, 3 insertions(+), 47 deletions(-)
> > 
> > diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> > index c2695e825d6b..620f4e7981c8 100644
> > --- a/misc/e4defrag.c
> > +++ b/misc/e4defrag.c
> > @@ -39,7 +39,6 @@
> >  #include <sys/mman.h>
> >  #include <sys/stat.h>
> >  #include <sys/statfs.h>
> > -#include <sys/syscall.h>
> >  #include <sys/vfs.h>
> >  
> >  /* A relatively new ioctl interface ... */
> > @@ -194,56 +193,13 @@ static struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
> >  #error posix_fadvise not available!
> >  #endif
> >  
> > -/*
> > - * Local definitions of some syscalls glibc may not yet have
> > - */
> >  #ifndef HAVE_SYNC_FILE_RANGE
> > -#warning Using locally defined sync_file_range interface.
> > -
> > -#ifndef __NR_sync_file_range
> > -#ifndef __NR_sync_file_range2 /* ppc */
> > -#error Your kernel headers dont define __NR_sync_file_range
> > -#endif
> > -#endif
> > -
> > -/*
> > - * sync_file_range() -	Sync file region.
> > - *
> > - * @fd:			defrag target file's descriptor.
> > - * @offset:		file offset.
> > - * @length:		area length.
> > - * @flag:		process flag.
> > - */
> > -int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
> > -{
> > -#ifdef __NR_sync_file_range
> > -	return syscall(__NR_sync_file_range, fd, offset, length, flag);
> > -#else
> > -	return syscall(__NR_sync_file_range2, fd, flag, offset, length);
> > -#endif
> > -}
> > +#error sync_file_range not available!
> >  #endif /* ! HAVE_SYNC_FILE_RANGE */
> >  
> >  #ifndef HAVE_FALLOCATE64
> > -#warning Using locally defined fallocate syscall interface.
> > -
> > -#ifndef __NR_fallocate
> > -#error Your kernel headers dont define __NR_fallocate
> > -#endif
> > -
> > -/*
> > - * fallocate64() -	Manipulate file space.
> > - *
> > - * @fd:			defrag target file's descriptor.
> > - * @mode:		process flag.
> > - * @offset:		file offset.
> > - * @len:		file size.
> > - */
> > -static int fallocate64(int fd, int mode, loff_t offset, loff_t len)
> > -{
> > -	return syscall(__NR_fallocate, fd, mode, offset, len);
> > -}
> > -#endif /* ! HAVE_FALLOCATE */
> > +#error fallocate64 not available!
> > +#endif /* ! HAVE_FALLOCATE64 */
> >  
> >  /*
> >   * get_mount_point() -	Get device's mount point.
> > -- 
> > 1.8.5.2

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
