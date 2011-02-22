From: Chris Mason <chris.mason@oracle.com>
Subject: fiemap bugs on sparse files.
Date: Tue, 22 Feb 2011 16:18:53 -0500
Message-ID: <1298409435-sup-2565@think>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:56991 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1BVVTJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 16:19:09 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id p1MLJ38R009947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 21:19:04 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by rcsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id p1MAndtX025115
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 21:18:57 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ resend, sorry if this is a dup ]

Hi everyone,

We've had reports on btrfs that cp is giving us files full of zeros
instead of actually copying them.  It was tracked down to a bug with
the btrfs fiemap implementation where it was returning holes for
delalloc ranges.

Newer versions of cp are trusting fiemap to tell it where the holes
are, which does seem like a pretty neat trick.

I decided to give xfs and ext4 a shot with a few tests cases too, xfs
passed with all the ones btrfs was getting wrong, and ext4 got the basic
delalloc case right.

# mkfs.ext4 /dev/xxx
# mount /dev/xxx /mnt
# dd if=/dev/zero of=/mnt/foo bs=1M count=1
# fiemap-test foo
ext:   0 logical: [       0..     255] phys:        0..     255 flags: 0x007 tot: 256

Horray!  But once we throw a hole in, things go bad:

# mkfs.ext4 /dev/xxx
# mount /dev/xxx /mnt
# dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=1
# fiemap-test foo
< no output >

We've got a delalloc extent after the hole and ext4 fiemap didn't find
it.  If I run sync to kick the delalloc out:

# sync
# fiemap-test foo
ext:   0 logical: [     256..     511] phys:    34048..   34303 flags: 0x001 tot: 256

fiemap-test is sitting in my /usr/local/bin, and I have no idea how it
got there.  It's full of pretty comments so I know it isn't mine, but
you can grab it here:

http://oss.oracle.com/~mason/fiemap-test.c

xfsqa has a fiemap program too.

-chris
