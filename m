From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Mon, 31 Aug 2009 15:56:12 -0600
Message-ID: <20090831215612.GG4197@webber.adilger.int>
References: <1248372301.31323.2.camel@bobble.smo.corp.google.com>
 <20090723215614.GF4231@webber.adilger.int>
 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
 <20090828194051.GM4197@webber.adilger.int>
 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
 <20090828221432.GS4197@webber.adilger.int>
 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
 <20090830025250.GA25768@mit.edu>
 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45516 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZHaV4D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 17:56:03 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7VLu50g021802
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 14:56:05 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP900F00GS72700@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 31 Aug 2009 14:56:05 -0700 (PDT)
In-reply-to: <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009  12:40 -0700, Jiaying Zhang wrote:
> > It's better to define the flag as EXT4_KEEPSIZE_FL, and to use it as
> > EXT4_KEEPSIZE_FL, but make a note of that bitfield position as being
> > reserved in include/linux/fs.h.
> 
> Here is the modified patch based on your suggestions. I stick with the
> KEEPSIZE_FL approach that I think can allow us to handle the special
> truncation accordingly during fsck. Other file systems can also re-use
> this flag when they want to support fallocate with KEEP_SIZE. As you
> suggested, I moved the EXT4_KEEPSIZE_FL checking to ext4_setattr
> that now calls vmtruncate if the KEEPSIZE flag is set in the i_flag.
> Please let me know what you think about this proposed patch.
> 
> --- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c	2009-08-31
> 12:08:10.000000000 -0700
> +++ fs/ext4/extents.c	2009-08-31 12:12:16.000000000 -0700
> @@ -3095,7 +3095,13 @@ static void ext4_falloc_update_inode(str
>  			i_size_write(inode, new_size);
>  		if (new_size > EXT4_I(inode)->i_disksize)
>  			ext4_update_i_disksize(inode, new_size);
> +		inode->i_flags &= ~EXT4_KEEPSIZE_FL;

Note that fallocate can be called multiple times for a file.  The
EXT4_KEEPSIZE_FL should only be cleared if there were writes to
the end of the fallocated space.  In that regard, I think the name
of this flag should be changed to something like "EXT4_EOFBLOCKS_FL"
to indicate that blocks are allocated beyond the end of file (i_size).

>  	} else {
> +		/*
> +		 * Mark that we allocate beyond EOF so the subsequent truncate
> +		 * can proceed even if the new size is the same as i_size.
> +		 */
> +		inode->i_flags |= EXT4_KEEPSIZE_FL;

Similarly, this should only be done in case the fallocate is actually
beyond i_size.  While that is the most common case, it isn't necessarily
ALWAYS going to be true (e.g. if multiple threads are calling fallocate()
on a single file, or if a program always calls fallocate() on a file
without first checking if the file size is large enough).

> +++ include/linux/fs.h	2009-08-31 12:12:16.000000000 -0700
>  #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */


> +++ fs/ext4/ext4.h	2009-08-31 12:12:16.000000000 -0700
>  #define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */

Should we redefine EXT4_EXT_MIGRATE not to conflict with FS_DIRECTIO_FL?
I don't think much, if any, use has been made of this flag, and I can
imagine a major headache in the future if this isn't changed now.

Also, EXT4_EXT_MIGRATE doesn't necessarily belong in the i_flags space,
since it is only used in-memory rather than on-disk as all of the others
are.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

