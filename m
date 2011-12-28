From: markk@clara.co.uk
Subject: fallocate() not "atomic" if insufficient disk space?
Date: Wed, 28 Dec 2011 16:09:03 -0000
Message-ID: <e10c1a3b87ce0766dcc538b8332cb9a4.squirrel@ssl-webmail-vh.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:35192 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1L1Quu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 11:50:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've been experimenting with using fallocate() to pre-allocate space for a
file on an ext4 partition. I'm testing with Ubuntu kernel
3.0.0-14-generic. Does fallocate() behave in the same way on more
recent/vanilla kernels?

What I expected to happen is that if fallocate() fails due to lack of disk
space, no space is allocated, i.e. either nothing happens or the
allocation succeeds.

What actually seems to happen is that all remaining space in the partition
gets allocated to the file. (Thus risking that other programs will fail
due to lack of disk space until the file is deleted.)

If it's relevant, the partition in question has no journal and is mounted
with barrier=0.

Example on a partition with ~100MB free:

$ fallocate -o 0 -l 999999999 blah
fallocate: blah: fallocate failed: No space left on device
$ df /
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1              3849136   3653604         0 100% /
$ du blah
107860	blah
$ ls -l blah
-rw-r--r-- 1 mark mark 110444544 2011-12-28 15:51 blah
$ rm blah

Same issue when specifying -n to call fallocate() with FALLOC_FL_KEEP_SIZE:

$ fallocate -n -o 0 -l 999999999 blah
fallocate: blah: fallocate failed: No space left on device
$ df /
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1              3849136   3653604         0 100% /
$ du blah
107860	blah
$ ls -l blah
-rw-r--r-- 1 mark mark 0 2011-12-28 15:52 blah


-- Mark


