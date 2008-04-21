From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 20:22:35 +0200
Message-ID: <200804212022.36817.rjw@sisk.pl>
References: <200804191522.54334.rjw@sisk.pl> <480CC9A4.9090503@gmail.com> <alpine.LFD.1.10.0804211030450.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Jiri Slaby <jirislaby@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:36122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbYDUSWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 14:22:37 -0400
In-Reply-To: <alpine.LFD.1.10.0804211030450.2779@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, 21 of April 2008, Linus Torvalds wrote:
> 
> On Mon, 21 Apr 2008, Jiri Slaby wrote:
> > 
> > BTW. I haven't see this without suspend/resume cycle, do you, Rafael? It
> > doesn't mean anything, since it needs longer time to trigger, but anyway, it
> > might be a clue.
> 
> There's a separate (and very different-looking) bug-report about the atl1 
> driver having problems when doing an "ifconfig down" on it. In fact, the 
> problem report says:
> 
> > With this commit in tree, I can reproduce either
> > a) kmalloc-2048 corruption after initscripts shutdown eth0
> >         http://marc.info/?l=linux-kernel&m=120820360221261&w=2
> > 
> > b) or oopses at filp_close() first reported long ago
> >         (sorry, can't find that email)
> 
> where that "or oopses at filp_close()" thing is somewhat interesting, 
> since your original bug was about something that looked like file pointer 
> corruption.
> 
> Now, I doubt you have an ATL chip, and I doubt the two are _really_ 
> related in any way (the ATL bug was actually triggered by enabling 64-bit 
> DMA), but the filp_close thing makes me go "hmm".
> 
> The two affected corrupted SLUB areas were the 2kB allocation (1560-byte 
> ethernet packets plus skb_shared_info overhead, anyone?) and apparently 
> the one that filp's are in (perhaps a 20-byte TCP ACK packet or other 
> "small" packet + the skb_shared_info overhead would be a common case that 
> might be in that 200-byte range?)
> 
> Maybe the ATL bug isn't ATL-specific at all, but somehow connected to 
> NETIF_F_HIGHDMA. Do you have 4GB+ of RAM?
> 
> And one thing that suspend/resume does, which is not necessarily commonly 
> done during normal operation, is that ifconfig down/up pattern. Maybe 
> there is something broken in general there?

Hm, that may be the case.

In fact, I've cut the messages that precede the oops from the dmesg output,
but they are from the b43 driver and the firewall (the full oops below is
reproduced for completness):

[12736.964336] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[12737.692435] b43-phy0 debug: Chip initialized
[12737.692659] b43-phy0 debug: 32-bit DMA initialized
[12742.213601] Registered led device: b43-phy0::tx
[12742.216372] Registered led device: b43-phy0::rx
[12742.216559] Registered led device: b43-phy0::radio
[12742.216587] b43-phy0 debug: Wireless interface started
[12737.724614] b43-phy0 ERROR: PHY transmission error
[12737.764440] b43-phy0 ERROR: PHY transmission error
[12738.469683] b43-phy0 debug: Switching to 2.4-GHz band
[12738.469755] b43-phy0 debug: Wireless interface stopped
[12738.469958] b43-phy0 debug: DMA-32 rx_ring: Used slots 0/64, Failed frames 0/0 = 0.0%, Average tries 0.00
[12738.470020] b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[12738.476448] b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[12738.484436] b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[12738.492433] b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 2/128, Failed frames 0/13 = 0.0%, Average tries 1.00
[12738.500433] b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[12738.668447] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[12739.892834] b43-phy0 debug: Chip initialized
[12739.893099] b43-phy0 debug: 32-bit DMA initialized
[12739.916479] Registered led device: b43-phy0::tx
[12739.919263] Registered led device: b43-phy0::rx
[12739.919329] Registered led device: b43-phy0::radio
[12739.919372] b43-phy0 debug: Wireless interface started
[12739.968824] wlan0: Initial auth_alg=0
[12739.968832] wlan0: authenticate with AP 00:17:9a:f3:b5:75
[12739.970261] wlan0: RX authentication from 00:17:9a:f3:b5:75 (alg=0 transaction=2 status=0)
[12739.970266] wlan0: authenticated
[12739.970269] wlan0: associate with AP 00:17:9a:f3:b5:75
[12739.972403] wlan0: RX AssocResp from 00:17:9a:f3:b5:75 (capab=0x431 status=0 aid=1)
[12739.972408] wlan0: associated
[12739.972420] wlan0: switched to short barker preamble (BSSID=00:17:9a:f3:b5:75)
[12739.972954] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[12750.001285] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12750.125294] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=368 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=348 
[12750.161238] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=254 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=234 
[12750.381280] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=368 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=348 
[12750.637329] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=368 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=348 
[12757.297378] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=180 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=160 
[12757.497389] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12757.553399] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=180 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=160 
[12757.809407] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=180 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=160 
[12757.997557] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=378 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=358 
[12766.069845] wlan0: no IPv6 routers present
[12777.783641] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12793.792438] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12817.529134] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12844.066757] BUG: unable to handle kernel paging request at ffffffffffffffff
[12844.066765] IP: [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.066775] PGD 203067 PUD 204067 PMD 0 
[12844.066778] Oops: 0000 [1] SMP DEBUG_PAGEALLOC
[12844.066782] CPU 1 
[12844.066784] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet rfkill_input snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter cpufreq_conservative ip6_tables x_tables cpufreq_ondemand cpufreq_userspace ipv6 cpufreq_powersave powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class rfcomm input_polldev l2cap fan ssb thermal pcmcia joydev snd_hda_intel snd_pcm rtc_cmos yenta_socket usbhid rtc_core hci_usb processor rsrc_nonstatic snd_timer shpchp psmouse i2c_piix4 sdhci ohci1394 battery pcmcia_core snd_page_alloc snd_hwdep tifm_7xx1 pci_hot
 plug serio_raw ide_cd_mod ac button i2c_core backlight output ieee1394 tifm_core mmc_core rtc_lib ff_memless bluetooth snd soundcore firmware_class k8temp cdrom tg3 sg ohci_hcd ehci_hcd usbcore edd ext3 jbd atiixp ide_core
[12844.066854] Pid: 13078, comm: kio_file Tainted: G   M     2.6.25 #401
[12844.066857] RIP: 0010:[<ffffffff802a7b3c>]  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.066861] RSP: 0018:ffff810064c5dc08  EFLAGS: 00010286
[12844.066863] RAX: ffffffffffffffff RBX: ffff8100f0bd7e10 RCX: 0000000000000012
[12844.066866] RDX: ffffffffffffffff RSI: ffff810064c5dd08 RDI: ffff810053304000
[12844.066868] RBP: ffff810064c5dc58 R08: 0000000000000003 R09: 0000000000000001
[12844.066871] R10: 0000000000000000 R11: 0000000000000246 R12: ffff810053304000
[12844.066873] R13: ffff810064c5dd08 R14: 000000005b3d8b1c R15: 000000000000001a
[12844.066876] FS:  00007f08e0719700(0000) GS:ffff81007782d480(0000) knlGS:0000000000000000
[12844.066879] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12844.066881] CR2: ffffffffffffffff CR3: 000000006a4f2000 CR4: 00000000000006a0
[12844.066884] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12844.066886] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12844.066889] Process kio_file (pid: 13078, threadinfo ffff810064c5c000, task ffff81005a8c8000)
[12844.066891] Stack:  ffff81000cdde000 000000000000001a ffff8100504a3000 000000000e310f76
[12844.066897]  ffffffffffffffff ffff810068c941c0 ffff810064c5de38 ffff8100533050c8
[12844.066901]  0000000000000000 ffff810064c5de38 ffff810064c5dca8 ffffffff8029e236
[12844.066905] Call Trace:
[12844.066919]  [<ffffffff8029e236>] do_lookup+0x2c/0x1b2
[12844.066930]  [<ffffffff802a04b4>] __link_path_walk+0x8e6/0xdbd
[12844.066955]  [<ffffffffa004deb4>] ? :ext3:ext3_xattr_get_acl_default+0x18/0x1a
[12844.066961]  [<ffffffff802b0869>] ? generic_getxattr+0x4e/0x5c
[12844.066973]  [<ffffffff802a09ec>] path_walk+0x61/0xc3
[12844.066981]  [<ffffffff802a0cd2>] do_path_lookup+0x15d/0x1d9
[12844.066991]  [<ffffffff802a161a>] __user_walk_fd+0x41/0x5c
[12844.067000]  [<ffffffff8029a252>] vfs_lstat_fd+0x24/0x5a
[12844.067007]  [<ffffffff8030b30d>] ? _atomic_dec_and_lock+0x3d/0x5c
[12844.067013]  [<ffffffff802abe02>] ? mntput_no_expire+0x20/0x8b
[12844.067019]  [<ffffffff8029dfe8>] ? path_put+0x2c/0x30
[12844.067021]  [<ffffffff802b128d>] ? sys_getxattr+0x60/0x75
[12844.067021]  [<ffffffff8029a2aa>] sys_newlstat+0x22/0x3c
[12844.067021]  [<ffffffff8020bf1b>] system_call_after_swapgs+0x7b/0x80
[12844.067021] 
[12844.067021] 
[12844.067021] Code: f6 43 04 10 75 06 f0 ff 03 48 89 d8 fe 43 08 eb 31 fe 43 08 48 8b 45 d0 48 8b 00 48 89 45 d0 48 8b 45 d0 48 85 c0 74 18 48 89 c2 <48> 8b 00 48 8d 5a e8 44 39 73 30 0f 18 08 75 d9 e9 6a ff ff ff 
[12844.067021] RIP  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.067021]  RSP <ffff810064c5dc08>
[12844.067021] CR2: ffffffffffffffff
[12844.067021] ---[ end trace 02645136ff144df9 ]---

Thanks,
Rafael
