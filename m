From: Alex <alex.vizor@gmail.com>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Sun, 27 Nov 2011 23:24:03 +0300
Message-ID: <4ED29C63.8070601@gmail.com>
References: <4ED2994A.9080907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1K0UYL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2011 15:24:11 -0500
Received: by bke11 with SMTP id 11so7471408bke.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Nov 2011 12:24:10 -0800 (PST)
In-Reply-To: <4ED2994A.9080907@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

BTW, after last resume from disk fs was corrupted but fsck managed to 
fix this error. So I think severity of this issue should be raised.

On 11/27/2011 11:10 PM, Alex wrote:
> Hi guys,
>
> I'm using linux kernel 3.2-rc3. Since bugzilla.kernel.org is in down 
> I'm writing this email. After resuming from s2disk I get following error:
> Nov 27 19:42:38 alex kernel: [ 3827.422675] ------------[ cut here 
> ]------------
> Nov 27 19:42:38 alex kernel: [ 3827.422683] WARNING: at fs/inode.c:884 
> unlock_new_inode+0x34/0x59()
> Nov 27 19:42:38 alex kernel: [ 3827.422686] Hardware name: 4170CTO
> Nov 27 19:42:38 alex kernel: [ 3827.422688] Modules linked in: vfat 
> fat usb_storage uas cpufreq_stats rfcomm lockd 8021q garp stp llc
>  fcoe libfcoe libfc scsi_transport_fc scsi_tgt bnep ip6t_REJECT 
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntr
> ack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack hdaps(O) 
> snd_hda_codec_hdmi snd_hda_codec_conexant virtio_net kvm_intel kvm 
> snd_hda_int
> el snd_hda_codec btusb snd_hwdep snd_seq snd_seq_device snd_pcm 
> snd_timer arc4 iwlwifi mac80211 cfg80211 wmi e1000e uvcvideo videodev
>  media v4l2_compat_ioctl32 bluetooth uinput pcspkr joydev 
> thinkpad_acpi snd snd_page_alloc soundcore i2c_i801 iTCO_wdt 
> iTCO_vendor_su
> pport rfkill binfmt_misc microcode sunrpc tp_smapi(O) thinkpad_ec(O) 
> sdhci_pci sdhci mmc_core [last unloaded: scsi_wait_scan]
> Nov 27 19:42:38 alex kernel: [ 3827.422738] Pid: 968, comm: abrtd 
> Tainted: G        W  O 3.2.0-0.rc3.git0.1.fc16.x86_64 #1
> Nov 27 19:42:38 alex kernel: [ 3827.422740] Call Trace:
> Nov 27 19:42:38 alex kernel: [ 3827.422744]  [<ffffffff810589c2>] 
> warn_slowpath_common+0x83/0x9b
> Nov 27 19:42:38 alex kernel: [ 3827.422747]  [<ffffffff810589f4>] 
> warn_slowpath_null+0x1a/0x1c
> Nov 27 19:42:38 alex kernel: [ 3827.422750]  [<ffffffff8113de44>] 
> unlock_new_inode+0x34/0x59
> Nov 27 19:42:38 alex kernel: [ 3827.422754]  [<ffffffff8118b6b8>] 
> ext4_new_inode+0xbc6/0xc5b
> Nov 27 19:42:38 alex kernel: [ 3827.422758]  [<ffffffff81196ca1>] 
> ext4_symlink+0x14d/0x2f4
> Nov 27 19:42:38 alex kernel: [ 3827.422762]  [<ffffffff8113592b>] 
> vfs_symlink+0x54/0x74
> Nov 27 19:42:38 alex kernel: [ 3827.422766]  [<ffffffff811356a1>] ? 
> user_path_create+0x4d/0x57
> Nov 27 19:42:38 alex kernel: [ 3827.422769]  [<ffffffff811371b8>] 
> sys_symlinkat+0x6b/0xb2
> Nov 27 19:42:38 alex kernel: [ 3827.422773]  [<ffffffff81137215>] 
> sys_symlink+0x16/0x18
> Nov 27 19:42:38 alex kernel: [ 3827.422777]  [<ffffffff81526042>] 
> system_call_fastpath+0x16/0x1b
> Nov 27 19:42:38 alex kernel: [ 3827.422780] ---[ end trace 
> 9866b4286b488fd4 ]---
>
> Kernel config is attached. Please let me know if I can help you with 
> anything to fix this issue
>
> Best regards,
> Alex

