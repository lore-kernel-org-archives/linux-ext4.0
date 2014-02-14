From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Fri, 14 Feb 2014 18:46:31 -0500
Message-ID: <20140214234631.GC1748@thunk.org>
References: <20140203182634.GA28811@shaniqua>
 <20140203185633.GA22856@thunk.org>
 <20140206210844.GA4335@helmut>
 <87sirnp2m3.fsf@openvz.org>
 <20140213145323.GA6296@helmut>
 <20140213211831.GA11480@thunk.org>
 <20140214201905.GA26292@helmut>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jon Bernard <jbernard@tuxion.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58148 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaBNXqg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Feb 2014 18:46:36 -0500
Content-Disposition: inline
In-Reply-To: <20140214201905.GA26292@helmut>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 14, 2014 at 03:19:05PM -0500, Jon Bernard wrote:
> Ahh, I see.  Here's where this comes from: the particular usecase is
> provisioning of new cloud instances whose root volume is of unknown
> size.  The filesystem and its contents are created and bundled
> before-hand into the smallest filesystem possible.  The instance is PXE
> booted for provisioning and the root filesystem is then copied onto the
> disk - and then resized to take advantage of the total amount of space.
> 
> In order to support very large partitions, the filesystem is created
> with an abnormally large inode table so that large resizes would be
> possible.  I traced it to this commit as best I can tell:
> 
>     https://github.com/openstack/diskimage-builder/commit/fb246a02eb2ed330d3cc37f5795b3ed026aabe07
> 
> I assumed that additional inodes would be allocated along with block
> groups during an online resize, but that commit contradicts my current
> understanding. 

Additional inodes *are* allocated as the file system is grown.
However thought otherwise was wrong.  What happens is that there is a
fixed number of inodes per block group.  When the file system is
resized, either by growing or shrinking file system, as block groups
are added or removed from the file system, the number of inodes
is also added or removed.

> I suggested that the filesystem be created during the time of
> provisioning to allow a more optimal on-disk layout, and I believe this
> is being considered now.

What causes the most damage in terms of a non-optimal data block
layout, installing the file system on a large file system, and then
shrinking the file system to its minimum size use resize2fs -M.  There
is so some non-optimality that occurs as the file system gets filled
beyond about 90% full, but that it's not nearly so bad as shrinking
the file system --- which you should avoid at all costs.

>From a performance point of view, the only time you should try to do
an off-line resize2fs shrink is if you are shrinking the file system
by a handful of blocks as part of converting a file system in place to
use LVM or LUKS encryption, and you need to make room for some
metadata blocks at the end of the partition.

The other thing thing to note is that if you are using a format such
as qcow2, or something like the device-mapper's thin-provisining
(thinkp) scheme, or if you are willing to deal with sparse files, one
approach is to not resize the file system at all.  You could just use
a tool like zerofree[1] to zero out all of the unused blocks in the
file system, and then use "/bin/cp --sparse==always" to cause all zero
blocks to be treated as sparse blocks on the destination file.

[1] http://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/util/zerofree.c

This is part of how I maintain my root filesystem that I use in a VM
for testing ext4 changes upstream.  After I update to the latest
Debian unstable package updates, install the latest updates from the
xfstests and e2fsprogs git repositories, I then run the following
script which uses the zerofree.c program to compress the qcow2 root
file system image that I use with kvm:

http://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/compress-rootfs


Also, starting with e2fsprogs 1.42.10, there's another way you can
efficiently deploy a large file system image by only copying the
blocks which are in use, by using a command like this:

       e2image -rap src_fs dest_fs

(See also the -c flag as described in e2image's man page if you want
to use this technique to do incremental image-based backups onto a
flash-based backup medium; I was using this for a while to keep two
laptop SSD's root filesystem in sync with one another.)

So there are lots of ways that you can do what you need, all without
playing games with resize2fs.  Perhaps some of them would actually be
better for your use case.


> If it turns out to be not terribly complicated and there is not an
> immediate time constraint, I would love to try to help with this or at
> least test patches.

I will hopefully have a bug fix in the next week or two.  

Cheers,

						- Ted
