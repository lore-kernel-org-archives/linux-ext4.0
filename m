From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Tue, 6 Dec 2011 14:47:02 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112061432000.1949@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
 <4EDD729E.2060402@linux.vnet.ibm.com> <alpine.LSU.2.00.1112060030220.1615@sister.anvils> <4EDE85F4.4020503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ted Ts'o <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54340 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1LFWrY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 17:47:24 -0500
Received: by iakc1 with SMTP id c1so4336416iak.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 14:47:23 -0800 (PST)
In-Reply-To: <4EDE85F4.4020503@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Dec 2011, Allison Henderson wrote:
> On 12/06/2011 01:55 AM, Hugh Dickins wrote:
> > On Mon, 5 Dec 2011, Allison Henderson wrote:
> > > 
> > > Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submit_io
> > > works well when blocksize<  pagesize" ?  I have tried it and it does
> > > seem to
> > > help, but I am still running into some failures that I am trying to
> > > debug,
> > > but let please let us know if it helps the issues that you are seeing.
> > > Thx!
> > 
> > That 1/2, or the 2/2 "ext4: let ext4_discard_partial_buffers handle
> > pages without buffers correctly"?  The latter is mostly a reversion
> > of your 02fac1297eb3, so that's the one I need to fix the oops and
> > rare data corruption.  Perhaps you're suggesting 1/2 for fsx failures
> > under memory pressure?
> > 
> > I've now tried the fsx test on three machines, with both 1/2 and 2/2
> > applied to 3.2-rc4.  On one machine, with ext2 on loop on tmpfs, the
> > fsx test failed in a couple of minutes with those patches; on another
> > machine, with ext2 on loop on tmpfs, it failed after about 40 minutes
> > with  the patches; on this laptop, with ext2 on SSD, it's just now
> > failed after 35 minutes with the patches.
> > 
> > That's not to say that Yongqiang's patches aren't good; but I cannot
> > detect whether they make any improvement or not, since lasting for 2 or
> > 40 minutes is typical for fsx under memory pressure with recent kernels.
> 
> 
> Well, initially I meant to just try the whole set, but now that I try just
> one of them, I find that I get further with only the first one.  I think
> Yongqiang and I have a similar set up because I get the hang if I dont have
> the first patch, and I get the fsx write failure (in about 20 or so minutes)
> if I have the second one.  But I think Yongqiang's right, we need to figure
> out why the page is uptodate when it shouldn't be.

I've not seen a hang myself.  I'm reluctant to drop the second patch,
since it appears to fix the real problems (oops and corruption) that
I have seen, and fsx fails with or without it; but I don't know whether
it's any better than simply reverting yours.

I would certainly like fsx under memory pressure to be reliable again -
that will help all our testing of new changes; but I think it's more
urgent to get normal loads to be reliable again.

If you can call building on -t ext2 -b 1024 under memory pressure normal ;)

Hugh
