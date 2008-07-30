From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 11175] New: ext3 BUG in add_dirent_to_buf+0x6c/0x269
Date: Tue, 29 Jul 2008 17:12:07 -0700
Message-ID: <20080729171207.d88728cf.akpm@linux-foundation.org>
References: <bug-11175-27@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, kernel.bugzilla@asheesh.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbYG3AMO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 20:12:14 -0400
In-Reply-To: <bug-11175-27@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 29 Jul 2008 17:00:11 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11175
> 
>            Summary: ext3 BUG in add_dirent_to_buf+0x6c/0x269
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.25.8-vs2.3.x-vs2.3.0.34.12
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: kernel.bugzilla@asheesh.org
> 
> 
> Latest working kernel version: Didn't see this problem a few months ago but the
> filesystem is new
> Earliest failing kernel version: 2.6.25.8-vs2.3.x-vs2.3.0.34.12 (same as
> submission)
> Distribution: Debian unstable
> Hardware Environment: Dell-brand ICH8-based Core 2 Duo
> Software Environment: Debian unstable
> Problem Description:
> 
> I have a 1T disk I store backups on using rsync and hardlinks.  Some usage
> information:
> 
> paulproteus@sf:~ $ df -k /dev/sdb1
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb1            961432072 635100984 326331088  67%
> /media/asheesh-big-backups
> paulproteus@sf:~ $ df -i /dev/sdb1
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb1            122109952 9786584 112323368    9%
> /media/asheesh-big-backups
> 
> Sometimes, the system will hang on writes to that filesystem until I reboot. 
> Strangely, the problem seems to persist after an fsck -f.
> 
> I reboot and fsck, and I can write again, but then I get it again.
> 
> Steps to reproduce:
> 
> * Wait a while
> * Write to the filesystem
> * Note that you get a BUG in dmesg and further writes to the filesystem hang
> 
> ksymoops has this to say about the BUG:
> 
> ksymoops 2.4.11 on i686 2.6.25.8-vs2.3.x-vs2.3.0.34.12.  Options used
>      -V (default)
>      -k /proc/ksyms (default)
>      -l /proc/modules (default)
>      -o /lib/modules/2.6.25.8-vs2.3.x-vs2.3.0.34.12/ (default)
>      -m /boot/System.map-2.6.25.8-vs2.3.x-vs2.3.0.34.12 (default)
> 
> Warning: You did not tell me where to find symbol information.  I will
> assume that the log matches the kernel and modules that are running
> right now and I'll use the default options above for symbol resolution.
> If the current kernel and/or modules do not match the log, you can get
> more accurate output by telling me the kernel version and where to find
> map, modules, ksyms etc.  ksymoops -h explains the options.
> 
> Error (regular_file): read_ksyms stat /proc/ksyms failed
> No modules in ksyms, skipping objects
> No ksyms, skipping lsmod
> lo: Disabled Privacy Extensions
> e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
> e1000e: Copyright (c) 1999-2007 Intel Corporation.
> ehci_hcd 0000:00:1a.7: debug port 1
> ehci_hcd 0000:00:1d.7: debug port 1
> dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> warning: `dnsmasq' uses deprecated v2 capabilities in a way that may be
> insecure.
> warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
> Pid: 8603, comm: smtpd Not tainted 2.6.25.8-vs2.3.x-vs2.3.0.34.12 #3
>  [<c01634a7>] oom_kill_process+0x43/0x18d
>  [<c01638fb>] out_of_memory+0x158/0x18d
>  [<c0165c6d>] __alloc_pages+0x22f/0x2b7
>  [<c01755a8>] read_swap_cache_async+0x71/0xe0
>  [<c0175654>] swapin_readahead+0x3d/0x6e
>  [<c016de6e>] handle_mm_fault+0x402/0x8cd
>  [<c0128846>] ? irq_exit+0x74/0x77
>  [<c0110689>] ? smp_apic_timer_interrupt+0x6e/0x7c
>  [<c0105600>] ? apic_timer_interrupt+0x28/0x30
>  [<c030021e>] do_page_fault+0x37c/0x725
>  [<c01373a8>] ? enqueue_hrtimer+0xc8/0xd3
>  [<c0137bf1>] ? hrtimer_start+0x154/0x16e
>  [<c011e8c1>] ? hrtick_set+0x98/0xe6
>  [<c02ffea2>] ? do_page_fault+0x0/0x725
>  [<c0104446>] ? do_notify_resume+0x735/0x74e
>  [<c0171d34>] ? mmap_region+0x187/0x405
>  [<c0171eeb>] ? mmap_region+0x33e/0x405
>  [<c010a8c2>] ? set_tls_desc+0x13d/0x156
>  [<c010ad25>] ? do_set_thread_area+0xa6/0xba
>  [<c02ffea2>] ? do_page_fault+0x0/0x725
>  [<c02fe952>] error_code+0x72/0x78
>  [<c02f0000>] ? clip_ioctl+0x3f5/0x45c
> CPU    0: hi:    0, btch:   1 usd:   0
> CPU    1: hi:    0, btch:   1 usd:   0
> CPU    0: hi:  186, btch:  31 usd: 149
> CPU    1: hi:  186, btch:  31 usd: 183
> CPU    0: hi:  186, btch:  31 usd: 136
> CPU    1: hi:  186, btch:  31 usd: 106
> 191968 total pagecache pages
> 521809 pages of RAM
> 292433 pages of HIGHMEM
> 5290 reserved pages
> 38300 pages shared
> 189736 pages swap cached
> 4584 pages slab
> 1504 pages pagetables
> BUG: unable to handle kernel paging request at f8000000
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT SMP 
> Pid: 12197, comm: rsync Not tainted (2.6.25.8-vs2.3.x-vs2.3.0.34.12 #3)
> EIP: 0060:[<f89c6854>] EFLAGS: 00210246 CPU: 1
> Using defaults from ksymoops -t elf32-i386 -a i386
> EAX: 00000000 EBX: f7fffe90 ECX: f7fffffe EDX: 00000000
> ESI: 00000000 EDI: 00000800 EBP: c248ddd0 ESP: c248dd5c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Stack: f7d6b000 c248de64 c9960e80 dbc20504 c248ddb4 00001000 ddb78860 f0f2b4b0 
>        f8000000 f7d6a000 f7fff000 0000002e f7fffff8 c9ada62a 00000f78 c248ddd4 
>        f89c6b1a f7d6a000 f7fffe90 00000058 c9bd73f4 875f4d2a 00000002 f7b56068 
> Call Trace:
>  [<f89c6b1a>] ? add_dirent_to_buf+0x6c/0x269 [ext3]
>  [<f89c70df>] ? ext3_add_entry+0x3c8/0x77f [ext3]
>  [<c012a34a>] ? capable+0x10/0x12
>  [<c0184f38>] ? generic_permission+0x8c/0xc6
>  [<c02fe715>] ? _spin_unlock+0xf/0x23
>  [<f898ea69>] ? start_this_handle+0x2a7/0x2c6 [jbd]
>  [<f89c7a71>] ? ext3_add_nondir+0x15/0x42 [ext3]
>  [<f89c7c3a>] ? ext3_link+0xb4/0xea [ext3]
>  [<c0185c50>] ? vfs_link+0x132/0x1c3
>  [<c01889ef>] ? sys_linkat+0xb2/0xee
>  [<c0181c36>] ? sys_lstat64+0x22/0x28
>  [<c0188a3f>] ? sys_link+0x14/0x16
>  [<c0104ad4>] ? sysenter_past_esp+0x6d/0xa5
> Code: 00 00 00 89 79 f8 89 f1 3b 4d d4 77 d7 85 c0 74 07 8b 75 bc 31 c0 eb ee
> 8b 55 b8 8b 7d a0 8b 5d d4 d1 ef 8d 4c d3 fe 31 f6 31 d2 <8b> 19 83 e9 08 89 d8
> 66 d1 e8 0f b7 c0 8d 04 02 39 f8 77 08 0f 
> 
> 
> >>EIP; f89c6854 <END_OF_CODE+3852d854/????>   <=====
> 
> Trace; f89c6b1a <END_OF_CODE+3852db1a/????>
> Trace; f89c70df <END_OF_CODE+3852e0df/????>
> Trace; c012a34a <capable+10/12>
> Trace; c0184f38 <generic_permission+8c/c6>
> Trace; c02fe715 <_spin_unlock+f/23>
> Trace; f898ea69 <END_OF_CODE+384f5a69/????>
> Trace; f89c7a71 <END_OF_CODE+3852ea71/????>
> Trace; f89c7c3a <END_OF_CODE+3852ec3a/????>
> Trace; c0185c50 <vfs_link+132/1c3>
> Trace; c01889ef <sys_linkat+b2/ee>
> Trace; c0181c36 <sys_lstat64+22/28>
> Trace; c0188a3f <sys_link+14/16>
> Trace; c0104ad4 <sysenter_past_esp+6d/a5>
> 
> Code;  f89c6829 <END_OF_CODE+3852d829/????>
> 00000000 <_EIP>:
> Code;  f89c6829 <END_OF_CODE+3852d829/????>
>    0:   00 00                     add    %al,(%eax)
> Code;  f89c682b <END_OF_CODE+3852d82b/????>
>    2:   00 89 79 f8 89 f1         add    %cl,-0xe760787(%ecx)
> Code;  f89c6831 <END_OF_CODE+3852d831/????>
>    8:   3b 4d d4                  cmp    -0x2c(%ebp),%ecx
> Code;  f89c6834 <END_OF_CODE+3852d834/????>
>    b:   77 d7                     ja     ffffffe4 <_EIP+0xffffffe4>
> Code;  f89c6836 <END_OF_CODE+3852d836/????>
>    d:   85 c0                     test   %eax,%eax
> Code;  f89c6838 <END_OF_CODE+3852d838/????>
>    f:   74 07                     je     18 <_EIP+0x18>
> Code;  f89c683a <END_OF_CODE+3852d83a/????>
>   11:   8b 75 bc                  mov    -0x44(%ebp),%esi
> Code;  f89c683d <END_OF_CODE+3852d83d/????>
>   14:   31 c0                     xor    %eax,%eax
> Code;  f89c683f <END_OF_CODE+3852d83f/????>
>   16:   eb ee                     jmp    6 <_EIP+0x6>
> Code;  f89c6841 <END_OF_CODE+3852d841/????>
>   18:   8b 55 b8                  mov    -0x48(%ebp),%edx
> Code;  f89c6844 <END_OF_CODE+3852d844/????>
>   1b:   8b 7d a0                  mov    -0x60(%ebp),%edi
> Code;  f89c6847 <END_OF_CODE+3852d847/????>
>   1e:   8b 5d d4                  mov    -0x2c(%ebp),%ebx
> Code;  f89c684a <END_OF_CODE+3852d84a/????>
>   21:   d1 ef                     shr    %edi
> Code;  f89c684c <END_OF_CODE+3852d84c/????>
>   23:   8d 4c d3 fe               lea    -0x2(%ebx,%edx,8),%ecx
> Code;  f89c6850 <END_OF_CODE+3852d850/????>
>   27:   31 f6                     xor    %esi,%esi
> Code;  f89c6852 <END_OF_CODE+3852d852/????>
>   29:   31 d2                     xor    %edx,%edx
> Code;  f89c6854 <END_OF_CODE+3852d854/????>   <=====
>   2b:   8b 19                     mov    (%ecx),%ebx   <=====
> Code;  f89c6856 <END_OF_CODE+3852d856/????>
>   2d:   83 e9 08                  sub    $0x8,%ecx
> Code;  f89c6859 <END_OF_CODE+3852d859/????>
>   30:   89 d8                     mov    %ebx,%eax
> Code;  f89c685b <END_OF_CODE+3852d85b/????>
>   32:   66 d1 e8                  shr    %ax
> Code;  f89c685e <END_OF_CODE+3852d85e/????>
>   35:   0f b7 c0                  movzwl %ax,%eax
> Code;  f89c6861 <END_OF_CODE+3852d861/????>
>   38:   8d 04 02                  lea    (%edx,%eax,1),%eax
> Code;  f89c6864 <END_OF_CODE+3852d864/????>
>   3b:   39 f8                     cmp    %edi,%eax
> Code;  f89c6866 <END_OF_CODE+3852d866/????>
>   3d:   77 08                     ja     47 <_EIP+0x47>
> Code;  f89c6868 <END_OF_CODE+3852d868/????>
>   3f:   
> 
> EIP: [<f89c6854>] do_split+0x1ee/0x419 [ext3] SS:ESP 0068:c248dd5c
> Warning (Oops_read): Code line not seen, dumping what data is available
> 
> 
> >>EIP; f89c6854 <END_OF_CODE+3852d854/????>   <=====
> 
> 
> 2 warnings and 1 error issued.  Results may not be reliable.
> 

