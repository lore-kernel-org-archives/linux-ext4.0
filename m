From: Nick Bowler <nbowler@elliptictech.com>
Subject: OOPS after deleting file on ext4 filesystem
Date: Tue, 23 Oct 2012 20:50:22 -0400
Message-ID: <20121024005022.GA25399@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.scalarmail.ca ([98.158.95.75]:9857 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2JXCWB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 22:22:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

I just saw an ext4 oops on one of my machines after a couple months of
uptime, on Linux 3.5.2.  I doubt I will be able to reproduce the problem
easily so I'm just posting this in case anyone can tell what's going on.

Going by the timing, and the call trace, it is presumably related to the
fact that I had rm'd a ~12G file shortly before the last log entry.  The
filesystem is aged somewhat and close to full (hence why I was deleting
the file in the first place).  However, I'm not certain of the *exact*
timeline because I didn't notice that the system had crashed until the
next day.

In case it matters, fs recovery after resetting the box resulted in
hundreds of messages like:

   EXT4-fs (md127): ext4_orphan_cleanup: deleting unreferenced inode 12058658

I took a photo of the oops text that was on screen and posted it here:

  http://i.imgur.com/7DfIP.jpg

For convenience (and the benefit of list archives), I've transcribed the
oops, but I could have easily fat-fingered something so the only the
photo is authoritative.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa007b332>] ext4_ext_remove_space+0x725/0x9db [ext4]
PGD 1043f067 PUD 1078f067 PMD 0
Oops: 0000 [#1] PREEMPT
CPU 0
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage nls_utf8 isofs it87 hwmon_vid sha1_generic hmac aes_generic cbc cts crypto_blkcipher cryptomgr aead nfs nfsd exportfs lockd bridge stp ipv6 llc iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables ext2 snd_pcm_oss snd_mixer_oss snd_emu10k1_synth snd_emux_synth snd_seq_midi_emul snd_seq_virmidi snd_seq_midi_event snd_seq rpcsec_gss_krb5 auth_rpcgss sunrpc tun raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx sg firewire_sbp2 loop snd_emu10k1 sr_mod snd_hwdep snd_util_mem snd_ac97_codec ac9_bus snd_rawmidi snd_seq_device snd_pcm snd_page_alloc snd_timer snd ftdi_sio cdrom epic100 firewire_ohci emu10k1_gp firewire_core gameport crc_itu_t soundcore forcede
 th k8temp usbserial mii powernow_k8 floppy pata_amd mperf evdev i2c_nforce2 ext4 crc16 jbd2 crypto_hash crypto_algapi crypto mbcache raid1 md_mod

Pid: 13628, comm: rm Not tainted 3.5.2 #107 ASUSTek Computer Inc. K8N-E-Deluxe/'K8N-E-Deluxe'
RIP: 0010:[<ffffffffa007b332>]  [<ffffffffa007b332>] ext4_ext_remove_space+0x725/0x9db [ext4]
RSP: 0018:ffff8800105cfca8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88006d5db5f0 RCX: 0000000000000002
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00000000073f313e
RBP: ffff8800105cfd88 R08: 00000000073f313e R09: 00000000000003e8
R10: 0000160000000000 R11: ffff88007b930180 R12: ffff8800588e4d68
R13: ffff88004d002000 R14: ffff88006d5db5c0 R15: 0000000000000000
FS:  00007f1e400b8700(0000) GS:ffffffff81623000(0000) knlGS:00000000f757a6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000007c6ec000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 13628, threadinfo ffff8800105ce00, task ffff8800718e7230)
Stack:
 ffff88000133bde0 ffff8800588e4d68 ffff8800219d2300 ffff880017ebf3d8
 ffff8800105cfd50 0000000000000003 0000000004549000 ffff8800fffffff5
 ffffffff105cfd50 ffff88006d5db648 ffff8800588e4cc8 0000080080006a88
Call Trace:
 [<ffffffffa007cd29>] ext4_ext_truncate+0xcd/0x173 [ext4]
 [<ffffffffa006875a>] ? ext4_mark_inode_dirty+0x13e/0x168 [ext4]
 [<ffffffffa0066417>] ext4_truncate+0x46/0x51 [ext4]
 [<ffffffffa006a0d2>] ext4_evict_inode+0x276/0x363 [ext4]
 [<ffffffffa0069e5c>] ? ext4_da_writepages+0x423/0x423 [ext4]
 [<ffffffff810a4b70>] evict+0xb6/0x182
 [<ffffffff810a51dd>] iput+0x1fb/0x203
 [<ffffffff8109b526>] do_unlinkat+0x10b/0x161
 [<ffffffff8109c762>] sys_unlinkat+0x24/0x26
 [<ffffffff8132ff64>] system_call_fastpath+0x1a/0x1f
Code: e1 ff ff 48 63 5d bc 48 6b db 30 48 03 5d b0 e9 f1 00 00 00 48 63 55 bc 48 6b da 30 48 03 5d b0 48 83 7b 20 00 75 0c 48 8b 43 28 <48> 8b 40 28 48 89 43 20 48 8b 43 18 48 85 c0 75 1f 48 8b 43 20
RIP  [<ffffffffa007b332>] ext4_ext_remove_space+0x725/0x9db [ext4]
 RSP <ffff8800105cfca8>
CR2: 0000000000000028

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
