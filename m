From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Mon, 24 Aug 2009 17:02:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908241655250.28411@asgard.lang.hm>
References: <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz>
 <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz>
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
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090824230036.GK29763@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Aug 2009, Pavel Machek wrote:

> On Mon 2009-08-24 18:39:15, Theodore Tso wrote:
>> On Mon, Aug 24, 2009 at 11:25:19PM +0200, Pavel Machek wrote:
>>>> I have to admit that I have not paid enough attention to this specifics
>>>> of your ext3 + flash card issue - is it the ftl stuff doing out of order
>>>> IO's?
>>>
>>> The problem is that flash cards destroy whole erase block on unplug,
>>> and ext3 can't cope with that.
>>
>> Sure --- but name **any** filesystem that can deal with the fact that
>> 128k or 256k worth of data might disappear when you pull out the flash
>> card while it is writing a single sector?
>
> First... I consider myself quite competent in the os level, yet I did
> not realize what flash does and what that means for data
> integrity. That means we need some documentation, or maybe we should
> refuse to mount those devices r/w or something.
>
> Then to answer your question... ext2. You expect to run fsck after
> unclean shutdown, and you expect to have to solve some problems with
> it. So the way ext2 deals with the flash media actually matches what
> the user expects. (*)

you loose data in ext2

> OTOH in ext3 case you expect consistent filesystem after unplug; and
> you don't get that.

the problem is that people have been preaching that journaling filesystems 
eliminate all data loss for no cost (or at worst for minimal cost).

they don't, they never did.

they address one specific problem (metadata inconsistancy), but they do 
not address data loss, and never did (and for the most part the filesystem 
developers never claimed to)

depending on how much data gets lost, you may or may not be able to 
recover enough to continue to use the filesystem, and when your block 
device takes actions in larger chunks than the filesystem asked it to, 
it's very possible for seemingly unrelated data to be lost as well.

this is true for every single filesystem, nothing special about ext3

people somehow have the expectation that ext3 does the data equivalent of 
solving world hunger, it doesn't, it never did, and it never claimed to.

bashing it because it doesn't isn't fair. bashing XFS because it doesn't 
also isn't fair.

personally I don't consider the two filesystems to be significantly 
different in terms of the data loss potential. I think people are more 
aware of the potentials with XFS than with ext3, but I believe that the 
risk of loss is really about the same (and pretty much for the same 
reasons)


>>>> Your statement is overly broad - ext3 on a commercial RAID array that
>>>> does RAID5 or RAID6, etc has no issues that I know of.
>>>
>>> If your commercial RAID array is battery backed, maybe. But I was
>>> talking Linux MD here.
> ...
>> If your concern is that with Linux MD, you could potentially lose an
>> entire stripe in RAID 5 mode, then you should say that explicitly; but
>> again, this isn't a filesystem specific cliam; it's true for all
>> filesystems.  I don't know of any file system that can survive having
>> a RAID stripe-shaped-hole blown into the middle of it due to a power
>> failure.
>
> Again, ext2 handles that in a way user expects it.
>
> At least I was teached "ext2 needs fsck after powerfail; ext3 can
> handle powerfails just ok".

you were teached wrong. the people making these claims for ext3 didn't 
understand what ext3 does and doesn't do.

David Lang

>> I'll note, BTW, that AIX uses a journal to protect against these sorts
>> of problems with software raid; this also means that with AIX, you
>> also don't have to rebuild a RAID 1 device after an unclean shutdown,
>> like you have do with Linux MD.  This was on the EVMS's team
>> development list to implement for Linux, but it got canned after LVM
>> won out, lo those many years ago.  Ce la vie; but it's a problem which
>> is solvable at the RAID layer, and which is traditionally and
>> historically solved in competent RAID implementations.
>
> Yep, we should add journal to RAID; or at least write "Linux MD
> *needs* an UPS" in big and bold letters. I'm trying to do the second
> part.
>
> (Attached is current version of the patch).
>
> [If you'd prefer patch saying that MMC/USB flash/Linux MD arrays are
> generaly unsafe to use without UPS/reliable connection/no kernel
> bugs... then I may try to push that. I was not sure... maybe some
> filesystem _can_ handle this kind of issues?]
>
> 								Pavel
>
> (*) Ok, now... user expects to run fsck, but very advanced users may
> not expect old data to be damaged. Certainly I was not advanced enough
> user few months ago.
>
> diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
> new file mode 100644
> index 0000000..d1ef4d0
> --- /dev/null
> +++ b/Documentation/filesystems/expectations.txt
> @@ -0,0 +1,57 @@
> +Linux block-backed filesystems can only work correctly when several
> +conditions are met in the block layer and below (disks, flash
> +cards). Some of them are obvious ("data on media should not change
> +randomly"), some are less so. Not all filesystems require all of these
> +to be satisfied for safe operation.
> +
> +Write errors not allowed (NO-WRITE-ERRORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Writes to media never fail. Even if disk returns error condition
> +during write, filesystems can't handle that correctly.
> +
> +	Fortunately writes failing are very uncommon on traditional
> +	spinning disks, as they have spare sectors they use when write
> +	fails.
> +
> +Don't cause collateral damage on a failed write (NO-COLLATERALS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +On some storage systems, failed write (for example due to power
> +failure) kills data in adjacent (or maybe unrelated) sectors.
> +
> +Unfortunately, cheap USB/SD flash cards I've seen do have this bug,
> +and are thus unsuitable for all filesystems I know.
> +
> +	An inherent problem with using flash as a normal block device
> +	is that the flash erase size is bigger than most filesystem
> +	sector sizes.  So when you request a write, it may erase and
> +	rewrite some 64k, 128k, or even a couple megabytes on the
> +	really _big_ ones.
> +
> +	If you lose power in the middle of that, filesystem won't
> +	notice that data in the "sectors" _around_ the one your were
> +	trying to write to got trashed.
> +
> +	MD RAID-4/5/6 in degraded mode has similar problem, stripes
> +	behave similary to eraseblocks.
> +
> +
> +Don't damage the old data on a powerfail (ATOMIC-WRITES-ON-POWERFAIL)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.
> +
> +	Because RAM tends to fail faster than rest of system during
> +	powerfail, special hw killing DMA transfers may be necessary;
> +	otherwise, disks may write garbage during powerfail.
> +	This may be quite common on generic PC machines.
> +
> +	Note that atomic write is very hard to guarantee for MD RAID-4/5/6,
> +	because it needs to write both changed data, and parity, to
> +	different disks. (But it will only really show up in degraded mode).
> +	UPS for RAID array should help.
> +
> +
> +
> diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
> index 67639f9..ef9ff0f 100644
> --- a/Documentation/filesystems/ext2.txt
> +++ b/Documentation/filesystems/ext2.txt
> @@ -338,27 +339,30 @@ enough 4-character names to make up unique directory entries, so they
> have to be 8 character filenames, even then we are fairly close to
> running out of unique filenames.
>
> +Requirements
> +============
> +
> +Ext2 expects disk/storage subsystem to behave sanely. On sanely
> +behaving disk subsystem, data that have been successfully synced will
> +stay on the disk. Sane means:
> +
> +* write errors not allowed (NO-WRITE-ERRORS)
> +
> +* don't damage the old data on a failed write (ATOMIC-WRITES-ON-POWERFAIL)
> +
> +and obviously:
> +
> +* don't cause collateral damage to adjacent sectors on a failed write
> +  (NO-COLLATERALS)
> +
> +(see expectations.txt; note that most/all linux block-based
> +filesystems have similar expectations)
> +
> +* write caching is disabled. ext2 does not know how to issue barriers
> +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
> +
> Journaling
> -----------
> -
> -A journaling extension to the ext2 code has been developed by Stephen
> -Tweedie.  It avoids the risks of metadata corruption and the need to
> -wait for e2fsck to complete after a crash, without requiring a change
> -to the on-disk ext2 layout.  In a nutshell, the journal is a regular
> -file which stores whole metadata (and optionally data) blocks that have
> -been modified, prior to writing them into the filesystem.  This means
> -it is possible to add a journal to an existing ext2 filesystem without
> -the need for data conversion.
> -
> -When changes to the filesystem (e.g. a file is renamed) they are stored in
> -a transaction in the journal and can either be complete or incomplete at
> -the time of a crash.  If a transaction is complete at the time of a crash
> -(or in the normal case where the system does not crash), then any blocks
> -in that transaction are guaranteed to represent a valid filesystem state,
> -and are copied into the filesystem.  If a transaction is incomplete at
> -the time of the crash, then there is no guarantee of consistency for
> -the blocks in that transaction so they are discarded (which means any
> -filesystem changes they represent are also lost).
> +==========
> Check Documentation/filesystems/ext3.txt if you want to read more about
> ext3 and journaling.
>
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
> index 570f9bd..752f4b4 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -199,6 +202,43 @@ debugfs: 	ext2 and ext3 file system debugger.
> ext2online:	online (mounted) ext2 and ext3 filesystem resizer
>
>
> +Requirements
> +============
> +
> +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> +behaving disk subsystem, data that have been successfully synced will
> +stay on the disk. Sane means:
> +
> +* write errors not allowed (NO-WRITE-ERRORS)
> +
> +* don't damage the old data on a failed write (ATOMIC-WRITES-ON-POWERFAIL)
> +
> +  Ext3 handles trash getting written into sectors during powerfail
> +  surprisingly well.  It's not foolproof, but it is resilient.
> +  Incomplete journal entries are ignored, and journal replay of
> +  complete entries will often "repair" garbage written into the inode
> +  table.  The data=journal option extends this behavior to file and
> +  directory data blocks as well.
> +
> +
> +and obviously:
> +
> +* don't cause collateral damage to adjacent sectors on a failed write
> +  (NO-COLLATERALS)
> +
> +
> +(see expectations.txt; note that most/all linux block-based
> +filesystems have similar expectations)
> +
> +* either write caching is disabled, or hw can do barriers and they are enabled.
> +
> +	   (Note that barriers are disabled by default, use "barrier=1"
> +	   mount option after making sure hw can support them).
> +
> +	   hdparm -I reports disk features. If you have "Native
> +	   Command Queueing" is the feature you are looking for.
> +
> +
> References
> ==========
>
>
>
