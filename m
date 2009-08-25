From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 01:37:02 +0200
Message-ID: <20090825233701.GH4300@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm>
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
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>>> is it under all conditions, or only when you have already lost redundancy?
>>
>> I'd prefer not to specify.
>
> you need to, otherwise you are claiming that all linux software raid  
> implementations will loose data on powerfail, which I don't think is the  
> case.

Well, I'm not saying it loses data on _every_ powerfail ;-).

>>> also, the talk about software RAID 5/6 arrays without journals will be
>>> confusing (after all, if you are using ext3/XFS/etc you are using a
>>> journal, aren't you?)
>>
>> Slightly confusing, yes. Should I just say "MD RAID 5" and avoid
>> talking about hardware RAID arrays, where that's really
>> manufacturer-specific?
>
> what about dm raid?
>
> I don't think you should talk about hardware raid cards.

Ok, fixed.

>>> in addition, even with a single drive you will loose some data on power
>>> loss (unless you do sync mounts with disabled write caches), full data
>>> journaling can help protect you from this, but the default journaling
>>> just protects the metadata.
>>
>> "Data loss" here means "damaging data that were already fsynced". That
>> will not happen on single disk (with barriers on etc), but will happen
>> on RAID5 and flash.
>
> this definition of data loss wasn't clear prior to this. you need to  

I actually think it was. write() syscall does not guarantee anything,
fsync() does.

> define this, and state that the reason that flash and raid arrays can  
> suffer from this is that both of them deal with blocks of storage larger  
> than the data block (eraseblock or raid stripe) and there are conditions  
> that can cause the loss of the entire eraseblock or raid stripe which can 
> affect data that was previously safe on disk (and if power had been lost  
> before the latest write, the prior data would still be safe)

I actually believe Ted's writeup is good.

> note that this doesn't nessasarily affect all flash disks. if the disk  
> doesn't replace the old block in the FTL until the data has all been  
> sucessfuly copies to the new eraseblock you don't have this problem.
>
> some (possibly all) cheap thumb drives don't do this, but I would expect  
> that the expensive SATA SSDs to do things in the right order.

I'd expect SATA SSDs to have that solved, yes. Again, Ted does not say
it affects _all_ such devices, and it certianly did affect all that I seen.

> do this right and you are properly documenting a failure mode that most  
> people don't understand, but go too far and you are crying wolf.

Ok, latest version is below, can you suggest improvements? (And yes,
details when exactly RAID-5 misbehaves should be noted somewhere. I
don't know enough about RAID arrays, can someone help?)
									Pavel

---
There are storage devices that high highly undesirable properties
when they are disconnected or suffer power failures while writes are
in progress; such devices include flash devices and MD RAID 4/5/6
arrays.  These devices have the property of potentially
corrupting blocks being written at the time of the power failure, and
worse yet, amplifying the region where blocks are corrupted such that
additional sectors are also damaged during the power failure.
        
Users who use such storage devices are well advised take
countermeasures, such as the use of Uninterruptible Power Supplies,
and making sure the flash device is not hot-unplugged while the device
is being used.  Regular backups when using these devices is also a
Very Good Idea.
        
Otherwise, file systems placed on these devices can suffer silent data
and file system corruption.  An forced use of fsck may detect metadata
corruption resulting in file system corruption, but will not suffice
to detect data corruption.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
