From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 02:44:31 +0200
Message-ID: <20090826004430.GR4300@elf.ucw.cz>
References: <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <4A94812C.5010803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A94812C.5010803@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>>>> THESE devices have the property of potentially corrupting blocks being
>>>> written at the time of the power failure,
>>>
>>> this is true of all devices
>>
>> Actually I don't think so. I believe SATA disks do not corrupt even
>> the sector they are writing to -- they just have big enough
>> capacitors. And yes I believe ext3 depends on that.
>
> Pavel, no S-ATA drive has capacitors to hold up during a power failure 
> (or even enough power to destage their write cache). I know this from 
> direct, personal knowledge having built RAID boxes at EMC for years. In 
> fact, almost all RAID boxes require that the write cache be hardwired to 
> off when used in their arrays.

I never claimed they have enough power to flush entire cache -- read
the paragraph again. I do believe the disks have enough capacitors to
finish writing single sector, and I do believe ext3 depends on that.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
