From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/11] vfs: Add better VFS support for page_mkwrite
	when blocksize < pagesize
Date: Mon, 1 Jun 2009 17:02:18 +0200
Message-ID: <20090601150218.GI14373@duck.suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-4-git-send-email-jack@suse.cz> <20090530112324.GD1395@ucw.cz> <20090601094402.GA14373@duck.suse.cz> <87y6scqjd7.fsf@frosties.localdomain> <20090601140030.GF14373@duck.suse.cz> <87zlcsxb97.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Pavel Machek <pavel@ucw.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZFAPCR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jun 2009 11:02:17 -0400
Content-Disposition: inline
In-Reply-To: <87zlcsxb97.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-06-09 16:46:28, Goswin von Brederlow wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Mon 01-06-09 13:33:08, Goswin von Brederlow wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> > On Sat 30-05-09 13:23:24, Pavel Machek wrote:
> >> >> Hi!
> >> >> 
> >> >> > On filesystems where blocksize < pagesize the situation is more complicated.
> >> >> > Think for example that blocksize = 1024, pagesize = 4096 and a process does:
> >> >> >   ftruncate(fd, 0);
> >> >> >   pwrite(fd, buf, 1024, 0);
> >> >> >   map = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
> >> >> >   map[0] = 'a';  ----> page_mkwrite() for index 0 is called
> >> >> >   ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
> >> >> >   fsync(fd); ----> writepage() for index 0 is called
> >> >> > 
> >> >> > At the moment page_mkwrite() is called, filesystem can allocate only one block
> >> >> > for the page because i_size == 1024. Otherwise it would create blocks beyond
> >> >> > i_size which is generally undesirable. But later at writepage() time, we would
> >> >> > like to have blocks allocated for the whole page (and in principle we have to
> >> >> > allocate them because user could have filled the page with data after the
> >> >> > second ftruncate()). This patch introduces a framework which allows filesystems
> >> >> > to handle this with a reasonable effort.
> >> >> 
> >> >> What happens when you do above sequence on today's kernels? Oops? 3000
> >> >> bytes of random junk in file? ...?
> >> >   Depends on the filesystem. For example on ext4, you'll see a WARN_ON and the data
> >> > won't be written. Some filesystems may just try to map blocks and possibly
> >> > hit deadlock or something like that. Filesystems like ext2 / ext3 /
> >> > reiserfs generally don't care because so far they allocate blocks on writepage
> >> > time (which has the problem that you can write data via mmap and kernel
> >> > will later discard them because it hits ENOSPC or quota limit). That's
> >> > actually what I was trying to fix originally.
> >> >
> >> > 										Honza
> >> 
> >> man mmap:
> >>        A file is mapped in multiples of the page size.  For a file that is not
> >>        a  multiple  of  the  page  size,  the  remaining memory is zeroed when
> >>        mapped, and writes to that region are not written out to the file.  The
> >>        effect  of changing the size of the underlying file of a mapping on the
> >>        pages that correspond to added  or  removed  regions  of  the  file  is
> >>        unspecified.
> >> 
> >> Whatever happens happens. The above code is just wrong, as in
> >> unspecified behaviour.
> >> What happens if you ftruncate() before mmap()?
> >   OK, I admit I didn't realize mmap() has so weak requirements. Doing mmap
> > after ftruncate() should work fine because before you write via that new
> > mmap page_mkwrite() will be called anyway.
> 
> But the ftruncate would only allocate a block at position 10000. The
> file still has a big hole from 1024-4095.
  ftruncate() actually allocates no blocks. It just updates file size (at
least for most filesystems). The hole is created as you write.

> >   So what we could alternatively do is that we just discard dirty bits from
> > buffers that don't have underlying blocks allocated. That would satisfy the
> > specification as well. But I have to say I'm a bit afraid of discarding
> > dirty bits like that. Also we'd have to handle the case where someone does
> > mremap() after ftruncate().
> >   What other memory management people think?
> 
> As said above the file still has a big hole after ftruncate. So not
> having underlying blocks allocated can't be the deciding factor.
  I'm not sure I understand here. Do you mean that we should not decide
about discarding dirty bits depending on whether the buffers have
underlying blocks or not? In my opinion that should be correct option
because from what the man page says, user is not guaranteed what happens
when the file size is extended to 10000 and he tries to write from offset
1024 (old i_size) further... Anyway, I'm not defending doing that :-) I'm
just trying to understand what you mean.

> If possible I would make ftruncate() after mmap() work just like
> ftruncate() before mmap(). That is write any dirty page completly up
> to the current filesize. Allocate disk blocks for the file as needed
> (you need to do that anyway). Wouldn't it be more work to remember the
  This is the thing my patches try to achieve :). At truncate time (or
generally just before i_size is extended), we check the last page and
propagate dirty bits to buffers inside old i_size (and clear the ones
beyond old i_size). We also writeprotect the page so that if someone tries
to write to it via mmap in future, we get page fault, page_mkwrite() is
called and a filesystem allocates all blocks it needs with the new i_size.

> filesize at the time of the mmap() to limit updates to that than using
> the current file size?
  Yes, that would be more work. But I never intended to do this...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
