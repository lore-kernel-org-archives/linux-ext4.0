From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: dm corruption? (Was: Re: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd)
Date: Sun, 27 May 2012 21:24:03 +0200
Message-ID: <10110495415.20120527212403@eikelenboom.it>
References: <20120525015417.GK29466@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	<linux-kernel@vger.kernel.org>, <dm-devel@redhat.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:35080
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2E0TbL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 May 2012 15:31:11 -0400
In-Reply-To: <20120525015417.GK29466@outflux.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Kees,

Friday, May 25, 2012, 3:54:17 AM, you wrote:

> Hi,

> On Thu, Jan 05, 2012 at 11:43:22PM +0100, Sander Eikelenboom wrote:
>> Hello Ted,
>> 
>> Thursday, January 5, 2012, 7:15:35 PM, you wrote:
>> 
>> > On Thu, Jan 05, 2012 at 05:14:28PM +0100, Sander Eikelenboom wrote:
>> >> 
>> >> OK spoke too soon, i have been able to trigger it again:
>> >> - copying files from LV to the same LV without the snapshot went OK
>> >> - copying from the RO snapshot of a LV to the same LV gave the error while copying the file again:
>> 
>> > OK.  Originally, you said you did this:
>> 
>> > 1) fsck -v -p -f the filesystem
>> > 2) mount the filesystem
>> > 3) Try to copy a file
>> > 4) filesystem will be mounted RO on error  (see below)
>> > 5) fsck again, journal will be recovered, no other errors
>> > 6) start at 1)
>> 
>> > Was this with with a read-only snapshot always being in existence
>> > through all of these five steps?  When was the RO snapshot created?
>> 
>> > If a RO snapshot has to be there in order for this to happen, then
>> > this is almost certainly a device-mapper regression.  (dm-devel folks,
>> > this is a problem which apparently occurred when the user went from
>> > v3.1.5 to v3.2, so this looks likes 3.2 regression.)
>> 
>> >                                                 - Ted
>> 
>> Tried to bisect, but every kernel in between seems to have some drivers for devices f*cked up so it doesn't even boot.
>> That was a quite frustrating and disappointing experience.
>> So it's back to 3.1.5 and continue with i was actually trying to do, and try later if it's still reproducible with another disk layout.
>> 
>> Thx for your effort so far.

> Has anything else happened with this?

Nope not that i know off, with kernel 3.4.0 ...
When trying to scp/sftp some files to a ext4 filesystem on a LVM partition, makes it readonly within a few seconds:

May 27 21:17:23 serveerstertje kernel: [  880.140374] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1699, 32254 clusters in bitmap, 32258 in gd
May 27 21:17:23 serveerstertje kernel: [  880.147052] Aborting journal on device dm-42-8.
May 27 21:17:23 serveerstertje kernel: [  880.263201] EXT4-fs (dm-42): Remounting filesystem read-only
May 27 21:17:23 serveerstertje kernel: [  880.276990] EXT4-fs (dm-42): ext4_da_writepages: jbd2_start: 1673 pages, ino 7847939; err -30
May 27 21:17:23 serveerstertje kernel: [  880.321661] EXT4-fs error (device dm-42): ext4_journal_start_sb:328: Detected aborted journal

It's quite a pain in the ass ... and not fixed nor tracked down, it's not clear if its a ext4 problem, lvm/dm or the combination.

--
Sander

> I'm seeing similar problems with dm_crypt (with kernel 3.2.7),
> only I also see "JBD2: Spotted dirty metadata buffer",
> which I've found some (unanswered) reference to here:
> https://bugzilla.redhat.com/show_bug.cgi?format=multiple&id=822071

> I can reproduce the problem 100% of the time, but only under the
> early-boot conditions I see it in. I've failed at any attempt so far to
> reproduce it once the system is all the way up. :(

> My steps to reproduce are:

> create 3G sparse file (making this zero-filled doesn't change anything)
> loopback mount file
> bring up dm-crypt on loopback
> build ext4 on dm-crypt
> copy about 100M worth of files into the filesystem

> The amount of errors reported varies, but most recently:

> [   82.659992] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 14, 32258 clusters in bitmap, 32262 in gd
> [   84.338432] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 15, 32258 clusters in bitmap, 32262 in gd
> [   86.334815] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 16, 32258 clusters in bitmap, 32262 in gd
> [   87.660183] JBD2: Spotted dirty metadata buffer (dev = dm-1, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> [   87.814646] JBD2: Spotted dirty metadata buffer (dev = dm-1, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> [   88.221369] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 17, 32258 clusters in bitmap, 32262 in gd
> [   89.930729] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 18, 32258 clusters in bitmap, 32262 in gd
> [   91.709804] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 19, 32258 clusters in bitmap, 32262 in gd
> [   93.805440] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:739: group 20, 32258 clusters in bitmap, 32262 in gd

> I'm at a loss for how to track this down. :(

> Any ideas?

> -Kees

>> >> [ 2357.655783] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:739: group 1861, 32254 clusters in bitmap, 32258 in gd
>> >> [ 2357.656056] Aborting journal on device dm-2-8.
>> >> [ 2357.718473] EXT4-fs (dm-2): Remounting filesystem read-only
>> >> [ 2357.736680] EXT4-fs error (device dm-2) in ext4_da_write_end:2532: IO failure
>> >> [ 2357.738328] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 7615 pages, ino 4079617; err -30
>> >> [ 2716.125010] EXT4-fs error (device dm-2): ext4_put_super:818: Couldn't clean up the journal
>> >> 
>> >> 
>> >> Attached are 4x output from dumpe2fs
>> >> - dumpe2fs-xen_images-3.2.0                           Made just after boot
>> >> - dumpe2fs-xen_images-3.2.0-afterfsck                 Made after doing a fsck -v -p -f on the unmounted LV
>> >> - dumpe2fs-xen_images-3.2.0-aftererror                Made after the error occured on the mounted LV
>> >> - dumpe2fs-xen_images-3.2.0-aftererror-afterfsck      Made after the error occured, and after a subsequent fsck -v -p -f on the unmounted LV
>> >> - dumpe2fs-xen_images-3.1.5                           Made after booting into 3.1.5 after all of the above
>> >> 
>> >> Oh yes also did a badblock scan to rule that out, and it seems the numbers stay the same.
>> >> e2fsck 1.41.12 (17-May-2010) (from debian squeeze)
>> >> 
>> >> --
>> >> Sander
>> >> 
>> >> 
>> >> 
>> >> >> 
>> >> >> --
>> >> >> Sander
>> >> >> 
>> >> >> 
>> >> >> This is a forwarded message
>> >> >> From: Sander Eikelenboom <linux@eikelenboom.it>
>> >> >> To: "Theodore Ts'o" <tytso@mit.edu>
>> >> >> Date: Thursday, January 5, 2012, 11:37:59 AM
>> >> >> Subject: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
>> >> >> 
>> >> >> ===8<==============Original message text===============
>> >> >> 
>> >> >> I'm having some troubles with a ext4 filesystem on LVM, it seems bricked and fsck doesn't seem to find and correct the problem.
>> >> >> 
>> >> >> Steps:
>> >> >> 1) fsck -v -p -f the filesystem
>> >> >> 2) mount the filesystem
>> >> >> 3) Try to copy a file
>> >> >> 4) filesystem will be mounted RO on error  (see below)
>> >> >> 5) fsck again, journal will be recovered, no other errors
>> >> >> 6) start at 1)
>> >> >> 
>> >> >> 
>> >> >> I think the way i bricked it is:
>> >> >> - make a lvm snapshot from that lvm logical disk
>> >> >> - mount that lvm snapshot as RO
>> >> >> - try to copy a file from that mounted RO snapshot to a diffrent dir on the lvm logical disk the snapshot is from.
>> >> >> - it fails and i can't recover (see above)
>> >> >> 
>> >> >> 
>> >> >> Is there a way to recover from this ?
>> >> >> 
>> >> >> 
>> >> >> 
>> >> >> [  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
>> >> >> [  220.749415] Aborting journal on device dm-2-8.
>> >> >> [  220.771633] EXT4-fs error (device dm-2): ext4_journal_start_sb:327: Detected aborted journal
>> >> >> [  220.772593] EXT4-fs (dm-2): Remounting filesystem read-only
>> >> >> [  220.792455] EXT4-fs (dm-2): Remounting filesystem read-only
>> >> >> [  220.805118] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 9680 pages, ino 4079617; err -30
>> >> >> serveerstertje:/mnt/xen_images/domains/production# cd /
>> >> >> serveerstertje:/# umount /mnt/xen_images/
>> >> >> serveerstertje:/# fsck -f -v -p /dev/serveerstertje/xen_images
>> >> >> fsck from util-linux-ng 2.17.2
>> >> >> /dev/mapper/serveerstertje-xen_images: recovering journal
>> >> >> 
>> >> >>     277 inodes used (0.00%)
>> >> >>       5 non-contiguous files (1.8%)
>> >> >>       0 non-contiguous directories (0.0%)
>> >> >>         # of inodes with ind/dind/tind blocks: 41/41/3
>> >> >>         Extent depth histogram: 69/28/2
>> >> >> 51890920 blocks used (79.18%)
>> >> >>       0 bad blocks
>> >> >>      41 large files
>> >> >> 
>> >> >>     199 regular files
>> >> >>      53 directories
>> >> >>       0 character device files
>> >> >>       0 block device files
>> >> >>       0 fifos
>> >> >>       0 links
>> >> >>      16 symbolic links (16 fast symbolic links)
>> >> >>       0 sockets
>> >> >> --------
>> >> >>     268 files
>> >> >> serveerstertje:/#
>> >> >> 
>> >> >> 
>> >> >> 
>> >> >> 
>> >> >> System:
>> >> >> - Kernel 3.2.0
>> >> >> - Debian Squeeze with:
>> >> >> ii  e2fslibs                              1.41.12-4stable1                     ext2/ext3/ext4 file system libraries
>> >> >> ii  e2fsprogs                             1.41.12-4stable1                     ext2/ext3/ext4 file system utilities
>> >> >> 
>> >> >> ===8<===========End of original message text===========




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

