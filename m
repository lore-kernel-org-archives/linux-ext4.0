From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstests results for 3.8 on Pandaboard ES (ARM)
Date: Sat, 23 Feb 2013 13:19:54 +0800
Message-ID: <5128517A.7000501@gmail.com>
References: <20130223000955.GA3231@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:59934 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3BWFUD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Feb 2013 00:20:03 -0500
Received: by mail-da0-f43.google.com with SMTP id u36so672771dak.2
        for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2013 21:20:02 -0800 (PST)
In-Reply-To: <20130223000955.GA3231@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

On 02/23/2013 08:09 AM, Eric Whitney wrote:
> Here are the results of a set of xfstests runs on a Pandaboard ES running a
> 3.8 kernel.  The test system was equipped with a USB-attached SATA HDD.  The
> test filesystems were located on the HDD.  The nine test scenarios were as
> defined by xfstests-bld.
> 
> The results I reported previously for 3.8-rc6 were for the tests in the
> xfstests "quick" group.  These results are for the "auto" group, which is
> rather larger. They agree well with a parallel run made on an x86-64 KVM
> guest, and with the exception of one broken xfstest (noted below), there's
> nothing obviously ARM-specific to report.
> 
> Regards,
> Eric
> 
> e2fsprogs (master, 1.43-WIP): fca8b1b241
> xfstests: e5f1a13792
> 
> FSTESTCFG=all
> FSTESTSET="-g auto"
> 
> BEGIN TEST: Ext4 4k block Thu Feb 21 12:56:03 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277
>  280 285 289 294
> Failures: 125 274
> END TEST: Ext4 4k block Thu Feb 21 15:40:44 EST 2013
> 
> Xfstest 125 failed because there's a bug in the test.  It defines O_DIRECT
> improperly for ARM (patch pending, and the test succeeds when patched).  This
> is the case for all following instances of 125 below as well.
> 
> 
> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Thu Feb 21
> 15:41:27 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 215
>  219 221 224 225 226 230 231 232 233 234 235 236 237 239 240 245 246 247 248
>  249 257 258 263 269 270 271 272 273 275 277 280 285 289 294
> Failures: 125 285
> END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Thu Feb 21
>  17:24:32 EST 2013
> 
> Xfstest 285 fails reliably for me on both ARM and x86-64 and only in this test
> scenario.  I see the same failure on 3.7, so it's not a regression (however,
> this failure doesn't appear in Ted's early 3.8-rc results).
> 
>     --- 285.out	2013-02-19 15:58:25.110665500 -0500
>     +++ 285.out.bad	2013-02-21 17:23:45.156519882 -0500
>     @@ -1 +1,3 @@
>      QA output created by 285
>     +seek sanity check failed!

This test case is used to test seek data/hole feature.  After 3.8 ext4
has supported it.  But it will fail without extents feature because
indirect-based file haven't unwritten extent.  Please check 285.full
file, and you will see that test07 fails.

BTW, I am trying to fix this problem for xfstests.

Regards,
						- Zheng

> 
> 
> BEGIN TEST: Ext4 4k block w/ no journal Thu Feb 21 17:24:38 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 074 075 076 077
>  079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130
>  131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214
>  215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243
>  245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 285
>  289 294
> Failures: 125 274
> END TEST: Ext4 4k block w/ no journal Thu Feb 21 19:57:53 EST 2013
> 
> BEGIN TEST: Ext4 1k block Thu Feb 21 19:58:29 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277
>  280 285 289 294
> Failures: 089 125 274
> END TEST: Ext4 1k block Thu Feb 21 21:37:34 EST 2013
> 
> Xfstest 089 failed because the test segfaulted.  I've never seen this in many
> test runs on earlier kernel versions, and was unable to reproduce it in 10
> trials on 3.8.
> 
> 
> BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Thu Feb 21 21:37:41 EST
> 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277
>  280 285 289 294
> Failures: 125 223 274
> END TEST: Ext4 4k block w/nodelalloc and no flex_bg Thu Feb 21 23:15:59 EST 2013
> 
> BEGIN TEST: Ext4 4k block w/metadata_csum Thu Feb 21 23:16:07 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277
>  280 285 289 294
> Failures: 125 274
> END TEST: Ext4 4k block w/metadata_csum Fri Feb 22 00:54:18 EST 2013
> 
> Xfstest 127 resulted in a few instances of this in the kernel log:
> 
> kernel: [39512.460052] EXT4-fs (sda3): ext4_da_update_reserve_space: ino 1133, allocated 1 with only 0 reserved metadata blocks
> kernel: [39512.460052] 
> kernel: [39512.460052] ------------[ cut here ]------------
> kernel: [39512.464935] WARNING: at fs/ext4/inode.c:362 ext4_da_update_reserve_space+0x214/0x280()
> kernel: [39512.473266] Modules linked in:
> kernel: [39512.476562] [<c0016d18>] (unwind_backtrace+0x0/0x104) from [<c059f448>] (dump_stack+0x20/0x24)
> kernel: [39512.485656] [<c059f448>] (dump_stack+0x20/0x24) from [<c0037c68>] (warn_slowpath_common+0x5c/0x74)
> kernel: [39512.495117] [<c0037c68>] (warn_slowpath_common+0x5c/0x74) from [<c0037cac>] (warn_slowpath_null+0x2c/0x34)
> kernel: [39512.505279] [<c0037cac>] (warn_slowpath_null+0x2c/0x34) from [<c01affd8>] (ext4_da_update_reserve_space+0x214/0x280)
> kernel: [39512.516418] [<c01affd8>] (ext4_da_update_reserve_space+0x214/0x280) from [<c01dd660>] (ext4_ext_map_blocks+0xe64/0x153c)
> kernel: [39512.527862] [<c01dd660>] (ext4_ext_map_blocks+0xe64/0x153c) from [<c01b0108>] (ext4_map_blocks+0xc4/0x230)
> kernel: [39512.538024] [<c01b0108>] (ext4_map_blocks+0xc4/0x230) from [<c01b4750>] (mpage_da_map_and_submit+0xa0/0x598)
> kernel: [39512.548370] [<c01b4750>] (mpage_da_map_and_submit+0xa0/0x598) from [<c01b512c>] (write_cache_pages_da+0x3fc/0x428)
> kernel: [39512.559265] [<c01b512c>] (write_cache_pages_da+0x3fc/0x428) from [<c01b5404>] (ext4_da_writepages+0x2ac/0x564)
> kernel: [39512.569793] [<c01b5404>] (ext4_da_writepages+0x2ac/0x564) from [<c00e3880>] (do_writepages+0x34/0x48)
> kernel: [39512.579498] [<c00e3880>] (do_writepages+0x34/0x48) from [<c00d9b18>] (__filemap_fdatawrite_range+0x5c/0x64)
> kernel: [39512.589752] [<c00d9b18>] (__filemap_fdatawrite_range+0x5c/0x64) from [<c00d9c44>] (filemap_write_and_wait_range+0x50/0x7c)
> kernel: [39512.601379] [<c00d9c44>] (filemap_write_and_wait_range+0x50/0x7c) from [<c01ab224>] (ext4_sync_file+0x80/0x354)
> kernel: [39512.611999] [<c01ab224>] (ext4_sync_file+0x80/0x354) from [<c0144ee0>] (vfs_fsync+0x4c/0x5c)
> kernel: [39512.620880] [<c0144ee0>] (vfs_fsync+0x4c/0x5c) from [<c01056f8>] (sys_msync+0x158/0x1d0)
> kernel: [39512.629425] [<c01056f8>] (sys_msync+0x158/0x1d0) from [<c000e3c0>] (ret_fast_syscall+0x0/0x3c)
> kernel: [39512.638488] ---[ end trace fd1fce56cb4aa3a9 ]---
> 
> 
> BEGIN TEST: Ext4 4k block w/dioread_nolock Fri Feb 22 00:54:19 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277
>  280 285 289 294
> Failures: 125 233 274
> END TEST: Ext4 4k block w/dioread_nolock Fri Feb 22 03:30:26 EST 2013
> 
> Xfstest 113 produced a lockdep warning previously reported in my 3.8-rc6 results and explained by Jan Kara.
> 
> Xfstest 272 resulted in a few instances of this in the kernel log:
> kernel: [51945.172241] WARNING: at fs/ext4/extents.c:4540 ext4_convert_unwritten_extents+0x11c/0x198()
> kernel: [51945.181030] Modules linked in:
> kernel: [51945.184265] [<c0016d18>] (unwind_backtrace+0x0/0x104) from [<c059f448>] (dump_stack+0x20/0x24)
> kernel: [51945.193359] [<c059f448>] (dump_stack+0x20/0x24) from [<c0037c68>] (warn_slowpath_common+0x5c/0x74)
> kernel: [51945.202850] [<c0037c68>] (warn_slowpath_common+0x5c/0x74) from [<c0037cac>] (warn_slowpath_null+0x2c/0x34)
> kernel: [51945.213012] [<c0037cac>] (warn_slowpath_null+0x2c/0x34) from [<c01de664>] (ext4_convert_unwritten_extents+0x11c/0x198)
> kernel: [51945.224304] [<c01de664>] (ext4_convert_unwritten_extents+0x11c/0x198) from [<c01b64f0>] (ext4_do_flush_completed_IO+0x1a4/0x2fc)
> kernel: [51945.236450] [<c01b64f0>] (ext4_do_flush_completed_IO+0x1a4/0x2fc) from [<c01b6668>] (ext4_end_io_work+0x20/0x24)
> kernel: [51945.247131] [<c01b6668>] (ext4_end_io_work+0x20/0x24) from [<c00562c4>] (process_one_work+0x1cc/0x58c)
> kernel: [51945.256927] [<c00562c4>] (process_one_work+0x1cc/0x58c) from [<c0056a18>] (worker_thread+0x17c/0x464)
> kernel: [51945.266601] [<c0056a18>] (worker_thread+0x17c/0x464) from [<c005bce0>] (kthread+0xb4/0xc0)
> kernel: [51945.275299] [<c005bce0>] (kthread+0xb4/0xc0) from [<c000e470>] (ret_from_fork+0x14/0x20)
> kernel: [51945.283813] ---[ end trace fd1fce56cb4aa3ab ]---
> kernel: [51945.288665] EXT4-fs (sda2): ext4_convert_unwritten_extents:4544: inode #16: block 10492: len 7: ext4_ext_map_blocks returned -28
> kernel: [51945.300842] EXT4-fs (sda2): failed to convert unwritten extents to written extents -- potential data loss!  (inode 16, offset 42876928, size 126976, error -28)
> 
> BEGIN TEST: Ext4 4k block w/data=journal Fri Feb 22 03:30:59 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277
>  280 285 289 294
> Failures: 125 223 274
> END TEST: Ext4 4k block w/data=journal Fri Feb 22 06:30:44 EST 2013
> 
> Xfstest 224 resulted in this in the kernel log:
> 
> kernel: [59876.623382] JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 238813). There's a risk of filesystem corruption in case of system crash.
> 
> 
> BEGIN TEST: Ext4 4k block w/bigalloc Fri Feb 22 11:55:11 EST 2013
>     +_check_generic_filesystem: filesystem on /dev/sda2 is inconsistent (see
> 077.full)
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076
>  077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129
>  130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213
>  214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240
>  243 245 246 247 248 249 257 258 263 269 270 271 272 273 274 275 277 280 285
>  289 294
> Failures: 015 077 125 204 219 233 235 273 274 275
> END TEST: Ext4 4k block w/bigalloc Fri Feb 22 13:21:17 EST 2013
> 
> There are numerous kernel messages in the syslog triggered by various tests
> in addition to these failures, but given that work is in progress to address
> some of these I'm going to omit the voluminous details for now.
> 
> Also, 015 hung twice and 275 hung once while attempting to get a clean
> bigalloc run.  The 015 hang was the same as previously reported for 3.8-rc6.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

