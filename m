From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Thu, 27 Aug 2009 07:43:49 -0400
Message-ID: <4A967175.5070700@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751829AbZH0LoU@vger.kernel.org>
In-Reply-To: <200908262253.17886.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/26/2009 11:53 PM, Rob Landley wrote:
> On Tuesday 25 August 2009 18:40:50 Ric Wheeler wrote:
>    
>> Repeat experiment until you get up to something like google scale or the
>> other papers on failures in national labs in the US and then we can have an
>> informed discussion.
>>      
> On google scale anvil lightning can fry your machine out of a clear sky.
>
> However, there are still a few non-enterprise users out there, and knowing
> that specific usage patterns don't behave like they expect might be useful to
> them.
>
>    

You are missing the broader point of both papers. They (and people like 
me when back at EMC) look at large numbers of machines and try to fix 
what actually breaks when run in the real world and causes data loss. 
The motherboards, S-ATA controllers, disk types are the same class of 
parts that I have in my desktop box today.

The advantage of google, national labs, etc is that they have large 
numbers of systems and can draw conclusions that are meaningful to our 
broad user base.

Specifically, in using S-ATA drives (just like ours, maybe slightly more 
reliable) they see up to 7% of those drives fail each year.  All users 
have "soft" drive failures like single remapped sectors.

These errors happen extremely commonly and are what RAID deals with well.

What does not happen commonly is that during the RAID rebuild (kicked 
off only after a drive is kicked out), you push the power button or have 
a second failure (power outage).

We will have more users loose data if they decide to use ext2 instead of 
ext3 and use only single disk storage.

We have real numbers that show that is true. Injecting double faults 
into a system that handles single faults is frankly not that interesting.

You can get better protection from these double faults if you move to 
"cloud" like storage configs where each box is fault tolerant, but you 
also spread your data over multiple boxes in multiple locations.

Regards,

Ric

>>>> I can promise you that hot unplugging and replugging a S-ATA drive will
>>>> also lose you data if you are actively writing to it (ext2, 3,
>>>> whatever).
>>>>          
>>> I can promise you that running S-ATA drive will also lose you data,
>>> even if you are not actively writing to it. Just wait 10 years; so
>>> what is your point?
>>>        
>> I lost a s-ata drive 24 hours after installing it in a new box. If I had
>> MD5 RAID5, I would not have lost any.
>>
>> My point is that you fail to take into account the rate of failures of a
>> given configuration and the probability of data loss given those rates.
>>      
> Actually, that's _exactly_ what he's talking about.
>
> When writing to a degraded raid or a flash disk, journaling is essentially
> useless.  If you get a power failure, kernel panic, somebody tripping over a
> USB cable, and so on, your filesystem will not be protected by journaling.
> Your data won't be trashed _every_ time, but the likelihood is much greater
> than experience with journaling in other contexts would suggest.
>
> Worse, the journaling may be counterproductive by _hiding_ many errors that
> fsck would promptly detect, so when the error is detected it may not be
> associated with the event that caused it.  It also may not be noticed until
> good backups of the data have been overwritten or otherwise cycled out.
>
> You seem to be arguing that Linux is no longer used anywhere but the
> enterprise, so issues affecting USB flash keys or cheap software-only RAID
> aren't worth documenting?
>
> Rob
>    
