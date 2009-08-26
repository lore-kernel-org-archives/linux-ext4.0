From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 13:25:36 +0200
Message-ID: <20090826112535.GF26595@elf.ucw.cz>
References: <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <4A94812C.5010803@redhat.com> <20090826004430.GR4300@elf.ucw.cz> <alpine.DEB.2.00.0908251817390.30426@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908251817390.30426@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 2009-08-25 18:19:40, david@lang.hm wrote:
> On Wed, 26 Aug 2009, Pavel Machek wrote:
>
>>>>>> THESE devices have the property of potentially corrupting blocks being
>>>>>> written at the time of the power failure,
>>>>>
>>>>> this is true of all devices
>>>>
>>>> Actually I don't think so. I believe SATA disks do not corrupt even
>>>> the sector they are writing to -- they just have big enough
>>>> capacitors. And yes I believe ext3 depends on that.
>>>
>>> Pavel, no S-ATA drive has capacitors to hold up during a power failure
>>> (or even enough power to destage their write cache). I know this from
>>> direct, personal knowledge having built RAID boxes at EMC for years. In
>>> fact, almost all RAID boxes require that the write cache be hardwired to
>>> off when used in their arrays.
>>
>> I never claimed they have enough power to flush entire cache -- read
>> the paragraph again. I do believe the disks have enough capacitors to
>> finish writing single sector, and I do believe ext3 depends on that.
>
> keep in mind that in a powerfail situation the data being sent to the  
> drive may be corrupt (the ram gets flaky while a DMA to the drive copies  
> the bad data to the drive, which writes it before the power loss gets bad 
> enough for the drive to decide there is a problem and shutdown)
>
> you just plain cannot count on writes that are in flight when a powerfail 
> happens to do predictable things, let alone what you consider sane or  
> proper.

>From what I see, this kind of failure is rather harder to reproduce
than the software problems. And at least SGI machines were designed to
avoid this...

Anyway, I'd like to hear from ext3 people... what happens on read
errors in journal? That's what you'd expect to see in situation above.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
