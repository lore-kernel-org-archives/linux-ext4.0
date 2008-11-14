From: Kelly Kane <kelly@hq.newdream.net>
Subject: Call traces on console from a test machine
Date: Thu, 13 Nov 2008 16:31:31 -0800
Message-ID: <491CC6E3.7070808@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.hq.newdream.net ([66.33.206.127]:42806 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYKNBFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 20:05:09 -0500
Received: from ip-10-0-1-185.dreamhost.com (ip-66-33-206-8.dreamhost.com [66.33.206.8])
	by mail.hq.newdream.net (Postfix) with ESMTP id 5E9EE244A7
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 16:33:07 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have a production (yay!) ext4 server which has started spewing 
ext4_da_writepages errors on the console. The only change anyone can 
think of is that we started doing rsync backups of the machine to 
another. Perhaps this heavy I/O on user home directories is causing the 
problem?

> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           51.46   20.91   19.90    0.63    0.00    7.10
> 
> Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00   165.48  0.00 40.61     0.00  1648.73    40.60     1.28   31.45   0.90   3.65
> sda1              0.00   165.48  0.00 40.61     0.00  1648.73    40.60     1.28   31.45   0.90   3.65
> sda2              0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> sda3              0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> sdb               0.51     0.00 31.98  0.00   795.94     0.00    24.89     0.27    8.76   6.73  21.52
> sdb1              0.51     0.00 31.98  0.00   795.94     0.00    24.89     0.27    8.76   6.73  21.52

The errors scrolling by pretty quickly on the serial console:

ext4_da_writepages: jbd2_start: 1024 pages, ino 3014931; err -30
Pid: 284, comm: pdflush Tainted: G        W 
2.6.27-serf-xeon-c6.1-ext4-grsec #1

Call Trace:
  [<ffffffff8031d485>] ext4_da_writepages+0x2f5/0x320
  [<ffffffff80227cc5>] __dequeue_entity+0x55/0x80
  [<ffffffff80227d15>] set_next_entity+0x25/0x50
  [<ffffffff8026f570>] do_writepages+0x20/0x40
  [<ffffffff802b3717>] __writeback_single_inode+0x97/0x340
  [<ffffffff8022787f>] update_curr+0x3f/0x60
  [<ffffffff80227cc5>] __dequeue_entity+0x55/0x80
  [<ffffffff802b3e17>] generic_sync_sb_inodes+0x217/0x320
  [<ffffffff802b42ce>] writeback_inodes+0x7e/0xc0
  [<ffffffff8026ffc6>] wb_kupdate+0xa6/0x120
  [<ffffffff802704a0>] pdflush+0x0/0x220
  [<ffffffff802704a0>] pdflush+0x0/0x220
  [<ffffffff802705de>] pdflush+0x13e/0x220
  [<ffffffff8026ff20>] wb_kupdate+0x0/0x120
  [<ffffffff80246b6b>] kthread+0x4b/0x80
  [<ffffffff80203789>] child_rip+0xa/0x11
  [<ffffffff80246b20>] kthread+0x0/0x80
  [<ffffffff8020377f>] child_rip+0x0/0x11

This is a vanilla 2.6.27 kernel + grsec + "2.6.27-ext4-2" patchset + the 
following patch per Sandeen:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3c37fc86d20fe35be656f070997d62f75c2e4874;hp=8c9fa93d51123c5540762b1a9e1919d6f9c4af7c

Unfortunately I do not have a reproducible, yet, and the kernel is 
monolithic. It hasn't been rebooted (yet!) so I can gather something 
from the memory. If it crashes or proves unusable, though, I will have 
to reboot it.

We also switched the fstab, but no one remembers remounting the 
filesystem to be as follows:

/dev/sdb1       /home      ext4 
defaults,noatime,nodiratime,nosuid,nodev,errors=remount-ro,data=writeback 
       0       0

Prior it had no "data=" section.

Kelly
