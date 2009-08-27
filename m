From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Thu, 27 Aug 2009 09:46:27 +0100
Message-ID: <1251362787.4354.373.camel@macbook.infradead.org>
References: <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de>
	 <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz>
	 <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz>
	 <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz>
	 <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz>
	 <20090825000842.GM17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36303 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZH0Iqx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 04:46:53 -0400
In-Reply-To: <20090825000842.GM17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-08-24 at 20:08 -0400, Theodore Tso wrote:
> 
> (It's worse with people using Digital SLR's shooting in raw mode,
> since it can take upwards of 30 seconds or more to write out a 12-30MB
> raw image, and if you eject at the wrong time, you can trash the
> contents of the entire CF card; in the worst case, the Flash
> Translation Layer data can get corrupted, and the card is completely
> ruined; you can't even reformat it at the filesystem level, but have
> to get a special Windows program from the CF manufacturer to --maybe--
> reset the FTL layer.

This just goes to show why having this "translation layer" done in
firmware on the device itself is a _bad_ idea. We're much better off
when we have full access to the underlying flash and the OS can actually
see what's going on. That way, we can actually debug, fix and recover
from such problems.

>   Early CF cards were especially vulnerable to
> this; more recent CF cards are better, but it's a known failure mode
> of CF cards.)

It's a known failure mode of _everything_ that uses flash to pretend to
be a block device. As I see it, there are no SSD devices which don't
lose data; there are only SSD devices which haven't lost your data
_yet_.

There's no fundamental reason why it should be this way; it just is.

(I'm kind of hoping that the shiny new expensive ones that everyone's
talking about right now, that I shouldn't really be slagging off, are
actually OK. But they're still new, and I'm certainly not trusting them
with my own data _quite_ yet.)

-- 
dwmw2

