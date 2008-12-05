From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: tune2fs -I seems dangerous
Date: Thu, 04 Dec 2008 21:08:18 -0600
Message-ID: <49389B22.9050700@redhat.com>
References: <49385927.9070003@redhat.com> <20081205012430.GC1323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYLEDIm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Dec 2008 22:08:42 -0500
In-Reply-To: <20081205012430.GC1323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> I think is fair, though, to say that tune2fs -I code was written by
> someone who wasn't sufficiently paranoid to think through all of the
> failure cases.  There is in fact a FIXME!! comment for case #2, but at
> the very least what should have happend is that the move_block should
> keep track of how many blocks were moved, and if it wasn't equal to
> needed blocks, it should have signalled an error because it would have
> indicated either a programming bug or a hardware bug or a filesystem
> corruption bug.  Either way, it shouldn't move forward because there
> is the risk that users' files might get destroyed.

So for kicks, when I try ext3:

mkfs.ext3 -F -I 128 -N 16384 fsfile
mount -o loop fsfile mnt
for I in `seq 1 16384`; do echo $I > mnt/file.$I; done
umount mnt
tune2fs -I 256 fsfile

tune2fs 1.41.3 (12-Oct-2008)
Error in resizing the inode size.
Run e2undo to undo the file system changes.

e2undo
Usage: e2undo <transaction file> <filesystem>

it seems to me that a) it'd be nice to know what the error was (likely
no room for the larger inodes?) and maybe not even begin if you know
you'll hit an error due to free space, and b) maybe e2undo (or the
previous command) should give you a hint about where the e2undo
transaction file is?

It's no my intent to pick on anyone who wrote the code, but it seems
like maybe this should be disabled in the next release unless these
issues get ironed out...

Thanks,
-Eric
