From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstests failure generic/299
Date: Sun, 14 Apr 2013 18:47:12 -0400
Message-ID: <20130414224712.GC12542@thunk.org>
References: <nsxvc7ra2cv.fsf@closure.thunk.org>
 <87sj2uokzc.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34197 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3DNWrS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Apr 2013 18:47:18 -0400
Content-Disposition: inline
In-Reply-To: <87sj2uokzc.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 13, 2013 at 01:09:27PM +0400, Dmitry Monakhov wrote:
> >      Run fio with random aio-dio pattern
> >      
> >      Start fallocate/truncate loop
> >     +./common/rc: line 2055:  3353 Segmentation fault      "$@" >>
> Yes, this is known issue. I probably use recent fio.git/HEAD
> Jens does a good job on developing fio, but he tend to commit random
> untested crap to his git. So stability is worse than it should be.
> I have golden-good commit (aeb32dfccbd05) which works for me, and suggest
> to use it.

Hmm... I just tried recompiling fio to git commit version
aeb32dfccbd05, and it's blowing up with a seg fault as well.

One thing about my test environment is that I'm building xfstests and
fio on a 32-bit x86 environemnt (because that way I can use an 32-bit
kernel, and because when I use a 64-bit kernel I stress test the
64-bit compatibility code paths).  Perhaps this has something to do
with it?

Unfortunately, I don't have the time to debug this, so at least for
now I'm going to exclude generic/299 from my automated test runs.

    	      	 	 	     	  - Ted
