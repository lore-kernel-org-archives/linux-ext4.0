From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a
 write error
Date: Mon, 23 Jun 2008 19:17:33 -0700
Message-ID: <20080623191733.52c3491c.akpm@linux-foundation.org>
References: <485F8822.5030205@hitachi.com>
	<200806232146.28379.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
	adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jack@suse.cz,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYFXCSB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 22:18:01 -0400
In-Reply-To: <200806232146.28379.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 23 Jun 2008 21:46:27 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Monday 23 June 2008 21:25, Hidehiro Kawai wrote:
> > A transient I/O error can corrupt inode data.  Here is the scenario:
> >
> > (1) update inode_A at the block_B
> > (2) pdflush writes out new inode_A to the filesystem, but it results
> >     in write I/O error, at this point, BH_Uptodate flag of the buffer
> >     for block_B is cleared and BH_Write_EIO is set
> > (3) create new inode_C which located at block_B, and
> >     __ext3_get_inode_loc() tries to read on-disk block_B because the
> >     buffer is not uptodate
> > (4) if it can read on-disk block_B successfully, inode_A is
> >     overwritten by old data
> >
> > This patch makes __ext3_get_inode_loc() not read the inode block if
> > the buffer has BH_Write_EIO flag.  In this case, the buffer should
> > have the latest information, so setting the uptodate flag to the
> > buffer (this avoids WARN_ON_ONCE() in mark_buffer_dirty().)
> >
> > According to this change, we would need to test BH_Write_EIO flag for
> > the error checking.  Currently nobody checks write I/O errors on
> > metadata buffers, but it will be done in other patches I'm working on.
> 
> IMO there is a problem with all the buffer head and pagecache error
> handling in that uptodate gets cleared on write errors. This is not
> only wrong (because the in-memory copy continues to contain the most
> uptodate copy), but it will trigger assertions all over the mm and
> buffer code AFAIKS.
> 
> I don't know why it was done like this, or if anybody actually tested
> any of it, but AFAIKS the best way to fix this is to simply not
> clear any uptodate bits upon write errors.

There's a plausible-sounding reason for this behaviour which I forgot
about three years ago.  Maybe Linus remembers?

Meanwhile I guess I'll queue the patch, sad though it is.
