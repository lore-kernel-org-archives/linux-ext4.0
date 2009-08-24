From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Mon, 24 Aug 2009 16:24:28 -0400
Message-ID: <4A92F6FC.4060907@redhat.com>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz>
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
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090824195159.GD29763@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>>> Isn't this by design?  In other words, if the metadata doesn't survive
>>> non-atomic writes, wouldn't it be an ext3 bug?
>>>       
>> Part of the problem here is that "atomic-writes" is confusing; it
>> doesn't mean what many people think it means.  The assumption which
>> many naive filesystem designers make is that writes succeed or they
>> don't.  If they don't succeed, they don't change the previously
>> existing data in any way.  
>>
>> So in the case of journalling, the assumption which gets made is that
>> when the power fails, the disk either writes a particular disk block,
>> or it doesn't.  The problem here is as with humans and animals, death
>> is not an event, it is a process.  When the power fails, the system
>> just doesn't stop functioning; the power on the +5 and +12 volt rails
>> start dropping to zero, and different components fail at different
>> times.  Specifically, DRAM, being the most voltage sensitve, tends to
>> fail before the DMA subsystem, the PCI bus, and the hard drive fails.
>> So as a result, garbage can get written out to disk as part of the
>> failure.  That's just the way hardware works.
>>     
>
> Yep, and at that point you lost data. You had "silent data corruption"
> from fs point of view, and that's bad. 
>
> It will be probably very bad on XFS, probably okay on Ext3, and
> certainly okay on Ext2: you do filesystem check, and you should be
> able to repair any damage. So yes, physical journaling is good, but
> fsck is better.
>   

I don't see why you think that. In general, fsck (for any fs) only 
checks metadata. If you have silent data corruption that corrupts things 
that are fixable by fsck, you most likely have silent corruption hitting 
things users care about like their data blocks inside of files. Fsck 
will not fix (or notice) any of that, that is where things like full 
data checksums can help.

Also note (from first hand experience), unless you check and validate 
your data, you can have data corruptions that will not get flagged as IO 
errors so data signing or scrubbing is a critical part of data integrity.
>   
>> Is that a file system "bug"?  Well, it's better to call that a
>> mismatch between the assumptions made of physical devices, and of the
>> file system code.  On Irix, SGI hardware had a powerfail interrupt,
>>     
>
> If those filesystem assumptions were not documented, I'd call it
> filesystem bug. So better document them ;-).
>
>   
I think that we need to help people understand the full spectrum of data 
concerns, starting with reasonable best practices that will help most 
people suffer *less* (not no) data loss. And make very sure that they 
are not falsely assured that by following any specific script that they 
can skip backups, remote backups, etc :-)

Nothing in our code in any part of the kernel deals well with every 
disaster or odd event.

>> There is another kind of non-atomic write that nearly all file systems
>> are subject to, however, and to give an example of this, consider what
>> happens if you a laptop is subjected to a sudden shock while it is
>> writing a sector, and the hard drive doesn't an accelerometer which
>>     
> ...
>   
>> Depending on how severe the shock happens to be, the head could end up
>> impacting the platter, destroying the medium (which used to be
>> iron-oxide; hence the term "spinning rust platters") at that spot.
>> This will obviously cause a write failure, and the previous contents
>> of the sector will be lost.  This is also considered a failure of the
>> ATOMIC-WRITE property, and no, ext3 doesn't handle this case
>> gracefully.  Very few file systems do.  (It is possible for an OS
>> that
>>     
>
> Actually, ext2 should be able to survive that, no? Error writing ->
> remount ro -> fsck on next boot -> drive relocates the sectors.
>   

I think that the example and the response are both off base. If your 
head ever touches the platter, you won't be reading from a huge part of 
your drive ever again (usually, you have 2 heads per platter, 3-4 
platters, impact would kill one head and a corresponding percentage of 
your data).

No file system will recover that data although you might be able to 
scrape out some remaining useful bits and bytes.

More common causes of silent corruption would be bad DRAM in things like 
the drive write cache, hot spots (that cause adjacent track data 
errors), etc.  Note in this last case, your most recently written data 
is fine, just the data you wrote months/years ago is toast!
>   
>> It's for this reason that I've never been completely sure how useful
>> Pavel's proposed treatise about file systems expectations really are
>> --- because all storage subsystems *usually* provide these guarantees,
>> but it is the very rare storage system that *always* provides these
>> guarantees.
>>     
>
> Well... there's very big difference between harddrives and flash
> memory. Harddrives usually work, and flash memory never does.
>   

It is hard for anyone to see the real data without looking in detail at 
large numbers of parts. Back at EMC, we looked at failures for lots of 
parts so we got a clear grasp on trends.  I do agree that flash/SSD 
parts are still very young so we will have interesting and unexpected 
failure modes to learn to deal with....
>   
>> We could just as easily have several kilobytes of explanation in
>> Documentation/* explaining how we assume that DRAM always returns the
>> same value that was stored in it previously --- and yet most PC class
>> hardware still does not use ECC memory, and cosmic rays are a reality.
>> That means that most Linux systems run on systems that are vulnerable
>> to this kind of failure --- and the world hasn't ended.
>>     
>
> There's a difference. In case of cosmic rays, hardware is clearly
> buggy. I have one machine with bad DRAM (about 1 errors in 2 days),
> and I still use it. I will not complain if ext3 trashes that.
>
> In case of degraded raid-5, even with perfect hardware, and with
> ext3 on top of that, you'll get silent data corruption. Nice, eh?
>
> Clearly, Linux is buggy there. It could be argued it is raid-5's
> fault, or maybe it is ext3's fault, but... linux is still buggy.
>   

Nothing is perfect. It is still a trade off between storage utilization 
(how much storage we give users for say 5 2TB drives), performance and 
costs (throw away any disks over 2 years old?).
>   
>> As I recall, the main problem which Pavel had was when he was using
>> ext3 on a *really* trashy flash drive, on a *really* trashing laptop
>> where the flash card stuck out slightly, and any jostling of the
>> netbook would cause the flash card to become disconnected from the
>> laptop, and cause write errors, very easily and very frequently.  In
>> those circumstnaces, it's highly unlikely that ***any*** file system
>> would have been able to survive such an unreliable storage system.
>>     
>
> Well well well. Before I pulled that flash card, I assumed that doing
> so is safe, because flashcard is presented as block device and ext3
> should cope with sudden disk disconnects.
>
> And I was wrong wrong wrong. (Noone told me at the university. I guess
> I should want my money back).
>
> Plus note that it is not only my trashy laptop and one trashy MMC
> card; every USB thumb drive I seen is affected. (OTOH USB disks should
> be safe AFAICT).
>
> Ext3 is unsuitable for flash cards and RAID arrays, plain and
> simple. It is not documented anywhere :-(. [ext2 should work better --
> at least you'll not get silent data corruption.]
>   

ext3 is used on lots of raid arrays without any issue.
>   
>> One of the problems I have with the break down which Pavel has used is
>> that it doesn't break things down according to probability; the chance
>> of a storage subsystem scribbling garbage on its last write during a
>>     
>
> Can you suggest better patch? I'm not saying we should redesign ext3,
> but... someone should have told me that ext3+USB thumb drive=problems.
>
>   
>> But these things are never absolute, mainly because people aren't
>> willing to pay for either the cost of superior hardware (consider the
>> cost of ECC memory, which isn't *that* much more expensive; and yet
>> most PC class systems don't use it) or in terms of software overhead
>> (historically many file system designers have eschewed the use of
>> physical block journalling because it really hurts on meta-data
>> intensive benchmarks), talking about absolute requirements for
>> ATOMIC-WRITE isn't all that useful --- because nearly all hardware
>> doesn't provide these guarantees, and nearly all filesystems require
>> them.  So to call out ext2 and ext3 for requiring them, without
>> making
>>     
>
> ext3+raid5 will fail even if you have perfect hardware.
>
>   
>> clear that pretty much *all* file systems require them, ends up
>> causing people to switch over to some other file system that
>> ironically enough, might end up being *more* vulernable, but which
>> didn't earn Pavel's displeasure because he didn't try using, say, XFS
>> on his flashcard on his trashy laptop.
>>     
>
> I hold ext2/ext3 to higher standards than other filesystem in
> tree. I'd not use XFS/VFAT etc. 
>
> I would not want people to migrate towards XFS/VFAT, and yes I believe
> XFSs/VFATs/... requirements should be documented, too. (But I know too
> little about those filesystems).
>
> If you can suggest better wording, please help me. But... those
> requirements are non-trivial, commonly not met and the result is data
> loss. It has to be documented somehow. Make it as innocent-looking as
> you can...
>
> 								Pavel
>   

I think that you really need to step back and look harder at real 
failures - not just your personal experience - but a larger set of real 
world failures. Many papers have been published recently about that (the 
google paper, the Bianca paper from FAST, Netapp, etc).

Regards,

Ric


