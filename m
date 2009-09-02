From: Pavel Machek <pavel@ucw.cz>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Wed, 2 Sep 2009 22:55:58 +0200
Message-ID: <20090902205558.GB2398@elf.ucw.cz>
References: <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.01.0908300152490.5744@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908300152490.5744@bogon.housecafe.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 2009-08-30 02:01:10, Christian Kujau wrote:
> On Sun, 30 Aug 2009 at 09:51, Pavel Machek wrote:
> > > give system administrators.  It's better than the fear-mongering
> > > patches you had proposed earlier, but what would be better *still* is
> > > telling people why running with degraded RAID arrays is bad, and to
> > > give them further tips about how to use RAID arrays safely.
> > 
> > Maybe this belongs to Doc*/filesystems, and more detailed RAID
> > description should go to md description?
> 
> Why should this be placed in *kernel* documentation anyway? The "dangers 
> of RAID", the hints that "backups are a good idea" - isn't that something 
> for howtos for sysadmins? No end-user will ever look into

The fact that two kernel subsystems (MD RAID, journaling filesystems)
do not work well together is surprising and should be documented near
the source.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
