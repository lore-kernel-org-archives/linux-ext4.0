From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 23:25:19 +0200
Message-ID: <20090824212518.GF29763@elf.ucw.cz>
References: <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A930160.8060508@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>> I can reproduce data loss with ext3 on flashcard in about 40
>> seconds. I'd not call that "odd event". It would be nice to handle
>> that, but that is hard. So ... can we at least get that documented
>> please?
>>   
>
> Part of documenting best practices is to put down very specific things  
> that do/don't work. What I worry about is producing too much detail to  
> be of use for real end users.

Well, I was trying to write for kernel audience. Someone can turn that
into nice end-user manual.

> I have to admit that I have not paid enough attention to this specifics  
> of your ext3 + flash card issue - is it the ftl stuff doing out of order  
> IO's? 

The problem is that flash cards destroy whole erase block on unplug,
and ext3 can't cope with that.

>> _All_ flash cards (MMC, USB, SD) had the problems. You don't need to
>> get clear grasp on trends. Those cards just don't meet ext3
>> expectations, and if you pull them, you get data loss.
>>   
> Pull them even after an unmount, or pull them hot?

Pull them hot.

[Some people try -osync to avoid data loss on flash cards... that will
not do the trick. Flashcard will still kill the eraseblock.]

>>> Nothing is perfect. It is still a trade off between storage 
>>> utilization  (how much storage we give users for say 5 2TB drives), 
>>> performance and  costs (throw away any disks over 2 years old?).
>>>     
>>
>> "Nothing is perfect"?! That's design decision/problem in raid5/ext3. I
>> believe that should be at least documented. (And understand why ZFS is
>> interesting thing).
>>   
> Your statement is overly broad - ext3 on a commercial RAID array that  
> does RAID5 or RAID6, etc has no issues that I know of.

If your commercial RAID array is battery backed, maybe. But I was
talking Linux MD here.

>> And I still use my zaurus with crappy DRAM.
>>
>> I would not trust raid5 array with my data, for multiple
>> reasons. The fact that degraded raid5 breaks ext3 assumptions should
>> really be documented.
>
> Again, you say RAID5 without enough specifics.  Are you pointing just at  
> MD RAID5 on S-ATA? Hardware RAID cards? A specific commercial RAID5 
> vendor?

Degraded MD RAID5 on anything, including SATA, and including
hypothetical "perfect disk".

>> The papers show failures in "once a year" range. I have "twice a
>> minute" failure scenario with flashdisks.
>>
>> Not sure how often "degraded raid5 breaks ext3 atomicity" would bite,
>> but I bet it would be on "once a day" scale.
>>
>> We should document those.
>
> Documentation is fine with sufficient, hard data....

Degraded MD RAID5 does not work by design; whole stripe will be
damaged on powerfail or reset or kernel bug, and ext3 can not cope
with that kind of damage. [I don't see why statistics should be
neccessary for that; the same way we don't need statistics to see that
ext2 needs fsck after powerfail.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
