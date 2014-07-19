From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: Delayed block allocation failures after shrinking fs
Date: Sun, 20 Jul 2014 03:47:49 +0400
Message-ID: <20140719234749.GB6073@azat>
References: <20140719223906.GA8148@pyropus.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Charles Cazabon <charlesc-linux-ext4@pyropus.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:45242 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGSXr5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2014 19:47:57 -0400
Received: by mail-la0-f51.google.com with SMTP id el20so3827124lab.10
        for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2014 16:47:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140719223906.GA8148@pyropus.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sun, Jul 20, 2014 at 2:39 AM, Charles Cazabon <charlesc-linux-ext4@pyropus.ca> wrote:
> Greetings,
>
> I ran into some odd behaviour/problems with an ext4 filesystem recently, and
> it appears I ran into an ext4 problem.  I've recovered my data, but wanted to
> know if the developers want any info about this problem before I wipe it out.
>
> I had a ~5TB ext4 filesystem (on LVM, on LUKS encrypted partitions, on
> spinning disks) that I had migrated much of the data off of, and planned to
> replace the underlying disks with a much smaller but faster SSD setup.
>
> So I unmounted the filesystem, fsck'ed it, shrank it to ~300GB with `resize2fs
> -M, then shrank the size of the LVM logical volume it was sitting on (to
> ~320G), then migrated the data off the spinning disks and to the SSD by
> migrating the LVM extents.  After this, I started seeing `Delayed block
> allocation failed` errors for this filesystem, and indeed some files were
> getting corrupted as they were written to.  My first suspicion was that this
> was due to a faulty SSD, but that doesn't appear to be the case -- for one
> thing, there were no SATA or other errors for the device logged.
>
> I tested the SSD by setting up another filesystem on it, and letting mkfs.ext4
> run badblocks over it -- no errors were reported.  Running various filesystem
> benchmarks and testing programs on the test filesystem showed no problems
> either, so I created a new ext4 filesystem, copied the data over from the
> failing filesystem, and switched to using it -- and the problems went away
> entirely (this is with the new filesystem on the same underlying physical
> device as the problematic one).  I've run like this for several days now, and
> have had no EXT4 errors (or other errors) logged about the new filesystem, and
> have experienced no further data corruption.
>
> So it would appear the filesystem didn't survive the shrink operation entirely
> fine.  I've recovered my data from backups, so this is not a big deal, but I
> was wondering if the ext4 developers would like any information (metadata
> image or whatever else) from this filesystem before I wipe it and reuse the
> space.  Shrinking a formerly-full filesystem from several TB to a few hundred
> GB is probably not a case that gets tested a lot, I would guess.

Hi Charles,

I've also used resize2fs for shrinking the fs, but with extra padding.
You could look into [1] for script that I've used for this, but it is
*VERY DEBUG*.
I used it for shrinking 36 disks, up to 30%-40% of reserved space. After
I copied them to new machines/disks (dd+nc, not lvm), there I enlarged it
to disk size (4T), and after all of this there was no errors during
exploitation.
(I use something like [2] for the whole shrink-copy-enlarge process)

I'm not sure about this, but if you could test shrinking with extra
padding, maybe it will help to avoid that errors, and also it would help
find the place where the problem is (if it is still there?).

And one question for you, do you have bigalloc option enabled?

Some information from my setup (nothing special):
  resize2fs 1.42.5 (29-Jul-2012)
  3.2.0-4-amd64 # uname -r
  Filesystem features: has_journal ext_attr resize_inode dir_index
  filetype extent flex_bg sparse_super large_file huge_file uninit_bg
  dir_nlink extra_isize
  Mount options: noatime,nouser_xattr,barrier=1,data=ordered

Cheers,
Azat.

[1] https://github.com/azat/e2fs-cp/blob/master/resize2fs.sh
[2] https://github.com/azat/e2fs-cp/blob/master/resize_copy.sh
