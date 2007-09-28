From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: kernel Oops in ext3 code
Date: Fri, 28 Sep 2007 11:00:49 -0700
Message-ID: <1191002449.3815.9.camel@localhost.localdomain>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
	 <1190927903.3872.12.camel@localhost.localdomain>
	 <20070928045456.GM23215@gamma.logic.tuwien.ac.at>
	 <1190991464.10145.0.camel@dyn9047017100.beaverton.ibm.com>
	 <20070928150031.GF27873@gamma.logic.tuwien.ac.at>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38942 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbXI1SAw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Sep 2007 14:00:52 -0400
In-Reply-To: <20070928150031.GF27873@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
On Fri, 2007-09-28 at 17:00 +0200, Norbert Preining wrote: 
> On Fr, 28 Sep 2007, Badari Pulavarty wrote:
> > objdump -DlS balloc.o 
> 
> Here it is
> 

Thanks

Looks like kernel oops at 1753(173b+0x18):

0000173b <ext3_discard_reservation>:
ext3_discard_reservation():
    173b:       57                      push   %edi
    173c:       56                      push   %esi
    173d:       89 c6                   mov    %eax,%esi
    173f:       53                      push   %ebx
    1740:       8b 58 b4                mov    -0x4c(%eax),%ebx
    1743:       8b 80 a4 00 00 00       mov    0xa4(%eax),%eax
    1749:       85 db                   test   %ebx,%ebx
    174b:       8b 80 78 01 00 00       mov    0x178(%eax),%eax
    1751:       74 30                   je     1783
<ext3_discard_reservation+0x48>
    1753:       83 7b 18 00             cmpl   $0x0,0x18(%ebx)

==========================> Kernel oops here, ebx=10000033, match bad
page location 1000004b(=10000033+0x18)


    1757:       74 2a                   je     1783
<ext3_discard_reservation+0x48>
    1759:       8d b8 00 03 00 00       lea    0x300(%eax),%edi
    175f:       89 f8                   mov    %edi,%eax
    1761:       e8 fc ff ff ff          call   1762
<ext3_discard_reservation+0x27>
    1766:       83 7b 18 00             cmpl   $0x0,0x18(%ebx)
    176a:       74 0d                   je     1779
<ext3_discard_reservation+0x3e>
    176c:       8b 86 a4 00 00 00       mov    0xa4(%esi),%eax
    1772:       89 da                   mov    %ebx,%edx
    1774:       e8 dc eb ff ff          call   355 <rsv_window_remove>
    1779:       89 f8                   mov    %edi,%eax
    177b:       5b                      pop    %ebx
    177c:       5e                      pop    %esi
    177d:       5f                      pop    %edi
    177e:       e9 fc ff ff ff          jmp    177f
<ext3_discard_reservation+0x44>
    1783:       5b                      pop    %ebx
    1784:       5e                      pop    %esi
    1785:       5f                      pop    %edi
    1786:       c3                      ret


And trying to matching to the code:

void ext3_discard_reservation(struct inode *inode)
{
        struct ext3_inode_info *ei = EXT3_I(inode);
        struct ext3_block_alloc_info *block_i = ei->i_block_alloc_info;
        struct ext3_reserve_window_node *rsv;
        spinlock_t *rsv_lock = &EXT3_SB(inode->i_sb)->s_rsv_window_lock;

        if (!block_i)
                return;

        rsv = &block_i->rsv_window_node;
        if (!rsv_is_empty(&rsv->rsv_window)) {

=================================> kernel oops here

                spin_lock(rsv_lock);
                if (!rsv_is_empty(&rsv->rsv_window))
                        rsv_window_remove(inode->i_sb, rsv);
                spin_unlock(rsv_lock);
        }
}


It seems ebx points to block_i(i_block_alloc_info), and that is bad
memory location, so that leads to bad paging request when try to get the
rsv_window structure. 

But it confused me why the rsv_window offset is 0x18 to
i_block_alloc_info, it should be 0x14(20 bytes)...Are you running a
vanilla 2.6.23-rc6?

No clue how i_block_alloc_info pointing to a bad location for now.
ext3_alloc_inode() clearly init this field to NULL, and
ext3_clear_inode() clearly set this field to NULL. So during the
lifecycle of the inode, i_block_alloc_info should point to a valid
address or being NULL.

And the stack trace indicating the oops happened when pushing the inode
from the cache, so racing is not a issue there. Possible random memory
corruption?

Mingming


Mingming
