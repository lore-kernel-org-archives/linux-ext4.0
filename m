From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Tue, 5 Jun 2012 08:56:26 +0200
Message-ID: <17610689248.20120605085626@eikelenboom.it>
References: <17610219749.20120604192048@eikelenboom.it> <20120604230404.GB6525@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120604230404.GB6525@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tuesday, June 5, 2012, 1:04:04 AM, you wrote:

> On Mon, Jun 04, 2012 at 07:20:48PM +0200, Sander Eikelenboom wrote:
>> Hello Ted,
>> 
>> I have a problem back that occured , but didn't receive much respons in debugging:
>> 
>> [ 4688.270789] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
>> [ 4688.279172] Aborting journal on device dm-42-8.
>> [ 4688.288634] EXT4-fs (dm-42): Remounting filesystem read-only
>> [ 4688.299011] EXT4-fs (dm-42): ext4_da_writepages: jbd2_start: 6144 pages, ino 15597569; err -30

> Ah, sorry, I didn't see this message when I responded to your earlier
> message (you didn't mail thread it).  I also didn't recall your
> earlier complaint until I did an search of my mail archives.

> The main problem is that we don't have an easy reproduction case.
> It's not a problem which has been showing up on any of my testing.
> Earlier you had said that this happened after a read-only snapshot, so
> I had assumed it was an DM issue.

Since it doesn't seem to reported much, it is perhaps related to DM, but where the actual cause is I can't say, and the symptoms are in ext4, so that seems where to start.
Especially since it's odd that e2fsck doesn't report and fix anything (apart from the journal).

> But you say this time it's not happening without a snapshot.  OK, how
> frequently does this happen?  How easily can you reproduce it?  Can
> you do it pretty much on demand?  And are the numbers *always* the same?

This time it IS happening WITHOUT a snapshot of this particular lvm-partition.
The numbers are currently always the same, so it's completely reproducible, just by copying say about 10-50 Mb of data to the filesystem.

>> 
>> Running: Fsck -D -f -v -p, results in:
>> 

> Can you run this command instead? e2fsck -f /dev/XXXX
> And send me the output?  The -p overrides the -f option, so it wasn't
> doing a full fsck check.  It should have done a full check if the file
> system was marked as containing an error, regardless of the -p, but
> there was a bug that was fixed in 3.5-rc1 which prevented that.  I'm
> at a loss to explain why you were still seeing problem in 3.5-rc1 ---
> was the fsck log from after running a kernel running 3.5-rc1?  In any
> case, please do a full fsck using "e2fsck -f /dev/XXX" and send me the
> output from that command.

serveerstertje:~# e2fsck -f /dev/serveerstertje/media
e2fsck 1.41.12 (17-May-2010)
/dev/serveerstertje/media: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/serveerstertje/media: ***** FILE SYSTEM WAS MODIFIED *****
/dev/serveerstertje/media: 19122/16384000 files (8.1% non-contiguous), 55602577/65536000 blocks

It didn't prompt for any error and yes this is with running 3.5-rc1.
Perhaps fsck gets the correct numbers and matching numbers for the clusters in the bitmap and gd, and it only differs when actually writing something to the partition, due to some bug ?

I also saw a report from Kees Cook, he has slightly different numbers, 32258 clusters in bitmap, 32262 in gd, although the 32258 seems to match.



> Regards,

>                                                 - Ted




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it
