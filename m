From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 01:53:59 +0200
Message-ID: <20090825235359.GJ4300@elf.ucw.cz>
References: <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A947682.2010204@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Why don't you hold all of your most precious data on that single S-ATA 
> drive for five year on one box and put a second copy on a small RAID5 
> with ext3 for the same period?
>
> Repeat experiment until you get up to something like google scale or the 
> other papers on failures in national labs in the US and then we can have 
> an informed discussion.

I'm not interested in discussing statistics with you. I'd rather discuss
fsync() and storage design issues.

ext3 is designed to work on single SATA disks, and it is not designed
to work on flash cards/degraded MD RAID5s, as Ted acknowledged.

Because that fact is non obvious to the users, I'd like to see it
documented, and now have nice short writeup from Ted.

If you want to argue that ext3/MD RAID5/no UPS combination is still
less likely to fail than single SATA disk given part fail
probabilities, go ahead and present nice statistics. Its just that I'm
not interested in them.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
