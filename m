From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.33-rc6 crashes on resume
Date: Tue, 09 Feb 2010 10:05:56 -0500
Message-ID: <4B7179D4.1090803@tmr.com>
References: <4B70982F.8090208@roadwarrior3.tmr.com> <201002090016.18027.rjw@sisk.pl> <4B70D75A.7010600@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090403010305080606080506"
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B70D75A.7010600@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------090403010305080606080506
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> On 02/09/2010 08:16 AM, Rafael J. Wysocki wrote:
>   
>> On Tuesday 09 February 2010, Bill Davidsen wrote:
>>     
>>> Pretty simple to reproduce, boot, suspend, press shift
>>>
>>> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.
>>>       
>> This looks suspicious:
>>
>> Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: ACPI cmd 03/42:00:00:00:a0:ef (CFA REQUEST EXTENDED ERROR) rejected by device (Stat=0x51 Err=0x04)
>> Feb  8 17:32:47 roadwarrior3 kernel: sd 0:0:0:0: [sda] Starting disk
>>     
[snip]

> These aren't harmful in themselves.  It just means that the device
> failed commands BIOS requested via ACPI.  Just in case, does
> "libata.noacpi=1" make any difference to the oops?
>   

I tried that, most interesting result. The kernel still crashes but then 
starts removing modules at random, re-crashing and declaring itself 
tainted, and finally gets up (for some definition of up) enough to issue 
shutdown. It then crashes its way to a halt. I have attached the first 
BUG here, but the whole log, boot to shutdown is pretty huge to inflict 
on people, so I put it up for download on the theory that it is unlikely 
to be helpful or interesting, just big.

At this point I'm going to build 2.6.33-rc{latest} and try again, I 
hoped this could be useful quickly, so I'll use the latest in the hope 
that it might show the problem fixed.

The whole log is at 
http://www.tmr.com/~davidsen/Private/noacpi_crash.trace.bz2

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--------------090403010305080606080506
Content-Type: text/plain;
 name="noacpi_crash_1st.trace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="noacpi_crash_1st.trace"

Feb  9 09:36:01 roadwarrior3 kernel: BUG: unable to handle kernel paging request at f72fd5a0
Feb  9 09:36:01 roadwarrior3 kernel: IP: [<c0552c43>] ext4_xattr_get+0xa0/0x232
Feb  9 09:36:01 roadwarrior3 kernel: *pde = 00007067 *pte = 00000000 
Feb  9 09:36:01 roadwarrior3 kernel: Oops: 0000 [#1] SMP 
Feb  9 09:36:01 roadwarrior3 kernel: last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
Feb  9 09:36:01 roadwarrior3 kernel: Modules linked in: aes_generic lib80211_crypt_ccmp fuse sunrpc cpufreq_ondemand acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 ext2 uinput snd_intel8x0 snd_intel8x0m snd_ac97_codec ipw2200 ac97_bus snd_seq libipw snd_seq_device snd_pcm cfg80211 b44 snd_timer rfkill snd ssb iTCO_wdt tifm_7xx1 tifm_core soundcore mii lib80211 snd_page_alloc iTCO_vendor_support i2c_i801 serio_raw sbs joydev sbshc dm_multipath firewire_ohci firewire_core yenta_socket crc_itu_t rsrc_nonstatic video output radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Feb  9 09:36:01 roadwarrior3 kernel:
Feb  9 09:36:01 roadwarrior3 kernel: Pid: 2339, comm: atd Not tainted 2.6.33-rc6 #1 Aspire 1680   /Aspire 1680   
Feb  9 09:36:01 roadwarrior3 kernel: EIP: 0060:[<c0552c43>] EFLAGS: 00010286 CPU: 0
Feb  9 09:36:01 roadwarrior3 kernel: EIP is at ext4_xattr_get+0xa0/0x232
Feb  9 09:36:01 roadwarrior3 kernel: EAX: c1d2a400 EBX: f72fd5a0 ECX: f72fd5a0 EDX: f72fd600
Feb  9 09:36:01 roadwarrior3 kernel: ESI: 00000000 EDI: c19a42f8 EBP: f43c5e08 ESP: f43c5dc8
Feb  9 09:36:01 roadwarrior3 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb  9 09:36:01 roadwarrior3 kernel: Process atd (pid: 2339, ti=f43c4000 task=f41432c0 task.ti=f43c4000)
Feb  9 09:36:01 roadwarrior3 kernel: Stack:
Feb  9 09:36:01 roadwarrior3 kernel: c19a42f8 c2c4dca0 00000163 00000007 c08b2bc1 00000006 c19a42c8 c19a4270
Feb  9 09:36:01 roadwarrior3 kernel: <0> f72fd59c f69ea900 00000500 00000008 f72fd5a0 c08b2bc1 c19adcc0 f43c5e5c
Feb  9 09:36:01 roadwarrior3 kernel: <0> f43c5e24 c0553bb0 f43c5e5c 00000014 c08b2bc1 c097807c c08b2bb8 f43c5e48
Feb  9 09:36:01 roadwarrior3 kernel: Call Trace:
Feb  9 09:36:01 roadwarrior3 kernel: [<c0553bb0>] ? ext4_xattr_security_get+0x39/0x47
Feb  9 09:36:01 roadwarrior3 kernel: [<c04e496e>] ? generic_getxattr+0x66/0x6a
Feb  9 09:36:01 roadwarrior3 kernel: [<c04e4908>] ? generic_getxattr+0x0/0x6a
Feb  9 09:36:01 roadwarrior3 kernel: [<c057376f>] ? get_vfs_caps_from_disk+0x45/0xcb
Feb  9 09:36:01 roadwarrior3 kernel: [<c057e984>] ? selinux_capable+0xb1/0xf6
Feb  9 09:36:01 roadwarrior3 kernel: [<c0573881>] ? cap_bprm_set_creds+0x8c/0x2f9
Feb  9 09:36:01 roadwarrior3 kernel: [<c057e673>] ? selinux_bprm_set_creds+0x31/0x20d
Feb  9 09:36:01 roadwarrior3 kernel: [<c04b795a>] ? __vma_link+0x5d/0x61
Feb  9 09:36:01 roadwarrior3 kernel: [<c04b79b6>] ? vma_link+0x58/0x77
Feb  9 09:36:01 roadwarrior3 kernel: [<c04b7a8c>] ? insert_vm_struct+0xb7/0xca
Feb  9 09:36:01 roadwarrior3 kernel: [<c0573ccb>] ? security_bprm_set_creds+0x11/0x13
Feb  9 09:36:01 roadwarrior3 kernel: [<c04d46d2>] ? prepare_binprm+0xbd/0xf4
Feb  9 09:36:01 roadwarrior3 kernel: [<c04d37b6>] ? count+0x34/0x6f
Feb  9 09:36:01 roadwarrior3 kernel: [<c04d4ca8>] ? do_execve+0x132/0x270
Feb  9 09:36:01 roadwarrior3 kernel: [<c04091f0>] ? sys_execve+0x30/0x58
Feb  9 09:36:01 roadwarrior3 kernel: [<c040346e>] ? ptregs_execve+0x12/0x18
Feb  9 09:36:01 roadwarrior3 kernel: [<c040339f>] ? sysenter_do_call+0x12/0x28
Feb  9 09:36:01 roadwarrior3 kernel: Code: d9 89 5d f0 8b 87 a4 00 00 00 8b 80 84 01 00 00 03 50 64 eb 16 0f b6 01 83 c0 13 83 e0 fc 01 c1 39 d1 72 07 be fb ff ff ff eb 34 <83> 39 00 75 e5 e9 26 01 00 00 8b 45 f0 83 7d 08 00 8b 58 08 74 
Feb  9 09:36:01 roadwarrior3 kernel: EIP: [<c0552c43>] ext4_xattr_get+0xa0/0x232 SS:ESP 0068:f43c5dc8
Feb  9 09:36:01 roadwarrior3 kernel: CR2: 00000000f72fd5a0
Feb  9 09:36:01 roadwarrior3 kernel: ---[ end trace d628288f47b346eb ]---

--------------090403010305080606080506--
