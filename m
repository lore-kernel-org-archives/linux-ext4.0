From: "George Spelvin" <linux@sciencehorizons.net>
Subject: ext4_iget:4740: inode #%ld: block 48: comm find: invalid block
Date: 19 Jan 2017 12:50:59 -0500
Message-ID: <20170119175059.4570.qmail@ns.sciencehorizons.net>
References: <20170118082128.2402.qmail@ns.sciencehorizons.net>
Cc: linux@sciencehorizons.net
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:52322 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751739AbdASRvC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2017 12:51:02 -0500
In-Reply-To: <20170118082128.2402.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is part of the fallout of previous errors, so I don't know how
it happened, but repeated e2fsck runs (git master, e2fsck 1.43.3.1
(22-Dec-2016)) aren't fixing it, which is at least an error in e2fsck.

I think it's something to do with inline_data.  The error is
	} else if (!ext4_has_inline_data(inode)) {
		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
			if ((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
			    (S_ISLNK(inode->i_mode) &&
			     !ext4_inode_is_fast_symlink(inode))))
				/* Validate extent which is part of inode */
				ret = ext4_ext_check_inode(inode);
		} else if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
			   (S_ISLNK(inode->i_mode) && 
			    !ext4_inode_is_fast_symlink(inode))) {
			/* Validate block references which are part of inode */
4740-->			ret = ext4_ind_check_inode(inode);
		}

but I think the !ext4_has_inline_data() check is wrong.  I.e. the inode
*does* have inline data but the test is not detecting it, leading
to -EFSCORRUPTED.

debugfs:  stat <1171779>
Inode: 1171779   Type: directory    Mode:  0775   Flags: 0x10000000
Generation: 2016668288    Version: 0x00000000:00000007
User:  1000   Group:   161   Project:     0   Size: 60
File ACL: 0    Directory ACL: 0
Links: 2   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x587eff35:6e19953c -- Wed Jan 18 00:37:57 2017
 atime: 0x56d5943f:bb6e1344 -- Tue Mar  1 08:08:15 2016
 mtime: 0x587eff35:6e19953c -- Wed Jan 18 00:37:57 2017
crtime: 0x56d388b6:533e9e7c -- Sun Feb 28 18:54:30 2016
Size of extra inode fields: 32
Inode checksum: 0x82a01dca
Size of inline data: 60

debugfs:  ls <1171779>
 1171779  (12) .    1171778  (12) ..    1171954  (12) 0    1171955  (12) 1   
 1171956  (12) 2    1171957  (20) 3   

debugfs:  ex <1171779>
<1171779>: does not uses extent block maps
debugfs:  blocks <1171779>

(i.e. blank line)


It has no blocks allocated, but contains data... must be inline, no?
The EXT4_INODE_INLINE_DATA bit (bit 28) is set, so i_inline_off must
be zero.  How could that arise?

Other info:

debugfs:  ea_list <1171779>
debugfs:  htree <1171779>
htree: Not a hash-indexed directory
debugfs:  id <1171779>
0000  fd45 e803 3c00 0000 3f94 d556 35ff 7e58  .E..<...?..V5.~X
0020  35ff 7e58 0000 0000 a100 0200 0000 0000  5.~X............
0040  0000 0010 0700 0000 42e1 1100 f2e1 1100  ........B.......
0060  0c00 0101 3000 0000 f3e1 1100 0c00 0101  ....0...........
0100  3100 0000 f4e1 1100 0c00 0101 3200 0000  1...........2...
0120  f5e1 1100 1400 0101 3300 0000 0000 0000  ........3.......
0140  0000 0000 80ea 3378 0000 0000 0000 0000  ......3x........
0160  0000 0000 0000 0000 0000 0000 ca1d 0000  ................
0200  2000 a082 3c95 196e 3c95 196e 4413 6ebb   ...<..n<..nD.n.
0220  b688 d356 7c9e 3e53 0000 0000 0000 0000  ...V|.>S........
0240  0000 0000 0000 0000 0000 0000 0000 0000  ................
*

debugfs:  dump <1171779> /tmp/empty
$ xxd /tmp/empty
00000000: 42e1 1100 f2e1 1100 0c00 0101 3000 0000  B...........0...
00000010: f3e1 1100 0c00 0101 3100 0000 f4e1 1100  ........1.......
00000020: 0c00 0101 3200 0000 f5e1 1100 1400 0101  ....2...........
00000030: 3300 0000 0000 0000 0000 0000            3...........

That data is clearly visible in the i_block area of the inode
(starting at offset 0050).
