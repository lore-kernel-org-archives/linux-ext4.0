From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: mkfs.ext4 -D option fails to mount
Date: Thu, 29 Jun 2017 17:06:37 -0600
Message-ID: <20170629230637.GA14347@linux.intel.com>
References: <20170629153538.GA4268@linux.intel.com>
 <20170629155727.GA8536@linux.intel.com>
 <20170629175319.s75rdncvejil357p@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:29896 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751950AbdF2XGo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Jun 2017 19:06:44 -0400
Content-Disposition: inline
In-Reply-To: <20170629175319.s75rdncvejil357p@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 29, 2017 at 01:53:19PM -0400, Theodore Ts'o wrote:
> On Thu, Jun 29, 2017 at 09:57:27AM -0600, Ross Zwisler wrote:
> > On Thu, Jun 29, 2017 at 09:35:38AM -0600, Ross Zwisler wrote:
> > > Our validation team noticed that in some configurations mkfs.ext4 with the
> > > -D option creates a filesystem that can't be mounted:
> 
> The -D option just means that we're doing the I/O using Direct I/O (as
> opposed to buffered I/O).  It shouldn't make any difference to what
> gets written, so this very much smells like a bug in how /dev/pmem
> supports Direct I/O...
> 
> > One more bit of info - this seems to be strongly tied to the size of the
> > block device.  With a 32 GB block device it works fine, with 248 GB you get
> > overlap messages for groups 1 through 63, and with a 250 GB device you get
> > overlaps for groups 1 through 1999.
> 
> This very much sounds like Direct I/O is just getting completely
> botched for the pmem device, and writes to a block group descriptor
> block is affecting the wrong place on the storage device.

This also reproduces with brd or loop as our block device:

  # modprobe brd rd_size=$((1024*1024*248))
  
  # mkfs.ext4 /dev/ram0 -F -D 
  mke2fs 1.43.3 (04-Sep-2016)
  Discarding device blocks: done                            
  Creating filesystem with 65011712 4k blocks and 16252928 inodes
  Filesystem UUID: 1632baa4-7260-4cc1-9558-0cb3aa2f213e
  Superblock backups stored on blocks: 
  	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
  	4096000, 7962624, 11239424, 20480000, 23887872
  
  Allocating group tables: done                            
  Writing inode tables: done                            
  Creating journal (262144 blocks): done
  Writing superblocks and filesystem accounting information: done     
  
  # mount /dev/ram0 /mnt
  mount: wrong fs type, bad option, bad superblock on /dev/ram0,
         missing codepage or helper program, or other error
  
         In some cases useful info is found in syslog - try
         dmesg | tail or so.

where dmesg says:

  EXT4-fs (ram0): ext4_check_descriptors: Block bitmap for group 64 overlaps superblock
  EXT4-fs (ram0): ext4_check_descriptors: Inode bitmap for group 64 overlaps superblock
  EXT4-fs (ram0): ext4_check_descriptors: Inode table for group 64 overlaps superblock
  EXT4-fs (ram0): ext4_check_descriptors: Block bitmap for group 65 overlaps superblock
  EXT4-fs (ram0): ext4_check_descriptors: Inode bitmap for group 65 overlaps superblock
  ...
  EXT4-fs (ram0): ext4_check_descriptors: Block bitmap for group 1983 overlaps superblock
  EXT4-fs (ram0): ext4_check_descriptors: Inode bitmap for group 1983 overlaps superblock
  EXT4-fs (ram0): ext4_check_descriptors: Inode table for group 1983 overlaps superblock
  EXT4-fs (ram0): no journal found

or

  # truncate -s 248G loop_fs
  # losetup /dev/loop0 ./loop_fs 
  # mkfs.ext4 /dev/loop0 -F -D
  mke2fs 1.43.3 (04-Sep-2016)
  /dev/loop0 contains a ext4 file system
  	last mounted on Thu Jun 29 17:03:07 2017
  Discarding device blocks: done                            
  Creating filesystem with 65011712 4k blocks and 16252928 inodes
  Filesystem UUID: 00912ac9-599a-4396-9ef3-a353bdec69ea
  Superblock backups stored on blocks: 
  	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
  	4096000, 7962624, 11239424, 20480000, 23887872
  
  Allocating group tables: done                            
  Writing inode tables: done                            
  Creating journal (262144 blocks): done
  Writing superblocks and filesystem accounting information: done     
  
  # mount /dev/loop0 /tmp
  mount: wrong fs type, bad option, bad superblock on /dev/loop0,
         missing codepage or helper program, or other error
  
         In some cases useful info is found in syslog - try
         dmesg | tail or so.

with similar messages.

- Ross
