From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 20:35:02 +0200
Message-ID: <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	 <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>
	 <200804220254.45251.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
	 <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	"David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au
To: "Ingo Molnar" <mingo@elte.hu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764828AbYDVSfi@vger.kernel.org>
In-Reply-To: <20080422095315.GA28014@elte.hu>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2008/4/22, Ingo Molnar <mingo@elte.hu>:
>
>  * Jiri Slaby <jirislaby@gmail.com> wrote:
>
>  >> What do you do to trigger this? Any particular load? Is it still just
>  >> doing suspend/resume, or do you have something else that you are
>  >> playing with?
>  >
>  > Yesterday I did 2 suspend/resumes after 1 hour of uptime and ran
>  > git-status for a fraction of a second until it was killed. So I can
>  > perfectly reproduce it when I suspend, resume and produce some io
>  > load. I guess it's time to bisect 2.6.25-rc8-mm2 as I'm able to
>  > reproduce it the best and haven't seen that bug in -rc8-mm1 for over
>  > week of suspending and working.
>
>
> the most dangerous x86 change we added was the PAT stuff. Does it
>  influence the crashes in any way if you boot with 'nopat' or if you
>  disable CONFIG_X86_PAT=y into the .config?
>
>  the other area was the DMA ops change - that should be rather trivial on
>  64-bit though.


Unsure how it is related to my orginal Oops post - but now when I've
debug pagealloc enabled this appeared in my log after resume - should
I open new bug for this - or could this be part of the problem I've
experienced later?

(Note - now I'm running commit: 8a81f2738f10ca817c975cec893aa58497e873b2

 sd 0:0:0:0: [sda] Starting disk
 mmc0: new SD card at address 5a61
 mmc mmc0:5a61: parent mmc0 is sleeping, will not add
 ------------[ cut here ]------------
 WARNING: at drivers/base/power/main.c:78 device_pm_add+0x6c/0xf0()
 Modules linked in: tda18271 nls_iso8859_2 nls_cp852 vfat fat i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc
binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput kvm_intel kvm
snd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq arc4
snd_seq_device snd_pcm_oss ecb crypto_blkcipher cryptomgr
crypto_algapi iwl3945 snd_mixer_oss mac80211 snd_pcm mmc_block video
sdhci thinkpad_acpi mmc_core i2c_i801 snd_timer rtc_cmos rtc_core
backlight iTCO_wdt cfg80211 evdev snd i2c_core e1000e psmouse
soundcore snd_page_alloc nvram intel_agp rtc_lib iTCO_vendor_support
output serio_raw ac battery button uhci_hcd ohci_hcd ehci_hcd usbcore
[last unloaded: microcode]
 Pid: 1240, comm: kmmcd Not tainted 2.6.25 #57

 Call Trace:
  [warn_on_slowpath+95/144] warn_on_slowpath+0x5f/0x90
  [device_pm_add+24/240] ? device_pm_add+0x18/0xf0
  [device_pm_add+108/240] device_pm_add+0x6c/0xf0
  [device_add+1092/1376] device_add+0x444/0x560
  [_end+510110570/2109230024] :mmc_core:mmc_add_card+0xa2/0x140
  [_end+510117927/2109230024] :mmc_core:mmc_attach_sd+0x17f/0x860
  [_end+510109176/2109230024] ? :mmc_core:mmc_rescan+0x0/0x1c0
  [_end+510109545/2109230024] :mmc_core:mmc_rescan+0x171/0x1c0
  [run_workqueue+246/560] run_workqueue+0xf6/0x230
  [worker_thread+167/288] worker_thread+0xa7/0x120
  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
  [worker_thread+0/288] ? worker_thread+0x0/0x120
  [kthread+73/144] kthread+0x49/0x90
  [child_rip+10/18] child_rip+0xa/0x12
  [restore_args+0/48] ? restore_args+0x0/0x30
  [kthread+0/144] ? kthread+0x0/0x90
  [child_rip+0/18] ? child_rip+0x0/0x12

 ---[ end trace ca143223eefdc828 ]---
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
 IP: [klist_del+29/128] klist_del+0x1d/0x80
 PGD 0
 Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
 CPU 0
 Modules linked in: tda18271 nls_iso8859_2 nls_cp852 vfat fat i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc
binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput kvm_intel kvm
snd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq arc4
snd_seq_device snd_pcm_oss ecb crypto_blkcipher cryptomgr
crypto_algapi iwl3945 snd_mixer_oss mac80211 snd_pcm mmc_block video
sdhci thinkpad_acpi mmc_core i2c_i801 snd_timer rtc_cmos rtc_core
backlight iTCO_wdt cfg80211 evdev snd i2c_core e1000e psmouse
soundcore snd_page_alloc nvram intel_agp rtc_lib iTCO_vendor_support
output serio_raw ac battery button uhci_hcd ohci_hcd ehci_hcd usbcore
[last unloaded: microcode]
 Pid: 1240, comm: kmmcd Not tainted 2.6.25 #57
 RIP: 0010:[klist_del+29/128]  [klist_del+29/128] klist_del+0x1d/0x80
 RSP: 0000:ffff81007cabbd00  EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000003
 RDX: 0000000000000008 RSI: ffffffffa0102308 RDI: 0000000000000000
 RBP: ffff81007cabbd20 R08: 0000000000000001 R09: 0000000000000000
 R10: 0000000000000001 R11: ffff81007c9a6d10 R12: ffff81007c517530
 R13: ffffffffa0102260 R14: ffff81007cabbdf0 R15: ffff81007c5175a8
 FS:  0000000000000000(0000) GS:ffffffff8148c000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000050 CR3: 0000000001001000 CR4: 00000000000026e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kmmcd (pid: 1240, threadinfo ffff81007caba000, task ffff81007cac0000)
 Stack:  ffff81007cabbd10 0000000000000050 ffff81007c5173f8 ffffffffa0102260
  ffff81007cabbd50 ffffffff812012fe ffff81007cabbd50 ffff81007c5173f8
  00000000fffffff0 ffff81007c5175f0 ffff81007cabbdb0 ffffffff8120016e
 Call Trace:
  [bus_remove_device+158/208] bus_remove_device+0x9e/0xd0
  [device_add+1358/1376] device_add+0x54e/0x560
  [_end+510110570/2109230024] :mmc_core:mmc_add_card+0xa2/0x140
hald[2531]: forcibly attempting to lazy unmount /dev/mmcblk0p1 as
enclosing drive was disconnected
  [_end+510117927/2109230024] :mmc_core:mmc_attach_sd+0x17f/0x860
  [_end+510109176/2109230024] ? :mmc_core:mmc_rescan+0x0/0x1c0
  [_end+510109545/2109230024] :mmc_core:mmc_rescan+0x171/0x1c0
  [run_workqueue+246/560] run_workqueue+0xf6/0x230
  [worker_thread+167/288] worker_thread+0xa7/0x120
  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
  [worker_thread+0/288] ? worker_thread+0x0/0x120
  [kthread+73/144] kthread+0x49/0x90
  [child_rip+10/18] child_rip+0xa/0x12
  [restore_args+0/48] ? restore_args+0x0/0x30
  [kthread+0/144] ? kthread+0x0/0x90
  [child_rip+0/18] ? child_rip+0x0/0x12


 Code: 8b 28 41 0f 95 c7 eb 87 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec
20 4c 89 65 f0 48 89 5d e8 4c 89 6d f8 49 89 fc 48 8b 1f 48 89 df <4c>
8b 6b 50 e8 9a 40 01 00 49 8d 7c 24 18 48 c7 c6 20 a4 2d 81
 RIP  [klist_del+29/128] klist_del+0x1d/0x80
  RSP <ffff81007cabbd00>
 CR2: 0000000000000050
 ---[ end trace ca143223eefdc828 ]---
