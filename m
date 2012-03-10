From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 9 Mar 2012 16:09:43 -0800
Message-ID: <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53050 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2CJAZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 19:25:40 -0500
Received: by iagz16 with SMTP id z16so2978364iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Mar 2012 16:25:40 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-09, at 3:29, Lukas Czerner <lczerner@redhat.com> wrote:
> 
> I have created a simple script which creates a bunch of files with
> random names in the directory and then performs operation like list,
> tar, find, copy and remove. I have run it for ext4, xfs and btrfs with
> the 4k size files. And the result is that ext4 pretty much dominates the
> create times, tar times and find times. However copy times is a whole
> different story unfortunately - is sucks badly.
> 
> Once we cross the mark of 320000 files in the directory (on my system) the
> ext4 is becoming significantly worse in copy times. And that is where
> the hash tree order in the directory entry really hit in.
> 
> Here is a simple graph:
> 
> http://people.redhat.com/lczerner/files/copy_benchmark.pdf
> 
> Here is a data where you can play with it:
> 
> https://www.google.com/fusiontables/DataSource?snapid=S425803zyTE
> 
> and here is the txt file for convenience:
> 
> http://people.redhat.com/lczerner/files/copy_data.txt
> 
> I have also run the correlation.py from Phillip Susi on directory with
> 100000 4k files and indeed the name to block correlation in ext4 is pretty
> much random :)

Just reading this on the plane, so I can't find the exact reference that I want, but a solution to this problem with htree was discussed a few years ago between myself and Coly Li.

The basic idea is that for large directories the inode allocator starts by selecting a range of (relatively) free inodes based on the current directory size, and then piecewise maps the hash value for the filename into this inode range and uses that as the goal inode.

When the inode range is (relatively) filled up (as determined by average distance between goal and allocated inode), a new (larger) inode range is selected based on the new (larger) directory size and usage continues as described.

This change is only in-memory allocation policy and does not affect the on disk format, though it is expected to improve the hash->inode mapping coherency significantly.

When the directory is small (below a thousand or so) the allocations will be close to the parent and the ordering doesn't matter significantly because the inode table blocks will all be quickly read or prefetched from disk.  It wouldn't be harmful to use the mapping algorithm in this case, but it likely won't show much improvement. 

As the directory gets larger, the range of inodes will also get larger. The number of inodes in the smaller range becomes less significant as the range continues to grow.

Once the inode range is hundreds of thousands or larger the mapping of the hash to the inodes will avoid a lot of random IO.

When restarting from a new mount, the inode ranges can be found when doing the initial name lookup in the leaf block by checking the allocated inodes for existing dirents. 

Unfortunately, the prototype that was developed diverged from this idea and didn't really achieve the results I wanted. 

Cheers, Andreas

> _ext4_
> Name to inode correlation: 0.50002499975
> Name to block correlation: 0.50002499975
> Inode to block correlation: 0.9999900001
> 
> _xfs_
> Name to inode correlation: 0.969660303397
> Name to block correlation: 0.969660303397
> Inode to block correlation: 1.0
> 
> 
> So there definitely is a huge space for improvements in ext4.
> 
> Thanks!
> -Lukas
> 
> Here is a script I have used to get the numbers above, just to see that
> are the operation I have performed.
> 
> 
> #!/bin/bash
> 
> dev=$1
> mnt=$2
> fs=$3
> count=$4
> size=$5
> 
> if [ -z $dev ]; then
>    echo "Device was not specified!"
>    exit 1
> fi
> 
> if [ -z $mnt ]; then
>    echo "Mount point was not specified!"
>    exit 1
> fi
> 
> if [ -z $fs ]; then
>    echo "File system was not specified!"
>    exit 1
> fi
> 
> if [ -z $count ]; then
>    count=10000
> fi
> 
> if [ -z $size ]; then
>    size=0
> fi
> 
> export TIMEFORMAT="%3R"
> 
> umount $dev &> /dev/null
> umount $mnt &> /dev/null
> 
> case $fs in
>    "xfs") mkfs.xfs -f $dev &> /dev/null; mount $dev $mnt;;
>    "ext3") mkfs.ext3 -F -E lazy_itable_init $dev &> /dev/null; mount $dev $mnt;;
>    "ext4") mkfs.ext4 -F -E lazy_itable_init $dev &> /dev/null; mount -o noinit_itable $dev $mnt;;
>    "btrfs") mkfs.btrfs $dev &> /dev/null; mount $dev $mnt;;
>    *) echo "Unsupported file system";
>       exit 1;;
> esac
> 
> 
> testdir=${mnt}/$$
> mkdir $testdir
> 
> _remount()
> {
>    sync
>    #umount $mnt
>    #mount $dev $mnt
>    echo 3 > /proc/sys/vm/drop_caches
> }
> 
> 
> #echo "[+] Creating $count files"
> _remount
> create=$((time ./dirtest $testdir $count $size) 2>&1)
> 
> #echo "[+] Listing files"
> _remount
> list=$((time ls $testdir > /dev/null) 2>&1)
> 
> #echo "[+] tar the files"
> _remount
> tar=$((time $(tar -cf - $testdir &> /dev/null)) 2>&1)
> 
> #echo "[+] find the files"
> _remount
> find=$((time $(find $testdir -type f &> /dev/null)) 2>&1)
> 
> #echo "[+] Copying files"
> _remount
> copy=$((time $(cp -a ${testdir} ${mnt}/copy)) 2>&1)
> 
> #echo "[+] Removing files"
> _remount
> remove=$((time $(rm -rf $testdir)) 2>&1)
> 
> echo "$fs $count $create $list $tar $find $copy $remove"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
