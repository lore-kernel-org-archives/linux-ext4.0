From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] New: EXT4-fs error: bad header/extent
Date: Tue, 29 Mar 2011 16:47:47 GMT
Message-ID: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35280 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1C2Qrs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 12:47:48 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2TGllGP032343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 16:47:47 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182

           Summary: EXT4-fs error: bad header/extent
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ramses.rommel@gmail.com
        Regression: No


I started noticing ext4-fs errors in my dmesg output, they look like this:

EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760218: comm
dropbox: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth
0(0)
EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760208: comm
dropbox: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth
0(0)
EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760218: comm
thunderbird-bin: bad header/extent: invalid magic - magic 0, entries 0, max
0(0), depth 0(0)
EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760208: comm
thunderbird-bin: bad header/extent: invalid magic - magic 0, entries 0, max
0(0), depth 0(0)

I fsck'ed the partition which showed nothing but the regular output but said
the file system was modified, after a reboot the same errors returned though.
I'm using e2fsprogs 1.41.14 and linux 2.6.38.1 and after a downgrade to linux
2.6.37.5 the errors kept reappearing (I'll test 2.6.38.2 soon but I didn't find
commit messages that seemed relevant).

I ran debugfs on one of the inodes:

% debugfs -R 'stat <3760208>' /dev/disk/by-label/home
debugfs 1.41.14 (22-Dec-2010)
Inode: 3760208   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 231468018    Version: 0x00000001
User:  1000   Group:   100   Size: 42
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x4b2a09ff -- Thu Dec 17 11:37:51 2009
atime: 0x4d909367 -- Mon Mar 28 15:55:51 2011
mtime: 0x490976f8 -- Thu Oct 30 09:57:28 2008
EXTENTS:

I'm not sure what extra info to give you, but I'd be glad to provide stuff you
need to reproduce/fix this.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
