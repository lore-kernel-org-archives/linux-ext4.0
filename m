From: Rob Landley <rob@landley.net>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Thu, 12 Mar 2009 14:13:03 -0500
Message-ID: <200903121413.04434.rob@landley.net>
References: <20090312092114.GC6949@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090312092114.GC6949@elf.ucw.cz>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 12 March 2009 04:21:14 Pavel Machek wrote:
> Not all block devices are suitable for all filesystems. In fact, some
> block devices are so broken that reliable operation is pretty much
> impossible. Document stuff ext2/ext3 needs for reliable operation.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/Documentation/filesystems/expectations.txt
> b/Documentation/filesystems/expectations.txt new file mode 100644
> index 0000000..9c3d729
> --- /dev/null
> +++ b/Documentation/filesystems/expectations.txt
> @@ -0,0 +1,47 @@
> +Linux block-backed filesystems can only work correctly when several
> +conditions are met in the block layer and below (disks, flash
> +cards). Some of them are obvious ("data on media should not change
> +randomly"), some are less so.
> +
> +Write errors not allowed (NO-WRITE-ERRORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Writes to media never fail. Even if disk returns error condition
> +during write, filesystems can't handle that correctly, because success
> +on fsync was already returned when data hit the journal.
> +
> +	Fortunately writes failing are very uncommon on traditional
> +	spinning disks, as they have spare sectors they use when write
> +	fails.

I vaguely recall that the behavior of when a write error _does_ occur is to 
remount the filesystem read only?  (Is this VFS or per-fs?)

Is there any kind of hotplug event associated with this?

I'm aware write errors shouldn't happen, and by the time they do it's too late 
to gracefully handle them, and all we can do is fail.  So how do we fail?

> +Sector writes are atomic (ATOMIC-SECTORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.
> +
> +	Unfortuantely, none of the cheap USB/SD flash cards I seen do

I've seen

> +	behave like this, and are unsuitable for all linux filesystems

"are thus unsuitable", perhaps?  (Too pretentious? :)

> +	I know.
> +
> +		An inherent problem with using flash as a normal block
> +		device is that the flash erase size is bigger than
> +		most filesystem sector sizes.  So when you request a
> +		write, it may erase and rewrite the next 64k, 128k, or
> +		even a couple megabytes on the really _big_ ones.

Somebody corrected me, it's not "the next" it's "the surrounding".

(Writes aren't always cleanly at the start of an erase block, so critical data 
_before_ what you touch is endangered too.)

> +		If you lose power in the middle of that, filesystem
> +		won't notice that data in the "sectors" _around_ the
> +		one your were trying to write to got trashed.
> +
> +	Because RAM tends to fail faster than rest of system during
> +	powerfail, special hw killing DMA transfers may be neccessary;

Necessary

> +	otherwise, disks may write garbage during powerfail.
> +	Not sure how common that problem is on generic PC machines.
> +
> +	Note that atomic write is very hard to guarantee for RAID-4/5/6,
> +	because it needs to write both changed data, and parity, to
> +	different disks.

These days instead of "atomic" it's better to think in terms of "barriers".  
Requesting a flush blocks until all the data written _before_ that point has 
made it to disk.  This wait may be arbitrarily long on a busy system with lots 
of disk transactions happening in parallel (perhaps because Firefox decided to 
garbage collect and is spending the next 30 seconds swapping itself back in to 
do so).

> +
> +
> diff --git a/Documentation/filesystems/ext2.txt
> b/Documentation/filesystems/ext2.txt index 4333e83..b09aa4c 100644
> --- a/Documentation/filesystems/ext2.txt
> +++ b/Documentation/filesystems/ext2.txt
> @@ -338,27 +339,25 @@ enough 4-character names to make up unique directory
> entries, so they have to be 8 character filenames, even then we are fairly
> close to running out of unique filenames.
>
> +Requirements
> +============
> +
> +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> +behaving disk subsystem, data that have been successfully synced will
> +stay on the disk. Sane means:

This paragraph talks about ext3...

> +* write errors not allowed
> +
> +* sector writes are atomic
> +
> +(see expectations.txt; note that most/all linux block-based
> +filesystems have similar expectations)
> +
> +* write caching is disabled. ext2 does not know how to issue barriers
> +  as of 2.6.28. hdparm -W0 disables it on SATA disks.

And here we're talking about ext2.  Does neither one know about write 
barriers, or does this just apply to ext2?  (What about ext4?)

Also I remember a historical problem that not all disks honor write barriers, 
because actual data integrity makes for horrible benchmark numbers.  Dunno how 
current that is with SATA, Alan Cox would probably know.

Rob
