From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Sun, 30 Aug 2009 12:10:54 -0400
Message-ID: <4A9AA48E.5070309@redhat.com>
References: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name> <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Pavel Machek <pavel@ucw.cz>,
	Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZH3QKw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 12:10:52 -0400
In-Reply-To: <4A9A9034.8000703@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/30/2009 10:44 AM, Michael Tokarev wrote:
> Ric Wheeler wrote:
> []
>> The easiest way to lose your data in Linux - with RAID, without RAID, 
>> S-ATA or SAS - is to run with the write cache enabled.
>>
>> If you compare the size of even a large RAID stripe it will be 
>> measured in KB and as this thread has mentioned already, you stand to 
>> have damage to just one stripe (or even just a disk sector or two).
>>
>> If you lose power with the write caches enabled on that same 5 drive 
>> RAID set, you could lose as much as 5 * 32MB of freshly written data 
>> on  a power loss (16-32MB write caches are common on s-ata disks 
>> these days).
>
> This is fundamentally wrong.  Many filesystems today use either barriers
> or flushes (if barriers are not supported), and the times when disk 
> drives
> were lying to the OS that the cache got flushed are long gone.
Unfortunately not - if you mount a file system with write cache enabled 
and see "barriers disabled" messages in /var/log/messages, this is 
exactly what happens.

File systems issue write barrier operations that in turn do cache 
flushes (ATA_FLUSH_EXT) commands or its SCSI  equivalent.

MD5 and MD6 do not pass these operations on currently and there is no 
other file system level mechanism that somehow bypasses the IO stack to 
invalidate or flush the cache.

Note that some devices have non-volatile write caches (specifically 
arrays or battery backed RAID cards) where this is not an issue.


>
>> For MD5 (and MD6), you really must run with the write cache disabled 
>> until we get barriers to work for those configurations.
>
> I highly doubt barriers will ever be supported on anything but simple
> raid1, because it's impossible to guarantee ordering across multiple
> drives.  Well, it *is* possible to have write barriers with journalled
> (and/or with battery-backed-cache) raid[456].
>
> Note that even if raid[456] does not support barriers, write cache
> flushes still works.
>
> /mjt

I think that you are confused - barriers are implemented using cache 
flushes.

Ric


