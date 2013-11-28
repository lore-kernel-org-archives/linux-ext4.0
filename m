From: Jan Kara <jack@suse.cz>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23 no space left on device
Date: Thu, 28 Nov 2013 12:33:01 +0100
Message-ID: <20131128113301.GC31516@quack.suse.cz>
References: <CAMuHMdWgMrNQqq84AK+CGF6VFnLs38O-vyye4MFKNUO7b8iFMw@mail.gmail.com>
 <20131127222345.GB27330@quack.suse.cz>
 <CAMuHMdWNvnKhJSBmR68EEMZHUuhzkAgWSLz=6eruhcfYKk2Y2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3K1LdD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Nov 2013 06:33:03 -0500
Content-Disposition: inline
In-Reply-To: <CAMuHMdWNvnKhJSBmR68EEMZHUuhzkAgWSLz=6eruhcfYKk2Y2A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-11-13 11:15:57, Geert Uytterhoeven wrote:
> On Wed, Nov 27, 2013 at 11:23 PM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 27-11-13 16:50:14, Geert Uytterhoeven wrote:
> >> To reduce kernel size, I disabled both CONFIG_EXT2_FS and
> >> CONFIG_EXT3_FS, and enabled CONFIG_EXT4_USE_FOR_EXT23.
> >>
> >> Unfortunately the system behaves badly afterwards. It seems the file system
> >> is considered full: new files can be created, but no data can be written.
> >> Note that the file system is almost full, but root can still write more data
> >> using the real ext3 filesystem driver.
> >>
> >> This is a v3.13-rc1-ish kernel.
> >>
> >> Diff of dmesg and output of a few operations below:
> >   Thanks for report. Maybe the easiest would be if you gathered fs metadata
> > using "e2image -r <fs-device>", compressed it and made it available for
> > download. We can then debug ourselves where the accounting goes wrong.
> 
> Dump from the live image, so it needs journal recovery:
> 
> http://users.telenet.be/geertu/Download/hda1.e2i.bz2
  Thanks. So I had a look and the difference is in ext4 block reservation
logic. ext4 stores away some blocks as reserved so that it can use them
as a safety pool in case it really needs to finish some metadata operations
and there isn't enough free space (see commit
27dd43854227bb0e6ab70129bd21b60d396db2e7 for detailed description).

However this block reservation isn't really needed when fs doesn't support
extents. So I'll send a patch in a moment which fixes the problem for me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
