From: Theodore Tso <tytso@mit.edu>
Subject: Re: undelete still opened file
Date: Fri, 17 Oct 2008 12:14:32 -0400
Message-ID: <20081017161432.GB8755@mit.edu>
References: <20081017120852.1f04dc36.taeuber@bbaw.de> <ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com> <20081017143311.52d50a23.taeuber@bbaw.de> <20081017132443.GA8755@mit.edu> <20081017153957.28a4dd67.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org
To: Lars =?iso-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49451 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755164AbYJQQOg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 12:14:36 -0400
Content-Disposition: inline
In-Reply-To: <20081017153957.28a4dd67.taeuber@bbaw.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 03:39:57PM +0200, Lars T=E4uber wrote:
>=20
> not that it is a way I would go, but theoretically: I could provoke
> a crash and mount the ext3 filesystem as ext2 and restore the file?
>=20

Unless you then manually modify the orphan list to remove the inode
from the orphan list, the next time you mount the filesystem as ext3
the blocks will be released and the filesystem will be corrupted.
Also, if you provoke a crash, the filesystem will be marked as "needs
recovery" and ext2 will refuse to mount the filesystem.

The much simpler way would be to kill -STOP the process that owns the
file, copy it via "cat /proc/$pid/fd/$fd > rescue-file". and then kill
-9 the process if you don't want it to make any further changes.

> > Not currently using ext3/ext4, no.  There would have to be an entir=
ely
> > new system call or other userspace interface for something like thi=
s.
>=20
> Is this planned?

No, this is not planned.   "rm is forever".=20

> But a solution should be independent of the real filesystem. Because
> the file is still somewhere in the ram and represented in linux vfs,
> isn't it?  It only needs to be copied/recreated on to a (different)
> filesystem somehow.

No, it's not necessarily in RAM.  It's on disk, in the filesystem, but
marked in such a way that if the system crashes or when the file
descriptor is closed, the inode and its contents are marked as freed
for allocation.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
