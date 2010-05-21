From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Fri, 21 May 2010 01:05:07 GMT
Message-ID: <201005210105.o4L157wo020900@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34944 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0EUBFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2010 21:05:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4L157So020901
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 21 May 2010 01:05:07 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906


Chuck Ebbert <cebbert@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cebbert@redhat.com




--- Comment #26 from Chuck Ebbert <cebbert@redhat.com>  2010-05-21 01:04:55 ---
(In reply to comment #18)
> Created an attachment (id=26255)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26255) [details]
> Explicitly pass in whether sb is pinned or not
> 

This patch is triggering a warning:

[ http://www.kerneloops.org/oops.php?number=3142224 ]

WARNING: at fs/fs-writeback.c:597 writeback_inodes_wb+0x229/0x380()
Hardware name: MS-7250
Modules linked in: fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 ext2 dm_multipath kvm_amd kvm uinput snd_hda_codec_atihdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device rndis_wlan snd_pcm cfg80211 snd_timer snd rfkill soundcore
snd_page_alloc rndis_host edac_core ppdev cdc_ether i2c_nforce2 usbnet k8temp
edac_mce_amd parport_pc forcedeth mii parport serio_raw sha256_generic
aes_x86_64 aes_generic cbc dm_crypt firewire_ohci pata_acpi firewire_core
crc_itu_t floppy ata_generic pata_amd sata_nv radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 1035, comm: flush-253:0 Not tainted 2.6.33.4-95.fc13.x86_64 #1
Call Trace:
[] warn_slowpath_common+0x77/0x8f
[] warn_slowpath_null+0xf/0x11
[] writeback_inodes_wb+0x229/0x380
[] wb_writeback+0x13d/0x1bc
[] ? call_rcu_sched+0x10/0x12
[] ? call_rcu+0x9/0xb
[] wb_do_writeback+0x69/0x14d
[] bdi_writeback_task+0x3a/0xaa
[] ? bdi_start_fn+0x0/0xd4
[] bdi_start_fn+0x6c/0xd4
[] ? bdi_start_fn+0x0/0xd4
[] kthread+0x7a/0x82
[] kernel_thread_helper+0x4/0x10
[] ? kthread+0x0/0x82
[] ? kernel_thread_helper+0x0/0x10

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
