From: david@lang.hm
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 17:20:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251718141.28411@asgard.lang.hm>
References: <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz>
 <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:43565 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZHZAVT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 20:21:19 -0400
In-Reply-To: <20090826001206.GL4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Aug 2009, Pavel Machek wrote:

> On Tue 2009-08-25 16:56:40, david@lang.hm wrote:
>> On Wed, 26 Aug 2009, Pavel Machek wrote:
>>
>>> There are storage devices that high highly undesirable properties
>>> when they are disconnected or suffer power failures while writes are
>>> in progress; such devices include flash devices and MD RAID 4/5/6
>>> arrays.
>>
>> change this to say 'degraded MD RAID 4/5/6 arrays'
>>
>> also find out if DM RAID 4/5/6 arrays suffer the same problem (I strongly
>> suspect that they do)
>
> I changed it to say MD/DM.
>
>> then you need to add a note that if the array becomes degraded before a
>> scrub cycle happens previously hidden damage (that would have been
>> repaired by the scrub) can surface.
>
> I'd prefer not to talk about scrubing and such details here. Better
> leave warning here and point to MD documentation.

I disagree with that, the way you are wording this makes it sound as if 
raid isn't worth it. if you are going to say that raid is risky you need 
to properly specify when it is risky

>>> THESE devices have the property of potentially corrupting blocks being
>>> written at the time of the power failure,
>>
>> this is true of all devices
>
> Actually I don't think so. I believe SATA disks do not corrupt even
> the sector they are writing to -- they just have big enough
> capacitors. And yes I believe ext3 depends on that.

you are incorrect on this.

ext3 (like every other filesystem) just accepts the risk (zfs makes some 
attempt to detect such corruption)

David Lang
