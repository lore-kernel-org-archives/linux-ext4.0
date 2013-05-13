From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [BUG] xfstest269 causes deadlock on linux-3.9.0 (ext4)
Date: Mon, 13 May 2013 15:49:24 +0900
Message-ID: <51908CF4.2000703@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:40739 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3EMGzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 02:55:49 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r4D6tlZ9010005
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 13 May 2013 15:55:47 +0900 (JST)
Received: from mailgate3.nec.co.jp ([10.7.69.160])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r4D6njrE003193
	for <linux-ext4@vger.kernel.org>; Mon, 13 May 2013 15:49:45 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id r4D6njE10459 for linux-ext4@vger.kernel.org; Mon, 13 May 2013 15:49:45 +0900 (JST)
Received: from mail01b.kamome.nec.co.jp (mail01b.kamome.nec.co.jp [10.25.43.2])
	by mailsv3.nec.co.jp (8.13.8/8.13.4) with ESMTP id r4D6njqm000579
	for <linux-ext4@vger.kernel.org>; Mon, 13 May 2013 15:49:45 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I ran into the deaclock with xfs_test 269 on linux-3.9.0.
It seems happen between jbd2_log_wait_commit, sleep_on_buffer
and writeback_indoes (Please see ps log below).
Once it occurs we can't touch FS anymore.
In my case 300 - 1000 trials to occur. Is this known issue?

The following kernels seems to have same problem:
- linux-3.5-rc5
- linux-3.8.5
- linux-3.9-rc7
And now I'm trying it on linux-3.10-rc1.

# ./check generic/269
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 mcds1 3.9.0
MKFS_OPTIONS  -- /dev/sda12
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda12 /mnt/mp2


# ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:16,comm
  PID   TID CLS RTPRIO  NI PRI PSR %CPU STAT WCHAN            COMMAND
    1     1 TS       -   0  19   0  0.0 Ss   poll_schedule_ti init
    2     2 TS       -   0  19   0  0.0 S    kthreadd         kthreadd
    3     3 TS       -   0  19   0  0.0 S    smpboot_thread_f ksoftirqd/0
...
 2391  2391 TS       -   0  19   2  0.1 D    jbd2_log_wait_co flush-8:0
...
22647 22647 TS       -   0  19   3  0.0 S    worker_thread    kworker/3:1
22655 22655 TS       -   0  19   0  0.0 S    hrtimer_nanoslee sleep
22657 22657 TS       -   0  19   2  0.0 R+   -                ps
25330 25330 TS       -   0  19   0  0.0 S    worker_thread    kworker/0:0
28963 28963 TS       -   0  19   1  0.0 S+   wait             loop_xfstests.s
28964 28964 TS       -   0  19   1  0.0 S+   wait             check
29180 29180 TS       -   0  19   3  0.0 S    kjournald2       jbd2/sda11-8
29181 29181 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
29199 29199 TS       -   0  19   3  0.0 S+   wait             269
29391 29391 TS       -   0  19   0  0.6 D    sleep_on_buffer  jbd2/sda12-8
29392 29392 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
29394 29394 TS       -   0  19   0  0.0 S    wait             fsstress
29505 29505 TS       -   0  19   3  0.0 D    writeback_inodes fsstress

# df -T /dev/sda11 /dev/sda12
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda11    ext4     9857264     22308   9327564   1% /mnt/mp1
/dev/sda12    ext4      499656    499656         0 100% /mnt/mp2

# tail -f /var/log/messages
May 11 05:59:22 mcds1 root: run xfstest generic/269
May 11 05:59:23 mcds1 kernel: [60999.075705] EXT4-fs (sda12): mounted filesystem with ordered data mode. Opts: acl,user_xattr
May 11 06:01:41 mcds1 kernel: [61137.377958] EXT4-fs (sda11): warning: maximal mount count reached, running e2fsck is recommended
May 11 06:01:41 mcds1 kernel: [61137.378756] EXT4-fs (sda11): mounted filesystem with ordered data mode. Opts: acl,user_xattr
May 11 06:01:48 mcds1 kernel: [61144.673759] EXT4-fs (sda12): mounted filesystem with ordered data mode. Opts: acl,user_xattr
May 11 06:01:48 mcds1 kernel: [61144.882217] EXT4-fs (sda11): warning: maximal mount count reached, running e2fsck is recommended
May 11 06:01:48 mcds1 kernel: [61144.882799] EXT4-fs (sda11): mounted filesystem with ordered data mode. Opts: acl,user_xattr
May 11 06:01:48 mcds1 root: run xfstest generic/269
May 11 06:01:49 mcds1 kernel: [61145.444455] EXT4-fs (sda12): mounted filesystem with ordered data mode. Opts: acl,user_xattr

Regards,
Akira Fujita

