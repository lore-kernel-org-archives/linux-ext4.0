From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 20:26:20 -0400
Message-ID: <4A94812C.5010803@redhat.com>
References: <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbZHZA1M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 20:27:12 -0400
In-Reply-To: <20090826001206.GL4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 08:12 PM, Pavel Machek wrote:
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

Than you should punt the MD discussion to the MD documentation entirely.

I would suggest:

"Users of any file system that have a single media (SSD, flash or normal disk) 
can suffer from catastrophic and complete data loss if that single media fails. 
To reduce your exposure to data loss after a single point of failure, consider 
using either hardware or properly configured software RAID. See the 
documentation on MD RAID for how to configure it.

To insure proper fsync() semantics, you will need to have a storage device that 
supports write barriers or have a non-volatile write cache. If not, best 
practices dictate disabling the write cache on the storage device."

>
>>> THESE devices have the property of potentially corrupting blocks being
>>> written at the time of the power failure,
>>
>> this is true of all devices
>
> Actually I don't think so. I believe SATA disks do not corrupt even
> the sector they are writing to -- they just have big enough
> capacitors. And yes I believe ext3 depends on that.
> 								Pavel

Pavel, no S-ATA drive has capacitors to hold up during a power failure (or even 
enough power to destage their write cache). I know this from direct, personal 
knowledge having built RAID boxes at EMC for years. In fact, almost all RAID 
boxes require that the write cache be hardwired to off when used in their arrays.

Drives fail partially on a very common basis - look at your remapped sector 
count with smartctl.

RAID (including MD RAID5) will protect you from this most common error as it 
will protect you from complete drive failure which is also an extremely common 
event.

Your scenario is really, really rare - doing a full rebuild after a complete 
drive failure (takes a matter of hours, depends on the size of the disk) and 
having a power failure during that rebuild.

Of course adding a UPS to any storage system (including MD RAID system) helps 
make it more reliable, specifically in your scenario.

The more important point is that having any RAID (MD1, MD5 or MD6) will greatly 
reduce your chance of data loss if configured correctly. With ext3, ext2 or zfs.

Ric

