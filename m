From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Mon, 24 Aug 2009 17:08:48 -0400
Message-ID: <4A930160.8060508@redhat.com>
References: <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZHXVJJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 17:09:09 -0400
In-Reply-To: <20090824205209.GE29763@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pavel Machek wrote:
> Hi!
>
>   
>>> Yep, and at that point you lost data. You had "silent data corruption"
>>> from fs point of view, and that's bad. 
>>>
>>> It will be probably very bad on XFS, probably okay on Ext3, and
>>> certainly okay on Ext2: you do filesystem check, and you should be
>>> able to repair any damage. So yes, physical journaling is good, but
>>> fsck is better.
>>>       
>> I don't see why you think that. In general, fsck (for any fs) only  
>> checks metadata. If you have silent data corruption that corrupts things  
>> that are fixable by fsck, you most likely have silent corruption hitting  
>> things users care about like their data blocks inside of files. Fsck  
>> will not fix (or notice) any of that, that is where things like full  
>> data checksums can help.
>>     
>
> Ok, but in case of data corruption, at least your filesystem does not
> degrade further.
>
>   
Even worse, your data is potentially gone and you have not noticed 
it...  This is why array vendors and archival storage products do 
periodic scans of all stored data (read all the bytes, compared to a 
digital signature, etc).
>>> If those filesystem assumptions were not documented, I'd call it
>>> filesystem bug. So better document them ;-).
>>>   
>>>       
>> I think that we need to help people understand the full spectrum of data  
>> concerns, starting with reasonable best practices that will help most  
>> people suffer *less* (not no) data loss. And make very sure that they  
>> are not falsely assured that by following any specific script that they  
>> can skip backups, remote backups, etc :-)
>>
>> Nothing in our code in any part of the kernel deals well with every  
>> disaster or odd event.
>>     
>
> I can reproduce data loss with ext3 on flashcard in about 40
> seconds. I'd not call that "odd event". It would be nice to handle
> that, but that is hard. So ... can we at least get that documented
> please?
>   

Part of documenting best practices is to put down very specific things 
that do/don't work. What I worry about is producing too much detail to 
be of use for real end users.

I have to admit that I have not paid enough attention to this specifics 
of your ext3 + flash card issue - is it the ftl stuff doing out of order 
IO's? 
>
>   
>>> Actually, ext2 should be able to survive that, no? Error writing ->
>>> remount ro -> fsck on next boot -> drive relocates the sectors.
>>>   
>>>       
>> I think that the example and the response are both off base. If your  
>> head ever touches the platter, you won't be reading from a huge part of  
>> your drive ever again (usually, you have 2 heads per platter, 3-4  
>> platters, impact would kill one head and a corresponding percentage of  
>> your data).
>>     
>
> Ok, that's obviously game over.
>   

This is when you start seeing lots of READ and WRITE errors :-)
>   
>>>> It's for this reason that I've never been completely sure how useful
>>>> Pavel's proposed treatise about file systems expectations really are
>>>> --- because all storage subsystems *usually* provide these guarantees,
>>>> but it is the very rare storage system that *always* provides these
>>>> guarantees.
>>>>         
>>> Well... there's very big difference between harddrives and flash
>>> memory. Harddrives usually work, and flash memory never does.
>>>       
>> It is hard for anyone to see the real data without looking in detail at  
>> large numbers of parts. Back at EMC, we looked at failures for lots of  
>> parts so we got a clear grasp on trends.  I do agree that flash/SSD  
>> parts are still very young so we will have interesting and unexpected  
>> failure modes to learn to deal with....
>>     
>
> _Maybe_ SSDs, being HDD replacements are better. I don't know.
>
> _All_ flash cards (MMC, USB, SD) had the problems. You don't need to
> get clear grasp on trends. Those cards just don't meet ext3
> expectations, and if you pull them, you get data loss.
>
>   
Pull them even after an unmount, or pull them hot?
>>>> We could just as easily have several kilobytes of explanation in
>>>> Documentation/* explaining how we assume that DRAM always returns the
>>>> same value that was stored in it previously --- and yet most PC class
>>>> hardware still does not use ECC memory, and cosmic rays are a reality.
>>>> That means that most Linux systems run on systems that are vulnerable
>>>> to this kind of failure --- and the world hasn't ended.
>>>>         
>
>   
>>> There's a difference. In case of cosmic rays, hardware is clearly
>>> buggy. I have one machine with bad DRAM (about 1 errors in 2 days),
>>> and I still use it. I will not complain if ext3 trashes that.
>>>
>>> In case of degraded raid-5, even with perfect hardware, and with
>>> ext3 on top of that, you'll get silent data corruption. Nice, eh?
>>>
>>> Clearly, Linux is buggy there. It could be argued it is raid-5's
>>> fault, or maybe it is ext3's fault, but... linux is still buggy.
>>>       
>> Nothing is perfect. It is still a trade off between storage utilization  
>> (how much storage we give users for say 5 2TB drives), performance and  
>> costs (throw away any disks over 2 years old?).
>>     
>
> "Nothing is perfect"?! That's design decision/problem in raid5/ext3. I
> believe that should be at least documented. (And understand why ZFS is
> interesting thing).
>
>   
Your statement is overly broad - ext3 on a commercial RAID array that 
does RAID5 or RAID6, etc has no issues that I know of.

Do you know first hand that ZFS works on flash cards?
>>> Ext3 is unsuitable for flash cards and RAID arrays, plain and
>>> simple. It is not documented anywhere :-(. [ext2 should work better --
>>> at least you'll not get silent data corruption.]
>>>       
>> ext3 is used on lots of raid arrays without any issue.
>>     
>
> And I still use my zaurus with crappy DRAM.
>
> I would not trust raid5 array with my data, for multiple
> reasons. The fact that degraded raid5 breaks ext3 assumptions should
> really be documented.
>   

Again, you say RAID5 without enough specifics.  Are you pointing just at 
MD RAID5 on S-ATA? Hardware RAID cards? A specific commercial RAID5 vendor?
>   
>>> I hold ext2/ext3 to higher standards than other filesystem in
>>> tree. I'd not use XFS/VFAT etc. 
>>>
>>> I would not want people to migrate towards XFS/VFAT, and yes I believe
>>> XFSs/VFATs/... requirements should be documented, too. (But I know too
>>> little about those filesystems).
>>>
>>> If you can suggest better wording, please help me. But... those
>>> requirements are non-trivial, commonly not met and the result is data
>>> loss. It has to be documented somehow. Make it as innocent-looking as
>>> you can...
>>>       
>
>   
>> I think that you really need to step back and look harder at real  
>> failures - not just your personal experience - but a larger set of real  
>> world failures. Many papers have been published recently about that (the  
>> google paper, the Bianca paper from FAST, Netapp, etc).
>>     
>
> The papers show failures in "once a year" range. I have "twice a
> minute" failure scenario with flashdisks.
>
> Not sure how often "degraded raid5 breaks ext3 atomicity" would bite,
> but I bet it would be on "once a day" scale.
>
> We should document those.
> 								Pavel
>   

Documentation is fine with sufficient, hard data....

ric


