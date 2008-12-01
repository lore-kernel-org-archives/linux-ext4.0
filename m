From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: BUG: scheduling while atomic: kswapd0/273/0x00000002
Date: Mon, 1 Dec 2008 20:56:56 +0530
Message-ID: <20081201152656.GB25876@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:44702 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYLAPek (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 10:34:40 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id mB1FY96Q5349452
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 02:34:09 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1FR9uB267412
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 02:27:09 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB1FR8CN008256
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 02:27:08 +1100
Received: from skywalker ([9.77.199.175])
	by d23av01.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id mB1FQvLW008093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 02:27:07 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

With the latest patch queue i am getting the below error

-aneesh


BUG: scheduling while atomic: kswapd0/273/0x00000002
1 lock held by kswapd0/273:
 #0:  (&ei->client_lock){----}, at: [<c04a014f>] blkdev_releasepage+0x27/0x5a
Modules linked in: autofs4 hidp rfkill input_polldev sbs sbshc battery ac parport_pc lp parport i6300esb i2c_i801 i2c_core tg3 libphy e752x_edac edac_core qla2xxx scsi_transport_fc dm_multipath dm_mirror dm_region_hash dm_log dm_mod loop xt_tcpudp ip6t_REJECT ipv6 ipt_REJECT x_tables sunrpc rfcomm bnep l2cap bluetooth bridge stp sg rtc_cmos rtc_core rtc_lib pcspkr button ata_piix libata mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: ip_tables]
Pid: 273, comm: kswapd0 Not tainted 2.6.28-rc6-autotest #1
Call Trace:
 [<c0426277>] __schedule_bug+0x5e/0x65
 [<c067d302>] schedule+0x85/0x7db
 [<c04454d6>] ? mark_held_locks+0x49/0x64
 [<c0445650>] ? trace_hardirqs_on_caller+0xe0/0x101
 [<c044567c>] ? trace_hardirqs_on+0xb/0xd
 [<c067fdc8>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c043b548>] ? prepare_to_wait+0x3f/0x45
 [<c04e65dc>] jbd2_log_wait_commit+0x8e/0xd8
 [<c043b405>] ? autoremove_wake_function+0x0/0x33
 [<c04e2ca1>] jbd2_journal_try_to_free_buffers+0x175/0x185
 [<c04c71d2>] ext4_release_metadata+0x54/0x66
 [<c04c717e>] ? ext4_release_metadata+0x0/0x66
 [<c04a0166>] blkdev_releasepage+0x3e/0x5a
 [<c045e987>] try_to_release_page+0x32/0x3f
 [<c0467c5c>] shrink_page_list+0x436/0x57e
 [<c044349b>] ? put_lock_stats+0xd/0x21
 [<c044353c>] ? lock_release_holdtime+0x8d/0x93
 [<c067fe00>] ? _spin_unlock_irq+0x22/0x42
 [<c0445650>] ? trace_hardirqs_on_caller+0xe0/0x101
 [<c0467f8e>] shrink_list+0x1ea/0x47c
 [<c044349b>] ? put_lock_stats+0xd/0x21
 [<c0468432>] shrink_zone+0x212/0x27f
 [<c0468f5b>] kswapd+0x341/0x4c6
 [<c0466cc5>] ? isolate_pages_global+0x0/0x18c
 [<c043b405>] ? autoremove_wake_function+0x0/0x33
 [<c0468c1a>] ? kswapd+0x0/0x4c6
 [<c043b344>] kthread+0x3b/0x63
 [<c043b309>] ? kthread+0x0/0x63
 [<c04048f3>] kernel_thread_helper+0x7/0x10
BUG: scheduling while atomic: kswapd0/273/0x0000000
