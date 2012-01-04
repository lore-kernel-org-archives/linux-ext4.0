From: markk@clara.co.uk
Subject: Re: fallocate() not "atomic" if insufficient disk space?
Date: Wed, 4 Jan 2012 22:40:32 -0000
Message-ID: <7fe41d7a6b28729267d6e337893837b4.squirrel@ssl-webmail-vh.clara.net>
References: <e10c1a3b87ce0766dcc538b8332cb9a4.squirrel@ssl-webmail-vh.clara.net>
    <4EFE45B1.9040902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:60728 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757137Ab2ADWkj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 17:40:39 -0500
In-Reply-To: <4EFE45B1.9040902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On December 30 Eric Sanden wrote:
> On 12/28/11 10:09 AM, markk@clara.co.uk wrote:
>>...
>> What I expected to happen is that if fallocate() fails due to lack of
>> disk
>> space, no space is allocated, i.e. either nothing happens or the
>> allocation succeeds.
>>
>> What actually seems to happen is that all remaining space in the
>> partition
>> gets allocated to the file. (Thus risking that other programs will fail
>> due to lack of disk space until the file is deleted.)
>
> To be honest, I'm not sure how it is _supposed_ to work, but I see this
> same behavior with fallocate, with posix_fallocate calling fallocate, and
> with
> posix_fallocate simply writing out data via glibc, (I tested several of
> those
> combinations on different filesystems, anyway).
>
> Even the posix_fallocate spec doesn't say what is supposed to happen to
> space
> allocated prior to failure, but the implementations seem fairly
> consistent.
> Seems fair to say that callers should check error returns, and unlink or
> truncate on error as needed.

Has anyone tested how posix_fallocate() handles ENOSPC on non-Linux
systems (Solaris, BSD etc.)?

Though the documentation doesn't specifically state what happens on an
out-of-disk-space condition, I would have assumed that the filesystem
should either check for sufficient space before allocating any, or back
out/undo any partial allocation on failure. The current
leave-the-disk-full behaviour is definitely not ideal IMHO. The filesystem
is much better placed than the calling program to revert any changes.

If a program created a non-sparse file and wanted to allocate a region
beyond its current end, failure of fallocate() is fairly simple to recover
from; just truncate the file.  But in the general case it's not possible
(or at least very tricky) to properly recover when fallocate() fails due
to insufficient disk space...

Suppose the fallocate program were modified to properly restore the file
state when fallocate() returns ENOSPC. Here's what it would need to do:
 - Open the file.
 - Build a map of the holes in the file. You could use SEEK_HOLE/SEEK_END,
but I don't think that's sufficient to tell if the file has space
allocated beyond its apparent length (i.e. if fallocate() was previously
used with FALLOC_FL_KEEP_SIZE). So you'd probably need to use fiemap
(which is Linux-specific and quite complicated).
 - Call fallocate() with the user-specified offset and length. If it
returns ENOSPC, then:
    - loop through the list of holes, calling fallocate() with
FALLOC_FL_PUNCH_HOLE to restore any holes which were in the fallocated
region (between offset and offset+length-1 bytes). That's only
possible if the user's kernel and filesystem are recent enough to
support hole punching.
    - If offset+length was greater than the file's original size,
ftruncate() to its original length.
    - If there was originally space allocated past the end of the file,
call fallocate() with FALLOC_FL_KEEP_SIZE to restore the allocation.

A possible real-world example could be a (sparse) virtual machine hard
disk image which the user wants to make non-sparse. He uses the fallocate
command to fully allocate its entire size, not realising there is
insufficient disk space. So fallocate() fails and the disk is full. If the
user doesn't have a program to scan a file and punch holes in the all-zero
regions (assuming the kernel/filesystem support hole punching) the only
way to recover would be to copy the image file to another partition (cp
--sparse=always) and back again.

It would be much simpler/easier if the filesystem could handle running out
of disk space; the filesystem can keep a list of allocated regions and on
running out can just free them again before returning ENOSPC.


