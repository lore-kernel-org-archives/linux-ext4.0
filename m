From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Sat, 14 Mar 2009 00:58:29 +1030
Message-ID: <1236954509.27699.25.camel@kulgan.wumi.org.au>
References: <20090310070915.GN3199@webber.adilger.int>
	 <20090310144651.GC23075@mit.edu>
	 <1236719691.16191.9.camel@kulgan.wumi.org.au>
	 <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int>
	 <1236735808.16191.23.camel@kulgan.wumi.org.au>
	 <1236736137.16191.25.camel@kulgan.wumi.org.au>
	 <20090311061839.GC3199@webber.adilger.int> <20090311132556.GB13698@mit.edu>
	 <1236794830.6624.11.camel@kulgan.wumi.org.au>
	 <20090313005506.GN17104@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:52956 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCMO2f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2009 10:28:35 -0400
In-Reply-To: <20090313005506.GN17104@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-03-12 at 20:55 -0400, Theodore Tso wrote:
> > Inode	Pathname
> > 864	/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32pl.dll
> > 875	/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll
> 
> Well, it's likely those files are corrupted, so you might as well
> delete them and restore from backup if needed/appropriate/possible.

Hrm, deleting these files resulted in:

  EXT4-fs error (device dm-0): ext4_xattr_delete_inode: inode 875: block 118279104364544 read error
  Aborting journal on device dm-0:8.
  Remounting filesystem read-only

Unmounting resulted in:

  EXT4-fs error (device dm-0) in ext4_free_inode: Journal has aborted
  EXT4-fs: mballoc: 6695972 blocks 38497 reqs (34673 success)
  EXT4-fs: mballoc: 4434 extents scanned, 37231 goal hits, 946 2^N hits, 0 breaks, 0 lost
  EXT4-fs: mballoc: 750 generated and it took 6082776
  EXT4-fs: mballoc: 4997239 preallocated, 120774 discarded
  ext4_abort called.
  EXT4-fs error (device dm-0): ext4_put_super: Couldn't clean up the journal

hermes:~# e2fsck -pfv /dev/dm-0
/dev/dm-0: recovering journal
/dev/dm-0: Group descriptor 768 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 769 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 770 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 771 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 772 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 773 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 774 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 775 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 776 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 777 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 778 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 779 checksum is invalid.  FIXED.
/dev/dm-0: Note: if several inode or block bitmap blocks or part
of the inode table require relocation, you may wish to try
running e2fsck with the '-b 32768' option first.  The problem
may lie only with the primary block group descriptors, and
the backup block group descriptors may be OK.

/dev/dm-0: Inode bitmap for group 780 is not in group.  (block 339410944)


/dev/dm-0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)

hermes:~# e2fsck -pfv -b 32768 /dev/dm-0
/dev/dm-0: Group descriptor 0 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 1 checksum is invalid.  FIXED.
/dev/dm-0: Group descriptor 2 checksum is invalid.  FIXED.
....
 (snip messages for every group descriptor in sequence)
....
/dev/dm-0: Group descriptor 8191 checksum is invalid.  FIXED.

  289080 inodes used (0.43%)
   11818 non-contiguous inodes (4.1%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 288728/287
40783849 blocks used (15.19%)
       0 bad blocks
       2 large files

  263218 regular files
   25794 directories
       0 character device files
       0 block device files
       1 fifo
       0 links
      58 symbolic links (54 fast symbolic links)
       0 sockets
--------
  289071 files

I guess there was some additional badness that e2fsck hadn't picked up
the on previous runs. And dammit, there's still something wrong.
Attempting to copy the backup files back in, the cp command is hanging
and I got another one of these:

attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648

Okay, I guess the hang has something to do with the stray file which
turned itself into a named pipe. Trying to remove it again:

hermes:~# rm '/srv/samba/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll'

And I get:

Mar 14 00:48:34 hermes kernel: attempt to access beyond end of device
Mar 14 00:48:34 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
Mar 14 00:48:34 hermes kernel: EXT4-fs error (device dm-0): ext4_xattr_delete_inode: inode 875: block 118279104364544 read error
Mar 14 00:48:34 hermes kernel: Aborting journal on device dm-0:8.
Mar 14 00:48:34 hermes kernel: Remounting filesystem read-only
Mar 14 00:48:34 hermes kernel: EXT4-fs error (device dm-0) in ext4_free_inode: Journal has aborted

Where is this request for block 118279104364544 coming from?

hermes:~# debugfs /dev/dm-0
debugfs 1.41.3 (12-Oct-2008)
debugfs:  stat <875>

Inode: 875   Type: FIFO    Mode:  0611   Flags: 0xb3a9c185
Generation: 3690868    Version: 0x00000000:9d36b10d
User: 27453   Group: 58480   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x49ba6b3a:5a58878c -- Sat Mar 14 00:48:34 2009
 atime: 0x472a2311:00000000 -- Fri Nov  2 05:33:45 2007
 mtime: 0x80c59881:ffffffff -- Fri Jun 18 09:51:21 2038
crtime: 0x49a6c1d1:5f76c580 -- Fri Feb 27 02:52:41 2009
dtime: 0x49ba6b3a -- Sat Mar 14 00:48:34 2009
Size of extra inode fields: 28
BLOCKS:

Does having this reliable way to reproduce the bug help?

Cheers,
Kevin.


