From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 crashes on nfs server
Date: Thu, 19 Jan 2012 09:25:39 -0600
Message-ID: <4F1835F3.9060604@redhat.com>
References: <OF2380C53F.32FE8350-ONC125798A.00494E7A@aschendorff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: muellejo@aschendorff.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab2ASPZn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jan 2012 10:25:43 -0500
In-Reply-To: <OF2380C53F.32FE8350-ONC125798A.00494E7A@aschendorff.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/19/12 7:20 AM, muellejo@aschendorff.de wrote:
> Hello,
> 
> Unfortunately there is no ext4-users list so please excuse that I am asking here.
> We run a nfs server on Debian 6.03. Squeeze 2.6.32-5-amd64 and export an ext4 filesystem.

Asking here is fine.

> We are see high iowait (up to 99%) and the system hangs. 
> This is from /var/log/messages but that all means nothing to me:

Looks like an oops/panic/BUG - but are you sure you didn't start copying a line or two too late?
I think there should be a bit more information just before this.
Something blew up in __ext4_get_inode_loc but it'd be nice to know what, that should have been in the lines previous.

-Eric

> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.508990] PGD 7c2d6067 PUD ba109067 PMD 0 
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.510799] CPU 0 
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.511415] Modules linked in: vmsync vmmemctl vmhgfs nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc ext4 jbd2 crc16 ext2 loop snd_pcm snd_timer snd soundcore snd_page_alloc i2c_piix4 parport_pc vmci psmouse evdev pcspkr i2c_core parport serio_raw shpchp pci_h
> otplug processor container ac button ext3 jbd mbcache dm_mod sd_mod crc_t10dif sg mptspi sr_mod cdrom mptscsih ata_generic mptbase scsi_transport_spi ata_piix libata thermal floppy vmxnet3 thermal_sys scsi_mod [last unloaded: scsi_wait_scan]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.515426] Pid: 1082, comm: nfsd Not tainted 2.6.32-5-amd64 #1 VMware Virtual Platform
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.516292] RIP: 0010:[<ffffffffa020776f>]  [<ffffffffa020776f>] __ext4_get_inode_loc+0x43/0x32e [ext4]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.517191] RSP: 0018:ffff88013da45bd0  EFLAGS: 00010297
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.518086] RAX: ffff8800718d9ba8 RBX: 0000000000000001 RCX: ffff8800a18ed1c0
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.519011] RDX: 0000000000000000 RSI: ffff88013da45c80 RDI: ffff8800718d9ba8
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.519949] RBP: ffff88013da45c80 R08: ffff88013da45ca0 R09: ffff88013da45ca0
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.520887] R10: ffff880078d34870 R11: ffff8801390ed0a8 R12: ffff8801390ed0a8
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.521837] R13: 0000000000000000 R14: ffff8801390ed0a8 R15: 0000000000000000
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.522794] FS:  0000000000000000(0000) GS:ffff880005200000(0000) knlGS:0000000000000000
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.523771] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.524743] CR2: 0000000000000290 CR3: 000000004f8dc000 CR4: 00000000000006f0
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.525829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.526874] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.527870] Process nfsd (pid: 1082, threadinfo ffff88013da44000, task ffff88013c2d8e20)
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.529915]  ffff8801390ed0a8 ffff8800144907e0 ffffffffa0232e70 ffff8801390ed0a8
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.529960] <0> ffff88013da45c80 ffff8800718d9ba8 ffff880135cacc20 0000000000000000
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.531030] <0> ffff8800a18ed1c0 0000000000000000 ffff88013da45c80 ffff8801390ed0a8
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.534289]  [<ffffffffa0207b78>] ? ext4_reserve_inode_write+0x1e/0x73 [ext4]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.535441]  [<ffffffffa0210a83>] ? ext4_orphan_del+0x118/0x1af [ext4]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.536587]  [<ffffffffa020d430>] ? ext4_delete_inode+0x199/0x21d [ext4]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.537760]  [<ffffffffa020d297>] ? ext4_delete_inode+0x0/0x21d [ext4]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.538920]  [<ffffffff81100654>] ? generic_delete_inode+0xdc/0x168
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.540084]  [<ffffffff810fcf7f>] ? d_kill+0x40/0x61
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.541268]  [<ffffffff810feb5e>] ? dput+0x152/0x15e
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.542442]  [<ffffffffa03363b2>] ? nfsd_rename+0x320/0x378 [nfsd]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.543646]  [<ffffffffa033d1cb>] ? nfsd3_proc_rename+0xd5/0xe6 [nfsd]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.544842]  [<ffffffffa0332329>] ? nfsd_dispatch+0xdd/0x1b9 [nfsd]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.546060]  [<ffffffffa02694ff>] ? svc_process+0x403/0x627 [sunrpc]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.547272]  [<ffffffffa0332772>] ? nfsd+0x0/0x12e [nfsd]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.548491]  [<ffffffffa0332857>] ? nfsd+0xe5/0x12e [nfsd]
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.549713]  [<ffffffff81064a5d>] ? kthread+0x79/0x81
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.550931]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.552164]  [<ffffffff810649e4>] ? kthread+0x0/0x81
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.553399]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.558507]  RSP <ffff88013da45bd0>
> Jan 18 21:32:06 ez-nfs-prod-vm1 kernel: [17289.563646] ---[ end trace 6434bec49a00291a ]---
> 
> Can somebody please give a hint it this is more an nfs or an ext4 issue ?
> 
> 
> Thanks a lot
> jom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

