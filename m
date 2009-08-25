From: david@lang.hm
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 15:59:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz>
 <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:60316 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbZHYXA1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 19:00:27 -0400
In-Reply-To: <20090825224004.GD4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Aug 2009, Pavel Machek wrote:

> On Tue 2009-08-25 15:33:08, david@lang.hm wrote:
>> On Wed, 26 Aug 2009, Pavel Machek wrote:
>>
>>>> It seems that you are really hung up on whether or not the filesystem
>>>> metadata is consistent after a power failure, when I'd argue that the
>>>> problem with using storage devices that don't have good powerfail
>>>> properties have much bigger problems (such as the potential for silent
>>>> data corruption, or even if fsck will fix a trashed inode table with
>>>> ext2, massive data loss).  So instead of your suggested patch, it
>>>> might be better simply to have a file in Documentation/filesystems
>>>> that states something along the lines of:
>>>>
>>>> "There are storage devices that high highly undesirable properties
>>>> when they are disconnected or suffer power failures while writes are
>>>> in progress; such devices include flash devices and software RAID 5/6
>>>> arrays without journals,
>>
>> is it under all conditions, or only when you have already lost redundancy?
>
> I'd prefer not to specify.

you need to, otherwise you are claiming that all linux software raid 
implementations will loose data on powerfail, which I don't think is the 
case.

>> prior discussions make me think this was only if the redundancy is
>> already lost.
>
> I'm not so sure now.
>
> Lets say you are writing to the (healthy) RAID5 and have a powerfail.
>
> So now data blocks do not correspond to the parity block. You don't
> yet have the corruption, but you already have a problem.
>
> If you get a disk failing at this point, you'll get corruption.

it's the same combination of problems (non-redundant array and write lost 
to powerfail/reboot), just in a different order.

reccomending a scrub of the raid after an unclean shutdown would make 
sense, along with a warning that if you loose all redundancy before the 
scrub is completed and there was a write failure in the unscrubbed portion 
it could corrupt things.

>> also, the talk about software RAID 5/6 arrays without journals will be
>> confusing (after all, if you are using ext3/XFS/etc you are using a
>> journal, aren't you?)
>
> Slightly confusing, yes. Should I just say "MD RAID 5" and avoid
> talking about hardware RAID arrays, where that's really
> manufacturer-specific?

what about dm raid?

I don't think you should talk about hardware raid cards.

>> in addition, even with a single drive you will loose some data on power
>> loss (unless you do sync mounts with disabled write caches), full data
>> journaling can help protect you from this, but the default journaling
>> just protects the metadata.
>
> "Data loss" here means "damaging data that were already fsynced". That
> will not happen on single disk (with barriers on etc), but will happen
> on RAID5 and flash.

this definition of data loss wasn't clear prior to this. you need to 
define this, and state that the reason that flash and raid arrays can 
suffer from this is that both of them deal with blocks of storage larger 
than the data block (eraseblock or raid stripe) and there are conditions 
that can cause the loss of the entire eraseblock or raid stripe which can 
affect data that was previously safe on disk (and if power had been lost 
before the latest write, the prior data would still be safe)

note that this doesn't nessasarily affect all flash disks. if the disk 
doesn't replace the old block in the FTL until the data has all been 
sucessfuly copies to the new eraseblock you don't have this problem.

some (possibly all) cheap thumb drives don't do this, but I would expect 
that the expensive SATA SSDs to do things in the right order.

do this right and you are properly documenting a failure mode that most 
people don't understand, but go too far and you are crying wolf.

David Lang
