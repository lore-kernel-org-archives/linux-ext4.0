From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A couple of ext4 crashes with inlinedata/bigalloc
Date: Wed, 9 Apr 2014 12:56:41 +0800
Message-ID: <20140409045641.GA8908@gmail.com>
References: <20140311030604.GK9875@birch.djwong.org>
 <20140408115425.GA23781@gmail.com>
 <20140408184003.GB8888@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38501 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaDIEue (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 00:50:34 -0400
Received: by mail-pb0-f48.google.com with SMTP id md12so1990672pbc.7
        for <linux-ext4@vger.kernel.org>; Tue, 08 Apr 2014 21:50:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140408184003.GB8888@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 11:40:03AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 08, 2014 at 07:54:25PM +0800, Zheng Liu wrote:
> > On Mon, Mar 10, 2014 at 08:06:04PM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > A couple of errors to complain about before I send out the e2fsprogs patchbomb.
> > > :)
> > > 
> > > Zheng: I've been running the metadata checksum test with inline_data set.
> > > flat_dir_test is a stress test which copies /usr/share/doc into a filesystem
> > > and then "enlarges" the directories by recursively renaming "$foo" to
> > > "$foo.longer", with the results below.  e2fsck complained that the directories
> > > involved (4156, 4251) have multiple links to the subdir inode.  I'm not sure
> > > what this is all about; the only (circumstantial) evidence I have is that it
> > > goes away if I don't turn on inline_data.
> > 
> > Hi Darrick,
> > 
> > I guess that you were talking about this bug at LSF/MM submmit this
> > year, right?  Thanks for reporting this bug.  I am trying to take a
> > closer look at it.  It would be great if you could tell me where I can
> > find the your test program ('flat_dir_test').
> 
> It's buried in the metadata checksum test suite, alas.  The test copies an
> arbitrary directory (/usr/share/doc) to the filesystem, then does a depth-first
> traversal of the copied tree, renaming everything it finds from "oldname" to
> "oldname.longer" to force the kernel to shuffle directory entries all over the
> place, and likely causing spill-out from formerly inlinedata directories.

I write a simple script to try to reproduce the problem.  But,
unfortunately, I failed.  The kernel is based on ext4/dev branch, and
e2fsprogs is based on e2fsprogs/next branch.  I paste the script below
and the output of 'dumpe2fs -h'.  Please let me know if I miss
something.

Thanks,
                                                - Zheng


#!/bin/bash

dev='/dev/sda1'
mnt='/mnt/sda1'
e2fsprogs_base="$HOME/projects/ext4-dev/e2fsprogs"
mkfs="$e2fsprogs_base/misc/mke2fs"
fsck="$e2fsprogs_base/e2fsck/e2fsck"

sudo umount $mnt
sudo $mkfs -t ext4 -O inline_data,metadata_csum,64bit $dev
sudo mount -t ext4 $dev $mnt
sudo chown wenqing:wenqing $mnt

cd $mnt
mkdir testdir
cp -rf /usr/share/doc/* testdir/

function do_rename()
{
	tmpfilename=$(mktemp --dry-run)
	postfix=$(echo $tmpfilename | awk -F'/' '{print $3}')
	mv "$1" "$1-$postfix"
}

function do_dir()
{
	for ent in $1/*; do
		if [ -d $ent ]; then
			do_dir $ent
		else
			do_rename $ent
		fi
	done
}

do_dir $mnt/testdir

cd $e2fsprogs_base
sudo umount $mnt
sudo $fsck -f $dev

exit 0


dumpe2fs 1.43-WIP (4-Feb-2014)
Filesystem volume name:   <none>
Last mounted on:          /mnt/sda1
Filesystem UUID:          5643cf62-dd3b-4883-9991-4d7f319e3e1e
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg inline_data sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              5021696
Block count:              20081242
Reserved block count:     1004062
Free blocks:              19663835
Free inodes:              5007473
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Wed Apr  9 11:41:36 2014
Last mount time:          Wed Apr  9 11:41:42 2014
Last write time:          Wed Apr  9 11:43:28 2014
Mount count:              0
Maximum mount count:      -1
Last checked:             Wed Apr  9 11:43:28 2014
Check interval:           0 (<none>)
Lifetime writes:          1601 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      698d5a93-bfa8-4b55-b4ab-ae94c4e9e5e0
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x7c4d3477
Journal features:         journal_64bit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000017
Journal start:            0
