From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fsck 1.39 segfaults while fixing a corrupt inode
Date: Fri, 10 Aug 2007 06:52:32 -0600
Message-ID: <20070810125232.GQ6689@schatzie.adilger.int>
References: <a73860e00708100534x312291et77e39b4f7ebe32b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kosta Kliakhandler <kostak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:58696 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbXHJMwb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 08:52:31 -0400
Content-Disposition: inline
In-Reply-To: <a73860e00708100534x312291et77e39b4f7ebe32b4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 10, 2007  15:34 +0300, Kosta Kliakhandler wrote:
> I have a severe problem - I was a fool and made / (root) ext4 (at
> least not /home, thank god) and somehow some corruption occured.
> While running fsck, it keeps segfaulting, complaining about fast
> memory corruption (segfaults always at the same inode, always when I
> tell it to fix it). I *think* the issue was addressed in
> e2fsprogs-1.40.2 (from what I understood in the changelog) - but I
> can't find a patchset for it...
> I tried to do the 1.39 patch on the 1.40.2 source but there were more
> then a few mismatches and it didn't build. with enough work, I might
> be able to build it, but I strongly prefer a ready patch/tarball which
> I know will work and I haven't found any on the net.
> 
> Can anyone please point me to one or send one to me, or advise on a
> different solution?

Try ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
