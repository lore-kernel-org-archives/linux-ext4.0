From: Eric Sandeen <sandeen@redhat.com>
Subject: [Fwd: [Bug 9732] New: oops in extent code via ext4_fallocate]
Date: Fri, 11 Jan 2008 14:42:00 -0600
Message-ID: <4787D498.1050202@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080303030104020809070400"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYAKUmD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2008 15:42:03 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0BKg2OH002711
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 15:42:02 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0BKg1Oc027184
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 15:42:01 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0BKg0CW031066
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 15:42:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080303030104020809070400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------080303030104020809070400
Content-Type: message/rfc822;
 name="[Bug 9732] New: oops in extent code via ext4_fallocate.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="[Bug 9732] New: oops in extent code via ext4_fallocate.eml"

Return-Path: <bugme-daemon@bugzilla.kernel.org>
Received: from pobox-2.corp.redhat.com ([unix socket])
	 by pobox-2.corp.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-8.1.RHEL4) with LMTPA;
	 Fri, 11 Jan 2008 15:41:10 -0500
X-Sieve: CMU Sieve 2.2
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0BKfAw7030748
	for <esandeen@pobox-2.corp.redhat.com>; Fri, 11 Jan 2008 15:41:10 -0500
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0BKf9Ft026685
	for <sandeen@redhat.com>; Fri, 11 Jan 2008 15:41:09 -0500
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m0BKebU7014409
	for <sandeen@redhat.com>; Fri, 11 Jan 2008 15:40:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m0BKe0fP001716
	for <sandeen@redhat.com>; Fri, 11 Jan 2008 12:40:01 -0800
Received: by picon.linux-foundation.org (Postfix, from userid 33)
	id AE1F2108069; Fri, 11 Jan 2008 12:40:00 -0800 (PST)
Subject: [Bug 9732] New: oops in extent code via ext4_fallocate
X-Bugzilla-Product: File System
X-Bugzilla-Severity: normal
X-Bugzilla-Keywords: 
X-Bugzilla-Reason: Reporter
X-Bugzilla-Component: ext4
Message-ID: <bug-9732-8797@http.bugzilla.kernel.org/>
To: sandeen@redhat.com
From: bugme-daemon@bugzilla.kernel.org
Date: Fri, 11 Jan 2008 12:40:00 -0800 (PST)
Received-SPF: none (domain of bugme-daemon@bugzilla.kernel.org does not designate permitted sender hosts)
X-Spam-Status: No, hits=-1.694 required=5 tests=AWL,BAYES_00,J_CHICKENPOX_33,NO_REAL_NAME,OSDL_HEADER_SUBJECT_BRACKETED,TW_JB,TW_PK,TW_QL,TW_UH
X-Spam-Checker-Version: SpamAssassin 3.1.0-osdl_revision__1.47__
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
X-Scanned-By: MIMEDefang 2.58 on 172.16.48.32
X-Scanned-By: MIMEDefang 2.53 on 207.189.120.14
X-RedHat-Spam-Score: 0.558 

http://bugzilla.kernel.org/show_bug.cgi?id=9732

           Summary: oops in extent code via ext4_fallocate
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.24-rc7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sandeen@redhat.com


Latest working kernel version: Unknown
Earliest failing kernel version: 2.6.24-rc7
Distribution: Fedora Rawhide
Hardware Environment: x86_64
Software Environment:
Problem Description:

a simple fallocate; truncate; fallocate series oopses the kernel.

2.6.24-rc7 with the latest ext4 patch stack as of about Jan 9, 2008, minus
delalloc patches.

Steps to reproduce, using the test program at
http://oss.sgi.com/archives/xfs/2007-07/msg00092.html

[root@bear-05 sdb8]# touch testfile
[root@bear-05 sdb8]# ./testfallocate -f testfile 0 65536
Trying to preallocate blocks (offset=0, len=65536)
fallocate system call succedded !  ret=0
# FALLOCATE TEST REPORT #
        New blocks preallocated = 16.
        Number of bytes preallocated = 65536
        Old file size = 0, New file size 65536.
        Old num blocks = 0, New num blocks 64.


### TESTS PASSED ###
[root@bear-05 sdb8]# ls  -lh testfile; du -hc testfile
-rw-r--r-- 1 root root 64K Jan 11 14:12 testfile
64K     testfile
64K     total
[root@bear-05 sdb8]# /root/truncate testfile 32768
Truncating testfile to 32768
[root@bear-05 sdb8]# ls  -lh testfile; du -hc testfile
-rw-r--r-- 1 root root 32K Jan 11 14:12 testfile
32K     testfile
32K     total
[root@bear-05 sdb8]# ./testfallocate -f testfile 0 65536
Trying to preallocate blocks (offset=0, len=65536)
Segmentation fault


and yields:
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:1056!
invalid opcode: 0000 [1] SMP 
CPU 2 
Modules linked in: ext4dev jbd2 crc16 autofs4 hidp nfs lockd nfs_acl rfcomm
l2cap bluetooth sunrpc ipv6 cpufreq_ondemand dm_multipath video output sbs
sbshc battery ac power_supply parport_pc lp parport sg pata_acpi
cfi_cmdset_0002 ata_generic cfi_util button jedec_probe serio_raw cfi_probe tg3
gen_probe ck804xrom mtd rtc_cmos chipreg pata_amd map_funcs k8temp libata hwmon
i2c_nforce2 shpchp i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_mod qla2xxx
scsi_transport_fc scsi_tgt mptspi mptscsih mptbase scsi_transport_spi sd_mod
scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
Pid: 3554, comm: testfallocate Not tainted 2.6.24-0.147.rc7.git2.fc9 #1
RIP: 0010:[<ffffffff88364497>]  [<ffffffff88364497>]
:ext4dev:ext4_ext_search_left+0x97/0xbc
RSP: 0018:ffff81012dc65cf0  EFLAGS: 00010287
RAX: 0000000000008008 RBX: ffff81012dc65d78 RCX: 0000000000000000
RDX: ffff81012dc65d90 RSI: ffff81012e5f37e0 RDI: ffff81012e04c00c
RBP: ffff81012e04c180 R08: 0000000000000008 R09: 0000000000000000
R10: 0000000000000000 R11: ffff81012dc65d98 R12: 0000000000000008
R13: ffff81012e04c180 R14: 0000000000000008 R15: 0000000000000000
FS:  00002aaaaaab96f0(0000) GS:ffff81013fc01a28(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000327d0414a0 CR3: 0000000130ce8000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process testfallocate (pid: 3554, threadinfo ffff81012dc64000, task
ffff81012dd5a000)
Stack:  ffffffff88366073 ffff8101349e71d0 ffffffff81053c91 000000022dcc30b8
 ffff81012dc65e88 0000000000000008 ffff81012e549000 ffff81012dcc30b8
 ffff81012dcc3090 ffff81012e04c000 ffff81012dcc30b8 0000000000000008
Call Trace:
 [<ffffffff88366073>] :ext4dev:ext4_ext_get_blocks+0x5ba/0x8c1
 [<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
 [<ffffffff812748f6>] _spin_unlock+0x17/0x20
 [<ffffffff883400a6>] :jbd2:start_this_handle+0x4e0/0x4fe
 [<ffffffff88366564>] :ext4dev:ext4_fallocate+0x175/0x39a
 [<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
 [<ffffffff81056480>] __lock_acquire+0x4e7/0xc4d
 [<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
 [<ffffffff810a8de7>] sys_fallocate+0xe4/0x10d
 [<ffffffff8100c043>] tracesys+0xd5/0xda


Code: 0f 0b eb fe ff c8 89 02 0f b7 47 06 8b 4f 08 0f b7 57 04 48 
RIP  [<ffffffff88364497>] :ext4dev:ext4_ext_search_left+0x97/0xbc
 RSP <ffff81012dc65cf0>
---[ end trace 9a60a6a6c694770a ]---
SysRq : Resetting


The BUG_ON is:

        BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));

where these were the values:

        logical 8 ee_block 0 ee_len 32776

Haven't looked further into it yet.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You reported the bug, or are watching the reporter.

--------------080303030104020809070400--
