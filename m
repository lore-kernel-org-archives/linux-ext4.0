From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/11] vfs: Add better VFS support for page_mkwrite
	when blocksize < pagesize
Date: Mon, 1 Jun 2009 11:44:02 +0200
Message-ID: <20090601094402.GA14373@duck.suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-4-git-send-email-jack@suse.cz> <20090530112324.GD1395@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZFAJoB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jun 2009 05:44:01 -0400
Content-Disposition: inline
In-Reply-To: <20090530112324.GD1395@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 30-05-09 13:23:24, Pavel Machek wrote:
> Hi!
> 
> > On filesystems where blocksize < pagesize the situation is more complicated.
> > Think for example that blocksize = 1024, pagesize = 4096 and a process does:
> >   ftruncate(fd, 0);
> >   pwrite(fd, buf, 1024, 0);
> >   map = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
> >   map[0] = 'a';  ----> page_mkwrite() for index 0 is called
> >   ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
> >   fsync(fd); ----> writepage() for index 0 is called
> > 
> > At the moment page_mkwrite() is called, filesystem can allocate only one block
> > for the page because i_size == 1024. Otherwise it would create blocks beyond
> > i_size which is generally undesirable. But later at writepage() time, we would
> > like to have blocks allocated for the whole page (and in principle we have to
> > allocate them because user could have filled the page with data after the
> > second ftruncate()). This patch introduces a framework which allows filesystems
> > to handle this with a reasonable effort.
> 
> What happens when you do above sequence on today's kernels? Oops? 3000
> bytes of random junk in file? ...?
  Depends on the filesystem. For example on ext4, you'll see a WARN_ON and the data
won't be written. Some filesystems may just try to map blocks and possibly
hit deadlock or something like that. Filesystems like ext2 / ext3 /
reiserfs generally don't care because so far they allocate blocks on writepage
time (which has the problem that you can write data via mmap and kernel
will later discard them because it hits ENOSPC or quota limit). That's
actually what I was trying to fix originally.

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
