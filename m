From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12896] New: ext3 FS problem or harddisk problem?
Date: Fri, 20 Mar 2009 02:16:16 -0700 (PDT)
Message-ID: <bug-12896-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821AbZCTJQz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Mar 2009 05:16:55 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2K9GHIv004630
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2009 02:16:53 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12896

           Summary: ext3 FS problem or harddisk problem?
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc8 (linus tree)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: htmldeveloper@gmail.com


Latest working kernel version:   not sure
Earliest failing kernel version:   not sure
Distribution:   FC10 x86_64
Hardware Environment:

/root/download>cat /proc/cpuinfo 
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4800+
stepping        : 2
cpu MHz         : 2411.008
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext
3dnow rep_good pni lahf_lm cmp_legacy
bogomips        : 4822.01
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4800+
stepping        : 2
cpu MHz         : 2411.008
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext
3dnow rep_good pni lahf_lm cmp_legacy
bogomips        : 4821.19
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

Mounted harddisk:   

scsi 11:0:0:0: Direct-Access     WD       1600BEAExternal  1.02 PQ: 0 ANSI: 0
sd 11:0:0:0: [sdf] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
sd 11:0:0:0: [sdf] Write Protect is off
sd 11:0:0:0: [sdf] Mode Sense: 00 00 00 00
sd 11:0:0:0: [sdf] Assuming drive cache: write through
sd 11:0:0:0: [sdf] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
sd 11:0:0:0: [sdf] Write Protect is off
sd 11:0:0:0: [sdf] Mode Sense: 00 00 00 00
sd 11:0:0:0: [sdf] Assuming drive cache: write through
 sdf: sdf1 sdf2 sdf3 < sdf5 > sdf4
sd 11:0:0:0: [sdf] Attached SCSI disk
sd 11:0:0:0: Attached scsi generic sg5 type 0
kjournald starting.  Commit interval 5 seconds

Software Environment:


ext3 fs, 
Problem Description:

Encountered this after FC10 automount the partition (ext3):

kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf4, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
ext3_abort called.
EXT3-fs error (device sde1): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
ext3_abort called.
EXT3-fs error (device sde1): ext3_put_super: Couldn't clean up the journal

As shown above, at first it was mounted as /dev/sde, but subsequently it
errored, umount automatically, and remount again (all done by FC10.....happened
without my control) as sdf:

/dev/sdf4             40631988  29915736   8618968  78% /media/_1
/dev/sdf5             14659280  14656544      2736 100% /media/disk-1
/dev/sdf2             38448304  20934324  15560880  58% /media/disk-2
/dev/sdf1             39381744  14880908  22500344  40% /media/disk

Repeatable or not cannot say, but done it thrice and seemingly happened three
times (mount and ls repeated).   

Other symptoms:

Message from syslogd@localhost at Mar 20 17:04:47 ...
 kernel:journal commit I/O error

Message from syslogd@localhost at Mar 20 17:04:48 ...
 kernel:journal commit I/O error

DBus error org.freedesktop.DBus.Error.NoReply: Did not receive a reply.
Possible causes include: the remote application did not send a reply, the
message bus security policy blocked the reply, the reply timeout expired, or
the network connection was broken.

etc.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
