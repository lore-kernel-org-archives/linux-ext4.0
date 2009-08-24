From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 18:39:15 -0400
Message-ID: <20090824223915.GI17684@mit.edu>
References: <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090824212518.GF29763@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 24, 2009 at 11:25:19PM +0200, Pavel Machek wrote:
> > I have to admit that I have not paid enough attention to this specifics  
> > of your ext3 + flash card issue - is it the ftl stuff doing out of order  
> > IO's? 
> 
> The problem is that flash cards destroy whole erase block on unplug,
> and ext3 can't cope with that.

Sure --- but name **any** filesystem that can deal with the fact that
128k or 256k worth of data might disappear when you pull out the flash
card while it is writing a single sector? 

> > Your statement is overly broad - ext3 on a commercial RAID array that  
> > does RAID5 or RAID6, etc has no issues that I know of.
> 
> If your commercial RAID array is battery backed, maybe. But I was
> talking Linux MD here.

It's not just high end RAID arrays that have battery backups; I happen
to use a mid-range hardware RAID card that comes with a battery
backup.   It's just a matter of choosing your hardware carefully.

If your concern is that with Linux MD, you could potentially lose an
entire stripe in RAID 5 mode, then you should say that explicitly; but
again, this isn't a filesystem specific cliam; it's true for all
filesystems.  I don't know of any file system that can survive having
a RAID stripe-shaped-hole blown into the middle of it due to a power
failure.

I'll note, BTW, that AIX uses a journal to protect against these sorts
of problems with software raid; this also means that with AIX, you
also don't have to rebuild a RAID 1 device after an unclean shutdown,
like you have do with Linux MD.  This was on the EVMS's team
development list to implement for Linux, but it got canned after LVM
won out, lo those many years ago.  Ce la vie; but it's a problem which
is solvable at the RAID layer, and which is traditionally and
historically solved in competent RAID implementations.

							- Ted
