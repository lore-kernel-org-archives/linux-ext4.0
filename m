From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Thu, 12 Mar 2009 04:37:10 +1030
Message-ID: <1236794830.6624.11.camel@kulgan.wumi.org.au>
References: <49B5EDFE.8060405@redhat.com>
	 <1236661371.30280.33.camel@kulgan.wumi.org.au>
	 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
	 <1236719691.16191.9.camel@kulgan.wumi.org.au>
	 <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int>
	 <1236735808.16191.23.camel@kulgan.wumi.org.au>
	 <1236736137.16191.25.camel@kulgan.wumi.org.au>
	 <20090311061839.GC3199@webber.adilger.int> <20090311132556.GB13698@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:59349 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZCKSIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2009 14:08:51 -0400
In-Reply-To: <20090311132556.GB13698@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-03-11 at 09:25 -0400, Theodore Tso wrote: 
> On Wed, Mar 11, 2009 at 12:18:39AM -0600, Andreas Dilger wrote:
> > On Mar 11, 2009  12:18 +1030, Kevin Shanahan wrote:
> > > On Wed, 2009-03-11 at 12:13 +1030, Kevin Shanahan wrote:
> > > > 
> > > >   getfattr: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error
> > > > 
> > > > And syslog shows:
> > > >   Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
> > > >   Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
> > > > 
> > > > hermes:~# debugfs /dev/dm-0
> > > > debugfs 1.41.3 (12-Oct-2008)
> > > > debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"
> > > > 
> > > > Inode: 875   Type: FIFO    Mode:  0611   Flags: 0xb3b9c185
> > > > Generation: 3690868    Version: 0x9d36b10d
> > > > User: 868313917   Group: -1340283792   Size: 0
> > > > File ACL: 0    Directory ACL: 0
> > > > Links: 1   Blockcount: 0
> > > > Fragment:  Address: 0    Number: 0    Size: 0
> > > > ctime: 0x0742afc4 -- Sun Nov 11 06:51:24 1973
> > > > atime: 0x472a2311 -- Fri Nov  2 05:33:45 2007
> > > > mtime: 0x80c59881 -- Fri Jun 18 09:51:21 2038
> > > > Size of extra inode fields: 4
> > > > BLOCKS:
> > 
> > There isn't anything obvious here that would imply reading a wacky block
> > beyond the end of the filesystem.  I even checked if e.g. you had quotas
> > enabled and the bogus UID/GID would result in the quota file becoming
> > astronomically large or something, but the numbers don't seem to match.
> 
> More to the point, given that mode bits of the file detected the file
> as a named pipe ("Type: FIFO"), it wouldn't have tried to access the
> the disk.  Trying to read from a named pipe would have resulted in a
> hang (assuming no data in the named pipe); writing to named pipe would
> have succeeded (and queued the data until another program tried
> reading from the named pipe).  So getting an I/O error from that file
> doesn't make any sense.

But getfattr isn't going to cause a read from the pipe is it? I would
expect that to cause a read from the disk. 

> > Yes, you should just delete the inodes reported corrupted in your
> > earlier postings in the 87x range - they contain nothing of value
> > anymore, and I suspect your troubles would be gone.  At least we
> > wouldn't be left wondering if you are seeing new corruption in
> > the same range of blocks, or just leftover badness.
> 
> The inodes in question that are on that block would be inode numbers
> 864 to 879, inclusive.  You can get the names of the files in question
> using the ncheck command:
> 
> debugfs: ncheck 864 865 866 867 868 869 870 871 872 873 874 875 876 877 878 879

debugfs:  ncheck 864 865 866 867 868 869 870 871 872 873 874 875 876 877 878 879
Inode	Pathname
864	/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32pl.dll
875	/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll

I haven't rm'd the files just yet, but good to know which ones they are.

> ... but at this point, I'm beginning to wonder if what is going on is
> something in the I/O stack is occasionally returning random garbage
> when you read from the particular block in question.  The contents
> reported for debugfs for block 875 should not have caused an I/O error
> when you tried reading from the file.  You can create your own named
> pipe by using the command "mknod /tmp/test-fifo p", and playing with
> it.

Okay, a quick check shows that getfattr on the test-fifo file doesn't
cause an I/O error and it doesn't block either. A straight read from the
pipe does block of course.

> So I'm wondering if when the kernel read block 875, it got one
> version of garbage, and then when debugfs read block 875 later, it got
> another version of garbage.
> 
> One of the original inodes involved was 867, right?  You might want to
> try using the "stat <867>" command and seeing if it still contains
> garbage or not.  Since that was e2fsck should have deleted for you (or
> did you delete it manually yourself?), it should either be all zero's,
> or it should contain the same inode garbage you had sent to the list,
> but with an i_links_count of zero if you deleting the file via the
> "rm" command.  If it contains a different version of garbage, then
> something is corrupting that block, possibly on the read path or the
> write path.

debugfs:  stat <867>

Inode: 867   Type: bad type    Mode:  0404   Flags: 0x0
Generation: 2483046020    Version: 0x17a7fdfd
User: 1455931783   Group: -798021131   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 956780679    Number: 0    Size: 0
ctime: 0xdca60244 -- Wed Apr 23 01:54:36 2087
atime: 0x5c9e956c -- Sat Mar 30 08:30:12 2019
mtime: 0x2ce44e11 -- Sat Nov 13 13:31:37 1993
dtime: 0x49b6564f -- Tue Mar 10 22:30:15 2009
Size of extra inode fields: 4
BLOCKS:
(0):1487030929, (1):3739364871, (2):16299385, (3):2955804704,
(4):3028301176, (5):3255403360, (6):4066441585, (7):643698920,
(8):377498450, (9):297332775, (10):2206476866, (11):169813600,
(IND):2885921245, (DIND):1077961371, (TIND):3308808842
TOTAL: 15

Looks like fsck cleaned up a number of the fields, but not all zeroed.
It seems to have gained some blocks too, but I guess that is meaningless
for an unlinked inode?

> We're now at the stage where I have to start asking questions about
> the storage stack --- i.e. have you used this with this exact
> hardware/configuration with ext3, and was it stable there,, have you
> made any recent changes to the hardware/configuration, etc., since
> this is starting to smell like a potential storage stack problem.

The same hardware has been stable with an ext3 filesystem for about 9
months before this. The only other change that I made at the same time
as moving to ext4 was reconfiguring the RAID from what was originally a
10-disk RAID6 array to a 9-disk RAID6 array with room for one hot spare
(though that spare is not installed currently).

In case it matters, the change to ext4 was done by creating a new
filesystem and rsync'ing the data across, rather than upgrading an
existing ext3 filesystem.

Cheers,
Kevin.


