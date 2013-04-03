From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Wed, 03 Apr 2013 12:52:06 +0400
Message-ID: <87li90q9mx.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org> <87r4isd1vn.fsf@openvz.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36702 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab3DCIwM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 04:52:12 -0400
In-Reply-To: <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Tue, 2 Apr 2013 16:22:41 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> On Wed, 3 Apr 2013 at 02:05, Dmitry Monakhov wrote:
> > Please drop that patch and collect logs with a kernel which 
> > has only 0001-enable-ES_AGGRESSIVE_TEST-V2.patch patch applied
Ok I have found at least one issue.
Please give a try to this patch

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=ext4_zeroout_cpu2disk_fix.patch

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1530cf4..e8460f6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3272,7 +3272,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		if (err)
 			goto out;
 		zero_ex.ee_block = ex->ee_block;
-		zero_ex.ee_len = ext4_ext_get_actual_len(ex);
+		zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ext));
 		ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
 
 		err = ext4_ext_get_access(handle, inode, path + depth);

--=-=-=


> 
> I've applied (only) 0001-enable-ES_AGGRESSIVE_TEST-V2.patch to 3.9-rc4:
> 
>   patching file fs/ext4/extents_status.h
>   patching file fs/ext4/inode.c
>   Hunk #1 succeeded at 1588 (offset 42 lines).
>   Hunk #2 succeeded at 1609 (offset 42 lines).
> 
> And tried to download some images via bittorrent. As expected, lots of 
> "ES cache assertation failed" were being logged:
> 
>  http://nerdbynature.de/bits/3.9.0-rc4/ext4/
>  => messages_0001-enable-ES_AGGRESSIVE_TEST-V2.txt.xz
> 
> I've tried to download 3 files, all via bittorrent (so, fallocate & heavy 
> mmap)
> 
> 1) 8GB Fedora iso, there are also WARNINGs bring triggered, see below.
>    I decided to cancel the download after some gigabyes.
> 
> 2) A 50 MB Debian iso, this produced just one "ES cache assertation" 
>    message. Download went OK, checksum was correct too.
> 
> 3) A 221 MB Fedora iso, produced a couple of "ES cache assertation" 
>    messages, but no WARNINGs. Download went OK, checksum was correct too.
> 
> It's all in that messages_0001-enable-ES_AGGRESSIVE_TEST-V2.txt.xz file 
> above. I just e2fsck'ed the ext4 filesystem again (and did so last night), 
> but no errors were found.
> 
> HTH,
> Christian.
> 
> One of the WARNINGs during that 8GB download:
> 
>     ino:39190654 lbkl:0, b_state=0x0004b988, b_size=4131
>  ------------[ cut here ]------------
>  WARNING: at /opt/linux-git/fs/ext4/inode.c:1600
>  Modules linked in: md5 ecb nfs i2c_powermac therm_adt746x ecryptfs firewire_sbp2 arc4 b43 usb_storage mac80211 cfg80211
>  NIP: c013745c LR: c013745c CTR: c000df9c
>  REGS: edc479a0 TRAP: 0700   Tainted: G        W     (3.9.0-rc4-dirty)
>  MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 44028644  XER: 20000000
>  TASK = edca9740[4379] 'flush-254:1' THREAD: edc46000
>  GPR00: c013745c edc47a50 edca9740 00000034 edca9db0 00000006 00000000 00008000
>  GPR08: 00003fb0 00218f23 00000000 c000006e 00000dc9 00000000 00000009 ee18cca0
>  GPR16: edc47c78 0000000e 0004b9bf 0004b988 00000000 edc47a84 00001000 e6357540
>  GPR24: edc47b78 e6357540 00000000 0004b97f 00000000 0051d188 00000000 0004b988
>  NIP [c013745c] mpage_da_submit_io+0x3dc/0x3f0
>  LR [c013745c] mpage_da_submit_io+0x3dc/0x3f0
>  Call Trace:
>  [edc47a50] [c013745c] mpage_da_submit_io+0x3dc/0x3f0 (unreliable)
>  [edc47b30] [c013c9f0] mpage_da_map_and_submit+0x16c/0x5f0
>  [edc47bc0] [c013d2e4] write_cache_pages_da+0x470/0x480
>  [edc47c70] [c013d554] ext4_da_writepages+0x260/0x49c
>  [edc47d20] [c00eeea0] __writeback_single_inode+0x34/0x120
>  [edc47d40] [c00ef508] writeback_sb_inodes+0x1fc/0x34c
>  [edc47db0] [c00ef6e4] __writeback_inodes_wb+0x8c/0xd0
>  [edc47de0] [c00efa90] wb_writeback+0x1b4/0x1bc
>  [edc47e20] [c00f06d0] wb_do_writeback+0x1ec/0x1f4
>  [edc47e80] [c00f0748] bdi_writeback_thread+0x70/0x140
>  [edc47eb0] [c0051c18] kthread+0xa8/0xac
>  [edc47f40] [c00106cc] ret_from_kernel_thread+0x64/0x6c
>  --- Exception: 0 at   (null)
>      LR =   (null)
>  Instruction dump:
> 
> -- 
> BOFH excuse #61:
> 
> not approved by the FCC

--=-=-=--
