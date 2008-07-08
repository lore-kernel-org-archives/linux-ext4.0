From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 9 Jul 2008 01:20:31 +0200
Message-ID: <20080708232031.GE18195@elf.ucw.cz>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33513 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257AbYGHXTi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 19:19:38 -0400
Content-Disposition: inline
In-Reply-To: <20080708231026.GP11558@disturbed>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 2008-07-09 09:10:27, Dave Chinner wrote:
> On Mon, Jul 07, 2008 at 01:07:31PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > I still disagree with this whole patch.  There is not reason to let
> > > the freeze request timeout - an auto-unfreezing will only confuse the
> > > hell out of the caller.  The only reason where the current XFS freeze
> > > call can hang and this would be theoretically useful is when the
> > 
> > What happens when someone dirties so much data that vm swaps out
> > whatever process that frozen the filesystem?
> 
> a) you can't dirty a frozen filesystem - by definition a frozen
>    filesystem is a *clean filesystem* and *cannot be dirtied*.

Can you stop me?

mmap("/some/huge_file", MAP_SHARED);

then write to memory mapping?

> b) Swap doesn't write through the filesystem
> c) you can still read from a frozen filesystem to page your
>    executable?? in.

atime modification should mean dirty data, right? And dirty data mean
memory pressure, right? 

> d) if dirtying another unfrozen filesystem swaps out your
                 ~~~~~~~
>    application so it can't run, then there's a major VM bug.
>    Regardless, until the app completes it is relying on the
>    filesystem being frozen, so it better remain frozen....

Agreed. With emphasis on "another".

> > I though that was why the timeout was there...
> 
> Not that I know of. 

Ok, lets see how you deal with mmap.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
