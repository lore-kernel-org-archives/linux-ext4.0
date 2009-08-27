From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Thu, 27 Aug 2009 09:10:44 -0400
Message-ID: <4A9685D4.2070906__40508.3980680958$1251378637$gmane$org@redhat.com>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	Pavel Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZH0NKU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2009 09:10:20 -0400
In-Reply-To: <20090827122423.GO6997@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/27/2009 08:24 AM, Theodore Tso wrote:
> On Thu, Aug 27, 2009 at 12:19:02AM -0500, Rob Landley wrote:
>>> To me, this isn't a particularly interesting or newsworthy point,
>>> since a competent system administrator
>>
>> I'm a bit concerned by the argument that we don't need to document
>> serious pitfalls because every Linux system has a sufficiently
>> competent administrator they already know stuff that didn't even
>> come up until the second or third day it was discussed on lkml.
>
> I'm not convinced that information which needs to be known by System
> Administrators is best documented in the kernel Documentation
> directory.  Should there be a HOWTO document on stuff like that?
> Sure, if someone wants to put something like that together, having
> free documentation about ways to set up your storage stack in a sane
> way is not a bad thing.
>
> It should be noted that these sorts of issues are discussed in various
> books targetted at System Administrators, and in Usenix's System
> Administration tutorials.  The computer industry is highly
> specialized, and so just because an OS kernel hacker might not be
> familiar with these issues, doesn't mean that professionals whose job
> it is to run data centers don't know about these things!  Similarly,
> you could be a whiz at Linux's networking stack, but you might not
> know about certain pitfalls in configuring a Cisco router using IOS;
> does that mean we should have an IOS tutorial in the kernel
> documentation directory?  I'm not so sure about that!
>
>> "You're documenting it wrong" != "you shouldn't document it".
>
> Sure, but the fact that we don't currently say much about storage
> stacks doesn't mean we should accept a patch that might actively
> mislead people.   I'm NACK'ing the patch on that basis.
>
>>> who cares about his data and/or
>>> his hardware will (a) have a UPS,
>>
>> I worked at a company that retested their UPSes a year after
>> installing them and found that _none_ of them supplied more than 15
>> seconds charge, and when they dismantled them the batteries had
>> physically bloated inside their little plastic cases.  (Same company
>> as the dead air conditioner, possibly overheating was involved but
>> the little _lights_ said everything was ok.)
>>
>> That was by no means the first UPS I'd seen die, the suckers have a
>> higher failure rate than hard drives in my experience.  This is a
>> device where the batteries get constantly charged and almost never
>> tested because if it _does_ fail you just rebooted your production
>> server, so a lot of smaller companies think they have one but
>> actually don't.
>
> Sounds like they were using really cheap UPS's; certainly not the kind
> I would expect to find in a data center.  And if company's system
> administrator is using the cheapest possible consumer-grade UPS's,
> then yes, they might have a problem.  Even an educational institution
> like MIT, where I was an network administrator some 15 years ago, had
> proper UPS's, *and* we had a diesel generator which kicked in after 15
> seconds --- and we tested the diesel generator every Friday morning,
> to make sure it worked properly.
>
>>> , and (b) be running with a hot spare
>>> and/or will imediately replace a failed drive in a RAID array.
>>
>> Here's hoping they shut the system down properly to install the new
>> drive in the raid then, eh?  Not accidentally pull the plug before
>> it's finished running the ~7 minutes of shutdown scripts in the last
>> Red Hat Enterprise I messed with...
>
> Even my home RAID array uses hot-plug SATA disks, so I can replace a
> failed disk without shutting down my system.  (And yes, I have a
> backup battery for the hardware RAID, and the firmware runs periodic
> tests on it; the hardware RAID card also will send me e-mail if a RAID
> array drive fails and it needs to use my hot-spare.  At that point, I
> order a new hard drive, secure in the knowledge that the system can
> still suffer another drive failure before falling into degraded mode.
> And no, this isn't some expensive enterprise RAID setup; this is just
> a mid-range Areca RAID card.)
>
>> If "degraded array" just means "don't have a replacement disk yet",
>> then it sounds like what Pavel wants to document is "don't write to
>> a degraded array at all, because power failures can cost you data
>> due to write granularity being larger than filesystem block size".
>> (Which still comes as news to some of us, and you need a way to
>> remount mount the degraded array read only until the sysadmin can
>> fix it.)
>
> If you want to document that as a property of RAID arrays, sure.  But
> it's not something that should live in Documentation/filesystems/ext2.txt
> and Documentation/filesystems/ext3.txt.  The MD RAID howto might be a
> better place, since it's far more likely more users will read it.  How
> many system administrators read what's in the kernel's Documentation
> directory, after all, and this is basic information about how RAID
> works; it's not necessarily something that someone would *expect* to
> be in kernel documentation, nor would necessarily go looking for it
> there.  And the reality is that it's not like most people go reading
> Documentation/* for pleasure.  :-)
>
> BTW, the RAID write atomicity issue and the possibility of failures
> cause data loss *is* documented in the Wikipedia article on RAID.
> It's not as written as direct practical advice to a system
> administrator (you'd have to go to a book that is really targetted at
> system administrators to find that sort of thing).
>
>         		      	      	   	   - Ted

One thing that does need fixing for some MD configurations is to stress again 
that we need to make sure that barrier operations are properly supported or 
users will need to disable the write cache on devices with volatile write caches.

Ric

