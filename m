From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Thu, 05 Mar 2015 14:32:44 +0000
Message-ID: <bug-32182-13602-QPT1HpZrnp@https.bugzilla.kernel.org/>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46708 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbbCEOct (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2015 09:32:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C8E1C2039C
	for <linux-ext4@vger.kernel.org>; Thu,  5 Mar 2015 14:32:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 545A52037F
	for <linux-ext4@vger.kernel.org>; Thu,  5 Mar 2015 14:32:45 +0000 (UTC)
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182

Adam Surak <adam.surak@algolia.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adam.surak@algolia.com

--- Comment #16 from Adam Surak <adam.surak@algolia.com> ---
We experience this problem and the FS remounts to read-only. BuildServer is our
write heavy application, the server has RAID0 using MD. We have seen this
problem on servers with Ubuntu kernel (3.13.x) and MD raid (Samsung SSDs) and
also on servers with OVH custom built kernel (3.10) and LSI HW raid (Intel
S3500 SSDs) - although we see the issue on the servers with MD raid more often.

Syslog
======
Mar  5 13:30:01 c5-use-1 CRON[12504]: (root) CMD (/usr/bin/run-chef-client.sh)
Mar  5 13:30:35 c5-use-1 kernel: [10890197.121882] EXT4-fs error (device md3):
ext4_ext_remove_space:2935: inode #26869814: comm BuildServer: pblk 107512509
bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
Mar  5 13:30:35 c5-use-1 kernel: [10890197.205494] Aborting journal on device
md3-8.
Mar  5 13:30:35 c5-use-1 kernel: [10890197.232881] EXT4-fs (md3): Remounting
filesystem read-only
Mar  5 13:30:35 c5-use-1 kernel: [10890197.244669] EXT4-fs error (device md3):
ext4_journal_check_start:56: Detected aborted journal
Mar  5 13:30:35 c5-use-1 kernel: [10890197.244673] EXT4-fs (md3): Remounting
filesystem read-only
Mar  5 13:30:35 c5-use-1 kernel: [10890197.342604] EXT4-fs error (device md3)
in ext4_ext_remove_space:3006: IO failure
Mar  5 13:30:35 c5-use-1 kernel: [10890197.398828] EXT4-fs error (device md3)
in ext4_ext_truncate:4544: IO failure
Mar  5 13:30:35 c5-use-1 kernel: [10890197.457592] EXT4-fs error (device md3)
in ext4_reserve_inode_write:4874: Journal has aborted
Mar  5 13:30:35 c5-use-1 kernel: [10890197.521148] EXT4-fs error (device md3)
in ext4_truncate:3797: Journal has aborted
Mar  5 13:30:35 c5-use-1 kernel: [10890197.588798] EXT4-fs error (device md3)
in ext4_reserve_inode_write:4874: Journal has aborted
Mar  5 13:30:35 c5-use-1 kernel: [10890197.659161] EXT4-fs error (device md3)
in ext4_orphan_del:2685: Journal has aborted
Mar  5 13:30:35 c5-use-1 kernel: [10890197.732682] EXT4-fs error (device md3)
in ext4_reserve_inode_write:4874: Journal has aborted
Mar  5 13:31:01 c5-use-1 CRON[13879]: (root) CMD ( /usr/bin/netstat.sh >
/tmp/netstat.json)

Debugfs
=======
debugfs -R 'stat <26869814>' /dev/md3
debugfs 1.42.9 (4-Feb-2014)
Inode: 26869814   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 2509781484    Version: 0x00000000:00000001
User:  1001   Group:  1001   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 816256
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x54f85a7b:0fc8be80 -- Thu Mar  5 13:30:35 2015
 atime: 0x54ee0aac:127f86a8 -- Wed Feb 25 17:47:24 2015
 mtime: 0x54ee0ab5:693a9f7c -- Wed Feb 25 17:47:33 2015
crtime: 0x54ee0aac:127f86a8 -- Wed Feb 25 17:47:24 2015
dtime: 0x0194088b -- Tue Nov  3 11:12:11 1970
Size of extra inode fields: 28
EXTENTS:
(ETB0):107512509

uname -a
========
Linux c5-use-1 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux

mount
=====
/dev/md3 on /home type ext4 (rw,noatime,nodiratime,errors=remount-ro)

I got also SMART output, dumpe2fs, lspci, mdadm, dpkg, dmesg and es2fsck
outputs but the files are quite extensive so I've put them to
http://www.surak.eu/fs-ro.tar.gz

Let me know if anything more is needed about the config of the server.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
