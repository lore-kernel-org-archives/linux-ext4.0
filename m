From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: fuzz testing a KVM machine (x86) with ext4fs forces much more often
 the oom killer than btrfs
Date: Mon, 24 Nov 2014 21:10:52 +0100
Message-ID: <547390CC.2050306@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52703 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbaKXUK4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2014 15:10:56 -0500
Received: from [192.168.178.21] ([85.177.144.159]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MPYqL-1XoJ922y0n-004ktS for
 <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2014 21:10:54 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If I change my fuzzer command sequence from "btrfs" to "ext4", eg.:

$> mkdir /mnt/ramdisk/ext4; truncate -s 97M /mnt/ramdisk/ext4.fs; /sbin/mkfs.ext4 /mnt/ramdisk/ext4.fs; sudo su -c "mount /mnt/ramdisk/ext4.fs /mnt/ramdisk/ext4; chmod 777 /mnt/ramdisk/ext4"

and then run trinity :

$> D=/mnt/ramdisk/ext4; while [[ : ]]; do cd ~; sudo rm -rf $D/t3 && mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 2 -N 100000 -V $D/t3/v1/v2 -q; echo; echo " done"; echo; sleep 4; done

it tooks just few minutes till the KVM machine (32 bit stable Gentoo Linux, 2040 MB RAM assigned, 512 MB tmpfs) gives this :


Nov 24 21:02:09 n22kvmclone kernel: init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
Nov 24 21:02:09 n22kvmclone kernel: init cpuset=/ mems_allowed=0
Nov 24 21:02:09 n22kvmclone kernel: CPU: 0 PID: 1 Comm: init Not tainted 3.18.0-rc6 #7
Nov 24 21:02:09 n22kvmclone kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Nov 24 21:02:09 n22kvmclone kernel:  00000000 00000000 f6081c54 cc05189a f6058000 f6081cb0 cc04f94c cc1a8e98
Nov 24 21:02:09 n22kvmclone kernel:  f60583c0 000201da 00000000 00000000 00000286 cc25b2e0 cbc8499b f6081c8c
Nov 24 21:02:09 n22kvmclone kernel:  00000286 cc25b2e0 00000001 f6081cb0 cbe55eea 00000286 00000000 00000000
Nov 24 21:02:09 n22kvmclone kernel: Call Trace:
Nov 24 21:02:09 n22kvmclone kernel:  [<cc05189a>] dump_stack+0x41/0x52
Nov 24 21:02:09 n22kvmclone kernel:  [<cc04f94c>] dump_header.isra.12+0x6f/0x1df
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc8499b>] ? trace_hardirqs_on+0xb/0x10
Nov 24 21:02:09 n22kvmclone kernel:  [<cbe55eea>] ? ___ratelimit+0xaa/0x150
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd11a85>] oom_kill_process+0x195/0x300
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc51bf0>] ? has_capability+0x20/0x20
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc51c84>] ? has_capability_noaudit+0x14/0x20
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd11ff4>] ? out_of_memory+0x264/0x2f0
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd12056>] out_of_memory+0x2c6/0x2f0
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd15bc7>] __alloc_pages_nodemask+0x897/0x930
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd10909>] filemap_fault+0x379/0x600
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd31d5e>] ? __do_fault+0x2e/0x60
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd31d5e>] __do_fault+0x2e/0x60
Nov 24 21:02:09 n22kvmclone kernel:  [<cc059072>] ? _raw_spin_unlock+0x22/0x30
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd348cc>] do_read_fault.isra.92+0x1dc/0x2d0
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd3522e>] handle_mm_fault+0x4ee/0x9f0
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc40408>] ? __do_page_fault+0x138/0x540
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc4045a>] __do_page_fault+0x18a/0x540
Nov 24 21:02:09 n22kvmclone kernel:  [<cbd66347>] ? poll_select_copy_remaining+0xc7/0x110
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc40889>] trace_do_page_fault+0x49/0xd0
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc3de90>] ? kvm_async_pf_task_wait+0x1e0/0x1e0
Nov 24 21:02:09 n22kvmclone kernel:  [<cbc3dea8>] do_async_page_fault+0x18/0x90
Nov 24 21:02:09 n22kvmclone kernel:  [<cc05ac20>] error_code+0x6c/0x74
Nov 24 21:02:09 n22kvmclone kernel: Mem-Info:
Nov 24 21:02:09 n22kvmclone kernel: DMA per-cpu:
Nov 24 21:02:09 n22kvmclone kernel: CPU    0: hi:    0, btch:   1 usd:   0
Nov 24 21:02:09 n22kvmclone kernel: CPU    1: hi:    0, btch:   1 usd:   0
Nov 24 21:02:09 n22kvmclone kernel: Normal per-cpu:
Nov 24 21:02:09 n22kvmclone kernel: CPU    0: hi:  186, btch:  31 usd:   0
Nov 24 21:02:09 n22kvmclone kernel: CPU    1: hi:  186, btch:  31 usd:   0
Nov 24 21:02:09 n22kvmclone kernel: HighMem per-cpu:
Nov 24 21:02:09 n22kvmclone kernel: CPU    0: hi:  186, btch:  31 usd:   0
Nov 24 21:02:09 n22kvmclone kernel: CPU    1: hi:  186, btch:  31 usd:   0
Nov 24 21:02:09 n22kvmclone kernel: active_anon:53227 inactive_anon:433398 isolated_anon:0\x0a active_file:21 inactive_file:18 isolated_file:0\x0a unevictable:0 dirty:0 writeback:40020 unstable:0\x0a free:12207 slab_reclaimable:2831 slab_unreclaimable:10468\x0a mapped:12327 shmem:439161 pagetables:151 bounce:0\x0a free_cma:0
Nov 24 21:02:09 n22kvmclone kernel: DMA free:7724kB min:64kB low:80kB high:96kB active_anon:1896kB inactive_anon:5288kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15916kB mlocked:0kB dirty:0kB writeback:8kB mapped:412kB shmem:7072kB slab_reclaimable:52kB slab_unreclaimable:884kB kernel_stack:16kB pagetables:16kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Nov 24 21:02:09 n22kvmclone kernel: lowmem_reserve[]: 0 839 1993 1993
Nov 24 21:02:09 n22kvmclone kernel: Normal free:40596kB min:3672kB low:4588kB high:5508kB active_anon:86676kB inactive_anon:673760kB active_file:84kB inactive_file:72kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:892920kB managed:860264kB mlocked:0kB dirty:0kB writeback:0kB mapped:20292kB shmem:747452kB slab_reclaimable:11272kB slab_unreclaimable:40988kB kernel_stack:880kB pagetables:588kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:17056 all_unreclaimable? yes
Nov 24 21:02:09 n22kvmclone kernel: lowmem_reserve[]: 0 0 9231 9231
B managed:1181576kB mlocked:0kB dirty:0kB writeback:160072kB mapped:28604kB shmem:1002120kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Nov 24 21:02:09 n22kvmclone kernel: lowmem_reserve[]: 0 0 0 0
Nov 24 21:02:09 n22kvmclone kernel: DMA: 25*4kB (UM) 13*8kB (UM) 8*16kB (UM) 5*32kB (M) 1*64kB (M) 4*128kB (U) 6*256kB (U) 2*512kB (U) 0*1024kB 0*2048kB 1*4096kB (R) = 7724kB
Nov 24 21:02:09 n22kvmclone kernel: Normal: 149*4kB (UEM) 287*8kB (UE) 143*16kB (UEM) 106*32kB (UEM) 66*64kB (UEM) 36*128kB (EM) 17*256kB (EM) 9*512kB (UM) 8*1024kB (UM) 1*2048kB (M) 1*4096kB (R) = 40700kB
Nov 24 21:02:09 n22kvmclone kernel: HighMem: 24*4kB (MR) 2*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 1*128kB (R) 1*256kB (R) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB
Nov 24 21:02:09 n22kvmclone kernel: 483957 total pagecache pages
Nov 24 21:02:09 n22kvmclone kernel: 44761 pages in swap cache
Nov 24 21:02:09 n22kvmclone kernel: Swap cache stats: add 125094, delete 80333, find 19/43
Nov 24 21:02:09 n22kvmclone kernel: Free swap  = 0kB
Nov 24 21:02:09 n22kvmclone kernel: Total swap = 499964kB
Nov 24 21:02:09 n22kvmclone kernel: 522622 pages RAM
Nov 24 21:02:09 n22kvmclone kernel: 295394 pages HighMem/MovableOnly
Nov 24 21:02:09 n22kvmclone kernel: 0 pages reserved
Nov 24 21:02:09 n22kvmclone kernel: [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
Nov 24 21:02:09 n22kvmclone kernel: [  934]     0   934     2501      107       4        0         -1000 systemd-udevd
Nov 24 21:02:09 n22kvmclone kernel: [ 1491]     0  1491     2721       35       3        0         -1000 auditd
Nov 24 21:02:09 n22kvmclone kernel: [ 1526]     0  1526     1185       47       5        0             0 syslog-ng
Nov 24 21:02:09 n22kvmclone kernel: [ 1527]     0  1527     6569      239       7        0             0 syslog-ng
Nov 24 21:02:09 n22kvmclone kernel: [ 1799]     0  1799      604       36       4        0             0 dhcpcd
Nov 24 21:02:09 n22kvmclone kernel: [ 1865]     0  1865     1368      138       5        0             0 crond
Nov 24 21:02:09 n22kvmclone kernel: [ 1887]     0  1887     1316      777       4        0             0 haveged
Nov 24 21:02:09 n22kvmclone kernel: [ 2020]     0  2020      691       52       4        0             0 rpcbind
Nov 24 21:02:09 n22kvmclone kernel: [ 2043]     0  2043      777      152       4        0             0 rpc.statd
Nov 24 21:02:09 n22kvmclone kernel: [ 2091]     0  2091     1291       75       5        0             0 ntpd
Nov 24 21:02:09 n22kvmclone kernel: [ 2119]     0  2119     1304       83       4        0         -1000 sshd
Nov 24 21:02:09 n22kvmclone kernel: [ 2143]     0  2143     1149       37       5        0             0 agetty
Nov 24 21:02:09 n22kvmclone kernel: [ 2144]     0  2144     1149       36       5        0             0 agetty
Nov 24 21:02:09 n22kvmclone kernel: [ 2145]     0  2145     1149       36       5        0             0 agetty
Nov 24 21:02:09 n22kvmclone kernel: [ 2146]     0  2146     1149       36       5        0             0 agetty
Nov 24 21:02:09 n22kvmclone kernel: [ 2147]     0  2147     1149       36       5        0             0 agetty
Nov 24 21:02:09 n22kvmclone kernel: [ 2148]     0  2148     1149       36       5        0             0 agetty
Nov 24 21:02:09 n22kvmclone kernel: [ 2191]     0  2191     2099      142       6        0             0 sshd
Nov 24 21:02:09 n22kvmclone kernel: [ 2196]     0  2196     1476       85       5        0             0 bash
Nov 24 21:02:09 n22kvmclone kernel: [ 3284]     0  3284     1299       75       5        0             0 su
Nov 24 21:02:09 n22kvmclone kernel: [ 3286]  1000  3286     1476       82       5        0             0 bash
Nov 24 21:02:09 n22kvmclone kernel: [ 3512]  1000  3512    13944      226       3        0             0 trinity
Nov 24 21:02:09 n22kvmclone kernel: [ 3513]  1000  3513    13944       34       3        0             0 trinity-watchdo
Nov 24 21:02:09 n22kvmclone kernel: [ 3514]  1000  3514    14010      149       3        0             0 trinity-main
Nov 24 21:02:09 n22kvmclone kernel: [ 3699]     0  3699     1476      162       5        0             0 crond
Nov 24 21:02:09 n22kvmclone kernel: [ 3703]     0  3703     1071       26       5        0             0 sadc
Nov 24 21:02:09 n22kvmclone kernel: [ 3873]  1000  3873    14042     1706      12        0           500 trinity-c0
Nov 24 21:02:09 n22kvmclone kernel: [ 3975]  1000  3975    14011    12309      16        0           500 trinity-c1
Nov 24 21:02:09 n22kvmclone kernel: Out of memory: Kill process 3975 (trinity-c1) score 518 or sacrifice child
Nov 24 21:02:09 n22kvmclone kernel: Killed process 3975 (trinity-c1) total-vm:56044kB, anon-rss:492kB, file-rss:48744kB
Nov 24 21:02:09 n22kvmclone kernel: trinity-main invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
Nov 24 21:02:09 n22kvmclone kernel: trinity-main cpuset=/ mems_allowed=0
Nov 24 21:02:09 n22kvmclone kernel: CPU: 1 PID: 3514 Comm: trinity-main Not tainted 3.18.0-rc6 #7
...


With BTRFS it would took much longer - so I'm wondering why ext4 needs so much more memory.

-- 
Toralf
pgp key: 0076 E94E

