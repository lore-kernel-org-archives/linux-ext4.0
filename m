From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/37] debugfs: force logdump to display (old) journal
 contents
Date: Sun, 11 May 2014 21:41:19 -0400
Message-ID: <20140512014119.GI5480@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231302.31890.45397.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021346570.2154@localhost.localdomain>
 <20140506002453.GN8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33601 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaELBlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 21:41:24 -0400
Content-Disposition: inline
In-Reply-To: <20140506002453.GN8434@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 05:24:53PM -0700, Darrick J. Wong wrote:
> I'll update the manpage.  -c seems to hexdump the contents of any block that we
> find while iterating the journal.  -b would seem to allow you to dump an
> arbitrary block #, but I could never get it to do that.

It's used to dump information _about_ an arbitrary block.  Here's an
example of some of the cool things you can do with logdump:

<tytso@closure> {/usr/projects/e2fsprogs/e2fsprogs}   (next)
1742% gunzip <  tests/f_jnl_32bit/image.gz  > /tmp/image
<tytso@closure> {/usr/projects/e2fsprogs/e2fsprogs}   (next)
1743% debugfs /tmp/image
debugfs 1.42.9 (4-Feb-2014)
debugfs:  logdump -b 680
Journal starts at block 1, transaction 2
  FS block 66 logged at sequence 3, journal block 8 (flags 0x2)
    (block bitmap for block 680: block is SET)
  FS block 680 logged at sequence 3, journal block 205 (flags 0x2)
  FS block 66 logged at sequence 4, journal block 231 (flags 0x2)
    (block bitmap for block 680: block is SET)
  FS block 680 logged at sequence 4, journal block 234 (flags 0x2)
  FS block 66 logged at sequence 5, journal block 339 (flags 0x2)
    (block bitmap for block 680: block is SET)
  FS block 680 logged at sequence 5, journal block 450 (flags 0x2)
No magic number at block 464: end of journal.
debugfs: icheck 680
Block	 Inode number
680	 2132
debugfs:  logdump -i <2132>
Inode 2132 is at group 1, block 364, offset 384
Journal starts at block 1, transaction 2
  FS block 364 logged at sequence 3, journal block 197 (flags 0x2)
    (inode block for inode 2132):
    Inode: 2132   Type: directory        Mode:  0755   Flags: 0x80000
    Generation: 3167953082    Version: 0x00000008
    User:     0   Group:     0   Size: 1024
    File ACL: 0    Directory ACL: 0
    Links: 9   Blockcount: 2
    Fragment:  Address: 0    Number: 0    Size: 0
    ctime: 0x4fa1639e -- Wed May  2 12:41:02 2012
    atime: 0x4fa1639e -- Wed May  2 12:41:02 2012
    mtime: 0x4fa1639e -- Wed May  2 12:41:02 2012
    Blocks:  (0+1): 127754 (1+1): 4 (5+1): 680 
  FS block 364 logged at sequence 4, journal block 233 (flags 0x2)
    (inode block for inode 2132):
    Inode: 2132   Type: directory        Mode:  0755   Flags: 0x80000
    Generation: 3167953082    Version: 0x0000000c
    User:     0   Group:     0   Size: 1024
    File ACL: 0    Directory ACL: 0
    Links: 13   Blockcount: 2
    Fragment:  Address: 0    Number: 0    Size: 0
    ctime: 0x4fa1639e -- Wed May  2 12:41:02 2012
    atime: 0x4fa1639e -- Wed May  2 12:41:02 2012
    mtime: 0x4fa1639e -- Wed May  2 12:41:02 2012
    Blocks:  (0+1): 127754 (1+1): 4 (5+1): 680 
  FS block 364 logged at sequence 5, journal block 434 (flags 0x2)
    (inode block for inode 2132):
    Inode: 2132   Type: directory        Mode:  0755   Flags: 0x80000
    Generation: 3167953082    Version: 0x00000015
    User:     0   Group:     0   Size: 1024
    File ACL: 0    Directory ACL: 0
    Links: 4   Blockcount: 2
    Fragment:  Address: 0    Number: 0    Size: 0
    ctime: 0x4fa163a7 -- Wed May  2 12:41:11 2012
    atime: 0x4fa163a7 -- Wed May  2 12:41:11 2012
    mtime: 0x4fa163a7 -- Wed May  2 12:41:11 2012
    Blocks:  (0+1): 127754 (1+1): 4 (5+1): 680 
No magic number at block 464: end of journal.
debugfs: quit

The idea is that this can be useful when debugging a potentially
corrupted journal, or for advanced file system recovery.

Note that logdump -c is most useful in combination with -b, for
example: "logdump -b 680 -c".

	  	      	  	   	- Ted
