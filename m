From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 02:39:26 +0200
Message-ID: <20090826003926.GQ4300@elf.ucw.cz>
References: <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <alpine.DEB.2.00.0908251718141.28411@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbZHZAje (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 20:39:34 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908251718141.28411@asgard.lang.hm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 2009-08-25 17:20:13, david@lang.hm wrote:
> On Wed, 26 Aug 2009, Pavel Machek wrote:
>
>> On Tue 2009-08-25 16:56:40, david@lang.hm wrote:
>>> On Wed, 26 Aug 2009, Pavel Machek wrote:
>>>
>>>> There are storage devices that high highly undesirable properties
>>>> when they are disconnected or suffer power failures while writes are
>>>> in progress; such devices include flash devices and MD RAID 4/5/6
>>>> arrays.
>>>
>>> change this to say 'degraded MD RAID 4/5/6 arrays'
>>>
>>> also find out if DM RAID 4/5/6 arrays suffer the same problem (I strongly
>>> suspect that they do)
>>
>> I changed it to say MD/DM.
>>
>>> then you need to add a note that if the array becomes degraded before a
>>> scrub cycle happens previously hidden damage (that would have been
>>> repaired by the scrub) can surface.
>>
>> I'd prefer not to talk about scrubing and such details here. Better
>> leave warning here and point to MD documentation.
>
> I disagree with that, the way you are wording this makes it sound as if  
> raid isn't worth it. if you are going to say that raid is risky you need  
> to properly specify when it is risky

Ok, would this help? I don't really want to go to scrubbing details.

(*) Degraded array or single disk failure "near" the powerfail is
neccessary for this property of RAID arrays to bite.

>>>> THESE devices have the property of potentially corrupting blocks being
>>>> written at the time of the power failure,
>>>
>>> this is true of all devices
>>
>> Actually I don't think so. I believe SATA disks do not corrupt even
>> the sector they are writing to -- they just have big enough
>> capacitors. And yes I believe ext3 depends on that.
>
> you are incorrect on this.
>
> ext3 (like every other filesystem) just accepts the risk (zfs makes some  
> attempt to detect such corruption)

I'd like Ted to comment on this. He wrote the original document, and
I'd prefer not to introduce mistakes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
