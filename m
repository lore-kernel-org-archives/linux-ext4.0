From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Tue, 6 Dec 2011 00:55:44 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112060030220.1615@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
 <4EDD729E.2060402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ted Ts'o <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49705 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab1LFI4O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 03:56:14 -0500
Received: by iakc1 with SMTP id c1so3399973iak.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 00:56:14 -0800 (PST)
In-Reply-To: <4EDD729E.2060402@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 Dec 2011, Allison Henderson wrote:
> On 12/05/2011 04:38 PM, Hugh Dickins wrote:
> > 
> > This has been outstanding for a month now, and we've heard no progress:
> > please revert commit 02fac1297eb3 "ext4: fix partial page writes" for rc5.
> > 
> > The problems appear on a 1k-blocksize filesystem under memory pressure:
> > the hunk in ext4_da_write_end() causes oops, because it's playing with
> > a page after generic_write_end() dropped our last reference to it; and
> > backing out the hunk in ext4_da_write_begin() is then found to stop
> > rare data corruption seen when kbuilding.
> > 
> > Although I earlier reported that backing out the patch caused an fsx
> > test to fail earlier, I've since found great variation in how soon it
> > fails, and seen it fail just as quickly with 02fac1297eb3 still in.
> > I also reported that I had to go back to 2.6.38 for fsx not to fail
> > under memory pressure: you won't be surprised that that turned out to
> > be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_submit.
> 
> Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submit_io
> works well when blocksize < pagesize" ?  I have tried it and it does seem to
> help, but I am still running into some failures that I am trying to debug,
> but let please let us know if it helps the issues that you are seeing.  Thx!

That 1/2, or the 2/2 "ext4: let ext4_discard_partial_buffers handle
pages without buffers correctly"?  The latter is mostly a reversion
of your 02fac1297eb3, so that's the one I need to fix the oops and
rare data corruption.  Perhaps you're suggesting 1/2 for fsx failures
under memory pressure?

I've now tried the fsx test on three machines, with both 1/2 and 2/2
applied to 3.2-rc4.  On one machine, with ext2 on loop on tmpfs, the
fsx test failed in a couple of minutes with those patches; on another
machine, with ext2 on loop on tmpfs, it failed after about 40 minutes
with  the patches; on this laptop, with ext2 on SSD, it's just now
failed after 35 minutes with the patches.

That's not to say that Yongqiang's patches aren't good; but I cannot
detect whether they make any improvement or not, since lasting for 2 or
40 minutes is typical for fsx under memory pressure with recent kernels.

Hugh
