From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: fix build when posix_fadvise is missing
Date: Wed, 1 Jan 2014 12:37:44 -0500
Message-ID: <20140101173744.GD17519@thunk.org>
References: <33245e3808058c72b66931ac14aea8d5dc6d1ba5.1388572103.git.baruch@tkos.co.il>
 <20140101172205.GC17519@thunk.org>
 <20140101173146.GM4470@tarshish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44957 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbaAARhs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jan 2014 12:37:48 -0500
Content-Disposition: inline
In-Reply-To: <20140101173146.GM4470@tarshish>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 01, 2014 at 07:31:46PM +0200, Baruch Siach wrote:
> > Or do you mean that for some reason, uClibc is not providing
> > posix_fadvise on all architectures, even though the kernel supports it?
> > 
> > That seems wierd.
> 
> The xtensa architecture has __NR_fadvise64_64 but not __NR_fadvise64. Should I 
> clarify this in the commit log?

Is uClibc providing a posix_fadvise64()?  Maybe the better fix would be
to try to use posix_fadvise64 if it is exists, with posix_fadvise()
and the locally defined posix_fadvise() as fallbacks.

If not, why is uClibc not providing any userspace access to
posix_fadvise, if the kernel suppots it, and it's insisting on
providing a function delcaration for it?

						- Ted
