From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 9 Mar 2012 12:29:29 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2CIL3e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 06:29:34 -0500
In-Reply-To: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 29 Feb 2012, Jacek Luczak wrote:

> Hi All,
> 
> /*Sorry for sending incomplete email, hit wrong button :) I guess I
> can't use Gmail */
> 
> Long story short: We've found that operations on a directory structure
> holding many dirs takes ages on ext4.
> 
> The Question: Why there's that huge difference in ext4 and btrfs? See
> below test results for real values.
> 
> Background: I had to backup a Jenkins directory holding workspace for
> few projects which were co from svn (implies lot of extra .svn dirs).
> The copy takes lot of time (at least more than I've expected) and
> process was mostly in D (disk sleep). I've dig more and done some
> extra test to see if this is not a regression on block/fs site. To
> isolate the issue I've also performed same tests on btrfs.
> 
> Test environment configuration:
> 1) HW: HP ProLiant BL460 G6, 48 GB of memory, 2x 6 core Intel X5670 HT
> enabled, Smart Array P410i, RAID 1 on top of 2x 10K RPM SAS HDDs.
> 2) Kernels: All tests were done on following kernels:
>  - 2.6.39.4-3 -- the build ID (3) is used here for internal tacking of
> config changes mostly. In -3 we've introduced ,,fix readahead pipeline
> break caused by block plug'' patch. Otherwise it's pure 2.6.39.4.
>  - 3.2.7 -- latest kernel at the time of testing (3.2.8 has been
> release recently).
> 3) A subject of tests, directory holding:
>  - 54GB of data (measured on ext4)
>  - 1978149 files
>  - 844008 directories
> 4) Mount options:
>  - ext4 -- errors=remount-ro,noatime,
> data=writeback
>  - btrfs -- noatime,nodatacow and for later investigation on
> copression effect: noatime,nodatacow,compress=lzo
> 
> In all tests I've been measuring time of execution. Following tests
> were performed:
> - find . -type d
> - find . -type f
> - cp -a
> - rm -rf
> 
> Ext4 results:
> | Type     | 2.6.39.4-3   | 3.2.7
> | Dir cnt  | 17m 40sec  | 11m 20sec
> | File cnt |  17m 36sec | 11m 22sec
> | Copy    | 1h 28m        | 1h 27m
> | Remove| 3m 43sec    | 3m 38sec
> 
> Btrfs results (without lzo comression):
> | Type     | 2.6.39.4-3   | 3.2.7
> | Dir cnt  | 2m 22sec  | 2m 21sec
> | File cnt |  2m 26sec | 2m 23sec
> | Copy    | 36m 22sec | 39m 35sec
> | Remove| 7m 51sec   | 10m 43sec
> 
> From above one can see that copy takes close to 1h less on btrfs. I've
> done strace counting times of calls, results are as follows (from
> 3.2.7):
> 1) Ext4 (only to elements):
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  57.01   13.257850           1  15082163           read
>  23.40    5.440353           3   1687702           getdents
>  6.15    1.430559           0   3672418           lstat
>  3.80    0.883767           0  13106961           write
>  2.32    0.539959           0   4794099           open
>  1.69    0.393589           0    843695           mkdir
>  1.28    0.296700           0   5637802           setxattr
>  0.80    0.186539           0   7325195           stat
> 
> 2) Btrfs:
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 53.38    9.486210           1  15179751           read
> 11.38    2.021662           1   1688328           getdents
>  10.64    1.890234           0   4800317           open
>  6.83    1.213723           0  13201590           write
>  4.85    0.862731           0   5644314           setxattr
>  3.50    0.621194           1    844008           mkdir
>  2.75    0.489059           0   3675992         1 lstat
>  1.71    0.303544           0   5644314           llistxattr
>  1.50    0.265943           0   1978149           utimes
>  1.02    0.180585           0   5644314    844008 getxattr
> 
> On btrfs getdents takes much less time which prove the bottleneck in
> copy time on ext4 is this syscall. In 2.6.39.4 it shows even less time
> for getdents:
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  50.77   10.978816           1  15033132           read
>  14.46    3.125996           1   4733589           open
>  7.15    1.546311           0   5566988           setxattr
>  5.89    1.273845           0   3626505           lstat
>  5.81    1.255858           1   1667050           getdents
>  5.66    1.224403           0  13083022           write
>  3.40    0.735114           1    833371           mkdir
>  1.96    0.424881           0   5566988           llistxattr
> 
> 
> Why so huge difference in the getdents timings?
> 
> -Jacek

Hi,

I have created a simple script which creates a bunch of files with
random names in the directory and then performs operation like list,
tar, find, copy and remove. I have run it for ext4, xfs and btrfs with
the 4k size files. And the result is that ext4 pretty much dominates the
create times, tar times and find times. However copy times is a whole
different story unfortunately - is sucks badly.

Once we cross the mark of 320000 files in the directory (on my system) the
ext4 is becoming significantly worse in copy times. And that is where
the hash tree order in the directory entry really hit in.

Here is a simple graph:

http://people.redhat.com/lczerner/files/copy_benchmark.pdf

Here is a data where you can play with it:

https://www.google.com/fusiontables/DataSource?snapid=S425803zyTE

and here is the txt file for convenience:

http://people.redhat.com/lczerner/files/copy_data.txt

I have also run the correlation.py from Phillip Susi on directory with
100000 4k files and indeed the name to block correlation in ext4 is pretty
much random :)

_ext4_
Name to inode correlation: 0.50002499975
Name to block correlation: 0.50002499975
Inode to block correlation: 0.9999900001

_xfs_
Name to inode correlation: 0.969660303397
Name to block correlation: 0.969660303397
Inode to block correlation: 1.0


So there definitely is a huge space for improvements in ext4.

Thanks!
-Lukas

Here is a script I have used to get the numbers above, just to see that
are the operation I have performed.


#!/bin/bash

dev=$1
mnt=$2
fs=$3
count=$4
size=$5

if [ -z $dev ]; then
	echo "Device was not specified!"
	exit 1
fi

if [ -z $mnt ]; then
	echo "Mount point was not specified!"
	exit 1
fi

if [ -z $fs ]; then
	echo "File system was not specified!"
	exit 1
fi

if [ -z $count ]; then
	count=10000
fi

if [ -z $size ]; then
	size=0
fi

export TIMEFORMAT="%3R"

umount $dev &> /dev/null
umount $mnt &> /dev/null

case $fs in
	"xfs") mkfs.xfs -f $dev &> /dev/null; mount $dev $mnt;;
	"ext3") mkfs.ext3 -F -E lazy_itable_init $dev &> /dev/null; mount $dev $mnt;;
	"ext4") mkfs.ext4 -F -E lazy_itable_init $dev &> /dev/null; mount -o noinit_itable $dev $mnt;;
	"btrfs") mkfs.btrfs $dev &> /dev/null; mount $dev $mnt;;
	*) echo "Unsupported file system";
	   exit 1;;
esac


testdir=${mnt}/$$
mkdir $testdir

_remount()
{
	sync
	#umount $mnt
	#mount $dev $mnt
	echo 3 > /proc/sys/vm/drop_caches
}


#echo "[+] Creating $count files"
_remount
create=$((time ./dirtest $testdir $count $size) 2>&1)

#echo "[+] Listing files"
_remount
list=$((time ls $testdir > /dev/null) 2>&1)

#echo "[+] tar the files"
_remount
tar=$((time $(tar -cf - $testdir &> /dev/null)) 2>&1)

#echo "[+] find the files"
_remount
find=$((time $(find $testdir -type f &> /dev/null)) 2>&1)

#echo "[+] Copying files"
_remount
copy=$((time $(cp -a ${testdir} ${mnt}/copy)) 2>&1)

#echo "[+] Removing files"
_remount
remove=$((time $(rm -rf $testdir)) 2>&1)

echo "$fs $count $create $list $tar $find $copy $remove"
