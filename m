From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [Fwd: [Bug] 2.6.30 kernel stack trace with 'fsfuzzer ext3' on s390]
Date: Mon, 29 Jun 2009 14:42:43 +0530
Message-ID: <4A48858B.5080602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010408070909020508040703"
Cc: sachinp@linux.vnet.ibm.com, linux-s390@vger.kernel.org,
	akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47528 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZF2JMz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 05:12:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010408070909020508040703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hitting the same bug with 2.6.31-rc1 on s390 arch.


EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in 
directory #2: rec_len % 4 != 0 - offset=44, inode=12, rec_len=139, 
name_len=10
__log_wait_for_space: needed 256 blocks and only had 0 space available
__log_wait_for_space: no way to get more journal space
------------[ cut here ]------------
Badness at fs/jbd/checkpoint.c:164
Modules linked in: loop qeth_l3 autofs4 lockd sunrpc iptable_filter 
ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 
qeth_l2 vmur qeth qdio ccwgroup dm_round_robin dm_multipath scsi_dh 
sd_mod scsi_mod multipath dm_snapshot dm_zero dm_mirror dm_region_hash 
dm_log dm_mod dasd_fba_mod dasd_eckd_mod dasd_mod ext3 jbd
CPU: 1 Not tainted 2.6.31-rc1 #2
Process fstest (pid: 3329, task: 0000000032054770, ksp: 0000000031e17870)
Krnl PSW : 0704100180000000 000003e00004324c 
(__log_wait_for_space+0x150/0x19c [jbd])
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000002d48 0000000001433000 000000000000003d 
0400000000000001
            000000000004aa66 00000000002f3ea8 0000000032574700 
0000000000000000
            000003e000000000 0000000000000100 0000000000000000 
000000003e66a400
            000003e00003d000 000003e000046580 000003e000043248 
0000000031e17c20
Krnl Code: 000003e00004323c: c020000026eb       larl    %r2,3e000048012
            000003e000043242: c0e5ffffcf05       brasl   %r14,3e00003d04c
            000003e000043248: a7f40001           brc     15,3e00004324a
           >000003e00004324c: a7390000           lghi    %r3,0
            000003e000043250: b904002b           lgr     %r2,%r11
            000003e000043254: c0e500000ddc       brasl   %r14,3e000044e0c
            000003e00004325a: 4120b024           la      %r2,36(%r11)
            000003e00004325e: c0e5ffffcf0b       brasl   %r14,3e00003d074
Call Trace:
([<000003e000043248>] __log_wait_for_space+0x14c/0x19c [jbd])
  [<000003e00003dd94>] start_this_handle+0x384/0x3f8 [jbd]
  [<000003e0000401c2>] journal_start+0xce/0x10c [jbd]
  [<000003e0000a758a>] ext3_dirty_inode+0x42/0xac [ext3]
  [<000000000010d4b4>] __mark_inode_dirty+0x4c/0x140
  [<0000000000103016>] touch_atime+0x162/0x174
  [<00000000000fb6dc>] vfs_readdir+0xbc/0xe0
  [<00000000000fb764>] SyS_getdents64+0x64/0xcc
  [<00000000000268ba>] sysc_tracego+0xe/0x14
  [<000000498d96b890>] 0x498d96b890
Last Breaking-Event-Address:
  [<000003e000043248>] __log_wait_for_space+0x14c/0x19c [jbd]
Aborting journal on device loop0.
attempt to access beyond end of device
loop0: rw=0, want=107522, limit=40960
ext3_abort called.
EXT3-fs error (device loop0): ext3_journal_start_sb: Detected aborted 
journal
Remounting filesystem read-only
EXT3-fs error (device loop0): ext3_readdir: bad entry in directory #11: 
rec_len % 4 != 0 - offset=0, inode=0, rec_len=1155, name_len=0
attempt to access beyond end of device
loop0: rw=0, want=107522, limit=40960
attempt to access beyond end of device
loop0: rw=0, want=107522, limit=40960
attempt to access beyond end of device
loop0: rw=0, want=107522, limit=40960
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in 
directory #2: rec_len % 4 != 0 - offset=44, inode=12, rec_len=139, 
name_len=10
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in 
directory #2: rec_len % 4 != 0 - offset=44, inode=12, rec_len=139, 
name_len=10
EXT3-fs error (device loop0): ext3_readdir: bad entry in directory #11: 
rec_len % 4 != 0 - offset=0, inode=0, rec_len=1155, name_len=0
ext3_abort called.
EXT3-fs error (device loop0): ext3_put_super: Couldn't clean up the journal


Thanks and Regards
R.Nageswara Sastry

--------------010408070909020508040703
Content-Type: message/rfc822;
 name="[Bug] 2.6.30 kernel stack trace with 'fsfuzzer ext3' on s390.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="[Bug] 2.6.30 kernel stack trace with 'fsfuzzer ext3' on s390";
 filename*1=".eml"

Return-Path: <rnsastry@linux.vnet.ibm.com>
Received: from imap.linux.ibm.com ([unix socket])
	 by imap.linux.ibm.com (Cyrus v2.3.7-Invoca-RPM-2.3.7-7) with LMTPA;
	 Tue, 16 Jun 2009 08:43:37 -0400
X-Sieve: CMU Sieve 2.3
Received: by imap.linux.ibm.com (Postfix, from userid 101)
	id 59B8E27DC356; Tue, 16 Jun 2009 08:43:37 -0400 (EDT)
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479,TW_JB=0.077,
	TW_QD=0.077,TW_VM=0.077
X-Spam-TokenSummary: Bayes not run.
X-Spam-Checker-Version: SpamAssassin 3.1.7 (2006-10-05) on imap.linux.ibm.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=5.0 tests=ALL_TRUSTED,
	DNS_FROM_RFC_ABUSE,TW_JB,TW_QD,TW_VM autolearn=disabled version=3.1.7
X-Spam-Relay-Country: 
Received: from smtp.linux.ibm.com (smtp.linux.ibm.com [9.26.4.197])
	by imap.linux.ibm.com (Postfix) with ESMTP id 1B46A27DC328
	for <rnsastry@imap.linux.ibm.com>; Tue, 16 Jun 2009 08:43:36 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.linux.ibm.com (Postfix) with ESMTP id C16C6C79FE
	for <rnsastry@linux.ibm.com>; Tue, 16 Jun 2009 08:43:35 -0400 (EDT)
X-Virus-Scanned: amavisd-new at linux.ibm.com
Received: from SYDVM9.AU.IBM.COM (sydvm9.au.ibm.com [9.190.3.49])
	by smtp.linux.ibm.com (Postfix) with ESMTP id A5D2CC79F1
	for <rnsastry@linux.ibm.com>; Tue, 16 Jun 2009 08:43:34 -0400 (EDT)
Received: by SYDVM9.AU.IBM.COM (IBM VM SMTP Level 430) via spool with SMTP id 3246 ; Tue, 16 Jun 2009 22:43:31 EST
Received: by sydvm9.vnet.ibm.com (xagent2 6.0.8) via xagsmtp with spool id
	4370 for rnsastry@linux.vnet.ibm.com; Tue, 16 Jun 2009 22:43:31 +1000 (EST)
Received: from d23relay03.au.ibm.com [9.190.235.21] by SYDVM9.AU.IBM.COM (IBM
	VM SMTP Level 430) via TCP with ESMTP ; Tue, 16 Jun 2009 22:43:31 EST
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])	by
	d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5GChX12761944;
	Tue, 16 Jun 2009 22:43:33 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])	by d23av02.au.ibm.com
	(8.12.11.20060308/8.13.3) with ESMTP id n5GChWLf031199;	Tue, 16 Jun 2009
	22:43:32 +1000
Received: from [127.0.0.1] (nasastry-009124029131.in.ibm.com [9.124.29.131]
	(may be forged))	by d23av02.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP
	id n5GChTcS031159;	Tue, 16 Jun 2009 22:43:32 +1000
Message-ID: <4A379385.6090903@linux.vnet.ibm.com>
Date: Tue, 16 Jun 2009 18:13:49 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org
CC: rnsastry@linux.vnet.ibm.com, sachinp@linux.vnet.ibm.com,
 linux-s390@vger.kernel.org
Subject: [Bug] 2.6.30 kernel stack trace with 'fsfuzzer ext3' on s390
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Xagent-From: rnsastry@linux.vnet.ibm.com
X-Xagent-To: rnsastry@linux.vnet.ibm.com
X-Xagent-Gateway: sydvm9.vnet.ibm.com (XAGENTU at SYDVM9)

Hi,

Kernel version	- 2.6.30
Architecture	- s390

Stack trace:
--------------------------------------------------------------------
Jun 16 17:26:47 HOSTNAME rooth: ./run_test ext3 42
Jun 16 17:26:47 HOSTNAME kernel: kjournald starting.  Commit interval 5 
seconds
Jun 16 17:26:47 HOSTNAME kernel: EXT3 FS on loop0, internal journal
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs: mounted filesystem with 
writeback data mode.
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
htree_dirblock_to_tree: bad entry in directory #2: inode out of bounds - 
offset=12, inode=3538946, rec_len=12, name_len=2
Jun 16 17:26:47 HOSTNAME kernel: __log_wait_for_space: needed 256 blocks 
and only had 0 space available
Jun 16 17:26:47 HOSTNAME kernel: __log_wait_for_space: no way to get 
more journal space
Jun 16 17:26:47 HOSTNAME kernel: ------------[ cut here ]------------
Jun 16 17:26:47 HOSTNAME kernel: Badness at fs/jbd/checkpoint.c:164
Jun 16 17:26:47 HOSTNAME kernel: Modules linked in: loop qeth_l3 autofs4 
lockd sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp 
ip6table_filter ip6_tables x_tables ipv6 qeth_l2 vmur qeth qdio ccwgroup 
dm_round_robin dm_multipath scsi_dh sd_mod scsi_mod multipath 
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod dasd_fba_mod 
dasd_eckd_mod dasd_mod ext3 jbd
Jun 16 17:26:47 HOSTNAME kernel: CPU: 1 Not tainted 2.6.30 #3
Jun 16 17:26:47 HOSTNAME kernel: Process fstest (pid: 4139, task: 
000000003fa72750, ksp: 000000003ee6f840)
Jun 16 17:26:47 HOSTNAME kernel: Krnl PSW : 0704100180000000 
000003e0000432ac (__log_wait_for_space+0x150/0x19c [jbd])
Jun 16 17:26:47 HOSTNAME kernel:            R:0 T:1 IO:1 EX:1 Key:0 M:1 
W:0 P:0 AS:0 CC:1 PM:0 EA:3
Jun 16 17:26:47 HOSTNAME kernel: Krnl GPRS: 00000000000076a5 
000000000142d000 000000000000003a 0400000000000001
Jun 16 17:26:47 HOSTNAME kernel:            0000000000045dfa 
00000000002cec80 000000003f06d700 0000000000000000
Jun 16 17:26:47 HOSTNAME kernel:            000003e000000000 
0000000000000100 0000000000000000 000000003e973400
Jun 16 17:26:47 HOSTNAME kernel:            000003e00003d000 
000003e0000465e0 000003e0000432a8 000000003ee6fbf8
Jun 16 17:26:47 HOSTNAME kernel: Krnl Code: 000003e00004329c: 
c020000026eb      larl    %r2,3e000048072
Jun 16 17:26:47 HOSTNAME kernel:            000003e0000432a2: 
c0e5ffffced5      brasl   %r14,3e00003d04c
Jun 16 17:26:47 HOSTNAME kernel:            000003e0000432a8: a7f40001 
         brc     15,3e0000432aa
Jun 16 17:26:47 HOSTNAME kernel:           >000003e0000432ac: a7390000 
         lghi    %r3,0
Jun 16 17:26:47 HOSTNAME kernel:            000003e0000432b0: b904002b 
         lgr     %r2,%r11
Jun 16 17:26:47 HOSTNAME kernel:            000003e0000432b4: 
c0e500000ddc      brasl   %r14,3e000044e6c
Jun 16 17:26:47 HOSTNAME kernel:            000003e0000432ba: 4120b024 
         la      %r2,36(%r11)
Jun 16 17:26:47 HOSTNAME kernel:            000003e0000432be: 
c0e5ffffcedb      brasl   %r14,3e00003d074
Jun 16 17:26:47 HOSTNAME kernel: Call Trace:
Jun 16 17:26:47 HOSTNAME kernel: ([<000003e0000432a8>] 
__log_wait_for_space+0x14c/0x19c [jbd])
Jun 16 17:26:47 HOSTNAME kernel:  [<000003e00003dd94>] 
start_this_handle+0x384/0x3f8 [jbd]
Jun 16 17:26:47 HOSTNAME kernel:  [<000003e000040222>] 
journal_start+0xce/0x10c [jbd]
Jun 16 17:26:47 HOSTNAME kernel:  [<000003e0000a75de>] 
ext3_dirty_inode+0x42/0xac [ext3]
Jun 16 17:26:47 HOSTNAME kernel:  [<00000000000f907c>] 
__mark_inode_dirty+0x4c/0x1cc
Jun 16 17:26:47 HOSTNAME kernel:  [<00000000000ee89e>] 
touch_atime+0x162/0x174
Jun 16 17:26:47 HOSTNAME kernel:  [<00000000000e71f8>] vfs_readdir+0xbc/0xe0
Jun 16 17:26:47 HOSTNAME kernel:  [<00000000000e7280>] 
SyS_getdents64+0x64/0xcc
Jun 16 17:26:47 HOSTNAME kernel:  [<0000000000026092>] sysc_tracego+0xe/0x14
Jun 16 17:26:47 HOSTNAME kernel:  [<000000498d96b890>] 0x498d96b890
Jun 16 17:26:47 HOSTNAME kernel: Last Breaking-Event-Address:
Jun 16 17:26:47 HOSTNAME kernel:  [<000003e0000432a8>] 
__log_wait_for_space+0x14c/0x19c [jbd]
Jun 16 17:26:47 HOSTNAME kernel: Aborting journal on device loop0.
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
htree_dirblock_to_tree: bad entry in directory #2: inode out of bounds - 
offset=12, inode=3538946, rec_len=12, name_len=2
Jun 16 17:26:47 HOSTNAME kernel: ext3_abort called.
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
ext3_journal_start_sb: Detected aborted journal
Jun 16 17:26:47 HOSTNAME kernel: Remounting filesystem read-only
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
ext3_xattr_block_get: inode 23: bad block 1192
Jun 16 17:26:47 HOSTNAME kernel: SELinux: inode_doinit_with_dentry: 
getxattr returned 5 for dev=loop0 ino=23
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
htree_dirblock_to_tree: bad entry in directory #2: inode out of bounds - 
offset=12, inode=3538946, rec_len=12, name_len=2
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
ext3_xattr_block_get: inode 48: bad block 1192
Jun 16 17:26:47 HOSTNAME kernel: SELinux: inode_doinit_with_dentry: 
getxattr returned 5 for dev=loop0 ino=48
Jun 16 17:26:47 HOSTNAME kernel: ext3_abort called.
Jun 16 17:26:47 HOSTNAME kernel: EXT3-fs error (device loop0): 
ext3_put_super: Couldn't clean up the journal
--------------------------------------------------------------------

Steps to reproduce:
fsfuzzer is an file system fuzzer.

fsfuzzer can be downloaded from URL - 
http://www.risesecurity.org/ramon/fsfuzzer-0.7.1.tar.gz

Untar the above file and change to dir fsfuzzer-0.7.1
# ./configure
# make
# ./fsfuzz ext3
...
++ Testing /root/fsfuzzer-0.7.1/fs/ext3.42.img...
+++ New Tests...
+statfs
+opendir
+fstatfs
++++ Tests finished
+++ Checking dir...
+++ Making files...

Message from syslogd@ at Tue Jun 16 17:26:47 2009 ...
HOSTNAME kernel: ------------[ cut here ]------------+++ Checking stat...
+++ Writing to files...
./run_test: line 114: /media/test/file: Read-only file system
+++ Reading from files...
+++ device files...
+++ Writing to dirs...
./run_test: line 131: /media/test/dir1: Read-only file system
+++ Checking unlink...
++ unmounting ./cfs/ext3.42.img
++ Checking results
++ Something found (/root/fsfuzzer-0.7.1/fs/ext3.42.img)...

*P.S. If you need any information please let me know. Please cc me as I 
am not subscribed to the list.

Thanks and Regards
R.Nageswara Sastry


--------------010408070909020508040703--

