From: "Kosta Kliakhandler" <kostak@gmail.com>
Subject: Re: fsck 1.39 segfaults while fixing a corrupt inode
Date: Sat, 11 Aug 2007 02:52:15 +0300
Message-ID: <a73860e00708101652s2d4a72fgcb51a35df66863f@mail.gmail.com>
References: <a73860e00708100534x312291et77e39b4f7ebe32b4@mail.gmail.com>
	 <20070810125232.GQ6689@schatzie.adilger.int>
	 <a73860e00708101648h502ae025pc02f113100316a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Andreas Dilger" <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:45969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXHJXwR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 19:52:17 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1054594wah
        for <linux-ext4@vger.kernel.org>; Fri, 10 Aug 2007 16:52:16 -0700 (PDT)
In-Reply-To: <a73860e00708101648h502ae025pc02f113100316a0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks man!

I'm now finally writing this from firefox and not from links :)

If you care to know, I found the 1.40.1 patches in the testing dir,
and applied only the extents patch to 1.40.2, and then build it and
ran e2fsck, which worked fine and found and fixed lots of
corruption...

as for the block that was giving problems last time, it now said that
it's position is in -1 instead of 0, so I guess this is what caused
problems..

Best regards,
Kosta.



>  On 8/10/07, Andreas Dilger <adilger@clusterfs.com> wrote:
> >  On Aug 10, 2007  15:34 +0300, Kosta Kliakhandler wrote:
> > > I have a severe problem - I was a fool and made / (root) ext4 (at
> > > least not /home, thank god) and somehow some corruption occured.
> > > While running fsck, it keeps segfaulting, complaining about fast
> > > memory corruption (segfaults always at the same inode, always when I
> > > tell it to fix it). I *think* the issue was addressed in
> > > e2fsprogs-1.40.2 (from what I understood in the changelog) - but I
> >  > can't find a patchset for it...
> > > I tried to do the 1.39 patch on the 1.40.2 source but there were more
> > > then a few mismatches and it didn't build. with enough work, I might
> > > be able to build it, but I strongly prefer a ready patch/tarball which
> > > I know will work and I haven't found any on the net.
> > >
> > > Can anyone please point me to one or send one to me, or advise on a
> > > different solution?
> >
> > Try  ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/
> >
> > Cheers, Andreas
> > --
> > Andreas Dilger
> > Principal Software Engineer
> > Cluster File Systems, Inc.
