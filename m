From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] New: provide a file system block size of 8KB for certain
 SSDs.
Date: Thu,  6 Sep 2012 20:34:16 +0000 (UTC)
Message-ID: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42278 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069Ab2IFUeU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Sep 2012 16:34:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 53157203E4
	for <linux-ext4@vger.kernel.org>; Thu,  6 Sep 2012 20:34:19 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 30A42203B9
	for <linux-ext4@vger.kernel.org>; Thu,  6 Sep 2012 20:34:18 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151

           Summary: provide a file system block size of 8KB for certain
                    SSDs.
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.6-2.10-default
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: estellnb@elstel.org
        Regression: No


Sandisk support says that its 480GB SSDs have a block size of 8KB instead of
the usual 4KB. Thus in order to use that SSD we would have to format with a
block size of 8KB. As SSDs get bigger and bigger it is likely that also other
vendors will sell SSDs with a block size of 8KB. Please look forward to
supporting an ext4 blocksize of 8KB!

# mkfs.ext4 -b 8192 test.disk 
Warning: blocksize 8192 not usable on most systems.
mke2fs 1.42.4 (12-June-2012)
test.disk is not a block special device.
Proceed anyway? (y,n) y
mkfs.ext4: 8192-byte blocks too big for system (max 4096)
Proceed anyway? (y,n) y
Warning: 8192-byte blocks too big for system (max 4096), forced to continue
Discarding device blocks: done                            
Filesystem label=
OS type: Linux
Block size=8192 (log=3)
Fragment size=8192 (log=3)
Stride=0 blocks, Stripe width=0 blocks
1280 inodes, 1280 blocks
64 blocks (5.00%) reserved for the super user
First data block=0
1 block group
65528 blocks per group, 65528 fragments per group
1280 inodes per group

Allocating group tables: done                            
Writing inode tables: done                            

Filesystem too small for a journal
Writing superblocks and filesystem accounting information: done

# mount -o loop test.disk /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
# dmesg | tail
[ 2020.657698] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:44:d8:84:61:8c:33:86:dd
SRC=fe80:0000:0000:0000:46d8:84ff:fe61:8c33
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=227 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=187 
[ 2020.657874] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:44:d8:84:61:8c:33:86:dd
SRC=fe80:0000:0000:0000:46d8:84ff:fe61:8c33
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=227 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=187 
[ 2020.696054] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:44:d8:84:61:8c:33:86:dd
SRC=fe80:0000:0000:0000:46d8:84ff:fe61:8c33
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=227 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=187 
[ 2020.992554] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:44:d8:84:61:8c:33:86:dd
SRC=fe80:0000:0000:0000:46d8:84ff:fe61:8c33
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=431 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=391 
[ 2045.224133] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:44:d8:84:61:8c:33:86:dd
SRC=fe80:0000:0000:0000:46d8:84ff:fe61:8c33
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=142 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=102 
[ 2188.427869] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:00:1b:63:2f:5e:93:86:dd
SRC=fe80:0000:0000:0000:021b:63ff:fe2f:5e93
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=111 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=71 
[ 2188.429149] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=33:33:00:00:00:fb:00:80:77:d8:ee:7d:86:dd
SRC=fe80:0000:0000:0000:0280:77ff:fed8:ee7d
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=485 TC=0 HOPLIMIT=1 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=445 
[ 2192.171020] EXT4-fs (loop0): bad block size 8192
[ 2193.769124] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=
SRC=fe80:0000:0000:0000:02a0:ccff:fed9:b3da
DST=ff02:0000:0000:0000:0000:0000:0000:00fb LEN=84 TC=0 HOPLIMIT=255 FLOWLBL=0
PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 2246.621356] EXT4-fs (loop0): bad block size 8192

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
