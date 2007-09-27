From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: kernel Oops in ext3 code
Date: Thu, 27 Sep 2007 14:18:23 -0700
Message-ID: <1190927903.3872.12.camel@localhost.localdomain>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: preining@debian.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59374 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbXI0VSX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2007 17:18:23 -0400
In-Reply-To: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
Could you please sent the objdump of the ext4_discard_reservation
function? It doesn't match what I see here.

Thanks,
Mingming

On Thu, 2007-09-27 at 12:31 +0200, linux-ext4-owner@vger.kernel.org
wrote:
> Hi all!
> 
> (Please Cc)
> 
> kernel 2.6.23-rc6
> Debian/sid
> 
> kernel ooops:
> 
> BUG: unable to handle kernel paging request at virtual address 1000004b
>  printing eip:
>  c0195bd3
>  *pde = 00000000
>  Oops: 0000 [#1]
>  PREEMPT SMP 
>  Modules linked in: vboxdrv binfmt_misc fuse coretemp hwmon gspca videodev v4l2_common v4l1_compat iwl3945 mac80211 tifm_7xx1 tifm_core joydev irda crc_ccitt 8250_pnp 8250 serial_core firewire_ohci firewire_core crc_itu_t
>  CPU:    0
>  EIP:    0060:[<c0195bd3>]    Not tainted VLI
>  EFLAGS: 00010206   (2.6.23-rc6 #1)
>  EIP is at ext3_discard_reservation+0x18/0x4d
>  eax: dff23800   ebx: 10000033   ecx: dfc15ec0   edx: ffffffff
>  esi: c0007c44   edi: 10000033   ebp: dfc2bef4   esp: dfc2beac
>  ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
>  Process kswapd0 (pid: 261, ti=dfc2a000 task=dfcac570 task.ti=dfc2a000)
>  Stack: c0007ba4 c0007c44 10000033 c019ec51 c0007c44 c0007d8c 0000002c c0171b1b 
>         0000002c c0007c44 c0007c4c c0171da2 c050880c 00000000 00000080 00000080 
>         c0171fb8 00000080 c0007e48 df9e3910 00007404 c03f5634 00000080 000000d0 
>  Call Trace:
>   [<c019ec51>] ext3_clear_inode+0x5d/0x76
>   [<c0171b1b>] clear_inode+0x6b/0xb9
>   [<c0171da2>] dispose_list+0x48/0xc9
>   [<c0171fb8>] shrink_icache_memory+0x195/0x1bd
>   [<c014f5ec>] shrink_slab+0xe2/0x159
>   [<c014f9a0>] kswapd+0x2d3/0x431
>   [<c0132520>] autoremove_wake_function+0x0/0x33
>   [<c014f6cd>] kswapd+0x0/0x431
>   [<c0132453>] kthread+0x38/0x5d
>   [<c013241b>] kthread+0x0/0x5d
>   [<c0104b73>] kernel_thread_helper+0x7/0x10
>   =======================
>  Code: 83 f8 01 19 c0 f7 d0 83 e0 08 89 42 0c 89 56 b4 5b 5e c3 57 56 89 c6 53 8b 58 b4 8b 80 a4 00 00 00 85 db 8b 80 78 01 00 00 74 30 <83> 7b 18 00 74 2a 8d b8 00 03 00 00 89 f8 e8 b8 ca 1a 00 83 7b 
>  EIP: [<c0195bd3>] ext3_discard_reservation+0x18/0x4d SS:ESP 0068:dfc2beac
> 
> 
> Sysrq did work, so the oops was saved. Good.
> 
> Any ideas?
> 
> Best wishes
> 
> Norbert
> 
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> As he came into the light they could see his black and
> gold uniform on which the buttons were so highly polished
> that they shone with an intensity that would have made an
> approaching motorist flash his lights in annoyance.
>                  --- Douglas Adams, The Hitchhikers Guide to the Galaxy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
