From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 10:01:11 +0200
Message-ID: <20080421080111.GD14446@one.firstfloor.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:60202 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYDUHzj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 03:55:39 -0400
Content-Disposition: inline
In-Reply-To: <20080420234241.GB23292@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 12:42:42AM +0100, Jamie Lokier wrote:
> Andi Kleen wrote:
> > [LVM] always disables barriers if you don't apply a so far unmerged
> > patch that enables them in some special circumstances (only single
> > backing device)
> 
> (I continue to be surprised at the un-safety of Linux fsync)

Note barrier less does not necessarily always mean unsafe fsync,
it just often means that.

Also surprisingly lot more syncs or write cache off tend to lower the MTBF 
of your disk significantly, so "unsafer" fsync might actually be more safe
for your unbackuped data.

> > Not having barriers sometimes makes your workloads faster (and less
> > safe) and in other cases slower.
> 
> I'm curious, how does it make them slower?  Merely not issuing barrier
> calls seems like it will always be the same speed or faster.

Some setups detect the no barrier case and switch to full sync + wait 
(or write cache off) which depending on the disk supporting NCQ can be slower.

-Andi
