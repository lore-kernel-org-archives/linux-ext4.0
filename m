From: Theodore Tso <tytso@mit.edu>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 15:42:23 -0500
Message-ID: <20081105204223.GC9266@mit.edu>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com> <20081103134008.GE29102@mit.edu> <319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com> <20081103165144.6514f003@starbug.prg01.itonis.net> <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr> <20081105195713.GB9266@mit.edu> <18705.64906.497902.219660@frecb006361.adech.frec.bull.fr> <18706.44.567787.592343@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Solofo.Ramangalahy@bull.net,
	Jindrich Makovicka <makovick@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60101 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757378AbYKEUm3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 15:42:29 -0500
Content-Disposition: inline
In-Reply-To: <18706.44.567787.592343@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 09:21:00PM +0100, Solofo.Ramangalahy@bull.net wrote:
> Solofo.Ramangalahy@bull.net writes:
>  >  > The next question is whether the problem is more easily triggerred
>  >  > when under memory pressure.
>  > 
>  > I was currently testing other kernels, but, right, I will retest with more memory.
> 
> with -m 2048 I do not observe the problem.
> 
> I should add that with 2.6.28-rc3 + ext4 patch queue, I am observing
> what seems to be lockdep bug:
> [   31.603020] BUG: key c9f315a8 not in .data!

Aneesh has some new patches in the ext4 patch queue that add new
lockdep annotations.  I'm guessing there's a problem there.  Aneesh,
can you look into this?  Solofo, can you send the .config you used
in case it was unique to replicating the problem?

						- Ted
