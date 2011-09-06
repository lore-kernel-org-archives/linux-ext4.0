From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Tue, 06 Sep 2011 11:17:18 -0500
Message-ID: <4E66478E.90102@redhat.com>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1IFQRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 12:17:23 -0400
In-Reply-To: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/2/11 4:00 PM, Christian Kujau wrote:
> Hi,
> 
> for some time now, the following message keeps pooping up in my logs:
> 
>  > EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed orphan 
>  > inode list.  Please umount/remount instead
> 
> I don't know when it started. Maybe 2 months ago, I'd guess. The ext4 fs 
> is on top of a dm-crypt device, attached via firewire to a 1TB external 
> disk enclosure. The system (powerpc 32) is loosely following vanilla 
> kernels, currently running 3.1.0-rc4.
> 
> The filesystem is normally mounted r/o but remounted r/w every day to 
> receive backups, then remounted r/o again. Running e2fsck-1.41.12 with -n 
> on the r/o-mounted devices gives the output below.
> 
> I've unmounted the disk some weeks ago, ran e2fsck for real and it fixed 
> the errors. But now more errors seem to have occured.
> 
> Anyone got an idea why this keeps happening? Bad memory? Bad cables? Disk? 
> No other hardware related errors are in the logs and the box is otherwise 
> quite stable.

It's probably not a bug or flaw; orphan inodes can occur for legitimate
reasons (fs goes down while someone is holding open an unlinked file),
and then they must be cleaned up.  If orphan inode processing was skipped
for some reason on the original mount, you can get this error.

Did you happen to also get a message like this on the original mount?

        if (bdev_read_only(sb->s_bdev)) {
                ext4_msg(sb, KERN_ERR, "write access "
                        "unavailable, skipping orphan cleanup");
                return;
        }

?

See also commit: 

commit ead6596b9e776ac32d82f7d1931d7638e6d4a7bd
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Feb 10 01:46:08 2007 -0800

    [PATCH] ext4: refuse ro to rw remount of fs with orphan inodes
    
    In the rare case where we have skipped orphan inode processing due to a
    readonly block device, and the block device subsequently changes back to
    read-write, disallow a remount,rw transition of the filesystem when we have an
    unprocessed orphan inodes as this would corrupt the list.
    
    Ideally we should process the orphan inode list during the remount, but that's
    trickier, and this plugs the hole for now.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Cc: "Stephen C. Tweedie" <sct@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 486a641..463b52b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2419,6 +2419,22 @@ static int ext4_remount (struct super_block * sb, int * flags, char * data)
                                err = -EROFS;
                                goto restore_opts;
                        }
+
+                       /*
+                        * If we have an unprocessed orphan list hanging
+                        * around from a previously readonly bdev mount,
+                        * require a full umount/remount for now.
+                        */
+                       if (es->s_last_orphan) {
+                               printk(KERN_WARNING "EXT4-fs: %s: couldn't "
+                                      "remount RDWR because of unprocessed "
+                                      "orphan inode list.  Please "
+                                      "umount/remount instead.\n",
+                                      sb->s_id);
+                               err = -EINVAL;
+                               goto restore_opts;
+                       }
+
                        /*
                         * Mounting a RDONLY partition read-write, so reread
                         * and store the current valid flag.  (It may have

-Eric

> Thanks,
> Christian.
> 
> -------------------------------------------------
> # fsck.ext4 -vnf /dev/mapper/wdc0 
> e2fsck 1.41.12 (17-May-2010)
> Warning!  /dev/mapper/wdc0 is mounted.
> Pass 1: Checking inodes, blocks, and sizes
> Inodes that were part of a corrupted orphan linked list found.  Fix? no
> 
> Inode 16385 was part of the orphaned inode list.  IGNORED.
> Deleted inode 16439 has zero dtime.  Fix? no
> 
> Inode 2260993 was part of the orphaned inode list.  IGNORED.
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -(9298--9299) -8921121
> Fix? no
> 
> Inode bitmap differences:  -16385 -16439 -2260993
> Fix? no
> 
> Directories count wrong for group #2 (72, counted=70).
> Fix? no
> 
> Directories count wrong for group #276 (76, counted=75).
> Fix? no
> 
> /dev/mapper/wdc0: ********** WARNING: Filesystem still has errors **********
> 
> 
>   562145 inodes used (0.92%)
>     3952 non-contiguous files (0.7%)
>     2544 non-contiguous directories (0.5%)
>          # of inodes with ind/dind/tind blocks: 0/0/0
>          Extent depth histogram: 555449/932
> 215226375 blocks used (88.14%)
>        0 bad blocks
>        5 large files
> 
>   353453 regular files
>   202351 directories
>        0 character device files
>        0 block device files
>        7 fifos
>  2491335 links
>     6235 symbolic links (5657 fast symbolic links)
>       87 sockets
> --------
>  3053468 files
> 

