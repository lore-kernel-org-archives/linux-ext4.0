From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [Bug] kernel oops with 'fsfuzzer ecryptfs' at crypto_destroy_tfm+0x60/0x84
Date: Thu, 30 Jul 2009 15:30:33 +0530
Message-ID: <4A716F41.80903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rnsastry@linux.vnet.ibm.com,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Ramon <rcvalle@linux.vnet.ibm.com>, kamalesh@linux.vnet.ibm.com
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:54536 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbZG3KCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jul 2009 06:02:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Kernel Version - 2.6.31-rc4
Architecture - s390

Unable to handle kernel pointer dereference at virtual kernel address (null)
Oops: 0004 [#1] SMP
Modules linked in: cbc md5 aes_s390 aes_generic ecb ecryptfs loop 
autofs4 lockd
sunrpc ipv6 qeth_l2 qeth qdio ccwgroup dm_round_robin dm_multipath scsi_dh
sd_mod scsi_mod multipath dm_snapshot dm_zero dm_mirror dm_region_hash 
dm_log
dm_mod dasd_fba_mod dasd_eckd_mod dasd_mod ext3 jbd
CPU: 3 Not tainted 2.6.31-rc4 #1
Process umount (pid: 2976, task: 000000007ecf6770, ksp: 0000000078cf3e20)
Krnl PSW : 0704100180000000 00000000001adca6 (crypto_mod_put+0x2e/0x68)
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000000008 0000000000000001 0000000000000000 
00000000ffffffff
            000003e000000001 0000000000000000 000000007139f800 
0000000000000000
            0000000000000000 000000007ee58400 fffffffffffffffe 
0000000000000000
            0000000000000000 0000000000310a08 0000000078cf3c70 
0000000078cf3c40
Krnl Code: 00000000001adc9e: 58502034           l       %r5,52(%r2)
            00000000001adca2: 1835               lr      %r3,%r5
            00000000001adca4: 1b31               sr      %r3,%r1
           >00000000001adca6: ba532034           cs      %r5,%r3,52(%r2)
            00000000001adcaa: a744fffc           brc     4,1adca2
            00000000001adcae: 5050f0a4           st      %r5,164(%r15)
            00000000001adcb2: 5030f0a0           st      %r3,160(%r15)
            00000000001adcb6: 5810f0a0           l       %r1,160(%r15)
Call Trace:
([<0000000071367110>] 0x71367110)
  [<00000000001add46>] crypto_destroy_tfm+0x66/0x84
  [<000003e002acdf9e>] ecryptfs_destroy_crypt_stat+0x46/0xe0 [ecryptfs]
  [<000003e002aca4d6>] ecryptfs_destroy_inode+0x102/0x120 [ecryptfs]
  [<00000000000fe71a>] shrink_dcache_for_umount_subtree+0x27a/0x2e8
  [<00000000000ff342>] shrink_dcache_for_umount+0x76/0x94
  [<00000000000eccb0>] generic_shutdown_super+0x40/0x12c
  [<00000000000ed34c>] deactivate_super+0xa0/0xc8
  [<0000000000106690>] SyS_umount+0x324/0x384
  [<00000000000267e6>] sysc_noemu+0x10/0x16
  [<000002000013bec2>] 0x2000013bec2
Last Breaking-Event-Address:
  [<00000000001add40>] crypto_destroy_tfm+0x60/0x84

---[ end trace 12da3f026a0e1321 ]---


*P.S. If you need any information please let me know. Please cc me as I 
am not subscribed to the list.

Thanks and Regards
R.Nageswara Sastry

