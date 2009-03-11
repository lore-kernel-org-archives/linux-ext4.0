From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 09:25:56 -0400
Message-ID: <20090311132556.GB13698@mit.edu>
References: <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au> <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu> <1236719691.16191.9.camel@kulgan.wumi.org.au> <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int> <1236735808.16191.23.camel@kulgan.wumi.org.au> <1236736137.16191.25.camel@kulgan.wumi.org.au> <20090311061839.GC3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45090 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129AbZCKN0U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Mar 2009 09:26:20 -0400
Content-Disposition: inline
In-Reply-To: <20090311061839.GC3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 11, 2009 at 12:18:39AM -0600, Andreas Dilger wrote:
> On Mar 11, 2009  12:18 +1030, Kevin Shanahan wrote:
> > On Wed, 2009-03-11 at 12:13 +1030, Kevin Shanahan wrote:
> > > 
> > >   getfattr: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error
> > > 
> > > And syslog shows:
> > >   Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
> > >   Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
> > > 
> > > hermes:~# debugfs /dev/dm-0
> > > debugfs 1.41.3 (12-Oct-2008)
> > > debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"
> > > 
> > > Inode: 875   Type: FIFO    Mode:  0611   Flags: 0xb3b9c185
> > > Generation: 3690868    Version: 0x9d36b10d
> > > User: 868313917   Group: -1340283792   Size: 0
> > > File ACL: 0    Directory ACL: 0
> > > Links: 1   Blockcount: 0
> > > Fragment:  Address: 0    Number: 0    Size: 0
> > > ctime: 0x0742afc4 -- Sun Nov 11 06:51:24 1973
> > > atime: 0x472a2311 -- Fri Nov  2 05:33:45 2007
> > > mtime: 0x80c59881 -- Fri Jun 18 09:51:21 2038
> > > Size of extra inode fields: 4
> > > BLOCKS:
> 
> There isn't anything obvious here that would imply reading a wacky block
> beyond the end of the filesystem.  I even checked if e.g. you had quotas
> enabled and the bogus UID/GID would result in the quota file becoming
> astronomically large or something, but the numbers don't seem to match.

More to the point, given that mode bits of the file detected the file
as a named pipe ("Type: FIFO"), it wouldn't have tried to access the
the disk.  Trying to read from a named pipe would have resulted in a
hang (assuming no data in the named pipe); writing to named pipe would
have succeeded (and queued the data until another program tried
reading from the named pipe).  So getting an I/O error from that file
doesn't make any sense.

> Yes, you should just delete the inodes reported corrupted in your
> earlier postings in the 87x range - they contain nothing of value
> anymore, and I suspect your troubles would be gone.  At least we
> wouldn't be left wondering if you are seeing new corruption in
> the same range of blocks, or just leftover badness.

The inodes in question that are on that block would be inode numbers
864 to 879, inclusive.  You can get the names of the files in question
using the ncheck command:

debugfs: ncheck 864 865 866 867 868 869 870 871 872 873 874 875 876 877 878 879

... but at this point, I'm beginning to wonder if what is going on is
something in the I/O stack is occasionally returning random garbage
when you read from the particular block in question.  The contents
reported for debugfs for block 875 should not have caused an I/O error
when you tried reading from the file.  You can create your own named
pipe by using the command "mknod /tmp/test-fifo p", and playing with
it.  So I'm wondering if when the kernel read block 875, it got one
version of garbage, and then when debugfs read block 875 later, it got
another version of garbage.  

One of the original inodes involved was 867, right?  You might want to
try using the "stat <867>" command and seeing if it still contains
garbage or not.  Since that was e2fsck should have deleted for you (or
did you delete it manually yourself?), it should either be all zero's,
or it should contain the same inode garbage you had sent to the list,
but with an i_links_count of zero if you deleting the file via the
"rm" command.  If it contains a different version of garbage, then
something is corrupting that block, possibly on the read path or the
write path.

							- Ted

P.S.  The reason why I asked you about your RAID card was because I
recently ended up spending time helping a user who had flashed LSI
firmware onto a Dell PERCS card, because some forum had stated that
the Dell PERCS card was a rebadged LSI hardware.  Turns out that while
the card was made by LSI, it was also customized by Dell, and flashing
the non-approved hardware caused a bug to trigger for devices larger
than 4TB, such that a block near the beginning of the filesystem (in
this case, it was a block group descriptor block, so we could easily
recover from the backup descriptor blocks) was getting trashed after
every boot.  I had forgotten that you had said earlier that you only
had a 1TB filesystem, but otherwise the symptoms looked very similar,
so I figured I had to ask.  

We're now at the stage where I have to start asking questions about
the storage stack --- i.e. have you used this with this exact
hardware/configuration with ext3, and was it stable there,, have you
made any recent changes to the hardware/configuration, etc., since
this is starting to smell like a potential storage stack problem.
