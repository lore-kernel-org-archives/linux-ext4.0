From: Rob Landley <rob@landley.net>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Wed, 26 Aug 2009 22:53:16 -0500
Message-ID: <200908262253.17886.rob@landley.net>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752968AbZH0Dxl@vger.kernel.org>
In-Reply-To: <4A947682.2010204@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 25 August 2009 18:40:50 Ric Wheeler wrote:
> Repeat experiment until you get up to something like google scale or the
> other papers on failures in national labs in the US and then we can have an
> informed discussion.

On google scale anvil lightning can fry your machine out of a clear sky.

However, there are still a few non-enterprise users out there, and knowing 
that specific usage patterns don't behave like they expect might be useful to 
them.

> >> I can promise you that hot unplugging and replugging a S-ATA drive will
> >> also lose you data if you are actively writing to it (ext2, 3,
> >> whatever).
> >
> > I can promise you that running S-ATA drive will also lose you data,
> > even if you are not actively writing to it. Just wait 10 years; so
> > what is your point?
>
> I lost a s-ata drive 24 hours after installing it in a new box. If I had
> MD5 RAID5, I would not have lost any.
>
> My point is that you fail to take into account the rate of failures of a
> given configuration and the probability of data loss given those rates.

Actually, that's _exactly_ what he's talking about.

When writing to a degraded raid or a flash disk, journaling is essentially 
useless.  If you get a power failure, kernel panic, somebody tripping over a 
USB cable, and so on, your filesystem will not be protected by journaling.  
Your data won't be trashed _every_ time, but the likelihood is much greater 
than experience with journaling in other contexts would suggest.

Worse, the journaling may be counterproductive by _hiding_ many errors that 
fsck would promptly detect, so when the error is detected it may not be 
associated with the event that caused it.  It also may not be noticed until 
good backups of the data have been overwritten or otherwise cycled out.

You seem to be arguing that Linux is no longer used anywhere but the 
enterprise, so issues affecting USB flash keys or cheap software-only RAID 
aren't worth documenting?

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
