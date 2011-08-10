From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] New: EXT4-fs error (device dm-4): ext4_lookup:1044:
 inode #3308277: comm rm: deleted inode referenced: 3058008
Date: Wed, 10 Aug 2011 08:57:50 GMT
Message-ID: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35451 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1HJI5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 04:57:51 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7A8voOZ001769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 08:57:50 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

           Summary: EXT4-fs error (device dm-4): ext4_lookup:1044: inode
                    #3308277: comm rm: deleted inode referenced: 3058008
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: seb.kernel@koocotte.org
        Regression: Yes


Created an attachment (id=68272)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=68272)
Result of the dumpe2fs on FS before fsck

Raid1+LVM, using a 250GB ext4 filesystem; 70% data full but 100% inode full.

I was running a "rm -rf " on ~ 6000 directories referencing nearly 1 000 000
inodes (with many many hard links, it's for backup).

The "rm" was running when I got:

[654463.455734] EXT4-fs warning (device dm-4): empty_dir:1917: bad directory
(dir #2630064) - no `.' or `..'
[657796.710284] EXT4-fs error (device dm-4): ext4_lookup:1044: inode #3308277:
comm rm: deleted inode referenced: 3058008
[657796.710500] Aborting journal on device dm-4-8.
[657796.725559] EXT4-fs (dm-4): Remounting filesystem read-only

No stack trace (btw I had one two hours before the first EXT4-fs warning
related to RX buffer, see #13561)

First line may be related to http://lwn.net/Articles/452117/ ??

dumpe2fs report FS as "clean with errors"

fsck without "-f" run in a few seconds just to recover journal:

# fsck.ext4 /dev/vg_main/lv_lagerbe_ss
e2fsck 1.41.12 (17-May-2010)
/dev/vg_main/lv_lagerbe_ss: recovering journal
/dev/vg_main/lv_lagerbe_ss: clean, 4148253/5013504 files, 43804713/67108864
blocks

fsck -f found an error:

# fsck.ext4 -f /dev/vg_main/lv_lagerbe_ss
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Entry 'settings.sol' in
/2011-08-08/home/bob/.macromedia/Flash_Player/macromedia.com/support/flashplayer/sys/#a.example.com
(3308277) has deleted/unused inode 3058008.  Clear<y>? yes
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/vg_main/lv_lagerbe_ss: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vg_main/lv_lagerbe_ss: 4148253/5013504 files (0.5% non-contiguous),
43804713/67108864 blocks
barberine:/space#

I did a LVM snapshot before fsck, so I can extract more informations for few
days if asked.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
