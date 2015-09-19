From: Johan Harvyl <johan@harvyl.se>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Sat, 19 Sep 2015 16:11:50 +0200
Message-ID: <55FD6D26.1010706@harvyl.se>
References: <55CA3BDE.7020401@harvyl.se> <20150811224718.GD20658@thunk.org>
 <55CBC212.6000507@harvyl.se> <20150813132716.GB26095@thunk.org>
 <55CCDE20.3010108@harvyl.se> <55E8C6AC.5000308@harvyl.se>
 <55F3FE07.9030807@harvyl.se> <55F73DAD.6020807@harvyl.se>
 <55F85B90.3000709@harvyl.se> <B9C846A3-35D0-480C-9888-3F46E8A9C6A5@dilger.ca>
 <20150919024725.GV3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34351 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbbISOL7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Sep 2015 10:11:59 -0400
Received: by wicfx3 with SMTP id fx3so94968564wic.1
        for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2015 07:11:57 -0700 (PDT)
In-Reply-To: <20150919024725.GV3902@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the tip about XFS Dave, I have never used it before but I 
decided to give it a try and managed to reproduce my original issue 
there quite quickly.

I took an old 1 TB disk, put it in a USB cradle and attached it to a 
Linux box running Linux 4.1.0-2-amd64, put XFS on it and created a 24T 
sparse file.

# mkfs.xfs /dev/sda1
# truncate test.img -s 24T

Note that this setup shares no hardware components with the box I 
originally noticed the issue on.
The USB cradle is attached to a different box.

Should this be reported in a bug tracker rather than here?

# mkfs.ext4 test.img -i 262144 -m 0 -O 64bit 15627548672k
mke2fs 1.42.13 (17-May-2015)
Discarding device blocks: done
Creating filesystem with 3906887168 4k blocks and 61045248 inodes
Filesystem UUID: 53b8a330-beba-4bc4-ab34-5d57c0f457fb
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
         102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
         2560000000, 3855122432

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

# resize2fs -p test.img 19534435840k
resize2fs 1.42.13 (17-May-2015)
Resizing the filesystem on test.img to 4883608960 (4k) blocks.
Begin pass 2 (max = 6)
Relocating blocks XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 119229)
Scanning inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 5 (max = 8)
Moving inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on test.img is now 4883608960 (4k) blocks long.

# resize2fs -p test.img 23441323008k
resize2fs 1.42.13 (17-May-2015)
Resizing the filesystem on test.img to 5860330752 (4k) blocks.
Begin pass 2 (max = 6)
Relocating blocks XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 149036)
Scanning inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 5 (max = 14)
Moving inode table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Should never happen: resize inode corrupt!

# debugfs -c test.img
debugfs 1.42.13 (17-May-2015)
test.img: catastrophic mode - not reading inode or group bitmaps
debugfs:  stat <2>
Inode: 2   Type: bad type    Mode:  0000   Flags: 0x0

So, again the root inode is trashed.

-johan

On 2015-09-19 04:47, Dave Chinner wrote:
> On Wed, Sep 16, 2015 at 07:21:59PM -0600, Andreas Dilger wrote:
>> If you add "-b 1024" to the mke2fs command line to use 1KB instead of 4KB blocks, and reduce the sizes by a factor of 4 does the problem still happen? That would make it easier for someone else to test, since it would only need a 4-5TB disk instead of a 19Tb array.
> Sparse files on XFS using loopback will allow you to simulate
> devices larger than 16TB easily. You can turtle it all the way down,
> too, to create the xfs filesystem on a loopback device on a sparse
> file on ext4....
>
> Doing this sort of thing lets me know, for example, that the
> mkfs.ext4 defaults fail on a 500TB device...
>
> # xfs_io -f -c 'truncate 500t' /mnt/xfs/fs.img
> # ls -lh /mnt/xfs
> total 0
> -rw------- 1 root root 500T Sep 19 12:41 fs.img
> # mkfs.ext4 /mnt/xfs/fs.img
> mke2fs 1.42.13 (17-May-2015)
> /mnt/xfs/fs.img: Cannot create filesystem with requested number of inodes while setting up superblock
> #
>
> Cheers,
>
> Dave.

