From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Problem mounting ext2 using ext3?
Date: Tue, 6 May 2008 09:11:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805060910320.3160@anakin>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edna.telenet-ops.be ([195.130.132.58]:49924 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYEFHLP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2008 03:11:15 -0400
In-Reply-To: <20080505222623.GA8357@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	Hi Ted,

On Mon, 5 May 2008, Theodore Tso wrote:
> On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
> > when mounting the root file system, which is ext2 (has_journal is not set).
> > Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
> > 
> > At first I thought it was an issue with the byteswapped IDE bus on Atari (a
> > new and different solution to handle this just went into mainline), but if I
> > disable CONFIG_EXT3 support, it boots up fine.
> > 
> > Is this a known problem?
> 
> I can confirm this as a regression.  You don't even need to mount it

Thanks for confirming!

> as a root filesystem, or do this on an 68k system.  On my x86 system,

That's all I had available for a quick test ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
