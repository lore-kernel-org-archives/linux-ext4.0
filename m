From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Re: possible ext4 race situation freezing linux
Date: Sat, 07 Mar 2009 08:21:27 +1300
Message-ID: <1236367287.8266.14.camel@localhost.localdomain>
References: <1235478142.11758.9.camel@localhost.localdomain>
	 <20090224141749.GC5482@mit.edu> <49A41469.6090604@redhat.com>
	 <1235495013.11758.37.camel@localhost.localdomain>
	 <20090224173031.GE5482@mit.edu>
	 <1236148970.4674.3.camel@localhost.localdomain>
	 <49AE2604.8080107@redhat.com>
	 <1236153803.4674.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:14074 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZCFTW6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 14:22:58 -0500
Received: by ti-out-0910.google.com with SMTP id d10so348941tib.23
        for <linux-ext4@vger.kernel.org>; Fri, 06 Mar 2009 11:22:56 -0800 (PST)
In-Reply-To: <1236153803.4674.16.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After downloading and installing kernel 2.6.29-rc7 fsck is working.
Few (451) files with multiply-claimed blocks.
fsck is running for the last 12 hours and looks like is doing the job.

-----Original Message-----
From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4
<linux-ext4@vger.kernel.org>
Subject: Re: possible ext4 race situation freezing linux
Date: Wed, 04 Mar 2009 21:03:35 +1300

Steps:

1. Original FS with problems.
2. Using fsck with -y was problematic because at certainpoint a segment
faul occured
3. Using fsck manually. Answering 'y' for all questions but the one
which caused the segment fault
4. Removed as most as possible files from FS to new LV in the same VG
5. A new fsck run worked
6. resize2fs+lvreduce to reduce FS size and have more free space in VG
7. Removed more files to new LV inside the same VG
8. New run of fsck worked
9. resize2fs to prepare for a new lvreduce. Power failure after almost
24 hours of run
10. After system reboot, FS can be mounted and FS seems to be ok.
Executed find, find+grep, cp, and other tools to check file
accessibility. Not messages in /var/log/messages
11. New run of fsck. system freeze
12. Per request, used ALT+PrintScreen+(dlmpqtvw)
13. Used AltPrintScree+(resuib) to restart system
14. System restarted
15. Copy of /var/log/messages to /tmp/messages. Removed lines before and
after Alt+PrintScreen commands

Problem can be reproduced as many times as needed.

Do you want me to execute any procedures to collect data?

Extract from /tmp/messages:

Mar  4 19:19:28 storage kernel: ------------[ cut here ]------------
Mar  4 19:19:28 storage kernel: WARNING: at arch/x86/mm/ioremap.c:226
__ioremap_caller+0xc7/0x299()
Mar  4 19:19:28 storage kernel: Modules linked in: ck804xrom(+) i2c_core
mtd chipreg map_funcs joydev usb_storage ata_generic pata_acpi pata_amd
[last unloaded: scsi_wait_scan]
Mar  4 19:19:28 storage kernel: Pid: 881, comm: modprobe Not tainted
2.6.28.7.afb.fc10.4.x86_amd64 #1
Mar  4 19:19:28 storage kernel: Call Trace:
Mar  4 19:19:28 storage kernel: [<ffffffff8104516d>] warn_on_slowpath
+0x58/0x7d
Mar  4 19:19:28 storage kernel: [<ffffffff810458a5>] ?
release_console_sem+0x1c6/0x1fb
Mar  4 19:19:28 storage kernel: [<ffffffff81347775>] ? printk+0x3c/0x3f
Mar  4 19:19:28 storage kernel: [<ffffffff81028787>] ?
default_spin_lock_flags+0x9/0xe
Mar  4 19:19:28 storage kernel: [<ffffffffa006c000>] ? init_ck804xrom
+0x0/0x556 [ck804xrom]
Mar  4 19:19:28 storage kernel: [<ffffffff8102e4a6>] __ioremap_caller
+0xc7/0x299
Mar  4 19:19:28 storage kernel: [<ffffffffa006c25c>] ? init_ck804xrom
+0x25c/0x556 [ck804xrom]
Mar  4 19:19:28 storage kernel: [<ffffffffa006c000>] ? init_ck804xrom
+0x0/0x556 [ck804xrom]
Mar  4 19:19:28 storage kernel: [<ffffffff8102e74d>] ioremap_nocache
+0x12/0x14
Mar  4 19:19:28 storage kernel: [<ffffffffa006c25c>] init_ck804xrom
+0x25c/0x556 [ck804xrom]
Mar  4 19:19:28 storage kernel: [<ffffffff810ae835>] ? vfree+0x29/0x2b
Mar  4 19:19:28 storage kernel: [<ffffffff810699e5>] ? load_module
+0x1803/0x197a
Mar  4 19:19:28 storage kernel: [<ffffffffa006c000>] ? init_ck804xrom
+0x0/0x556 [ck804xrom]
Mar  4 19:19:28 storage kernel: [<ffffffff8100a058>] do_one_initcall
+0x58/0x145
Mar  4 19:19:28 storage kernel: [<ffffffff810c612c>] ? do_sync_read
+0xe7/0x12d
Mar  4 19:19:28 storage kernel: [<ffffffff81069ce2>] sys_init_module
+0xa9/0x1b6
Mar  4 19:19:28 storage kernel: [<ffffffff8101104a>]
system_call_fastpath+0x16/0x1b
Mar  4 19:19:28 storage kernel: ---[ end trace 66d1cdaa6433edb1 ]---


-----Original Message-----
From: Eric Sandeen <sandeen@redhat.com>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4
<linux-ext4@vger.kernel.org>
Subject: Re: possible ext4 race situation freezing linux
Date: Wed, 04 Mar 2009 00:56:04 -0600

Andreas Friedrich Berendsen wrote:
>  Ts'o,
> 
> Problem still exist. Now, when executing 'fsck.ext4 -C 0 -F -y -v' I
> receive a list of inodes, and at certain point system freezes.

so now it's freezing when ext4 isn't even mounted but simply being
fsck'd?  This may point to a generic storage problem.

> Attached I'm sending the output for SysRq as requested

$ zcat messages.gz | grep -i sysrq
$

The sysrq output didn't seem to make it to that log.

-Eric
-- 
__________________________________________
Andreas Friedrich Berendsen
SCA OCP MSCA A+ Linux+ Network+ HpMASE

