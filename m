From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 03/11] vfs: Add better VFS support for page_mkwrite
	when blocksize < pagesize
Date: Sat, 30 May 2009 13:23:24 +0200
Message-ID: <20090530112324.GD1395@ucw.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52212 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZE3LXi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 May 2009 07:23:38 -0400
Content-Disposition: inline
In-Reply-To: <1243429268-3028-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> On filesystems where blocksize < pagesize the situation is more complicated.
> Think for example that blocksize = 1024, pagesize = 4096 and a process does:
>   ftruncate(fd, 0);
>   pwrite(fd, buf, 1024, 0);
>   map = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
>   map[0] = 'a';  ----> page_mkwrite() for index 0 is called
>   ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
>   fsync(fd); ----> writepage() for index 0 is called
> 
> At the moment page_mkwrite() is called, filesystem can allocate only one block
> for the page because i_size == 1024. Otherwise it would create blocks beyond
> i_size which is generally undesirable. But later at writepage() time, we would
> like to have blocks allocated for the whole page (and in principle we have to
> allocate them because user could have filled the page with data after the
> second ftruncate()). This patch introduces a framework which allows filesystems
> to handle this with a reasonable effort.

What happens when you do above sequence on today's kernels? Oops? 3000
bytes of random junk in file? ...?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
