From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Problem mounting ext2 using ext3?
Date: Tue, 6 May 2008 21:05:01 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805062104370.6341@anakin>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu>
 <20080506100216.GB1409@duck.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wilson.telenet-ops.be ([195.130.132.42]:42971 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729AbYEFTFH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2008 15:05:07 -0400
In-Reply-To: <20080506100216.GB1409@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 May 2008, Jan Kara wrote:
> On Mon 05-05-08 18:26:23, Theodore Tso wrote:
> > On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
> > > when mounting the root file system, which is ext2 (has_journal is not set).
> > > Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
> > > 
> > > At first I thought it was an issue with the byteswapped IDE bus on Atari (a
> > > new and different solution to handle this just went into mainline), but if I
> > > disable CONFIG_EXT3 support, it boots up fine.
> > > 
> > > Is this a known problem?
> > 
> > I can confirm this as a regression.  You don't even need to mount it
> > as a root filesystem, or do this on an 68k system.  On my x86 system,
> > using a kernel based off of git commit: afa26be8 (6 commits after
> > 2.6.26-rc1), mounting an ext3 filesystem, you can cause an oops by
> > taking an ext2 filesystem and forcing a mount as ext3, "mount -t ext3
> > /dev/closure/textext2fs /mnt").  (see below for my oops).  This does
> > not occur with a kernel based off of 2.6.25, so it's a definite
> > regression.
> > 
> > Looks like the problem is some of the recent quota cleanups.  The
> > problem is that ext3_fill_super is returning an error, because the
> > journal is missing.  get_sb_dev() calls ext3_fill_super, and upon
> > receiving an error, it is calling deactivate_super(), which calls:
> > 
> > 	     DQUOT_OFF(s, 0);
> > 
> > (line 182 in fs/super.c, in deactivate_super(), recently modified just
> > after 2.6.25, at comment 0ff5af8340aa6be44220d7237ef4a654314cf795,
> > although I'm not sure this is actually the problem commit)).  
> > 
> > The blow up is happening because the because superblock was not fully
> > set up, and the comment in the commit involved mentioned cleaning up
> > what is supposed to happen when remounting a filesystem turning quota
> > on or off.  I'm guessing that the changes didn't take into account
> > that DQUOT_OFF() can get called with a partially set-up superblock,
> > which will happen when the filesystme specific get_sb() code refuses a
> > mount and returns an error.
> > 
> > Jan, can you take a look at this and confirm whether or not this is
> > the root cause of the crash?
>   Thanks Ted for looking into this. Yes, the problem is caused by my
> modifications to quota code... The patch below fixes it for me and I've
> also added a comment so that someone does not remove the check again in
> future ;).

Thanks Jan! Your patch fixed my problem.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
