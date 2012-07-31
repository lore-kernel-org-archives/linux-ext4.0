From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Serious bug?
Date: Tue, 31 Jul 2012 17:38:45 -0400
Message-ID: <20120731213845.GA3945@thunk.org>
References: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <20120731024236.GB5027@thunk.org>
 <0408C81F72528E40A0D3235A1F67FFC804A643@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <20120731032536.GE5027@thunk.org>
 <0408C81F72528E40A0D3235A1F67FFC804A65F@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42384 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab2GaVit (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 17:38:49 -0400
Content-Disposition: inline
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A65F@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 04:54:42AM +0000, Nelson, John R wrote:
> ok i am using 3.2.0-27-generic (ubuntu 64 bit) e2fsporgs 1.42. the filesystem is 681GB.  Both computers are intel based on is core i5 and one is intel atom and they are in no special configuration just one sata cable to each drive
> 
> here are the steps i did
> 1. fallocate file1 -l 500gb              << exact method
> 2.mkfs.ext4 file1                                <<  exact method
> i will get the error messages about it failing, i delete the file and fsck is still forced upon next mount

OK, I see what's going on.  I was able to reproduce it using a 3.2
kernel (but not a more recent kernel which is what I normally use;
more about that later) with a slightly smaller size (since that's all
the space I had on free on my laptop):

# fallocate -l 215g file1
# mke2fs -t ext4 -F file1

The problem is that fallocate allocated a large number of blocks, which
mke2fs then immediately discarded as its first order of business.
This made the fallocate rather pointless, except that it resulted in
an empty extent tree of depth 2.

# debugfs /dev/closure/bigscratch 
debugfs 1.42.5 (29-Jul-2012)
debugfs:  stat file1
Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 746100356    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 214748364800
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x5018491f:7251aec0 -- Tue Jul 31 17:07:43 2012
 atime: 0x5018491f:3dddf2e0 -- Tue Jul 31 17:07:43 2012
 mtime: 0x5018491f:7251aec0 -- Tue Jul 31 17:07:43 2012
crtime: 0x501848d2:26fabf44 -- Tue Jul 31 17:06:26 2012
Size of extra inode fields: 28
EXTENTS:
(ETB0):33794, (ETB1):55300096
debugfs:  extents file1
Level Entries             Logical            Physical Length Flags
 0/ 2   1/  1 52398080 - 52428799    33794             30720
 1/ 2   1/  0 52398080 - 52428799 55300096             30720
debugfs: quit

E2fsck doesn't detect a problem with this because as far as it is
concerned it is a valid (although granted, very unusual) extent tree
layout.

However, this causes the 3.2 kernel to not handle this situation
correctly, and it throws ext4_error() messages which mark the file
system as containing an error.  However, it appears to be a kernel bug
in the 3.2 kernel.  I just tried to reproduce it using a 3.5 kernel
with the commits that I pushed to the Linus for the 3.6 merge window,
and I was *not* able to reproduce it there.

So it looks like the problem has been fixed upstream.  It would take a
bit more work to figure out (a) whether it's been fixed in the latest
3.2.x stable release, and (b) if not, which 3.x release it was fixed
in, and then narrow it down to a specific commit that needs to be
backported to the 3.2 kernel for Ubuntu.

If you have a support contract with Canonical, I'd suggest complaining
to them; this is the classic sort of thing that distributions get paid
to do.  If you don't, you can either do it yourself, or maybe someone
from the community will do it as they have time.  For your
convenience, I've opened a bug with Canonical:

     https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1031518

(Feel free to confirm the bug, and if you have a support contract,
escalate it and ask them to fix it under the terms of your support
contract.)

In the meantime, let me suggest a workaround:

# rm -f file1; touch file1
# mke2fs -t ext4 -F file1 500g

This is what most of the ext4 developers generally do when they create
file system images.  As you'll see it's faster and more efficient in
terms of space utilization, and will work around the bug in the 3.2
kernel.  As far as whether you're likely to trip over it in practice,
other than your "fallocate followed mke2fs" sequence, I wouldn't know
for sure until the specific fix has been identified, but from what
I've seen, I doubt it's likely to be a common issue in practice.

Regards,

						- Ted
