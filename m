From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Fri, 8 Feb 2013 11:55:47 +0800
Message-ID: <20130208035547.GA19703@gmail.com>
References: <20130207220536.GA16092@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:33401 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434Ab3BHDlY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 22:41:24 -0500
Received: by mail-da0-f51.google.com with SMTP id n15so1546327dad.24
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 19:41:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130207220536.GA16092@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

Thanks for sharing this.  The result is the same as my result on a x86
with a SSD.  Further, for 'Ext4 4k block w/dioread_nolock' and
'Ext4 4k block' cases I run all of xfstests' test cases, and the result
are the same and looks like the following:

Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075
076 077 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127
128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210
211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235
236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271
272 273 274 275 277 280 285 286 289 294
Not run: 003 004 008 009 010 012 016 017 018 019 021 022 023 024 025 026
027 028 029 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044
045 046 047 048 049 050 051 052 054 055 056 057 058 059 060 061 063 064
065 066 067 071 072 073 078 080 081 082 084 085 086 087 090 092 093 094
095 096 097 098 099 101 102 103 104 106 107 108 109 110 111 114 115 116
118 119 121 122 134 136 137 138 139 140 142 143 144 145 146 147 148 149
150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167
168 170 171 172 173 174 175 176 177 178 179 180 181 182 183 185 186 187
188 189 190 191 194 195 196 197 199 200 201 202 203 205 206 216 217 218
220 222 227 229 238 241 242 244 250 251 252 253 254 259 260 261 262 264
265 266 267 268 276 278 279 281 282 283 284 287 288 290 291 292 293 295
296
Failures: 274
Failed 1 of 99 tests

274      [failed, exit status 1] - output mismatch (see 274.out.bad)
    --- 274.out 2013-02-07 22:56:14.000000000 +0800
    +++ 274.out.bad     2013-02-08 11:47:12.000000000 +0800
    @@ -2,4 +2,5 @@
     ------------------------------
     preallocation test
     ------------------------------
    -done
    +failed to fill test file
    +(see 274.full for details)
     ...
     (Run 'diff -u 274.out 274.out.bad' to see the entire diff)

FWIW, I wonder whether we could give a report after every kernel is
released.  The report contains the result of xfstests and it could tell
us which test case is failed.  Then we can know whether the later patch
breaks something or not.

Regards,
                                                - Zheng

On Thu, Feb 07, 2013 at 05:05:36PM -0500, Eric Whitney wrote:
> These are the results of a run of Ted Ts'o's xfstests-bld test harness against
> ext4 on a Pandaboard ES running a 3.8-rc6 kernel.  The harness contains
> several test suites exercising various combinations of ext4 mount options.
> Each segment of the text below describes the mount options used in each
> scenario (although not noted, the block_validity option was also used in all
> cases), a list of xfstests run, and notes discussing any failures reported by 
> the suite or found in the syslog.
> 
> Code built from the tips of the e2fsprogs and xfstests master branches was
> used for this testing rather than that found in the xfstests-bld tree.
> 
> With one exception noted below, the test results taken on the Pandaboard (ARM
> processor) are the same as those observed from a run on an x86-64 KVM guest.
> 
> Thanks,
> Eric
> 
> 
> BEGIN TEST: Ext4 4k block Fri Feb  1 13:08:25 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Passed all 69 tests
> END TEST: Ext4 4k block Fri Feb  1 14:07:45 EST 2013
> 
> 
> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Feb  1
>  14:08:14 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 215 219 221 225 230 235 236 237 240 245 246 247 248 249 257
>  258 263 271 277 289 294
> Passed all 62 tests
> END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Feb  1 
>  14:38:05 EST 2013
> 
> 
> BEGIN TEST: Ext4 4k block w/ no journal Fri Feb  1 14:38:10 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Passed all 69 tests
> END TEST: Ext4 4k block w/ no journal Fri Feb  1 15:33:29 EST 2013
> 
> 
> BEGIN TEST: Ext4 1k block Fri Feb  1 15:33:52 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Passed all 69 tests
> END TEST: Ext4 1k block Fri Feb  1 16:05:38 EST 2013
> 
> 
> BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Fri Feb  1 16:05:45 EST
>  2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Failures: 223
> END TEST: Ext4 4k block w/nodelalloc and no flex_bg Fri Feb  1 16:36:47 EST
>  2013
> 
> Notes:
> 
> 1) This is a sample of the 223 failure output (also seen on x86-64);  the
> complete test log contains numerous additional mismatches of the same sort:
> 
> 223 54s ...	[15:33:09] [15:34:11] - output mismatch (see 223.out.bad)
>     --- 223.out	2012-12-23 14:52:52.897392805 -0500
>     +++ 223.out.bad	2013-02-06 15:34:11.750303000 -0500
>     @@ -204,47 +204,47 @@
>      SCRATCH_MNT/file-1-131072-falloc: well-aligned
>      SCRATCH_MNT/file-1-131072-write: well-aligned
>      SCRATCH_MNT/file-2-131072-falloc: well-aligned
>     -SCRATCH_MNT/file-2-131072-write: well-aligned
>     +SCRATCH_MNT/file-2-131072-write: Start block 33296 not multiple of sunit 32
>      SCRATCH_MNT/file-3-131072-falloc: well-aligned
>      SCRATCH_MNT/file-3-131072-write: well-aligned
>      ...
> 
> 
> BEGIN TEST: Ext4 4k block w/metadata_csum Fri Feb  1 16:36:54 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Passed all 69 tests
> END TEST: Ext4 4k block w/metadata_csum Fri Feb  1 17:09:01 EST 2013
> 
> 
> BEGIN TEST: Ext4 4k block w/dioread_nolock Fri Feb  1 17:09:01 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Passed all 69 tests
> END TEST: Ext4 4k block w/dioread_nolock Fri Feb  1 18:05:12 EST 2013
> 
> Notes:
> 
> 1) 113 produces lockdep warnings on 3.8-rc6 that I've only seen on the
> Pandaboard so far (this is the only testing anomaly on -rc6 that appears to be
> unique to it).  I've seen them on both the Pandaboard and x86-64 in past -rc's,
> and the signature has varied over time with different rc's.  The lockdep
> warning is lengthy, so I've placed it at the end of this report.
> 
> 
> BEGIN TEST: Ext4 4k block w/data=journal Fri Feb  1 18:05:32 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 255 256 257 258 263 271 277 289 294
> Failures: 223
> END TEST: Ext4 4k block w/data=journal Fri Feb  1 19:01:44 EST 2013
> 
> Notes:
> 
> 1) The following message appears in the syslog when xfstest 246 is run (also
> seen on x86-64):
> 
> JBD2: Spotted dirty metadata buffer (dev = sda1, blocknr = 160256). There's a
> risk of filesystem corruption in case of system crash.
> 
> 2) This is a sample of the 223 failure output (also seen on x86-64);  the
> complete test log contains numerous additional mismatches of the same sort:
> 223 61s ...	[15:48:55] [15:50:18] - output mismatch (see 223.out.bad)
>     --- 223.out	2012-12-23 14:52:52.897392805 -0500
>     +++ 223.out.bad	2013-02-06 15:50:18.437803000 -0500
>     @@ -204,45 +204,45 @@
>      SCRATCH_MNT/file-1-131072-falloc: well-aligned
>      SCRATCH_MNT/file-1-131072-write: well-aligned
>      SCRATCH_MNT/file-2-131072-falloc: well-aligned
>     -SCRATCH_MNT/file-2-131072-write: well-aligned
>     +SCRATCH_MNT/file-2-131072-write: Start block 33296 not multiple of sunit 32
>      SCRATCH_MNT/file-3-131072-falloc: well-aligned
>      SCRATCH_MNT/file-3-131072-write: well-aligned
>      ...
> 
> 
> BEGIN TEST: Ext4 4k block w/bigalloc Fri Feb  1 19:02:10 EST 2013
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088
>  091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198
>  207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245
>  246 247 248 249 257 258 263 271 277 289 294
> Failures: 015 219 235
> END TEST: Ext4 4k block w/bigalloc Fri Feb  1 19:21:22 EST 2013
> 
> Notes:
> 
> 1) This is all of the 015 failure output (also seen on x86-64):
> 
> 015 6s ...	[17:23:07] [17:23:12] - output mismatch (see 015.out.bad)
>     --- 015.out	2012-12-23 14:52:52.530205305 -0500
>     +++ 015.out.bad	2013-02-06 17:23:12.390928000 -0500
>     @@ -4,4 +4,5 @@
>      check free space:
>      delete fill:
>      check free space:
>     -   !!! free space is in range
>     +   !!! free space has value of 0
>     +free space is NOT in range 43655.04 .. 44536.96
>      ...
> 
> Multiple bursts of messages similar to this sample appear in the syslog when
> 015 is run:
> 
> EXT4-fs (sda2): delayed block allocation failed for inode 12 at logical offset 11056 with max blocks 2048 with error -28
> EXT4-fs (sda2): This should not happen!! Data will be lost
> EXT4-fs (sda2): Total free blocks count 0
> EXT4-fs (sda2): Free/Dirty block details
> EXT4-fs (sda2): free_blocks=0
> EXT4-fs (sda2): dirty_blocks=42992
> EXT4-fs (sda2): Block reservation details
> EXT4-fs (sda2): i_reserved_data_blocks=998
> EXT4-fs (sda2): i_reserved_meta_blocks=1689
> EXT4-fs (sda2): delayed block allocation failed for inode 12 at logical offset 13105 with max blocks 2048 with error -28
> EXT4-fs (sda2): This should not happen!! Data will be lost
> 
> Occasionally (maybe 20% of the time), 015 will lead to a stall where the test
> makes no further forward progress.  This happens at the end of the test when
> a file used to consume available free space on the filesystem is deleted.
> The rm is left in the D state, a flusher thread continues to run and
> accumulate time, and I/O is continuously written to the storage device at a
> slow rate.
> 
> 
> 2) This is all of the 219 failure output (also seen on x86-64):
> 
> --- 219.out	2013-02-01 12:46:06.672838718 -0500
> +++ 219.out.bad	2013-02-07 12:36:14.734678000 -0500
> @@ -16,7 +16,7 @@
>    Size: 49152        Filetype: Regular File
>    File: "SCRATCH_MNT/mmap"
>    Size: 49152        Filetype: Regular File
> -Usage OK (type=u)
> +Too many blocks used (type=u)
>  
>  ### test group accounting
>  
> @@ -34,4 +34,4 @@
>    Size: 49152        Filetype: Regular File
>    File: "SCRATCH_MNT/mmap"
>    Size: 49152        Filetype: Regular File
> -Usage OK (type=g)
> +Too many blocks used (type=g)
> 
> 
> 3) This is all of the 235 failure output (also seen on x86-64):
> 
> --- 235.out	2012-12-23 14:52:52.905205305 -0500
> +++ 235.out.bad	2013-02-07 12:40:53.750303000 -0500
> @@ -21,7 +21,7 @@
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     --       8       0       0              1     0     0       
> +fsgqa     --      64       0       0              1     0     0       
>  
>  
>  *** Report for group quotas on device SCRATCH_DEV
> @@ -29,6 +29,6 @@
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     --       8       0       0              1     0     0       
> +fsgqa     --      64       0       0              1     0     0       
> 
> 
> 4) When 225 is run, one or more instances of the following warning will be
> posted to the syslog (also on x86-64):
> 
> WARNING: at fs/ext4/inode.c:362 ext4_da_update_reserve_space+0x214/0x280()
> Modules linked in:
> [<c0016d18>] (unwind_backtrace+0x0/0x104) from [<c059e450>] (dump_stack+0x20/0x24)
> [<c059e450>] (dump_stack+0x20/0x24) from [<c0037c68>] (warn_slowpath_common+0x5c/0x74)
> [<c0037c68>] (warn_slowpath_common+0x5c/0x74) from [<c0037cac>] (warn_slowpath_null+0x2c/0x34)
> [<c0037cac>] (warn_slowpath_null+0x2c/0x34) from [<c01af4f4>] (ext4_da_update_reserve_space+0x214/0x280)
> [<c01af4f4>] (ext4_da_update_reserve_space+0x214/0x280) from [<c01dc928>] (ext4_ext_map_blocks+0xc10/0x153c)
> [<c01dc928>] (ext4_ext_map_blocks+0xc10/0x153c) from [<c01af624>] (ext4_map_blocks+0xc4/0x230)
> [<c01af624>] (ext4_map_blocks+0xc4/0x230) from [<c01b3c6c>] (mpage_da_map_and_submit+0xa0/0x598)
> [<c01b3c6c>] (mpage_da_map_and_submit+0xa0/0x598) from [<c01b494c>] (ext4_da_writepages+0x2d8/0x564)
> [<c01b494c>] (ext4_da_writepages+0x2d8/0x564) from [<c00e38cc>] (do_writepages+0x34/0x48)
> [<c00e38cc>] (do_writepages+0x34/0x48) from [<c00d9b64>] (__filemap_fdatawrite_range+0x5c/0x64)
> [<c00d9b64>] (__filemap_fdatawrite_range+0x5c/0x64) from [<c00d9ba4>] (filemap_fdatawrite+0x38/0x40)
> [<c00d9ba4>] (filemap_fdatawrite+0x38/0x40) from [<c00d9bdc>] (filemap_write_and_wait+0x30/0x54)
> [<c00d9bdc>] (filemap_write_and_wait+0x30/0x54) from [<c0128864>] (do_vfs_ioctl+0x498/0x5d8)
> [<c0128864>] (do_vfs_ioctl+0x498/0x5d8) from [<c0128a18>] (sys_ioctl+0x74/0x94)
> [<c0128a18>] (sys_ioctl+0x74/0x94) from [<c000e3c0>] (ret_fast_syscall+0x0/0x3c)
> 
> 
> 
> Here's the lockdep report for xfstest 113 run in the dioread_nolock scenario
> as mentioned above (the taint is due to an unrelated warning from the clk
> subsystem believed to be unique to 3.8 on Pandaboards/OMAP):
> 
> [ INFO: possible circular locking dependency detected ]
> 3.8.0-rc6 #1 Tainted: G        W   
> -------------------------------------------------------
> aio-stress/8597 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<c00f1928>] get_user_pages_fast+0x48/0x88
> 
> but task is already holding lock:
>  (&ei->i_data_sem){++++.+}, at: [<c01ae2a8>] ext4_direct_IO+0x3d4/0x450
>  
> which lock already depends on the new lock.
>  
>  
> the existing dependency chain (in reverse order) is:
>  
> -> #1 (&ei->i_data_sem){++++.+}:
>        [<c008c190>] __lock_acquire+0x162c/0x1b04
>        [<c008cb70>] lock_acquire+0x9c/0x114
>        [<c05a4f78>] down_read+0x40/0x50
>        [<c01af6dc>] ext4_map_blocks+0x17c/0x230
>        [<c01b1b6c>] _ext4_get_block+0x84/0x164
>        [<c01b1d2c>] ext4_get_block+0x34/0x3c
>        [<c0153bfc>] do_mpage_readpage+0x4d8/0x754
>        [<c0153f50>] mpage_readpages+0xd8/0x134
>        [<c01aedf4>] ext4_readpages+0x4c/0x54
>        [<c00e3cbc>] __do_page_cache_readahead+0x1e8/0x2b0
>        [<c00e408c>] ra_submit+0x38/0x40
>        [<c00db0d4>] filemap_fault+0x3b4/0x490
>        [<c00fb220>] __do_fault+0x78/0x4a8
>        [<c00fe36c>] handle_pte_fault+0x80/0x6f8
>        [<c00fea8c>] handle_mm_fault+0xa8/0xd8
>        [<c05a91bc>] do_page_fault+0x294/0x3b4
>        [<c05a9384>] do_translation_fault+0xa8/0xb0
>        [<c00083f4>] do_DataAbort+0x44/0xa8
>        [<c05a751c>] __dabt_svc+0x3c/0x60
>        [<c02d17c0>] __clear_user_std+0x34/0x64
>  
> -> #0 (&mm->mmap_sem){++++++}:
>        [<c059fa20>] print_circular_bug+0x78/0x2c8
>        [<c008c59c>] __lock_acquire+0x1a38/0x1b04
>        [<c008cb70>] lock_acquire+0x9c/0x114
>        [<c05a4f78>] down_read+0x40/0x50
>        [<c00f1928>] get_user_pages_fast+0x48/0x88
>        [<c0151110>] __blockdev_direct_IO+0x1be4/0x3840
>        [<c01ae1ac>] ext4_direct_IO+0x2d8/0x450
>        [<c00d9db0>] generic_file_direct_write+0xf4/0x20c
>        [<c00da23c>] __generic_file_aio_write+0x374/0x454
>        [<c01aa49c>] ext4_file_write+0x2ac/0x4d0
>        [<c015cf18>] aio_rw_vect_retry+0x78/0x1ac
>        [<c015d858>] aio_run_iocb+0x64/0x14c
>        [<c015ed10>] do_io_submit+0x574/0x8ec
>        [<c015f0a4>] sys_io_submit+0x1c/0x20
>        [<c000e3c0>] ret_fast_syscall+0x0/0x3c
>  
> other info that might help us debug this:
>  
>  Possible unsafe locking scenario:
>  
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ei->i_data_sem);
>                                lock(&mm->mmap_sem);
>                                lock(&ei->i_data_sem);
>   lock(&mm->mmap_sem);
>  
>  *** DEADLOCK ***
>  
> 1 lock held by aio-stress/8597:
>  #0:  (&ei->i_data_sem){++++.+}, at: [<c01ae2a8>] ext4_direct_IO+0x3d4/0x450
>  
> stack backtrace:
> [<c0016d18>] (unwind_backtrace+0x0/0x104) from [<c059e450>] (dump_stack+0x20/0x24)
> [<c059e450>] (dump_stack+0x20/0x24) from [<c059fc24>] (print_circular_bug+0x27c/0x2c8)
> [<c059fc24>] (print_circular_bug+0x27c/0x2c8) from [<c008c59c>] (__lock_acquire+0x1a38/0x1b04)
> [<c008c59c>] (__lock_acquire+0x1a38/0x1b04) from [<c008cb70>] (lock_acquire+0x9c/0x114)
> [<c008cb70>] (lock_acquire+0x9c/0x114) from [<c05a4f78>] (down_read+0x40/0x50)
> [<c05a4f78>] (down_read+0x40/0x50) from [<c00f1928>] (get_user_pages_fast+0x48/0x88)
> [<c00f1928>] (get_user_pages_fast+0x48/0x88) from [<c0151110>] (__blockdev_direct_IO+0x1be4/0x3840)
> [<c0151110>] (__blockdev_direct_IO+0x1be4/0x3840) from [<c01ae1ac>] (ext4_direct_IO+0x2d8/0x450)
> [<c01ae1ac>] (ext4_direct_IO+0x2d8/0x450) from [<c00d9db0>] (generic_file_direct_write+0xf4/0x20c)
> [<c00d9db0>] (generic_file_direct_write+0xf4/0x20c) from [<c00da23c>] (__generic_file_aio_write+0x374/0x454)
> [<c00da23c>] (__generic_file_aio_write+0x374/0x454) from [<c01aa49c>] (ext4_file_write+0x2ac/0x4d0)
> [<c01aa49c>] (ext4_file_write+0x2ac/0x4d0) from [<c015cf18>] (aio_rw_vect_retry+0x78/0x1ac)
> [<c015cf18>] (aio_rw_vect_retry+0x78/0x1ac) from [<c015d858>] (aio_run_iocb+0x64/0x14c)
> [<c015d858>] (aio_run_iocb+0x64/0x14c) from [<c015ed10>] (do_io_submit+0x574/0x8ec)
> [<c015ed10>] (do_io_submit+0x574/0x8ec) from [<c015f0a4>] (sys_io_submit+0x1c/0x20)
> [<c015f0a4>] (sys_io_submit+0x1c/0x20) from [<c000e3c0>] (ret_fast_syscall+0x0/0x3c)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
