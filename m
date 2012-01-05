From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: fallocate() not "atomic" if insufficient disk space?
Date: Wed, 04 Jan 2012 16:19:52 -0800
Message-ID: <4F04ECA8.8090609@oracle.com>
References: <e10c1a3b87ce0766dcc538b8332cb9a4.squirrel@ssl-webmail-vh.clara.net>    <4EFE45B1.9040902@redhat.com> <7fe41d7a6b28729267d6e337893837b4.squirrel@ssl-webmail-vh.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: markk@clara.co.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:47171 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab2AEAU7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 19:20:59 -0500
In-Reply-To: <7fe41d7a6b28729267d6e337893837b4.squirrel@ssl-webmail-vh.clara.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/04/2012 02:40 PM, markk@clara.co.uk wrote:
> Has anyone tested how posix_fallocate() handles ENOSPC on non-Linux
> systems (Solaris, BSD etc.)?
>
> Though the documentation doesn't specifically state what happens on an
> out-of-disk-space condition, I would have assumed that the filesystem
> should either check for sufficient space before allocating any, or back
> out/undo any partial allocation on failure. The current
> leave-the-disk-full behaviour is definitely not ideal IMHO. The filesystem
> is much better placed than the calling program to revert any changes.
>
> If a program created a non-sparse file and wanted to allocate a region
> beyond its current end, failure of fallocate() is fairly simple to recover
> from; just truncate the file.  But in the general case it's not possible
> (or at least very tricky) to properly recover when fallocate() fails due
> to insufficient disk space...
>
> Suppose the fallocate program were modified to properly restore the file
> state when fallocate() returns ENOSPC. Here's what it would need to do:
>   - Open the file.
>   - Build a map of the holes in the file. You could use SEEK_HOLE/SEEK_END,
> but I don't think that's sufficient to tell if the file has space
> allocated beyond its apparent length (i.e. if fallocate() was previously
> used with FALLOC_FL_KEEP_SIZE). So you'd probably need to use fiemap
> (which is Linux-specific and quite complicated).
>   - Call fallocate() with the user-specified offset and length. If it
> returns ENOSPC, then:
>      - loop through the list of holes, calling fallocate() with
> FALLOC_FL_PUNCH_HOLE to restore any holes which were in the fallocated
> region (between offset and offset+length-1 bytes). That's only
> possible if the user's kernel and filesystem are recent enough to
> support hole punching.
>      - If offset+length was greater than the file's original size,
> ftruncate() to its original length.
>      - If there was originally space allocated past the end of the file,
> call fallocate() with FALLOC_FL_KEEP_SIZE to restore the allocation.
>
> A possible real-world example could be a (sparse) virtual machine hard
> disk image which the user wants to make non-sparse. He uses the fallocate
> command to fully allocate its entire size, not realising there is
> insufficient disk space. So fallocate() fails and the disk is full. If the
> user doesn't have a program to scan a file and punch holes in the all-zero
> regions (assuming the kernel/filesystem support hole punching) the only
> way to recover would be to copy the image file to another partition (cp
> --sparse=always) and back again.
>
> It would be much simpler/easier if the filesystem could handle running out
> of disk space; the filesystem can keep a list of allocated regions and on
> running out can just free them again before returning ENOSPC.
>

While it is not ideal, the current behaviour is consistent with write(2). Partial writes are part
of the POSIX spec. And the aftermath is handled purely by userspace.

What you say is easy and simple is not only inconsistent but also a lot of work for something that
can mostly be avoided if the app were to check freespace upfront and issue fallocate(2) only
if the freespace is considerably larger than the requested pre-allocated space.

