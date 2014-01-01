From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: fix build when posix_fadvise is missing
Date: Wed, 1 Jan 2014 15:46:50 -0500
Message-ID: <20140101204650.GE17519@thunk.org>
References: <33245e3808058c72b66931ac14aea8d5dc6d1ba5.1388572103.git.baruch@tkos.co.il>
 <20140101172205.GC17519@thunk.org>
 <20140101173146.GM4470@tarshish>
 <20140101173744.GD17519@thunk.org>
 <20140101190800.GA6589@tarshish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45019 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbaAAUqy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jan 2014 15:46:54 -0500
Content-Disposition: inline
In-Reply-To: <20140101190800.GA6589@tarshish>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 01, 2014 at 09:08:00PM +0200, Baruch Siach wrote:
> 
> Yes. uClibc does provide posix_fadvise64() when __NR_fadvise64_64 is 
> available.
> 
> > Maybe the better fix would be to try to use posix_fadvise64 if it is exists, 
> > with posix_fadvise() and the locally defined posix_fadvise() as fallbacks.
> 
> OK. So you suggest to add another autoconf test for posix_fadvise64 and use 
> that as a fall back before trying direct syscall()?

Yes, I think that's the more general and hence the more correct
answer.  In fact what we have right now is arguably wrong, since on a
32-bit platform where off_t is 32-bits, and which defines
posix_fadvise, we wouldn't correctly handle files that are larger than
2GB.  So if posix_fadvise64 exists, we should be using in preference
to posix_fadvise(), even if both are provided by the C library.

Would you mind sending such a revised patch?

Many thanks!!

						- Ted
