From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Tue, 21 Jul 2009 15:54:21 -0600
Message-ID: <20090721215421.GM4231@webber.adilger.int>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
 <4A64F37D.7020803@redhat.com>
 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34210 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZGUVyv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 17:54:51 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6LLsnYA028439
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 14:54:51 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN500B00JJ0EC00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 21 Jul 2009 14:54:49 -0700 (PDT)
In-reply-to: <1248211771.20743.2.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2009  14:29 -0700, Frank Mayhar wrote:
> I've spent a little while today digging into this.  My guess (only a
> guess at this point until I have a chance to prove it) is that
> i_disksize should be updated by fallocate() even when KEEP_SIZE is
> specified.  It's currently not updated in that case.

No, that isn't correct.  The intent of KEEP_SIZE is to allow fallocate
to preallocate blocks beyond the EOF, so that it doesn't affect the
file data visible to userspace, but can avoid fragmentation from e.g.
log files or mbox files.

The i_disksize variable is just to handle the lag in updating the on-disk
file size during truncate, because the VFS updates i_size to indicate a
truncate, but in order to handle the truncation of files within finite
transaction sizes the on-disk file size needs to be shrunk incrementally.

> It's my
> understanding that i_disksize should be the real allocation, right?
> While i_size is the size that has actually been used?  If so, then
> setting i_disksize is probably what's missing.

The difference is that i_size is in the VFS inode, and represents the
current in-memory state, while i_disksize is in the ext4 private inode
data and represents what is currently in the on-disk inode.

If we were to change i_disksize then on the next reboot the filesize
would become whatever is stored in i_disksize.

That said, we might need to have some kind of flag in the on-disk
inode to indicate that it was preallocated beyond EOF.  Otherwise,
e2fsck will try and extend the file size to match the block count,
which isn't correct.  We could also use this flag to determine if
truncate needs to be run on the inode even if the new size is the
same.

As a workaround for now, you could truncate to (size+1), then again
truncate to (size) and it should have the desired effect.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

