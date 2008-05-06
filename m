From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem mounting ext2 using ext3?
Date: Tue, 6 May 2008 08:05:44 -0400
Message-ID: <20080506120544.GB6918@mit.edu>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu> <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52040 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123AbYEFMGD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2008 08:06:03 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 06, 2008 at 09:26:30AM +0200, Vegard Nossum wrote:
> 
> I posted a very similar problem a couple of days ago:
> http://www.nabble.com/BUG-in-ext3_sync_fs-td16999997.html
> 
> to which I got zero replies. Can I close this in my internal bugzilla
> as dup/"not my fault"? The stacktrace looks very similar. This was
> also ext2 fs mounted (apparently) by ext3 code.

Yeah, sorry, I didn't have network access when I looked at your
e-mail, and so I didn't see the stack trace until you pointed at the
mail message again.  Because you mentioned a USB stick, I assumed it
was the problem with a USB stick getting pulled or being loose causing
an I/O error leading to an oops problem, and I missed the hint of the
problem occurring in the ext3 code when you were using an ext2
formattem.  Fortunately when Geert reported the bug a second time, I
was less dense at the time, and figured it out quickly.  :-)

							- Ted
