From: Marti Raudsepp <marti@juffo.org>
Subject: ext4 startup kernel oops in kernel 3.3.0
Date: Wed, 21 Mar 2012 15:16:34 +0200
Message-ID: <CABRT9RB1L4vKmD5tZoQuoZyPmsaniwwFmZjsgGkrwoqz83954g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab2CUNRP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Mar 2012 09:17:15 -0400
Received: by iagz16 with SMTP id z16so1566425iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2012 06:17:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm using kernel 3.3.0 on one of my VMs and recently it oopsed in ext4
during startup. Before this crash, I did a package update, followed
quickly by a reboot.

Things went wrong early enough in the boot process that there are no
log entries of the system's startup. Yet the fact that it crashed at
12 seconds is weird -- usually this machine boots in under 3 seconds.

Strangely enough, after another reboot, things were OK again.

I'm using Arch Linux with systemd, x86_64 VM under QEMU/KVM. virtio
storage using QEMU's "threads" I/O mode. ext4 with the only mount
option "noatime".

Here's a picture of the oops: http://ompldr.org/vZDNnNg

Since all I have is this screenshot, I'll have to type in the stack
trace. The oops message itself was lost thanks to kernel's brilliant
debugging tools (Shift+PgUp didn't work).

Process: flush-254:0 (pid 299)

Call Trace:
? pagevec_lookup_tag
? write_cache_pages_da [ext4]
mpage_da_map_and_submit [ext4]
? ext4_da_writepages [ext4]
ext4_da_writepages [ext4]
do_writepages
writeback_single_inode
writeback_sb_inodes
__writeback_inodes_wb
wb_writeback
? prop_fraction_percpu
wb_do_writeback
? schedule_timeout
bdi_writeback_thread
? wb_do_writeback
kthread
kernel_thread_helper
? kthread_freezable_should_stop
? gs_change

RIP mpage_da_submit_io [ext4]

Regards,
Marti
