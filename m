From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 15:54:51 -0400
Message-ID: <20101028195451.GB28126@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
 <20101028180118.GC6814@thunk.org>
 <20101028193211.GA28126@thunk.org>
 <4CC9D0A8.8030209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
	Arnd Bergmann <arnd@arndb.de>,
	Avinash Kurup <kurup.avinash@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59308 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab0J1Ty4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 15:54:56 -0400
Content-Disposition: inline
In-Reply-To: <4CC9D0A8.8030209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 02:36:08PM -0500, Eric Sandeen wrote:
> Ted Ts'o wrote:
> > On Thu, Oct 28, 2010 at 02:01:18PM -0400, Ted Ts'o wrote:
> >> On Thu, Oct 28, 2010 at 07:52:21PM +0200, Markus Trippelsdorf wrote:
> >>> The same BUG (inode.c:2721) happend here today running latest vanilla
> >>> git. There is nothing in my logs unfortunately, but I shot a photo of
> >>> the trace (see attachment).
> >> I see, it's the page_buffers() call which is triggering.  Looking into
> >> it...
> > 
> > Can folks let me know if this fixes the problem?
> 
> Ted, any idea what caused the change in behavior here?

The bug was caused by commit a42afc5f56: ext4: simplify ext4_writepage()

I somehow managed to use page_buffers(page) instead of
page_has_buffers(page) when cleaning up ext4_writpage().  It's not
something I can trigger in xfstests, and so on my todo list is to
create a test case that can trigger this issue.

The immediate trigger was journal_submit_inode_data_buffers() getting
called in data=ordered mode, which ends up calling
generic_writepages() which iterates over all of the dirty pages in the
inode and calls ext4_writepage() on them.  If we're under enough
memory pressure that the buffer heads get stripped from the page
before the journal commit happens (by default on a 5 second interval),
then we'll end up calling page_buffers() on a page with the buffer
heads stripped, and the fact that I had somehow changed
page_has_buffers() to page_buffers(), would cause a BUG_ON.

My standard test setup runs xfstests using 768k of memory on a
dual-CPU system, and apparently fsstress wasn't enough to trigger the
case where the bh's get stripped from the page, even with a relatively
small memory configuration.  Which is surprising to me, but one good
thing about this bug is that it has pointed out a gap in my testing
strategy.

To address this, we need to either (a) create tests that generate
enough memory pressure so this happens, or (b) we need to have some
hooks (maybe some magic ioctl's) that emulate this by forcibly
detaching bh's from some random number of pages.

	       	    	 	       	  - Ted
