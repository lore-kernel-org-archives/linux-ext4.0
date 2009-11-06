From: Theodore Tso <tytso@mit.edu>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 6 Nov 2009 11:01:52 -0500
Message-ID: <20091106160152.GB26342@mit.edu>
References: <4AF3F82D.50105@elector.dk> <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com> <4AF40D60.1080503@elector.dk> <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com> <20091106140415.GA26342@mit.edu> <4AF43525.1040205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Salmin <alexey.salmin@gmail.com>,
	Jesper Jensen <linux-ext4_mailinglist@elector.dk>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59582 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340AbZKFQBx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 11:01:53 -0500
Content-Disposition: inline
In-Reply-To: <4AF43525.1040205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2009 at 08:39:33AM -0600, Eric Sandeen wrote:
>
> Well, if you repartitioned / moved the partition, then the new mkfs  
> likely wouldn't have perfectly overwritten the old metadata structures,  
> so if you can re-partition again and put the starting sector -back- at  
> the original location, an e2fsck might have a fighting chance to find  
> -something- ...

I thought what had been done was that a physical disk had a new ESX
layout slapped on top of it, and then a new partition label was
created, and *then* mkfs.ext4 was run --- so that the new filesystem
pretty much overlaid the original filesystem.  In that case, there
really isn't much that can be done.  If the repartitioning really did
move the start of the filesystem sufficiently to avoid smashing all of
the metadata fields, then I agree, there might be a chance....


One idea which Andi Kleen and I tossed around at Linux Kongress was to
add a 4 byte per-inode CRC that also mixed in the inode number (to
detect inode table blocks getting written to the wrong location on
disk) as well as a per-filesystem ID.  This would allow us to detect
inodes from pervious filesystems formats, which would also allow us to
avoid needing to zero out the inode table, and it might allow for
people to have a slightly better chance of recovering after a mke2fs
(as well as making mke2fs faster without needing to zero the inode
table, either in mke2fs or via a background kernel thread once the
file system is mounted).

					- Ted
