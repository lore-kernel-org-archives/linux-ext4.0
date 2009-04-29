From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Wed, 29 Apr 2009 01:06:09 GMT
Message-ID: <200904290106.n3T169m2006757@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55343 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbZD2BGK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 21:06:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3T169mn006758
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 01:06:10 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #2 from Franco Broi <franco@fugro-fsi.com.au>  2009-04-29 01:06:09 ---
Of the 12 tests, 2 produced errors.

EXT4-fs error (device dm-5): ext4_mb_generate_buddy: EXT4-fs: group 9: 32768
blocks in bitmap, 1023 in gd

The filesystem seems OK, I can ls the test files.

EXT4-fs error (device dm-3): ext4_mb_generate_buddy: EXT4-fs: group 0: 32768
blocks in bitmap, 970 in gd
EXT4-fs error (device dm-3): ext4_mb_generate_buddy: EXT4-fs: group 0: 32768
blocks in bitmap, 32766 in gd
EXT4-fs error (device dm-3): ext4_init_block_bitmap: Checksum bad for group 1
EXT4-fs error (device dm-3): ext4_mb_generate_buddy: EXT4-fs: group 1: 0 blocks
in bitmap, 1023 in gd
EXT4-fs error (device dm-3): ext4_dx_find_entry: bad entry in directory #15:
directory entry across blocks - offset=28672, inode=0, rec_len=65536,
name_len=0
EXT4-fs error (device dm-3): ext4_add_entry: bad entry in directory #15:
directory entry across blocks - offset=0, inode=0, rec_len=65536, name_len=0
EXT4-fs error (device dm-3): htree_dirblock_to_tree: bad entry in directory #2:
directory entry across blocks - offset=0, inode=0, rec_len=65536, name_len=0
EXT4-fs error (device dm-3): htree_dirblock_to_tree: bad entry in directory #2:
directory entry across blocks - offset=0, inode=0, rec_len=65536, name_len=0
EXT4-fs error (device dm-3): htree_dirblock_to_tree: bad entry in directory #2:
directory entry across blocks - offset=0, inode=0, rec_len=65536, name_len=0
EXT4-fs error (device dm-3): htree_dirblock_to_tree: bad entry in directory #2:
directory entry across blocks - offset=0, inode=0, rec_len=65536, name_len=0
EXT4-fs error (device dm-3): htree_dirblock_to_tree: bad entry in directory #2:
directory entry across blocks - offset=0, inode=0, rec_len=65536, name_len=0

Although df looks ok
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vgdata--143-data143
                     13456415384 13232157624 224257760  99% /data143
# ls /data143

Produces no output.

At this point I will need to switch back to ext3 so that I can get this disk
into production but I do have a small window to run some more tests if anyone
has any ideas.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
