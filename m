From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Mon, 13 Aug 2012 14:40:53 -0400
Message-ID: <20120813184053.GE32484@thunk.org>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
 <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
 <20120813032243.GB13072@thunk.org>
 <20120813173224.GF9117@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44470 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2HMSlE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 14:41:04 -0400
Content-Disposition: inline
In-Reply-To: <20120813173224.GF9117@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 13, 2012 at 10:32:24AM -0700, Zach Brown wrote:
> >     we allow it to be tunable via sysfs and set an initial default value
> >     of 32, so instead of creating uninitalized extents smaller than
> 
> s/32/16/?

Oops, nice catch.

> It'd be nice to define the tunable in terms of some fixed unit, kb or
> mb, whatever, and then translate to the block size in the code so people
> don't have to do that math by hand.
> 
> No?

Agreed, thanks for the suggestion.  The next question is whether the
default maximum zero-out size should be 256k (as previously
documented) or 128k (as previously coded).

The previously rule of thumb which I had used was that after doing a
random seek, the time needed to write 4k and 32k was pretty much in
the noise.  But that was a number from several years ago.  I suppose I
should do some quick experiments to see what is a good number these
days....

						- Ted
