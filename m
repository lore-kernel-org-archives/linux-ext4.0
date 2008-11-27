From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Crash with 2.6.28-rc6
Date: Thu, 27 Nov 2008 22:41:51 +0100
Message-ID: <200811272241.51926.rjw@sisk.pl>
References: <2DB7D81DBD004B64A5EF08CF13DB04A6@Seven>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Ben Castricum" <lk0811@bencastricum.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:56668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbYK0Vmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Nov 2008 16:42:35 -0500
In-Reply-To: <2DB7D81DBD004B64A5EF08CF13DB04A6@Seven>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks like an ext3 issue, adding CCs.

On Thursday, 27 of November 2008, you wrote:
> 
> My computer was unresponsive yesterday and had to ask my to wife reset the 
> server. The only thing I could find in the logs is below. Judging from the 
> timestamp it was caused by the daily logrotate. The logfiles are moved from 
> an ext3 to an ext4 filesystem. This is probably not enough for a decent bug 
> report but I thought I report it anyway, even if it is just for statistics.
> 
> my .config can be found at http://www.bencastricum.nl/.config
> 
> Kind regards,
> Ben
> 
> Nov 26 00:00:03 gateway kernel: last sysfs file: 
> /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-3/3-002e/in0_input
> Nov 26 00:00:03 gateway kernel: Modules linked in: ipt_MASQUERADE ipt_REJECT 
> ipt_LOG xt_recent xt_tcpudp xt_state iptable_filter nf_conntrack_ftp 
> iptable_na
> t ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 
> af_packet 8139too mii usb_storage tg3 libphy cdc_acm uhci_hcd ehci_hcd 
> usbcore lm8
> 5 hwmon_vid hwmon i2c_i801 softdog rtc ext4 jbd2 crc16 [last unloaded: 
> firmware_class]
> Nov 26 00:00:03 gateway kernel:
> Nov 26 00:00:03 gateway kernel: Pid: 14430, comm: mv Not tainted 
> (2.6.28-rc6-00007-ged31348 #143) HP d530 SFF(PL110ES)
> Nov 26 00:00:03 gateway kernel: EIP: 0060:[<b01a82ee>] EFLAGS: 00010287 CPU: 
> 1
> Nov 26 00:00:03 gateway kernel: EIP is at journal_start+0x39/0xb9
> Nov 26 00:00:04 gateway kernel: EAX: ef37dc00 EBX: c65fd518 ECX: ef356a00 
> EDX: ef356800
> Nov 26 00:00:04 gateway kernel: ESI: c65fd518 EDI: 0000000a EBP: e3ababc0 
> ESP: e3ababac
> Nov 26 00:00:04 gateway kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 
> 0068
> Nov 26 00:00:04 gateway kernel: Process mv (pid: 14430, ti=e3aba000 
> task=ddf57390 task.ti=e3aba000)
> Nov 26 00:00:04 gateway kernel: Stack:
> Nov 26 00:00:04 gateway kernel:  00000012 ef356800 b29b19a4 b29b19ac 
> 0000000a e3ababc8 b01a4b71 e3ababd8
> Nov 26 00:00:04 gateway kernel:  b01a4d63 b29b19a4 b29b19ac e3ababe0 
> b0189b68 e3ababf0 b016fd0e 00000002
> Nov 26 00:00:04 gateway kernel:  b29b19a4 e3abac08 b016fdc0 e3abac18 
> e6fea788 00000000 00000080 e3abac2c
> Nov 26 00:00:04 gateway kernel: Call Trace:
> Nov 26 00:00:04 gateway kernel:  [<b01a4b71>] ? 
> ext3_journal_start_sb+0x40/0x42
> Nov 26 00:00:04 gateway kernel:  [<b01a4d63>] ? ext3_dquot_drop+0x2b/0x5f
> Nov 26 00:00:04 gateway kernel:  [<b0189b68>] ? vfs_dq_drop+0x38/0x3a
> Nov 26 00:00:04 gateway kernel:  [<b016fd0e>] ? clear_inode+0x4c/0xb0
> Nov 26 00:00:04 gateway kernel:  [<b016fdc0>] ? dispose_list+0x4e/0xda
> Nov 26 00:00:04 gateway kernel:  [<b016ffdd>] ? 
> shrink_icache_memory+0x191/0x1be
> Nov 26 00:00:04 gateway kernel:  [<b014db67>] ? shrink_slab+0xda/0x134
> Nov 26 00:00:04 gateway kernel:  [<b014e5cf>] ? 
> try_to_free_pages+0x20b/0x2c6
> Nov 26 00:00:04 gateway kernel:  [<b014c1f7>] ? 
> isolate_pages_global+0x0/0x1af
> Nov 26 00:00:04 gateway kernel:  [<b01494b5>] ? 
> __alloc_pages_internal+0x1fa/0x371
> Nov 26 00:00:04 gateway kernel:  [<b014520a>] ? __grab_cache_page+0x35/0x6d
> Nov 26 00:00:04 gateway kernel:  [<f00d72c6>] ? 
> ext4_da_write_begin+0x11f/0x1ef [ext4]
> Nov 26 00:00:04 gateway kernel:  [<b0145a89>] ? 
> generic_file_buffered_write+0xc9/0x212
> Nov 26 00:00:04 gateway kernel:  [<b0146004>] ? 
> __generic_file_aio_write_nolock+0x24a/0x272
> Nov 26 00:00:04 gateway kernel:  [<b0144a22>] ? file_read_actor+0x74/0xbf
> Nov 26 00:00:04 gateway kernel:  [<b0172d57>] ? mnt_drop_write+0x1d/0xd5
> Nov 26 00:00:04 gateway kernel:  [<b0146744>] ? 
> generic_file_aio_write+0x57/0xb4
> Nov 26 00:00:04 gateway kernel:  [<f00d3a2f>] ? ext4_file_write+0x99/0x10e 
> [ext4]
> Nov 26 00:00:04 gateway kernel:  [<b0161a04>] ? do_sync_write+0xab/0xe9
> Nov 26 00:00:04 gateway kernel:  [<b0131c22>] ? 
> autoremove_wake_function+0x0/0x33
> Nov 26 00:00:05 gateway kernel:  [<b02a016e>] ? schedule+0x6d8/0x6e8
> Nov 26 00:00:05 gateway kernel:  [<b0161a42>] ? do_sync_read+0x0/0xe9
> Nov 26 00:00:05 gateway kernel:  [<b0161959>] ? do_sync_write+0x0/0xe9
> Nov 26 00:00:05 gateway kernel:  [<b0162116>] ? vfs_write+0x7c/0xad
> Nov 26 00:00:05 gateway kernel:  [<b01621e0>] ? sys_write+0x3b/0x60
> Nov 26 00:00:05 gateway kernel:  [<b0103905>] ? sysenter_do_call+0x12/0x25
> Nov 26 00:00:05 gateway kernel: Code: ec 64 a1 00 70 3b b0 8b b0 00 04 00 00 
> bb e2 ff ff ff 83 7d f0 00 0f 84 86 00 00 00 89 f3 85 f6 74 12 8b 06 8b 55 
> f0 3
> 9 10 74 04 <0f> 0b eb fe ff 46 08 eb 6e ba 50 00 00 00 a1 40 ee 40 b0 e8 bf
> Nov 26 00:00:05 gateway kernel: EIP: [<b01a82ee>] journal_start+0x39/0xb9 
> SS:ESP 0068:e3ababac
> Nov 26 00:00:05 gateway kernel: ---[ end trace f93fb7e213015178 ]--- 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
