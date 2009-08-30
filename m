From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Sun, 30 Aug 2009 10:12:06 -0400
Message-ID: <4A9A88B6.9050902@redhat.com>
References: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name> <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/30/2009 08:55 AM, david@lang.hm wrote:
> On Sun, 30 Aug 2009, Pavel Machek wrote:
>
>>>> From: Theodore Tso <tytso@mit.edu>
>>>>
>>> To use your ABS brakes analogy, just becase it's not safe to rely on
>>> ABS brakes if the "check brakes" light is on, that doesn't justify
>>> writing something alarmist which claims that ABS brakes don't work
>>> 100% of the time, don't use ABS brakes, they're broken!!!!
>>
>> If it only was this simple. We don't have 'check brakes' (aka
>> 'journalling ineffective') warning light. If we had that, I would not
>> have problem.
>>
>> It is rather that your ABS brakes are ineffective if 'check engine'
>> (RAID degraded) is lit. And yes, running with 'check engine' for
>> extended periods may be bad idea, but I know people that do
>> that... and I still hope their brakes work (and believe they should
>> have won suit for damages should their ABS brakes fail).
>
> the 'RAID degraded' warning says that _anything_ you put on that block 
> device is at risk. it doesn't matter if you are using a filesystem 
> with a journal, one without, or using the raw device directly.
>
> David Lang

The easiest way to lose your data in Linux - with RAID, without RAID, 
S-ATA or SAS - is to run with the write cache enabled.

If you compare the size of even a large RAID stripe it will be measured 
in KB and as this thread has mentioned already, you stand to have damage 
to just one stripe (or even just a disk sector or two).

If you lose power with the write caches enabled on that same 5 drive 
RAID set, you could lose as much as 5 * 32MB of freshly written data on  
a power loss (16-32MB write caches are common on s-ata disks these days).

For MD5 (and MD6), you really must run with the write cache disabled 
until we get barriers to work for those configurations.

It would be interesting for Pavel to retest with the write cache 
enabled/disabled on his power loss scenarios with multi-drive RAID.

Regards,

Ric



