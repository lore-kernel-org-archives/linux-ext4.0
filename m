From: Ted Ts'o <tytso@mit.edu>
Subject: xfstests test #74 failure
Date: Sun, 28 Aug 2011 19:54:37 -0400
Message-ID: <20110828235437.GA12187@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43144 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1H1Xyk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Aug 2011 19:54:40 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Has anyone else noticed failures with xfstests #74?  What I'm finding
is that if compile the fstest program so that it is statically linked,
I can't get it to fail:

candygram:~/xfstests# ldd /vdb/fstest.static 
		      not a dynamic executable

However ,if it is dynamically linked withthe system C library, it
works just fine:

candygram:~/xfstests# ldd /vdb/fstest.dyn
		      linux-gate.so.1 =>  (0xffffe000)
		      libc.so.6 => /lib/i386-linux-gnu/i686/cmov/libc.so.6 (0xb765d000)
		      /lib/ld-linux.so.2 (0xb77bc000)

The failure case looks like this.  If it doesn't fail the first time,
it almost certainly will fail the second time the command is repeated.
(And when I run test #74, it usually fails during the 2nd fstest
invocation, which adds a -m option to command line below, but the -m
doesn't seem necessary to cause the failure; what seems to be
important is running fstest the second time.)

candygram:~/xfstests# /vdb/fstest.dyn -n 3 -F -l 10 -f 5 -s 31457280 -b 512 -p /vdb/fstest.2875.2
num_children=3 file_size=31457280 num_files=5 loop_count=10 block_size=512
mmap=0 sync=0 prealloc=0
Total data size 471.9 Mbyte
Child 2 cleaning /vdb/fstest.2875.2/child2
Child 1 cleaning /vdb/fstest.2875.2/child1
Child 0 cleaning /vdb/fstest.2875.2/child0
Child 1 loop 0
Child 0 loop 0
Child 2 loop 0
Child 0 loop 1
Child 1 loop 1
Child 2 loop 1
Corruption in child 0 fnum 3 at offset 22327432
Correct:   5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c 5c [ 1344.124844] fstest.dyn used greatest stack depth: 5436 bytes left
5c 5c 5c 
Incorrect: 07 f2 ba 78 49 d0 a3 18 bd e5 c7 02 28 99 c5 4c 07 f2 ba 78 Corruption length: 0

Child exited with status 1
Child 2 loop 2
Child 1 loop 2
Child 1 loop 3
Child 2 loop 3
Child 1 loop 4

The exact same command-line works fine if I use statically linked
binary (fstest.dyn).  It also seems to work fine if I double the
amount of memory in my VM (from 1024 to 2048 megs).  At this point I'm
not sure whether it's a bug in fstest, or in ext4.  It is reproducible with 4k block size, 1k
block size, 4k/nodelalloc/noextents, nojournal mode. 

I'm using the libc6 in Debian unstable, version 2.13-18, both when
compiling and the shared library runtime.

If it's an ext4 bug, it's not a recent regression; I can replicate
this with v3.1-rc3, v3.0, 2.6.39, and 2.6.38.  However, I can *not*
replicate this with ext3, so this smells like an ext4 bug.  I have
absolutely no idea why linking dynamically vs. statically would make a
difference, though....

					- Ted
