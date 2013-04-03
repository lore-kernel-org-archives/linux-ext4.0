From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Wed, 03 Apr 2013 15:02:49 +0400
Message-ID: <87eherri5i.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org> <87r4isd1vn.fsf@openvz.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org> <87li90q9mx.fsf@openvz.org> <87hajoq6s2.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34575 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3DCLCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 07:02:55 -0400
In-Reply-To: <87hajoq6s2.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 03 Apr 2013 13:53:49 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
Non-text part: multipart/mixed
> On Wed, 03 Apr 2013 12:52:06 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Non-text part: multipart/mixed
> > On Tue, 2 Apr 2013 16:22:41 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> > > On Wed, 3 Apr 2013 at 02:05, Dmitry Monakhov wrote:
> > > > Please drop that patch and collect logs with a kernel which 
> > > > has only 0001-enable-ES_AGGRESSIVE_TEST-V2.patch patch applied
Good news big endian cpu owners
Please try following patches(second is most important):
http://patchwork.ozlabs.org/patch/233396/
http://patchwork.ozlabs.org/patch/233397/
I hope this should fix all known issues
> > Ok I have found at least one issue.
> Yeah.. My college advise me to use sparse in order to spot all
> cpu_to_ondisk format conversion
> make C=2 CF="-D__CHECK_ENDIAN__" fs/ext4/ 
> And it spotted a huge amount of issues. Which tell us that we are deeply
> in shit.
> <stdin>:1220:2: warning: #warning syscall kcmp not implemented
> <stdin>:1223:2: warning: #warning syscall finit_module not implemented
> fs/ext4/ialloc.c:902:37: warning: symbol 'sbi' shadows an earlier one
> fs/ext4/ialloc.c:650:29: originally declared here
> fs/ext4/inode.c:58:17: warning: incorrect type in assignment (different base types)
> fs/ext4/inode.c:58:17:    expected unsigned short [unsigned] [usertype] csum_lo
> fs/ext4/inode.c:58:17:    got restricted __le16 [usertype] l_i_checksum_lo
> fs/ext4/inode.c:62:25: warning: incorrect type in assignment (different base types)
> fs/ext4/inode.c:62:25:    expected unsigned short [unsigned] [usertype] csum_hi
> fs/ext4/inode.c:62:25:    got restricted __le16 [usertype] i_checksum_hi
> fs/ext4/inode.c:69:28: warning: incorrect type in assignment (different base types)
> fs/ext4/inode.c:69:28:    expected restricted __le16 [usertype] l_i_checksum_lo
> fs/ext4/inode.c:69:28:    got unsigned short [unsigned] [usertype] csum_lo
> fs/ext4/inode.c:72:36: warning: incorrect type in assignment (different base types)
> fs/ext4/inode.c:72:36:    expected restricted __le16 [usertype] i_checksum_hi
> fs/ext4/inode.c:72:36:    got unsigned short [unsigned] [usertype] csum_hi
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> fs/ext4/ioctl.c:358:36: warning: symbol 'sb' shadows an earlier one
> fs/ext4/ioctl.c:26:28: originally declared here
> fs/ext4/namei.c:2008:36: warning: potentially expensive pointer subtraction
> fs/ext4/namei.c:423:18: warning: incorrect type in assignment (different base types)
> fs/ext4/namei.c:423:18:    expected unsigned int [unsigned] [usertype] old_csum
> fs/ext4/namei.c:423:18:    got restricted __le32 [usertype] dt_checksum
> fs/ext4/namei.c:427:24: warning: incorrect type in assignment (different base types)
> fs/ext4/namei.c:427:24:    expected restricted __le32 [usertype] dt_checksum
> fs/ext4/namei.c:427:24:    got unsigned int [unsigned] [usertype] old_csum
> include/trace/events/ext4.h:1926:1: warning: cast from restricted __le32
> include/trace/events/ext4.h:1926:1: warning: incorrect type in assignment (different base types)
> include/trace/events/ext4.h:1926:1:    expected unsigned int [unsigned] [usertype] ee_lblk
> include/trace/events/ext4.h:1926:1:    got restricted __le32 [usertype] <noident>
> include/trace/events/ext4.h:1926:1: warning: cast from restricted __le32
> include/trace/events/ext4.h:1926:1: warning: incorrect type in assignment (different base types)
> include/trace/events/ext4.h:1926:1:    expected unsigned int [unsigned] [usertype] ee_lblk
> include/trace/events/ext4.h:1926:1:    got restricted __le32 [usertype] <noident>
> fs/ext4/super.c:1957:26: warning: incorrect type in assignment (different base types)
> fs/ext4/super.c:1957:26:    expected unsigned short [unsigned] [usertype] old_csum
> fs/ext4/super.c:1957:26:    got restricted __le16 [usertype] bg_checksum
> fs/ext4/super.c:1963:34: warning: incorrect type in assignment (different base types)
> fs/ext4/super.c:1963:34:    expected restricted __le16 [usertype] bg_checksum
> fs/ext4/super.c:1963:34:    got unsigned short [unsigned] [usertype] old_csum
> include/uapi/linux/swab.h:60:16: error: undefined identifier '__builtin_bswap32'
> include/uapi/linux/swab.h:60:33: error: not a function <noident>
> fs/ext4/extents.c:3002:48: warning: incorrect type in assignment (different base types)
> fs/ext4/extents.c:3002:48:    expected restricted __le16 [assigned] [usertype] ee_len
> fs/ext4/extents.c:3002:48:    got restricted __be16 [usertype] <noident>
> fs/ext4/extents.c:3008:48: warning: incorrect type in assignment (different base types)
> fs/ext4/extents.c:3008:48:    expected restricted __le16 [addressable] [assigned] [usertype] ee_len
> fs/ext4/extents.c:3008:48:    got restricted __be16 [usertype] <noident>
> fs/ext4/extents.c:3015:40: warning: incorrect type in assignment (different base types)
> fs/ext4/extents.c:3015:40:    expected restricted __le16 [addressable] [assigned] [usertype] ee_len
> fs/ext4/extents.c:3015:40:    got restricted __be16 [usertype] <noident>
> fs/ext4/extents.c:603:28: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:671:28: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:849:43: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:984:47: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:1063:50: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:1656:52: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:1706:32: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:1929:43: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:2206:55: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:2528:72: warning: potentially expensive pointer subtraction
> fs/ext4/extents.c:2787:36: warning: incorrect type in argument 5 (different base types)
> fs/ext4/extents.c:2787:36:    expected unsigned short [unsigned] eh_entries
> fs/ext4/extents.c:2787:36:    got restricted __le16 [usertype] eh_entries
> fs/ext4/extents.c:3275:32: warning: incorrect type in assignment (different base types)
> fs/ext4/extents.c:3275:32:    expected restricted __le16 [assigned] [usertype] ee_len
> fs/ext4/extents.c:3275:32:    got restricted __be16 [usertype] <noident>
> fs/ext4/extents.c:4642:34: warning: cast from restricted __le16
> fs/ext4/extents.c:4642:34: warning: incorrect type in argument 1 (different base types)
> fs/ext4/extents.c:4642:34:    expected unsigned short [unsigned] [usertype] val
> fs/ext4/extents.c:4642:34:    got restricted __le16 [usertype] eh_entries
> fs/ext4/extents.c:4642:34: warning: cast from restricted __le16
> fs/ext4/extents.c:4642:34: warning: cast from restricted __le16
> fs/ext4/extents.c:4642:34: warning: restricted __be16 degrades to integer
> fs/ext4/mballoc.c:863:21: warning: symbol 'group' shadows an earlier one
> fs/ext4/mballoc.c:795:35: originally declared here
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> fs/ext4/mballoc.c:4855:9: warning: context imbalance in 'ext4_trim_extent' - unexpected unlock
> fs/ext4/move_extent.c:859:29: warning: symbol 'err' shadows an earlier one
> fs/ext4/move_extent.c:835:16: originally declared here
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> fs/ext4/mmp.c:18:16: warning: incorrect type in return expression (different base types)
> fs/ext4/mmp.c:18:16:    expected unsigned int
> fs/ext4/mmp.c:18:16:    got restricted __le32 [usertype] <noident>
> fs/ext4/mmp.c:27:19: warning: restricted __le32 degrades to integer
> fs/ext4/mmp.c:36:27: warning: incorrect type in assignment (different base types)
> fs/ext4/mmp.c:36:27:    expected restricted __le32 [usertype] mmp_checksum
> fs/ext4/mmp.c:36:27:    got unsigned int
> fs/ext4/indirect.c:579:41: warning: potentially expensive pointer subtraction
> fs/ext4/indirect.c:592:52: warning: potentially expensive pointer subtraction
> fs/ext4/indirect.c:1257:68: warning: potentially expensive pointer subtraction
> fs/ext4/indirect.c:1268:67: warning: potentially expensive pointer subtraction
> fs/ext4/indirect.c:1275:48: warning: potentially expensive pointer subtraction
> fs/ext4/indirect.c:1327:52: warning: incorrect type in argument 2 (different base types)
> fs/ext4/indirect.c:1327:52:    expected unsigned long [unsigned] [usertype] block
> fs/ext4/indirect.c:1327:52:    got restricted __le32 [assigned] [usertype] blk
> fs/ext4/indirect.c:1329:33: warning: incorrect type in argument 4 (different base types)
> fs/ext4/indirect.c:1329:33:    expected unsigned long long [unsigned] [usertype] <noident>
> fs/ext4/indirect.c:1329:33:    got restricted __le32 [assigned] [usertype] blk
> fs/ext4/xattr.c:127:13: warning: incorrect type in assignment (different base types)
> fs/ext4/xattr.c:127:13:    expected unsigned int [unsigned] [usertype] old
> fs/ext4/xattr.c:127:13:    got restricted __le32 [usertype] h_checksum
> fs/ext4/xattr.c:129:18: warning: incorrect type in assignment (different base types)
> fs/ext4/xattr.c:129:18:    expected unsigned long [unsigned] [usertype] block_nr
> fs/ext4/xattr.c:129:18:    got restricted __le64 [usertype] <noident>
> fs/ext4/xattr.c:135:25: warning: incorrect type in assignment (different base types)
> fs/ext4/xattr.c:135:25:    expected restricted __le32 [usertype] h_checksum
> fs/ext4/xattr.c:135:25:    got unsigned int [unsigned] [usertype] old
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> include/linux/mm.h:759:16: warning: potentially expensive pointer subtraction
> So please give me couple of hours and I'll send you a complete patch.
> 
> 
> > Please give a try to this patch
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 1530cf4..e8460f6 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3272,7 +3272,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >  		if (err)
> >  			goto out;
> >  		zero_ex.ee_block = ex->ee_block;
> > -		zero_ex.ee_len = ext4_ext_get_actual_len(ex);
> > +		zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ext));
> >  		ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
> >  
> >  		err = ext4_ext_get_access(handle, inode, path + depth);
> > 
> > > 
> > > I've applied (only) 0001-enable-ES_AGGRESSIVE_TEST-V2.patch to 3.9-rc4:
> > > 
> > >   patching file fs/ext4/extents_status.h
> > >   patching file fs/ext4/inode.c
> > >   Hunk #1 succeeded at 1588 (offset 42 lines).
> > >   Hunk #2 succeeded at 1609 (offset 42 lines).
> > > 
> > > And tried to download some images via bittorrent. As expected, lots of 
> > > "ES cache assertation failed" were being logged:
> > > 
> > >  http://nerdbynature.de/bits/3.9.0-rc4/ext4/
> > >  => messages_0001-enable-ES_AGGRESSIVE_TEST-V2.txt.xz
> > > 
> > > I've tried to download 3 files, all via bittorrent (so, fallocate & heavy 
> > > mmap)
> > > 
> > > 1) 8GB Fedora iso, there are also WARNINGs bring triggered, see below.
> > >    I decided to cancel the download after some gigabyes.
> > > 
> > > 2) A 50 MB Debian iso, this produced just one "ES cache assertation" 
> > >    message. Download went OK, checksum was correct too.
> > > 
> > > 3) A 221 MB Fedora iso, produced a couple of "ES cache assertation" 
> > >    messages, but no WARNINGs. Download went OK, checksum was correct too.
> > > 
> > > It's all in that messages_0001-enable-ES_AGGRESSIVE_TEST-V2.txt.xz file 
> > > above. I just e2fsck'ed the ext4 filesystem again (and did so last night), 
> > > but no errors were found.
> > > 
> > > HTH,
> > > Christian.
> > > 
> > > One of the WARNINGs during that 8GB download:
> > > 
> > >     ino:39190654 lbkl:0, b_state=0x0004b988, b_size=4131
> > >  ------------[ cut here ]------------
> > >  WARNING: at /opt/linux-git/fs/ext4/inode.c:1600
> > >  Modules linked in: md5 ecb nfs i2c_powermac therm_adt746x ecryptfs firewire_sbp2 arc4 b43 usb_storage mac80211 cfg80211
> > >  NIP: c013745c LR: c013745c CTR: c000df9c
> > >  REGS: edc479a0 TRAP: 0700   Tainted: G        W     (3.9.0-rc4-dirty)
> > >  MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 44028644  XER: 20000000
> > >  TASK = edca9740[4379] 'flush-254:1' THREAD: edc46000
> > >  GPR00: c013745c edc47a50 edca9740 00000034 edca9db0 00000006 00000000 00008000
> > >  GPR08: 00003fb0 00218f23 00000000 c000006e 00000dc9 00000000 00000009 ee18cca0
> > >  GPR16: edc47c78 0000000e 0004b9bf 0004b988 00000000 edc47a84 00001000 e6357540
> > >  GPR24: edc47b78 e6357540 00000000 0004b97f 00000000 0051d188 00000000 0004b988
> > >  NIP [c013745c] mpage_da_submit_io+0x3dc/0x3f0
> > >  LR [c013745c] mpage_da_submit_io+0x3dc/0x3f0
> > >  Call Trace:
> > >  [edc47a50] [c013745c] mpage_da_submit_io+0x3dc/0x3f0 (unreliable)
> > >  [edc47b30] [c013c9f0] mpage_da_map_and_submit+0x16c/0x5f0
> > >  [edc47bc0] [c013d2e4] write_cache_pages_da+0x470/0x480
> > >  [edc47c70] [c013d554] ext4_da_writepages+0x260/0x49c
> > >  [edc47d20] [c00eeea0] __writeback_single_inode+0x34/0x120
> > >  [edc47d40] [c00ef508] writeback_sb_inodes+0x1fc/0x34c
> > >  [edc47db0] [c00ef6e4] __writeback_inodes_wb+0x8c/0xd0
> > >  [edc47de0] [c00efa90] wb_writeback+0x1b4/0x1bc
> > >  [edc47e20] [c00f06d0] wb_do_writeback+0x1ec/0x1f4
> > >  [edc47e80] [c00f0748] bdi_writeback_thread+0x70/0x140
> > >  [edc47eb0] [c0051c18] kthread+0xa8/0xac
> > >  [edc47f40] [c00106cc] ret_from_kernel_thread+0x64/0x6c
> > >  --- Exception: 0 at   (null)
> > >      LR =   (null)
> > >  Instruction dump:
> > > 
> > > -- 
> > > BOFH excuse #61:
> > > 
> > > not approved by the FCC
