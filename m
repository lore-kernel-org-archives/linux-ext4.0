From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] e4defrag: fix build when posix_fadvise is missing
Date: Wed, 1 Jan 2014 21:08:00 +0200
Message-ID: <20140101190800.GA6589@tarshish>
References: <33245e3808058c72b66931ac14aea8d5dc6d1ba5.1388572103.git.baruch@tkos.co.il>
 <20140101172205.GC17519@thunk.org>
 <20140101173146.GM4470@tarshish>
 <20140101173744.GD17519@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:43498 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbaAATII (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jan 2014 14:08:08 -0500
Content-Disposition: inline
In-Reply-To: <20140101173744.GD17519@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Wed, Jan 01, 2014 at 12:37:44PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 01, 2014 at 07:31:46PM +0200, Baruch Siach wrote:
> > > Or do you mean that for some reason, uClibc is not providing
> > > posix_fadvise on all architectures, even though the kernel supports it?
> > > 
> > > That seems wierd.
> > 
> > The xtensa architecture has __NR_fadvise64_64 but not __NR_fadvise64. Should I 
> > clarify this in the commit log?
> 
> Is uClibc providing a posix_fadvise64()?

Yes. uClibc does provide posix_fadvise64() when __NR_fadvise64_64 is 
available.

> Maybe the better fix would be to try to use posix_fadvise64 if it is exists, 
> with posix_fadvise() and the locally defined posix_fadvise() as fallbacks.

OK. So you suggest to add another autoconf test for posix_fadvise64 and use 
that as a fall back before trying direct syscall()?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
