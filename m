From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 21:15:00 -0400
Message-ID: <4A948C94.7040103__27790.7993914143$1251249444$gmane$org@redhat.com>
References: <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <r
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbZHZBP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 21:15:59 -0400
In-Reply-To: <20090826010018.GA17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 09:00 PM, Theodore Tso wrote:
> On Tue, Aug 25, 2009 at 08:31:21PM -0400, Ric Wheeler wrote:
>    
>>>> You are simply incorrect, Ted did not say that ext3 does not work
>>>> with MD raid5.
>>>>          
>>> http://lkml.org/lkml/2009/8/25/312
>>> 									Pavel
>>>        
>> I will let Ted clarify his text on his own, but the quoted text says "...
>> have potential...".
>>
>> Why not ask Neil if he designed MD to not work properly with ext3?
>>      
> So let me clarify by saying the following things.
>
> 1) Filesystems are designed to expect that storage devices have
> certain properties.  These include returning the same data that you
> wrote, and that an error when writing a sector, or a power failure
> when writing sector, should not be amplified to cause collateral
> damage with previously succfessfully written sectors.
>
> 2) Degraded RAID 5/6 filesystems do not meet these properties.
> Neither to cheap flash drives.  This increases the chances you can
> lose, bigtime.
>
>    

I agree with the whole write up outside of the above - degraded RAID 
does meet this requirement unless you have a second (or third, counting 
the split write) failure during the rebuild.

Note that the window of exposure during a RAID rebuild is linear with 
the size of your disk and how much you detune the rebuild...

ric

> 3) Does that mean that you shouldn't use ext3 on RAID drives?  Of
> course not!  First of all, Ext3 still saves you against kernel panics
> and hangs caused by device driver bugs or other kernel hangs.  You
> will lose less data, and avoid needing to run a long and painful fsck
> after a forced reboot, compared to if you used ext2.  You are making
> an assumption that the only time running the journal takes place is
> after a power failure.  But if the system hangs, and you need to hit
> the Big Red Switch, or if you using the system in a Linux High
> Availability setup and the ethernet card fails, so the STONITH ("shoot
> the other node in the head") system forces a hard reset of the system,
> or you get a kernel panic which forces a reboot, in all of these cases
> ext3 will save you from a long fsck, and it will do so safely.
>
> Secondly, what's the probability of a failure causes the RAID array to
> become degraded, followed by a power failure, versus a power failure
> while the RAID array is not running in degraded mode?  Hopefully you
> are running with the RAID array in full, proper running order a much
> larger percentage of the time than running with the RAID array in
> degraded mode.  If not, the bug is with the system administrator!
>
> If you are someone who tends to run for long periods of time in
> degraded mode --- then better get a UPS.  And certainly if you want to
> avoid the chances of failure, periodically scrubbing the disks so you
> detect hard drive failures early, instead of waiting until a disk
> fails before letting the rebuild find the dreaded "second failure"
> which causes data loss, is a d*mned good idea.
>
> Maybe a random OS engineer doesn't know these things --- but trust me
> when I say a competent system administrator had better be familiar
> with these concepts.  And someone who wants their data to be reliably
> stored needs to do some basic storage engineering if they want to have
> long-term data reliability.  (That, or maybe they should outsource
> their long-term reliable storage some service such as Amazon S3 ---
> see Jeremy Zawodny's analysis about how it can be cheaper, here:
> http://jeremy.zawodny.com/blog/archives/007624.html)
>
> But we *do* need to be careful that we don't write documentation which
> is ends up giving users the wrong impression.  The bottom line is that
> you're better off using ext3 over ext2, even on a RAID array, for the
> reasons listed above.
>
> Are you better off using ext3 over ext2 on a crappy flash drive?
> Maybe --- if you are also using crappy proprietary video drivers, such
> as Ubuntu ships, where every single time you exit a 3d game the system
> crashes (and Ubuntu users accept this as normal?!?), then ext3 might
> be a better choice since you'll reduce the chance of data loss when
> the system locks up or crashes thanks to the aforemention crappy
> proprietary video drivers from Nvidia.  On the other hand, crappy
> flash drives *do* have really bad write amplification effects, where a
> 4K write can cause 128k or more worth of flash to be rewritten, such
> that using ext3 could seriously degrade the lifetime of said crappy
> flash drive; furthermore, the crappy flash drives have such terribly
> write performance that using ext3 can be a performance nightmare.
> This of course, doesn't apply to well-implemented SSD's, such as the
> Intel's X25-M and X18-M.  So here your mileage may vary.  Still, if
> you are using crappy proprietary drivers which cause system hangs and
> crashes at a far greater rate than power fail-induced unclean
> shutdowns, ext3 *still* might be the better choice, even with crappy
> flash drives.
>
> The best thing to do, of course, is to improve your storage stack; use
> competently implemented SSD's instead of crap flash cards.  If your
> hardware RAID card supports a battery option, *get* the battery.  Add
> a UPS to your system.  Provision your RAID array with hot spares, and
> regularly scrub (read-test) your array so that failed drives can be
> detected early.  Make sure you configure your MD setup so that you get
> e-mail when a hard drive fails and the array starts running in
> degraded mode, so you can replace the failed drive ASAP.
>
> At the end of the day, filesystems are not magic.  They can't
> compensate for crap hardware, or incompetently administered machines.
>
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    

