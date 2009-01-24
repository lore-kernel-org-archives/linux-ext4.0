From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12534] ext4 extent structure backwards
Date: Sat, 24 Jan 2009 08:07:12 -0800 (PST)
Message-ID: <20090124160712.C9ABB108040@picon.linux-foundation.org>
References: <bug-12534-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbZAXQHz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Jan 2009 11:07:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0OG7CAN006916
	for <linux-ext4@vger.kernel.org>; Sat, 24 Jan 2009 08:07:14 -0800
In-Reply-To: <bug-12534-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12534


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|sandeen@redhat.com
             Status|NEW                         |ASSIGNED




------- Comment #1 from sandeen@redhat.com  2009-01-24 08:07 -------
It'd be a good trick to have the on-disk format not match the header ;)

For this file:

debugfs:  stat testfile
Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 1797761550    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 98304
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 128
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x497b8705:5cc91558 -- Sat Jan 24 15:24:21 2009
 atime: 0x497b86f8:c29715dc -- Sat Jan 24 15:24:08 2009
 mtime: 0x497b8705:5cc91558 -- Sat Jan 24 15:24:21 2009
crtime: 0x497b86f8:c29715dc -- Sat Jan 24 15:24:08 2009
Size of extra inode fields: 28
Extended attributes stored in inode body: 
  selinux = "unconfined_u:object_r:file_t:s0\000" (32)
BLOCKS:
(8-23):9256-9271
TOTAL: 16

(logical start 0x8, len 0x10, physical start 0x2428)

the inode looks like this:

00421b00  a4 81 00 00 00 80 01 00  f8 86 7b 49 4b 87 7b 49  |..........{IK.{I|
00421b10  05 87 7b 49 00 00 00 00  00 00 01 00 80 00 00 00  |..{I............|
00421b20  00 00 08 00 01 00 00 00  0a f3 01 00 04 00 00 00  |................|
00421b30  00 00 00 00 08 00 00 00  10 00 00 00 28 24 00 00  |............($..|
00421b40  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00421b60  00 00 00 00 0e aa 27 6b  00 00 00 00 00 00 00 00  |......'k........|
00421b70  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00421b80  1c 00 00 00 6c 19 d5 e2  58 15 c9 5c dc 15 97 c2  |....l...X..\....|
00421b90  f8 86 7b 49 dc 15 97 c2  00 00 00 00 00 00 02 ea  |..{I............|
00421ba0  07 06 40 00 00 00 00 00  20 00 00 00 00 00 00 00  |..@..... .......|
00421bb0  73 65 6c 69 6e 75 78 00  04 01 38 00 00 00 00 00  |selinux...8.....|
00421bc0  05 00 00 00 00 00 00 00  61 74 74 72 00 00 00 00  |........attr....|
00421bd0  00 00 00 00 00 00 00 00  76 34 6c 75 65 00 00 00  |........v4lue...|
00421be0  75 6e 63 6f 6e 66 69 6e  65 64 5f 75 3a 6f 62 6a  |unconfined_u:obj|
00421bf0  65 63 74 5f 72 3a 66 69  6c 65 5f 74 3a 73 30 00  |ect_r:file_t:s0.|

An extent looks like this:
struct ext4_extent {
        __le32  ee_block;       /* first logical block extent covers */
        __le16  ee_len;         /* number of blocks covered by extent */
        __le16  ee_start_hi;    /* high 16 bits of physical block */
        __le32  ee_start_lo;    /* low 32 bits of physical block */
};

The extents portion is here:
                                   0a f3 01 00 04 00 00 00  |................|
00421b30  00 00 00 00 08 00 00 00  10 00 00 00 28 24 00 00  |............($..|
                    ^logical 0x8^  ^len^ ^ hi^  ^start lo^
                                    0x16   0      0x2428

There is nothing wrong with this; you are just looking at it wrong.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
