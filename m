From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: backup of the last group'descriptor when it is the 1st group of a meta_bg
Date: Tue, 3 Apr 2012 13:28:14 -0600
Message-ID: <2E05166B-2C63-4DA0-BD80-7C91C9623BDF@dilger.ca>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com> <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca> <20120403183951.GA24502@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44607 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab2DCTZ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2012 15:25:59 -0400
In-Reply-To: <20120403183951.GA24502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-03, at 12:39 PM, Ted Ts'o wrote:
> On Wed, Mar 28, 2012 at 10:08:39AM -0600, Andreas Dilger wrote:
>> Actually, if the backup is always stored in the last block of the 0th
>> group (which is itself the last group in the filesystem), there isn't
>> even a need to store this location in the superblock.
> 
> Something that might make sense is to put a backup of the block group
> descriptor at block #s_num_blocks (i.e., one block past the end of the
> file system as described in the superblock).  E2fsck would just simply
> try to see if there's a valid block group descriptor block at one
> block past the end of the file system if the primary looks bad and
> there aren't any of the normal meta_bg backups --- and that way we
> wouldn't need to make any file system format changes.

I had thought of that as well, but came to the conclusion that it was
a bit hacky to store filesystem metadata past the end of the filesystem
as declared in the superblock.

My thinking for putting the backup inside the filesystem was that the
error reported by an old e2fsck (last block marked in bitmap) was
harmless, and could easily be repaired by a newer version of e2fsck.

It would probably not even cause the backup group descriptor to be
lost in the worst case (new mke2fs/e2fsck/resize2fs creates gd backup,
old e2fsck "deletes" gd backup block, use filesystem for a long time,
corrupt primary group descriptors, try to recover using new e2fsck).

If the user is only running an old e2fsck, then they are no worse off
than before - no backup existed for the meta_bg at all.  In virtually
every case with a new e2fsck, the last block inside the filesystem
would not be allocated (compounding the already rare case where the
last group descriptor is corrupted), and e2fsck can verify the checksum
of the group descriptor in that block and use this to locate the bitmaps
and inode table for the last group.  Again, if the checksum fails, then
the filesystem is no worse off than today if no backup was stored.

Cheers, Andreas





