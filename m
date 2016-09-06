From: Xiong Zhou <xzhou@redhat.com>
Subject: LTP proc01 panic when ext4_validate_block_bitmap
Date: Tue, 6 Sep 2016 15:53:08 +0800
Message-ID: <20160906075308.tvaaxg6o4tvuniuj@xzhoul.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ezfr2l2mqic5a6dl"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbcIFHxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Sep 2016 03:53:10 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E36B681F01
        for <linux-ext4@vger.kernel.org>; Tue,  6 Sep 2016 07:53:09 +0000 (UTC)
Received: from localhost (dhcp-12-103.nay.redhat.com [10.66.12.103])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u867r8CO009368
        for <linux-ext4@vger.kernel.org>; Tue, 6 Sep 2016 03:53:09 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ezfr2l2mqic5a6dl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Attached reproducer can crash kernel in several minutes. It's
looping a subset of LTP testcases consisting of proc01 and
ftruncate04:

$cat /opt/ltp/runtest/tfile
proc01 proc01 -m 128
ftruncate04 ftruncate04
ftruncate04_64 ftruncate04

After commented out ftruncate calls in ftruncate04.c, it's still
reproduciable.

Latest kernel commit:
commit bc4dee5aa72723632a1f83fd0d3720066c93b433
Merge: 56291b2 8b18e23
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 5 11:10:00 2016 -0700

    Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6


Calltrace:

[  497.567282] ltptest proc01 start
[  497.584599] general protection fault: 0000 [#1] SMP
[  497.609178] Modules linked in: binfmt_misc ext4 jbd2 mbcache loop intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel nd_pmem dax_pmem aesni_intel nd_btt dax lrw gf128mul ipmi_ssif glue_helper nd_e820 ablk_helper iTCO_wdt cryptd hpilo hpwdt libnvdimm iTCO_vendor_support sg nfsd ipmi_si pcspkr ioatdma shpchp i2c_i801 ipmi_msghandler dca pcc_cpufreq lpc_ich acpi_power_meter acpi_cpufreq i2c_smbus wmi auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm tg3 ptp hpsa serio_raw crc32c_intel pps_core i2c_core scsi_transport_sas fjes dm_mirror dm_region_hash dm_log dm_mod
[  497.918435] CPU: 21 PID: 3214 Comm: proc01 Not tainted 4.8.0-rc5+ #1
[  497.947019] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[  497.976447] task: ffff88085b610000 task.stack: ffff880840a54000
[  498.003184] RIP: 0010:[<ffffffff81372d90>]  [<ffffffff81372d90>] _find_next_bit.part.0+0x10/0x70
[  498.042662] RSP: 0018:ffff880840a57a60  EFLAGS: 00010a06
[  498.066543] RAX: 03ffffffffffff00 RBX: ffff88106ca0b000 RCX: 00000000ffffc000
[  498.099534] RDX: ffffffffffffc000 RSI: ffffffffffffc0fd RDI: ffff88084822a000
[  498.134230] RBP: ffff880840a57a70 R08: ffffffffffffffff R09: ffffffffffffffff
[  498.167599] R10: 0000000000000000 R11: 0000000000000040 R12: ffffffffffffc000
[  498.199576] R13: 0000000000000002 R14: ffff88106ca0c800 R15: ffff8808559f7208
[  498.231538] FS:  00007f08b4c95800(0000) GS:ffff88085fd40000(0000) knlGS:0000000000000000
[  498.268080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  498.293825] CR2: 00007ffd1f4688f8 CR3: 0000000841682000 CR4: 00000000001406e0
[  498.325787] Stack:
[  498.334748]  ffff880840a57a70 ffffffff81372e2e ffff880840a57ad0 ffffffffa07844aa
[  498.367913]  0000000000000000 ffff880855aff110 ffff88106ca0b000 0000000000000002
[  498.401539]  ffff88106ca0b000 ffff88106ca0c800 ffff88084822a840 0000000000000002
[  498.434763] Call Trace:
[  498.445666]  [<ffffffff81372e2e>] ? find_next_zero_bit+0x1e/0x20
[  498.472276]  [<ffffffffa07844aa>] ext4_validate_block_bitmap+0x2da/0x3a0 [ext4]
[  498.505375]  [<ffffffffa07850b7>] ext4_read_block_bitmap_nowait+0x277/0x5e0 [ext4]
[  498.542504]  [<ffffffff81202cae>] ? __kmalloc+0x1ce/0x200
[  498.566777]  [<ffffffffa07c4bb8>] ? ext4_mb_init_cache+0x98/0x750 [ext4]
[  498.596890]  [<ffffffffa07c4c94>] ext4_mb_init_cache+0x174/0x750 [ext4]
[  498.630241]  [<ffffffff811ac16e>] ? lru_cache_add+0xe/0x10
[  498.657499]  [<ffffffff8119b6ca>] ? add_to_page_cache_lru+0x8a/0xf0
[  498.689362]  [<ffffffff8119c67e>] ? pagecache_get_page+0x8e/0x250
[  498.717082]  [<ffffffffa07c53e1>] ext4_mb_init_group+0x171/0x2b0 [ext4]
[  498.746880]  [<ffffffffa07c5b2c>] ext4_mb_load_buddy_gfp+0x47c/0x520 [ext4]
[  498.778204]  [<ffffffffa07c5d2c>] ext4_mb_seq_groups_show+0x15c/0x1e0 [ext4]
[  498.809757]  [<ffffffff8124d714>] ? mntput+0x24/0x40
[  498.832072]  [<ffffffff8123670d>] ? terminate_walk+0xbd/0xd0
[  498.859406]  [<ffffffff81251b17>] seq_read+0x247/0x390
[  498.884253]  [<ffffffff8129cced>] proc_reg_read+0x3d/0x70
[  498.909589]  [<ffffffff8122b647>] __vfs_read+0x37/0x150
[  498.933715]  [<ffffffff812de463>] ? security_file_permission+0xa3/0xc0
[  498.963390]  [<ffffffff8122bc0e>] vfs_read+0x8e/0x140
[  498.986086]  [<ffffffff8122d105>] SyS_read+0x55/0xc0
[  499.008492]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  499.033269]  [<ffffffff816f8b21>] entry_SYSCALL64_slow_path+0x25/0x25
[  499.062252] Code: 48 8d 04 0a 5d 48 39 f0 48 0f 47 c6 c3 31 c0 5d c3 66 2e 0f 1f 84 00 00 00 00 00 48 89 d0 55 49 89 c8 48 c1 e8 06 49 89 c9 89 d1 <4c> 33 04 c7 48 c7 c0 ff ff ff ff 48 83 e2 c0 48 d3 e0 48 89 e5
[  499.147466] RIP  [<ffffffff81372d90>] _find_next_bit.part.0+0x10/0x70
[  499.178821]  RSP <ffff880840a57a60>
[  499.196144] ---[ end trace fc25249ef11fbba9 ]---
[  499.221378] Kernel panic - not syncing: Fatal exception
[  499.244979] Kernel Offset: disabled
[  499.264961] ---[ end Kernel panic - not syncing: Fatal exception


--ezfr2l2mqic5a6dl
Content-Type: application/x-sh
Content-Disposition: attachment; filename="proc01.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Afallocate -l 1G /home/test.img=0Afallocate -l 1G /home/scr=
atch.img=0AMNT1=3D/loopmnt=0AMNT2=3D/loopsch=0Aumount -d $MNT1=0Aumount -d =
$MNT2=0Alosetup -D=0Amkdir -p $MNT1=0Amkdir -p $MNT2=0Alosetup -D=0ADEV1=3D=
$(losetup --find --show /home/test.img)=0ADEV2=3D$(losetup --find --show /h=
ome/scratch.img)=0A=0A[ -b $DEV1 ] || { echo "no dev"; exit 1; }=0A[ -b $DE=
V2 ] || { echo "no dev"; exit 1; }=0A=0Aumount $DEV1=0Aumount $MNT1=0A=0Amk=
fs.ext4 -Fq -b 4096 $DEV1=0A#mkfs.xfs -fq -b size=3D4096 $DEV1=0Aif test $?=
 -ne 0 ; then=0A	echo "mkfs failed"=0A	exit 1=0Afi=0A=0Amount $DEV1 $MNT1=
=0Aif test $? -ne 0 ; then=0A	echo "mount $DEV1 $MNT1 failed"=0A	exit 1=0Af=
i=0A=0Acat > /opt/ltp/runtest/tfile <<EOF=0Aproc01 proc01 -m 128=0Aftruncat=
e04 ftruncate04=0Aftruncate04_64 ftruncate04=0AEOF=0A=0Acnt=3D0=0Awhile tru=
e ; do=0A	echo "ledp loop $cnt" >> /dev/kmsg=0A	/opt/ltp/runltp -d $MNT1 -f=
 tfile -p -z $DEV2 \=0A		-l ltp-tfile.log -o ltp-tfile.out=0A	((cnt=3Dcnt+1=
))=0Adone=0A
--ezfr2l2mqic5a6dl--
