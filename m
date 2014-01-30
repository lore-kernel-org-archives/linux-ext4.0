From: Luca Ognibene <luca.ognibene@gmail.com>
Subject: Re: same ext4 file system corruption on different machines
Date: Thu, 30 Jan 2014 08:59:09 +0100
Message-ID: <1391068749.2680.6.camel@snow.station>
References: <1390999955.2601.22.camel@snow.station>
	 <1391000743.2601.26.camel@snow.station> <20140129173826.GA30419@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140129173826.GA30419@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Il giorno mer, 29/01/2014 alle 12.38 -0500, Theodore Ts'o ha scritto:
> On Wed, Jan 29, 2014 at 02:05:43PM +0100, Luca Ognibene wrote:
> > I say "same ext4 file system corruption" because e2fsck reports errors
> > on inodes around 127233 on all file systems.a I'm not sure about the
> > syslog errors because i have syslog logs for only the latest faulty
> > partition.
> 
> The e2fsck output shows that all of the inodes in a tight sequential
> range around 127233 are getting corrupted.  That implies that a
> specific block is getting corrupted.  You can see which block by using
> the imap command in debugfs:
> 
> # debugfs -R "imap <12345>" /dev/sda3
> debugfs 1.42.9 (28-Dec-2013)
> Inode 12345 is part of block group 1
>       located at block 1828, offset 0x0800

These are debugfs(1.42.9) outputs. BROKEN1/BROKEN2 are two partitions
with the problem, CORRECT1 is a system without the problem made from the
same root image.

BROKEN1

debugfs:  imap <127233>
Inode 127233 is part of block group 16
        located at block 524320, offset 0x0000

debugfs:  bd 524320
0000  ffff ffff ffff ffff ffff ffff ffff ffff  ................
*

debugfs:  ex <127233>
debugfs:  

debugfs: stats
Filesystem volume name:   <none>
Last mounted on:          /root/dom/a
Filesystem UUID:          6ee8fc7f-9229-44c2-8173-921b9d625436
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              230608
Block count:              921600
Reserved block count:     9216
Free blocks:              298621
Free inodes:              128483
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      224
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         7952
Inode blocks per group:   497
Flex block group size:    16
Filesystem created:       Wed May 15 12:44:06 2013
Last mount time:          Tue Jan 28 17:45:16 2014
Last write time:          Thu Jan 30 07:31:43 2014
Mount count:              37
Maximum mount count:      -1
Last checked:             Fri Dec 13 16:56:50 2013
Check interval:           15552000 (6 months)
Next check after:         Wed Jun 11 17:56:50 2014
Lifetime writes:          2692 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      43472f4b-ba7f-4204-97d8-9addd838f9a6
Journal backup:           inode blocks
FS Error count:           13
First error time:         Wed Jan 15 08:46:12 2014
First error function:     ext4_iget
First error line #:       3888
First error inode #:      127233
First error block #:      0
Last error time:          Tue Jan 28 17:46:07 2014
Last error function:      ext4_iget
Last error line #:        3888
Last error inode #:       127233
Last error block #:       0
Directories:              11616
 Group  0: block bitmap at 226, inode bitmap at 242, inode table at 258
           17418 free blocks, 0 free inodes, 1013 used directories, 0
unused inodes
           [Checksum 0x2793]
 Group  1: block bitmap at 227, inode bitmap at 243, inode table at 755
           1 free block, 0 free inodes, 741 used directories, 0 unused
inodes
           [Checksum 0xb365]
 Group  2: block bitmap at 228, inode bitmap at 244, inode table at 1252
           114 free blocks, 0 free inodes, 1175 used directories, 0
unused inodes
           [Checksum 0xed5f]
 Group  3: block bitmap at 229, inode bitmap at 245, inode table at 1749
           10815 free blocks, 0 free inodes, 868 used directories, 0
unused inodes
           [Checksum 0x3127]
 Group  4: block bitmap at 230, inode bitmap at 246, inode table at 2246
           0 free blocks, 0 free inodes, 861 used directories, 0 unused
inodes
           [Checksum 0xfd99]
 Group  5: block bitmap at 231, inode bitmap at 247, inode table at 2743
           0 free blocks, 1 free inode, 741 used directories, 0 unused
inodes
           [Checksum 0x1b9e]
 Group  6: block bitmap at 232, inode bitmap at 248, inode table at 3240
           0 free blocks, 364 free inodes, 487 used directories, 0
unused inodes
           [Checksum 0x0b53]
 Group  7: block bitmap at 233, inode bitmap at 249, inode table at 3737
           78 free blocks, 3977 free inodes, 348 used directories, 3874
unused inodes
           [Checksum 0x8ffb]
 Group  8: block bitmap at 234, inode bitmap at 250, inode table at 4234
           0 free blocks, 7922 free inodes, 30 used directories, 7695
unused inodes
           [Checksum 0x0c36]
 Group  9: block bitmap at 235, inode bitmap at 251, inode table at 4731
           0 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0xefe1]
 Group 10: block bitmap at 236, inode bitmap at 252, inode table at 5228
           3259 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x58db]
 Group 11: block bitmap at 237, inode bitmap at 253, inode table at 5725
           24703 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x3373]
 Group 12: block bitmap at 238, inode bitmap at 254, inode table at 6222
           15305 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0xfb7a]
 Group 13: block bitmap at 239, inode bitmap at 255, inode table at 6719
           0 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x2b8a]
 Group 14: block bitmap at 240, inode bitmap at 256, inode table at 7216
           19607 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0xfe1d]
 Group 15: block bitmap at 241, inode bitmap at 257, inode table at 7713
           21398 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x556e]
 Group 16: block bitmap at 524288, inode bitmap at 524304, inode table
at 524320
           20533 free blocks, 996 free inodes, 762 used directories, 0
unused inodes
           [Checksum 0x7cef]
 Group 17: block bitmap at 524289, inode bitmap at 524305, inode table
at 524817
           2746 free blocks, 0 free inodes, 1828 used directories, 0
unused inodes
           [Checksum 0xda0d]
 Group 18: block bitmap at 524290, inode bitmap at 524306, inode table
at 525314
           1 free block, 0 free inodes, 537 used directories, 0 unused
inodes
           [Checksum 0xf843]
 Group 19: block bitmap at 524291, inode bitmap at 524307, inode table
at 525811
           0 free blocks, 0 free inodes, 626 used directories, 0 unused
inodes
           [Checksum 0xbbbf]
 Group 20: block bitmap at 524292, inode bitmap at 524308, inode table
at 526308
           1737 free blocks, 0 free inodes, 1188 used directories, 0
unused inodes
           [Checksum 0xed82]
 Group 21: block bitmap at 524293, inode bitmap at 524309, inode table
at 526805
           4641 free blocks, 3897 free inodes, 409 used directories,
3896 unused inodes
           [Checksum 0xb072]
 Group 22: block bitmap at 524294, inode bitmap at 524310, inode table
at 527302
           6752 free blocks, 7950 free inodes, 2 used directories, 7950
unused inodes
           [Checksum 0xfb30]
 Group 23: block bitmap at 524295, inode bitmap at 524311, inode table
at 527799
           14797 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x8e2e]
 Group 24: block bitmap at 524296, inode bitmap at 524312, inode table
at 528296
           32768 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x1c83]
 Group 25: block bitmap at 524297, inode bitmap at 524313, inode table
at 528793
           32542 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0xd472]
 Group 26: block bitmap at 524298, inode bitmap at 524314, inode table
at 529290
           32768 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Block not init, Checksum 0xc0d5]
 Group 27: block bitmap at 524299, inode bitmap at 524315, inode table
at 529787
           32542 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x4a8a]
 Group 28: block bitmap at 524300, inode bitmap at 524316, inode table
at 530284
           4096 free blocks, 7952 free inodes, 0 used directories, 7952
unused inodes
           [Inode not init, Checksum 0x0c1e]

BROKEN2
root@ay5:~/dom# ../debugfs /dev/mapper/loop2p2 
debugfs 1.42.9 (28-Dec-2013)
debugfs:  imap <127233>
Inode 127233 is part of block group 16
        located at block 524320, offset 0x0000
debugfs:  bd 524320
0000  ffff ffff ffff ffff ffff ffff ffff ffff  ................
*


CORRECT1
debugfs:  imap <127233> (it's the /lib/x86_64-linux-gnu/ directory)
Inode 127233 is part of block group 16
        located at block 524320, offset 0x0000

debugfs:  bd 524320
0000  ed41 0000 0010 0000 9e36 6551 0d8f 9d52  .A.......6eQ...R
0020  0d8f 9d52 0000 0000 0000 0300 0800 0000  ...R............
0040  0000 0800 9100 0000 0af3 0100 0400 0000  ................
0060  0000 0000 0000 0000 0100 0000 0d00 0800  ................
0100  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0140  0000 0000 8dbb 0181 0000 0000 0000 0000  ................
0160  0000 0000 0000 0000 0000 0000 0000 0000  ................
0200  1c00 0000 685b 8833 685b 8833 e0fc bf03  ....h[.3h[.3....
0220  0f67 9351 5418 bfb6 0000 0000 0000 0000  .g.QT...........
0240  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0400  a481 0000 50dc 0100 575c 5d52 0f67 9351  ....P...W\]R.g.Q
0420  f7fd 544f 0000 0000 0000 0100 f000 0000  ..TO............
0440  0000 0800 0100 0000 0af3 0100 0400 0000  ................
0460  0000 0000 0000 0000 1e00 0000 0080 0800  ................
0500  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0540  0000 0000 8ebb 0181 0000 0000 0000 0000  ................
0560  0000 0000 0000 0000 0000 0000 0000 0000  ................
0600  1c00 0000 5418 bfb6 0000 0000 8499 039f  ....T...........
0620  0f67 9351 5418 bfb6 0000 0000 0000 0000  .g.QT...........
0640  0000 0000 0000 0000 0000 0000 0000 0000  ................
...........

debugfs:  ex <127233>
Level Entries       Logical        Physical Length Flags
 0/ 0   1/  1     0 -     0 524301 - 524301      1 

> The fact that the corruption is so consistenth is highly suspicious.
> It tends to rule out hardware errrors, but it tends to also rule out
> most kernel bugs.  If it's caused by some race condition, or wild
> pointer dereference, it's highly unlikely it would result in the same
> block getting overwritten with garbage.

Yes it's indeed very strange.. i tend to rule out application errors
because i don't write directly to the device so i don't think i can
break a filesystem from userspace. I've checked previous and next blocks
and they seem ok, only the block 524320 is getting corrupted. Any idea
on what should i look for now?

ciao
Luca
