From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [Bug] 2.6.30 kernel stack trace with 'fsfuzzer ext3' on s390
Date: Tue, 16 Jun 2009 18:13:49 +0530
Message-ID: <4A379385.6090903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rnsastry@linux.vnet.ibm.com, sachinp@linux.vnet.ibm.com,
	linux-s390@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38575 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZFPMnc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jun 2009 08:43:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

