From: Rob Landley <rob@landley.net>
Subject: Re: Data integrity built into the storage stack [was: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3: document conditions when reliable operation is possible)]
Date: Sat, 29 Aug 2009 19:35:06 -0500
Message-ID: <200908291935.08831.rob@landley.net>
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Pavel Machek <pavel@ucw.cz>,
	Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net,
	"Martin K. Petersen" <martin.petersen@oracle.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday 29 August 2009 16:23:50 Greg Freemyer wrote:
> I've read a fair amount of the various threads discussing sector /
> data corruption of flash and raid devices, but by no means all.
>
> It seems to me the key thing Pavel is highlighting is that many
> storage devices / arrays have reasonably common failure modes where
> data corruption is silently introduced to stable data.  I have seen it
> mentioned, but the scsi spec. recently got a "data integrity" option
> that would allow these corruptions to at least be detected if the
> option were in use.
>
> Regardless, administrators have known forever that a bad cable / bad
> ram / bad controller / etc. can cause data written to a hard drive to
> be written with corrupted values that will not cause a media error on
> read.

Bad ram can do anything if you don't have ECC memory, sure.  In my admittedly 
limited experience, bad controllers tend not to fail _quietly_, with a problem 
writing just this one sector.

I personally have had a tropism for software raid because over the years I've 
seen more than one instance of data loss when a proprietary hardware raid card 
went bad after years of service and the company couldn't find a sufficiently 
similar replacement for the obsolete part capable of reading that strange 
proprietary disk format the card was using.  (Dell was notorious for this once 
upon a time.  These days it's a bit more standardized, but I still want to be 
sure that I _can_ get the data off from a straight passthrough arrangement 
before being _happy_ about it.)

As for bad cables, I believe ATA/33 and higher have checksummed the data going 
across the cable for most of a decade now, at least for DMA transfers.  (Don't 
ask me about about scsi, I mostly didn't use it.)

You've got a 1 in 4 billion chance of a 32 bit checksum magically working out 
even with corrupted data, of course, but that's a fluke failure and not a 
design problem.  And if it got enough failures it would downshift the speed or 
drop to PIO mode and it was possible to detect that your hardware was flaky.

These days I'm pretty sure SATA and USB2 are both checksumming the data going 
across the cable, because the PHY transcievers those use are descended from 
the PHY transcievers originally developed for gigabit ethernet.

PC hardware has always been exactly as cheap and crappy as it could get away 
with, but that's a lot less crappy at gigabit speeds and terabyte sizes than 
it was in the 16 bit ISA days.  We'd be overwhelmed with all the failures 
otherwise.  (Note that the crappiness of USB flash keys is actually 
_surprising_ to some of us , the severity and ease of triggering these failure 
modes are beyond what we've come to expect.)

> It seems to me a file system neutral document describing "silent
> corruption of stable data on permanent storage medium" would be
> appropriate.   Then the linux kernel can start to be hardened to
> properly respond to situations where the data read is not the data
> written.

According to http://lwn.net/Articles/342892/ some of the cool things about 
btrfs are:

A) everything is checksummed, because inodes and dentries and data extents are 
all just slightly differently tagged entries in one big tree, and every entry 
in the tree is checksummed.

2) It has backreferences so you can find most entries from more than one place 
if you have to rebuild a damaged tree.

III) The tree update algorithms are lockless so you can potentially run an 
fsck/defrag on the sucker in the background, which can among other things re-
read the old data and make sure the checksums match.  (So your recommended 
regular fsck can in fact be a low priority cron job.)

That wouldn't prevent you from losing data to this sort of corruption (nothing 
would), but it does give you potentially better ways to find and deal with it.  
Heck, just looking at the stderr output of a simple:

  find / -type f -print0 | xargs -0 -n 1 cat > /dev/null

Could potentially tell you something useful if the filesystem is giving you 
read errors when the extent checksums don't match.  And an rsync could 
reliably get read errors (and abort the backup) due to checksum mismatch 
instead of copying spans of zeroes over your archival copy.

So far this thread reads to _me_ as an implicit endorsement of btrfs.  But so 
far any suggestion that one filesystem might handle this problem better than 
another has so far been taken as personal attacks against people's babies, so 
I haven't asked...

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
