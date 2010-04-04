From: tytso@mit.edu
Subject: Re: fsck more often when powerfail is detected (was Re: wishful
 thinking about atomic, multi-sector or full MD stripe width, writes in
 storage)
Date: Sun, 4 Apr 2010 15:35:02 -0400
Message-ID: <20100404193502.GI18524@thunk.org>
References: <20090831132139.GA5425@infradead.org>
 <20090907131026.GC32427@mit.edu>
 <20100404134729.GA1388@ucw.cz>
 <201004041259.18741.rob@landley.net>
 <20100404184546.GA18873@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, Ric Wheeler <rwheeler@redhat.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	NeilBrown <neilb@suse.de>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100404184546.GA18873@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 04, 2010 at 08:45:46PM +0200, Pavel Machek wrote:
> 
> I'm not sure of what right intervals between check are for you, but
> I'd say that fsck once a year or every 100 mounts or every 10 power
> failures is probably good idea for everybody...

For people using e2croncheck, where you can check it when the system
is idle and without needing to do a power cycle, I'd recommend once a
week, actually.

> > hours of downtime due to the system deciding to fsck itself, and I
> > don't know a Linux laptop user anywhere who would be happy to fire
> > up their laptop and suddenly be told "oh, you can't do anything
> > with it for two hours, and you can't power it down either".
> 
> On laptop situation is easy. Pull the plug, hit reset, wait for fsck,
> plug AC back in. Done that, too :-).

Some distributions will allow you to cancel an fsck; either by using
^C, or hitting escape.  That's a matter for the boot scripts, which
are distribution specific.  Ubuntu has a way of doing this, for
example, if I recall correctly --- although since I've started using
e2croncheck, I've never had an issue with an e2fsck taking place on
bootup.  Also, ext4, fscks are so much much faster that even before I
upgraded to using an SSD, it's never been an issue for me.  It's
certainly not hours any more....

> Yep, it would be nice if fsck had "escape" button.

Complain to your distribution.  :-)

Or this is Linux and open source; fix it yourself, and submit the
patches back to your distribution.  If all you want to do is whine,
then maybe Rob's choice is the best way, go switch to the velvet-lined
closed system/jail which is the Macintosh.  :-)

(I created e2croncheck to solve my problem; if that isn't good enough
for you, I encourage you to find/create your own fixes.)

							- Ted
