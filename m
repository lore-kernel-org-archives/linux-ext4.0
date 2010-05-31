From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] New: Data loss after crash during heavy I/O
Date: Mon, 31 May 2010 15:19:38 GMT
Message-ID: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36141 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab0EaPTj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 May 2010 11:19:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4VFJcYM011608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 31 May 2010 15:19:38 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081

           Summary: Data loss after crash during heavy I/O
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32.12 (Debian-Version 2.6.32-12)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: lkolbe@techfak.uni-bielefeld.de
        Regression: No


Created an attachment (id=26590)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26590)
end of trace 

On a Supermicro X7DWN+, Intel 5400 chipset, Xeon E5420, 8GB RAM, Adaptec 52445
RAID controller, LSI SAS1068E controller. We have two 9TB ext4-filesystems on
LVM on a 20TB RAID50 spanning 24 disks, used as a diskpool for bacula. After
writing about 10TB of data (8.5TB to the first, 1.5TB to the second fs), the
machine crashed hard (screenshot attached). Afterwards, the filesystems were
both bonkers (after e2fsck 1.41.9 ran over them):

shepherd:~# mount /dev/data/badp1 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/mapper/data-badp1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

shepherd:~# dmesg | tail
[ 8720.688682] EXT4-fs (dm-1): ext4_check_descriptors: Checksum for group 1
failed (49189!=48621)
[ 8720.688708] EXT4-fs (dm-1): group descriptors corrupted!
[14726.691071] EXT4-fs (dm-1): ext4_check_descriptors: Checksum for group 1
failed (49189!=48621)
[14726.691097] EXT4-fs (dm-1): group descriptors corrupted!
[14737.262709] EXT4-fs (dm-2): mounted filesystem with ordered data mode
[15315.441515] EXT4-fs (dm-1): ext4_check_descriptors: Checksum for group 1
failed (49189!=48621)
[15315.441540] EXT4-fs (dm-1): group descriptors corrupted!

shepherd:~# mount /dev/data/badp2 /mnt/
shepherd:~# ls -la /mnt/
total 80
drwxr-xr-x   3 root root  4096 2010-05-31 13:10 .
drwxr-xr-x  23 root root  4096 2010-05-31 13:01 ..
drwx------ 250 root root 69632 2010-05-31 13:10 lost+found
shepherd:~# ls -la /mnt/lost+found/ | head -n 20
total 216936
drwx------ 250 root       root          69632 2010-05-31 13:10 .
drwxr-xr-x   3 root       root           4096 2010-05-31 13:10 ..
c----wxr--   1  774037444  162299347 237, 210 1957-02-23 13:50 #1000
brwx-----T   1 1954511736 3121970260 249, 121 1922-08-12 15:08 #10021
b-w---xrwt   1  543753214 3130053982 234, 213 2012-06-01 07:58 #10027
c--S--sr-T   1 3871079531 3443641576   2, 232 2036-01-31 13:12 #10036
-r-S-w-r-T   1 2298731406  344458386    32768 2035-05-22 08:46 #10046
brw---Srw-   1 2052225653 4012639896 218, 196 1912-06-23 18:14 #10067
prwS-wSr-x   1 2235883341 1302567651        0 1927-10-10 00:51 #10086
s-wS--x-wt   1 2286828425 2999490124        0 1949-08-22 22:50 #10109
crw--wSrwt   1 3083778288 3882824206 148, 212 2003-07-28 08:32 #10126
s-wS--sr-x   1  874900871   80451928        0 1977-11-28 01:52 #10130
s--sr-x---   1 1903432768    1059722        0 2013-07-05 00:55 #10131
c-w-r-Sr-T   1 3259732952 2590389953   9,  22 2012-06-19 14:56 #10147
pr-x-w--wt   1 1627318825 1016384218        0 1956-12-27 06:01 #10160
srw-r-SrwT   1 2603486838 3240878817        0 1954-11-16 08:43 #10177
srw---srwt   1  458009213  951782573        0 2023-12-03 18:43 #10184
brwxr--rwx   1 2423698452 2252742920  44, 231 1956-07-25 07:28 #10197
brwS-wS-w-   1 3480615060 1244965598  44, 189 2006-10-21 17:03 #1020

This is the second or third time the machine crashed after writing ca. 10TB of
data, but the first time we see this kind of data corruption.

Any hints on how to debug/reprocude such a thing? For the moment, we keep the
broken filesystem for further analysis (if that's neccessary), but sadly this
is our primary backup diskpool and we need to have it running again rather soon
...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
