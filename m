From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] document flash/RAID dangers
Date: Sat, 29 Aug 2009 11:39:47 +0200
Message-ID: <20090829093947.GE1634@ucw.cz>
References: <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A94B8FE.8050307@redhat.com> <20090826112219.GE26595@elf.ucw.cz> <4A954A98.5070808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rik van Riel <riel@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A954A98.5070808@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 2009-08-26 10:45:44, Rik van Riel wrote:
> Pavel Machek wrote:
>
>> Sledgehammer is hardware problem, and I'm demonstrating
>> software/documentation problem we have here.
>
> So your argument is that a sledgehammer is a hardware
> problem, while a broken hard disk and a power failure
> are software/documentation issues?
>
> I'd argue that the broken hard disk and power failure
> are hardware issues, too.

Noone told me that degraded md raid5 is dangerous. Thats documentation
issue #1. Maybe I just pulled the disk for fun.

ext3 docs told me that journal protects me against fs corruption
during power fails. It does not in this particular case. Seems like
docs issue #2. Maybe I just hit the reset button because it was there.

Randomly hitting power button may be stupid, but should not result in
filesystem corruption on reasonably working filesystem/storage stack.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
