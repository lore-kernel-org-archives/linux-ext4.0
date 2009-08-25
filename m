From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 18:42:48 -0400
Message-ID: <4A9468E8.607@redhat.com>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090825211515.GA3688@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/25/2009 05:15 PM, Pavel Machek wrote:
>
>>>> Maybe this came as a surprise to you, but anyone who has used a
>>>> compact flash in a digital camera knows that you ***have*** to wait
>>>> until the led has gone out before trying to eject the flash card.  I
>>>> remember seeing all sorts of horror stories from professional
>>>> photographers about how they lost an important wedding's day worth of
>>>> pictures with the attendant commercial loss, on various digital
>>>> photography forums.  It tends to be the sort of mistake that digital
>>>> photographers only make once.
>>>
>>> It actually comes as surprise to me. Actually yes and no. I know that
>>> digital cameras use VFAT, so pulling CF card out of it may do bad
>>> thing, unless I run fsck.vfat afterwards. If digital camera was using
>>> ext3, I'd expect it to be safely pullable at any time.
>>>
>>> Will IBM microdrive do any difference there?
>>>
>>> Anyway, it was not known to me. Rather than claiming "everyone knows"
>>> (when clearly very few people really understand all the details), can
>>> we simply document that?
>>
>> I really think that the expectation that all OS's (windows, mac, even
>> your ipod) all teach you not to hot unplug a device with any file system.
>> Users have an "eject" or "safe unload" in windows, your iPod tells you
>> not to power off or disconnect, etc.
>
> That was before journaling filesystems...

Not true - that is true today with or without journals as we have discussed in 
great detail. Including specifically ext2.

Basically, any file system (Linux, windows, OSX, etc) that writes into the page 
cache will lose data when you hot unplug its storage. End of story, don't do it!


>
>> I don't object to making that general statement - "Don't hot unplug a
>> device with an active file system or actively used raw device" - but
>> would object to the overly general statement about ext3 not working on
>> flash, RAID5 not working, etc...
>
> You can object any way you want, but running ext3 on flash or MD RAID5
> is stupid:
>
> * ext2 would be faster
>
> * ext2 would provide better protection against powerfail.

Not true in the slightest, you continue to ignore the ext2/3/4 developers 
telling you that it will lose data.

>
> "ext3 works on flash and MD RAID5, as long as you do not have
> powerfail" seems to be the accurate statement, and if you don't need
> to protect against powerfails, you can just use ext2.
> 								Pavel

Strange how your personal preference is totally out of sync with the entire 
enterprise class user base.

ric


