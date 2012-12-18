From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51781] New: System got hanged with firefox. Filesystem not
 responding.
Date: Tue, 18 Dec 2012 08:53:48 +0000 (UTC)
Message-ID: <bug-51781-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab2LRIxv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 03:53:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5498020226
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 08:53:50 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1684F201B2
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 08:53:48 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51781

               URL: https://developer.mozilla.org/en-US/demos/detail/banan
                    abread
           Summary: System got hanged with firefox. Filesystem not
                    responding.
           Product: File System
           Version: 2.5
    Kernel Version: Linux red1 3.5.0-21-generic #32-Ubuntu SMP
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: gaguilar@aguilardelgado.com
        Regression: No


Created an attachment (id=89401)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=89401)
Syslog from faillure to next reboot

Hello, 

Something really bizarre happened with firefox. It seems the kernel stopped to
serve filesystem request because a hung process.

I ran de mozilla demo bananabread, exited one level and entered another and
everything stopped to work. I tried to kill the process but it has a "D" on the
status and cannot be killed. 

After a while everything stopped to work. Even the reboot didn't work. I had to
unplug the machine.

Kernel logs (syslog) is attached. 

It seems something was failing in the disk. It has everything there until next
reboot.



I don't know if it's a bug or not but wanted to make sure that nothing can be
done.


I did an error installing bios raid. I have to undo it but I'm a little bit
afraid of undoing without a backup. 

root@red1:/var/log# dmraid -r
/dev/sdb: pdc, "pdc_bbbgggjccd", mirror, ok, 625011328 sectors, data@ 0
/dev/sda: pdc, "pdc_bbbgggjccd", mirror, ok, 625011328 sectors, data@ 0


This raid is getting me into troubles. Disk sdb is what failed.


gad@red1:~$ cat /proc/cpuinfo 
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 4
model name    : AMD Phenom(tm) II X4 810 Processor
stepping    : 2
microcode    : 0x10000db
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 4
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock
nrip_save
bogomips    : 5217.27
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor    : 1
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 4
model name    : AMD Phenom(tm) II X4 810 Processor
stepping    : 2
microcode    : 0x10000db
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 4
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock
nrip_save
bogomips    : 5217.27
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor    : 2
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 4
model name    : AMD Phenom(tm) II X4 810 Processor
stepping    : 2
microcode    : 0x10000db
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 2
cpu cores    : 4
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock
nrip_save
bogomips    : 5217.27
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor    : 3
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 4
model name    : AMD Phenom(tm) II X4 810 Processor
stepping    : 2
microcode    : 0x10000db
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 3
cpu cores    : 4
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock
nrip_save
bogomips    : 5217.27
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate





Linux red1 3.5.0-21-generic #32-Ubuntu SMP Tue Dec 11 18:51:59 UTC 2012 x86_64
x86_64 x86_64 GNU/Linux

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
