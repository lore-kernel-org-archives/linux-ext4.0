From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Thu, 18 Sep 2014 21:29:37 +0200
Message-ID: <541B32A1.3080706@profihost.ag>
References: <541AD93A.70203@profihost.ag> <20140918192131.GD19520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140918192131.GD19520@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Am 18.09.2014 21:21, schrieb Theodore Ts'o:
> On Thu, Sep 18, 2014 at 03:08:10PM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi List,
>>
>> I'm seeing this error pretty often at a vanilla 3.10.53 kernel.
>>
>> Can anybody point me to a patch or tell me if this is a known bug?
>
> This is just call trace; can you send the complete set of kernel
> messages?  Please send  everything starting a few lines before the
>
> ---------------- [ cut here ] ----------
>
> line, and then going all the way to the
>
> ----------- [ end trace XXXXXXXXXX ] --------


Sorry but whole output is:
2014-09-18 02:30:34     0000000000000000 ffff881021663b20 
ffff881021663b08 ffffffffa02d66b3
2014-09-18 02:30:34     Call Trace:
2014-09-18 02:30:34     [<ffffffffa0311e56>] ext4_es_lru_add+0x26/0x80 
[ext4]
2014-09-18 02:30:34     [<ffffffffa0311f41>] 
ext4_es_lookup_extent+0x91/0x190 [ext4]
2014-09-18 02:30:34     [<ffffffffa02d66b3>] ext4_map_blocks+0x43/0x450 
[ext4]
2014-09-18 02:30:34     [<ffffffffa02d8167>] _ext4_get_block+0x87/0x190 
[ext4]
2014-09-18 02:30:34     [<ffffffffa02d82c6>] ext4_get_block+0x16/0x20 [ext4]
2014-09-18 02:30:34     [<ffffffff8117f63f>] generic_block_bmap+0x3f/0x50
2014-09-18 02:30:34     [<ffffffffa017e4ae>] ? 
jbd2_journal_file_buffer+0x4e/0x80 [jbd2]
2014-09-18 02:30:34     [<ffffffff810f6242>] ? mapping_tagged+0x12/0x20
2014-09-18 02:30:34     [<ffffffffa02d5d71>] ext4_bmap+0x91/0xf0 [ext4]
2014-09-18 02:30:34     [<ffffffff8116866e>] bmap+0x1e/0x30
2014-09-18 02:30:34     [<ffffffffa0187043>] jbd2_journal_bmap+0x33/0xb0 
[jbd2]
2014-09-18 02:30:34     [<ffffffffa01872fd>] 
jbd2_journal_next_log_block+0x7d/0x90 [jbd2]
2014-09-18 02:30:34     [<ffffffffa017f238>] 
jbd2_journal_commit_transaction+0x7f8/0x1ae0 [jbd2]
2014-09-18 02:30:34     [<ffffffff81084e03>] ? idle_balance+0xd3/0x110
2014-09-18 02:30:34     [<ffffffff8105a008>] ? 
lock_timer_base.isra.35+0x38/0x70
2014-09-18 02:30:34     [<ffffffffa018491a>] kjournald2+0xba/0x230 [jbd2]
2014-09-18 02:30:34     [<ffffffff81070350>] ? finish_wait+0x80/0x80
2014-09-18 02:30:34     [<ffffffffa0184860>] ? 
jbd2_journal_release_jbd_inode+0x130/0x130 [jbd2]
2014-09-18 02:30:34     [<ffffffff8106fb50>] kthread+0xc0/0xd0
2014-09-18 02:30:34     [<ffffffff8106fa90>] ? 
kthread_create_on_node+0x130/0x130
2014-09-18 02:30:34     [<ffffffff815548ec>] ret_from_fork+0x7c/0xb0
2014-09-18 02:30:34     [<ffffffff8106fa90>] ? 
kthread_create_on_node+0x130/0x130
2014-09-18 02:30:34     Code: 84 00 00 00 00 00 66 66 66 66 90 55 48 89 
e5 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0e 0f 1f 40 00 
f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 90 90 90 90 66 66 66 66 90 55 48 
89 e5 53
2014-09-18 02:30:34     BUG: soft lockup - CPU#1 stuck for 23s! 
[jbd2/sdb1-8:1795]
2014-09-18 02:30:34     Modules linked in: nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_owner ipt_REJECT 
xt_multiport mpt2sas raid_class iptable_filter ip_tables x_tables 
cpufreq_userspace cpufreq_powersave cpufreq_conservative 
cpufreq_ondemand 8021q garp ext4 crc16 jbd2 mbcache ext2 mperf usbhid 
coretemp kvm_intel kvm crc32_pclmul ehci_pci ghash_clmulni_intel sb_edac 
ehci_hcd edac_core microcode usbcore i2c_i801 usb_common button 
netconsole sg sd_mod igb i2c_algo_bit isci i2c_core libsas ahci ptp 
libahci scsi_transport_sas pps_core megaraid_sas
2014-09-18 02:30:34     CPU: 1 PID: 1795 Comm: jbd2/sdb1-8 Not tainted 
3.10.53+85-ph #1
2014-09-18 02:30:34     Hardware name: XX
2014-09-18 02:30:34     task: ffff881020d90000 ti: ffff881021662000 
task.ti: ffff881021662000
2014-09-18 02:30:34     RIP: 0010:[<ffffffff81553cb5>] 
[<ffffffff81553cb5>] _raw_spin_lock+0x25/0x30
2014-09-18 02:30:34     RSP: 0018:ffff881021663a38 EFLAGS: 00000297
2014-09-18 02:30:34     RAX: 000000000000c7a2 RBX: ffff881020800310 RCX: 
0000000000000000
2014-09-18 02:30:34     RDX: 000000000000c7a3 RSI: 00000000000046b6 RDI: 
ffff8810265c9440
2014-09-18 02:30:34     RBP: ffff881021663a38 R08: ffffffffa02d82b0 R09: 
ffffea001d48dd40
2014-09-18 02:30:34     R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000020
2014-09-18 02:30:34     R13: 000000000000c79f R14: 0000000000000000 R15: 
ffff88107fc359c0
2014-09-18 02:30:34     FS: 0000000000000000(0000) 
GS:ffff88107fc20000(0000) knlGS:0000000000000000
2014-09-18 02:30:34     CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2014-09-18 02:30:34     CR2: 000000000509d700 CR3: 0000000001a0b000 CR4: 
00000000000407e0
2014-09-18 02:30:34     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
2014-09-18 02:30:34     DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400Stack:
2014-09-18 02:30:34     ffff881021663a58 ffffffffa0311e56 
00000000000046b6 ffff8810208000b0
2014-09-18 02:30:34     ffff881021663a88 ffffffffa0311f41 
ffff8810208000b0 0000000000000000


Stefan

>
> line.
>
> Cheers,
>
> 				- Ted
>
