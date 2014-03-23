From: Jan Kara <jack@suse.cz>
Subject: Re: Consistent kernel oops with 3.11.10 & 3.12.9 on Haswell CPUs...
Date: Sun, 23 Mar 2014 14:25:35 +0100
Message-ID: <20140323132535.GE2813@quack.suse.cz>
References: <20140318184909.GA26255@ofan>
 <Pine.LNX.4.64.1403192239560.5202@axis700.grange>
 <20140322123706.GE12444@ofan>
 <alpine.DEB.2.02.1403221415380.18573@ionos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: dafreedm@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403221415380.18573@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 22-03-14 14:18:39, Thomas Gleixner wrote:
> On Sat, 22 Mar 2014, dafreedm@gmail.com wrote:
> 
> > Ahh.  Good call.  I wasn't sophisticated enough with these things to
> > ascertain the difference.  I knew to avoid reporting oops/panics with
> > kernels tainted with out-of-tree (non-free) modules, but I guess I
> > grabbed the wrong lines from the dmesg (namely, subsequent oops after
> > the initial one).  Here's a more recent kernel oops (from this
> > morning) --- it's the first oops after a fresh reboot:
> 
> Cc'ing ext4 and block folks.
  Hum, so decodecode shows:
...
  26:	48 85 c0             	test   %rax,%rax
  29:	74 10                	je     0x3b
  2b:*	0f b7 80 ac 05 00 00 	movzwl 0x5ac(%rax),%eax		<--
trapping instruction
  32:	66 85 c0             	test   %ax,%ax
...

  And the register has:
RAX: f7ff880037267140 RBX: 0000000000001000 RCX: 0000000000000000

  So that looks like a bitbflip the upper byte. So I'd check the hardware
first...

								Honza

> > [33488.170415] general protection fault: 0000 [#1] SMP 
> > [33488.171351] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realtek snd_hda_codec_hdmi hid_kensington x86_pkg_temp_thermal coretemp joydev kvm_intel hid_generic kvm crct10dif_pclmul snd_hda_intel crc32_pclmul crc32c_intel snd_hda_codec usbhid snd_hwdep hid ghash_clmulni_intel snd_pcm iTCO_wdt iTCO_vendor_support snd_page_alloc aesni_intel i915 snd_seq aes_x86_64 snd_seq_device snd_timer lrw evdev gf128mul glue_helper drm_kms_helper ablk_helper snd psmouse cryptd drm i2c_i801 pcspkr soundcore serio_raw lpc_ich mei_me mei mfd_core video button processor ext4 
 crc16 mbcache jbd2 sg sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd ehci_pci ehci_hcd e1000e libata igb scsi_mod i2c_algo_bit i2c_core dca ptp pps_core fan usbcore usb_common thermal therma
>  l_sys
> > [33488.177102] CPU: 0 PID: 340 Comm: jbd2/sdd2-8 Not tainted 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
> > [33488.178100] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/2013
> > [33488.179095] task: ffff88081b179080 ti: ffff88081b3ee000 task.ti: ffff88081b3ee000
> > [33488.180102] RIP: 0010:[<ffffffff811b6b22>]  [<ffffffff811b6b22>] __getblk+0x52/0x2c0
> > [33488.181117] RSP: 0018:ffff88081b3efb78  EFLAGS: 00010282
> > [33488.182127] RAX: f7ff880037267140 RBX: 0000000000001000 RCX: 0000000000000000
> > [33488.183142] RDX: 00000000000001ff RSI: 000000000148b2ac RDI: 0000000000000000
> > [33488.184152] RBP: ffff88081b2a4800 R08: 0000000000000000 R09: ffff8807eccca628
> > [33488.185168] R10: 00000000000032ad R11: 0000000000000001 R12: 0000000000000000
> > [33488.186182] R13: ffff88081bcf67c0 R14: 00000000532d22fd R15: 000000000148b2ac
> > [33488.187194] FS:  0000000000000000(0000) GS:ffff88083fa00000(0000) knlGS:0000000000000000
> > [33488.188212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [33488.189228] CR2: ffffffffff600400 CR3: 000000000180c000 CR4: 00000000001407f0
> > [33488.190245] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [33488.191268] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [33488.192279] Stack:
> > [33488.193273]  0000000000000000 ffffffffa01ec1ba ffff88081b179080 ffff88081b2a4800
> > [33488.194276]  00000000000032ac 0000000000000000 ffff88081b2a4800 ffff88081b2a4800
> > [33488.195265]  ffff8807f36b4688 00000000532d22fd 00000000ffffffff ffffffffa01737d0
> > [33488.196246] Call Trace:
> > [33488.197222]  [<ffffffffa01ec1ba>] ? ext4_bmap+0x5a/0x110 [ext4]
> > [33488.198210]  [<ffffffffa01737d0>] ? jbd2_journal_get_descriptor_buffer+0x30/0x80 [jbd2]
> > [33488.199203]  [<ffffffff811b5100>] ? __wait_on_buffer+0x30/0x30
> > [33488.200196]  [<ffffffffa016aedd>] ? journal_submit_commit_record.isra.12+0x9d/0x200 [jbd2]
> > [33488.201193]  [<ffffffff811b5100>] ? __wait_on_buffer+0x30/0x30
> > [33488.202198]  [<ffffffffa016c1f4>] ? jbd2_journal_commit_transaction+0x11b4/0x18c0 [jbd2]
> > [33488.203211]  [<ffffffffa01706cc>] ? kjournald2+0xac/0x240 [jbd2]
> > [33488.204219]  [<ffffffff81082d20>] ? add_wait_queue+0x60/0x60
> > [33488.205226]  [<ffffffffa0170620>] ? commit_timeout+0x10/0x10 [jbd2]
> > [33488.206230]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
> > [33488.207230]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
> > [33488.208231]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
> > [33488.209224]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
> > [33488.210205] Code: 12 48 83 c4 28 4c 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8b 85 98 00 00 00 ba ff 01 00 00 48 8b 80 58 03 00 00 48 85 c0 74 10 <0f> b7 80 ac 05 00 00 66 85 c0 0f 85 cd 01 00 00 85 da 0f 85 d2 
> > [33488.212277] RIP  [<ffffffff811b6b22>] __getblk+0x52/0x2c0
> > [33488.213276]  RSP <ffff88081b3efb78>
> > [33488.370823] ---[ end trace cf90c18d45ff9570 ]---
> > 
> > 
> > Thoughts?
> > 
> > Ingo, Peter, Thomas, any further ideas, please?
> > 
> > 
> > > > Though at times the oops occur even when the system is largely idle,
> > > > they seem to be exacerbated by md5sum'ing all files on a large
> > > > partition as part of archive verification --- say 1 million files
> > > > corresponding to 1 TByte of storage.  If I perform this repeatedly,
> > > > the machines seem to lock up about once a week.  Strangely, other
> > > > typical high-load/high-stress scenarios don't seem to provoke the oops
> > > > nearly so much (see below).
> > > > 
> > > > Naturally, such md5sum usage is putting heavy load on the processor,
> > > > memory, and even power supply, and my initial inclination is generally
> > > > that I must have some faulty components.  Even after otherwise
> > > > ambiguous diagnostics (described below), I'm highly skeptical that
> > > > there's anything here inherent to the md5sum codebase, in particular.
> > > > However, I have started to wonder whether this might be a kernel
> > > > regression...
> > > > 
> > > > For reference, here's my setup:
> > > > 
> > > >   Mainboard:  Supermicro X10SLQ
> > > >   Processor:  (Single-Socket) Intel Haswell i7-4770S (65W max TDP)
> > > >   Memory:     32GB Kingston DDR3 RAM (4x KVR16N11/8)
> > > >   PSU:        SeaSonic SS-400FL2 400W PSU
> > > >   O/S:        Debian v7.4 Wheezy (amd64)
> > > >   Filesystem: Ext4 (with default settings upon creation) over LUKS
> > > >   Kernel:     Using both:
> > > >                 Linux 3.11.10 ('3.11-0.bpo.2-amd64' via wheezy-backports)
> > > >                 Linux 3.12.9 ('3.12-0.bpo.2-amd64' via wheezy-backports)
> > > > 
> > > > To summarize where I am now: I've been very extensively testing all of
> > > > the likely culprits among hardware components on both of my servers
> > > > --- running memtest86 upon boot for 3+ days, memtester in userspace
> > > > for 24 hours, repeated kernel compiles with various '-j' values, and
> > > > the 'stress' and 'stressapptest' load generators (see [2] for full
> > > > details) --- and I have never seen even a hiccup in server operation
> > > > under such "artificial" environments --- however, it consistently
> > > > occurs with heavy md5sum operation, and randomly at other times.
> > > > 
> > > > At least from my past experiences (with scientific HPC clusters), such
> > > > diagnostic results would normally seem to largely rule out most
> > > > problems with the processor, memory, mainboard subsystems.  The PSU is
> > > > often a little harder to rule out, but the 400W Seasonic PSUs are
> > > > rated at 2--3 times the wattage I should really need, even under peak
> > > > load (given each server's single-socket CPU is 65W at max TDP, there
> > > > are only a few HDs and one SSD, and no discrete graphics at all, of
> > > > course).
> > > > 
> > > > I'm further surprised to see the exact same kernel-crash behavior on
> > > > two separate, but identical, servers, which leads me to wonder if
> > > > there's possibly some regression between the hardware (given that it's
> > > > relatively new Haswell microcode / silicon) and the (kernel?)
> > > > software.
> > > > 
> > > > Any thoughts on what might be occurring here?  Or what I should focus
> > > > on?  Thanks in advance.
> > 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
