From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 09:37:12 -0400
Message-ID: <4A93E908.6050908@redhat.com>
References: <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZHYNie (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 09:38:34 -0400
In-Reply-To: <20090825094244.GC15563@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 05:42 AM, Pavel Machek wrote:
> On Mon 2009-08-24 20:08:42, Theodore Tso wrote:
>> On Tue, Aug 25, 2009 at 01:00:36AM +0200, Pavel Machek wrote:
>>> Then to answer your question... ext2. You expect to run fsck after
>>> unclean shutdown, and you expect to have to solve some problems with
>>> it. So the way ext2 deals with the flash media actually matches what
>>> the user expects. (*)
>>
>> But if the 256k hole is in data blocks, fsck won't find a problem,
>> even with ext2.
>
> True.
>
>> And if the 256k hole is the inode table, you will *still* suffer
>> massive data loss.  Fsck will tell you how badly screwed you are, but
>> it doesn't "fix" the disk; most users don't consider questions of the
>> form "directory entry<precious-thesis-data>  points to trashed inode,
>> may I delete directory entry?" as being terribly helpful.  :-/
>
> Well it will fix the disk in the end. And no, "directory entry
> <precious-thesis-data>  points to trashed inode, may I delete directory
> entry?" is not _terribly_ helpful, but it is slightly helpful and
> people actually expect that from ext2.
>
>> Maybe this came as a surprise to you, but anyone who has used a
>> compact flash in a digital camera knows that you ***have*** to wait
>> until the led has gone out before trying to eject the flash card.  I
>> remember seeing all sorts of horror stories from professional
>> photographers about how they lost an important wedding's day worth of
>> pictures with the attendant commercial loss, on various digital
>> photography forums.  It tends to be the sort of mistake that digital
>> photographers only make once.
>
> It actually comes as surprise to me. Actually yes and no. I know that
> digital cameras use VFAT, so pulling CF card out of it may do bad
> thing, unless I run fsck.vfat afterwards. If digital camera was using
> ext3, I'd expect it to be safely pullable at any time.
>
> Will IBM microdrive do any difference there?
>
> Anyway, it was not known to me. Rather than claiming "everyone knows"
> (when clearly very few people really understand all the details), can
> we simply document that?
> 									Pavel

I really think that the expectation that all OS's (windows, mac, even your ipod) 
all teach you not to hot unplug a device with any file system. Users have an 
"eject" or "safe unload" in windows, your iPod tells you not to power off or 
disconnect, etc.

I don't object to making that general statement - "Don't hot unplug a device 
with an active file system or actively used raw device" - but would object to 
the overly general statement about ext3 not working on flash, RAID5 not working, 
etc...

ric



