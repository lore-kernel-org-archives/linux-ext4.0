From: Zeev Tarantov <zeev.tarantov@gmail.com>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Wed, 6 Apr 2011 09:51:56 +0300
Message-ID: <BANLkTi=wnyvf2T5KDo5NQkjLw4aTHPUz9w@mail.gmail.com>
References: <4D9A17F8.4000406@redhat.com> <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca>
 <4D9B45AB.8000208@redhat.com> <4D9B49A6.7000709@redhat.com> <4D9B95DE.6050408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:61087 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1DFGwR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Apr 2011 02:52:17 -0400
Received: by pxi2 with SMTP id 2so666956pxi.10
        for <linux-ext4@vger.kernel.org>; Tue, 05 Apr 2011 23:52:16 -0700 (PDT)
In-Reply-To: <4D9B95DE.6050408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 6, 2011 at 01:21, Eric Sandeen <sandeen@redhat.com> wrote:
> Zeev, if you'd like to test that patch above with your profiling, that'd be awesome.

My wall-clock timings are strange and I disregard them.
On a desktop with X turned off and perf recording system-wide, I trust
the profile to show everything.

In the no-stride case, I don't think you've made it any worse.
In the stripe=stride=1, it went from:

[ perf record: Woken up 13 times to write data ]
[ perf record: Captured and wrote 3.163 MB perf.data (~138211 samples) ]
# Events: 14K cycles
#
# Overhead         Command          Shared Object
             Symbol
# ........  ..............  .....................
.......................................
#
    13.08%            gzip  gzip                   [.] zip
    12.65%     flush-253:0  [kernel.kallsyms]      [k] ext4_mb_scan_aligned
    12.46%            gzip  gzip                   [.] treat_file.part.4.2264
     9.34%     flush-253:0  [csnappy_compress]     [k] snappy_compress_fragment
     5.47%          md5sum  md5sum                 [.] digest_file.isra.2.2089
     4.70%          md5sum  [csnappy_decompress]   [k]
snappy_decompress_noheader
     4.29%          md5sum  md5sum                 [.] 0x2fe7
     2.16%            gzip  libc-2.13.so           [.] __memcpy_ssse3
     1.79%     flush-253:0  [kernel.kallsyms]      [k] memcpy
     1.52%             tar  [kernel.kallsyms]      [k] copy_user_generic_string
     1.08%             tar  [kernel.kallsyms]      [k] _raw_spin_lock
     1.00%            gzip  [kernel.kallsyms]      [k] copy_user_generic_string
     0.87%     flush-253:0  [kernel.kallsyms]      [k] __memset
     0.58%          md5sum  md5sum                 [.] __libc_csu_init
     0.54%          md5sum  [zram]                 [k] zram_make_request
     0.50%          md5sum  [kernel.kallsyms]      [k] copy_user_generic_string
     0.45%             tar  [kernel.kallsyms]      [k] ext4_mark_iloc_dirty
     0.44%             tar  [kernel.kallsyms]      [k] __memset
     0.39%            gzip  gzip                   [.] treat_stdin.2262
     0.35%            gzip  gzip                   [.] treat_file.2267
     0.33%         swapper  [kernel.kallsyms]      [k] mwait_idle
     0.28%              dd  [kernel.kallsyms]      [k] system_call
     0.26%          md5sum  [kernel.kallsyms]      [k] memcpy
     0.25%     flush-253:0  [zram]                 [k] zram_make_request
     0.25%     flush-253:0  [kernel.kallsyms]      [k] _raw_spin_lock
     0.23%             tar  [kernel.kallsyms]      [k] ext4_mb_scan_aligned
     0.22%            gzip  gzip                   [.] compress_block.2644.2190
     0.20%             tar  [kernel.kallsyms]      [k] __find_get_block

to:

[ perf record: Woken up 12 times to write data ]
[ perf record: Captured and wrote 3.091 MB perf.data (~135042 samples) ]
# Events: 13K cycles
#
# Overhead      Command          Shared Object
        Symbol
# ........  ...........  .....................
.....................................
#
    15.10%         gzip  gzip                   [.] zip
    14.70%         gzip  gzip                   [.] treat_file.part.4.2264
    11.10%  flush-253:0  [csnappy_compress]     [k] snappy_compress_fragment
     6.12%       md5sum  md5sum                 [.] digest_file.isra.2.2089
     5.44%       md5sum  [csnappy_decompress]   [k] snappy_decompress_noheader
     5.10%       md5sum  md5sum                 [.] 0x3262
     2.42%         gzip  libc-2.13.so           [.] __memcpy_ssse3
     2.03%  flush-253:0  [kernel.kallsyms]      [k] memcpy
     1.52%          tar  [kernel.kallsyms]      [k] copy_user_generic_string
     1.13%         gzip  [kernel.kallsyms]      [k] copy_user_generic_string
     0.80%  flush-253:0  [kernel.kallsyms]      [k] __memset
     0.62%       md5sum  md5sum                 [.] __libc_csu_init
     0.60%       md5sum  [zram]                 [k] zram_make_request
     0.57%         gzip  gzip                   [.] treat_stdin.2262
     0.56%       md5sum  [kernel.kallsyms]      [k] copy_user_generic_string
     0.55%          tar  [kernel.kallsyms]      [k] __memset
     0.49%          tar  [kernel.kallsyms]      [k] ext4_mark_iloc_dirty
     0.39%       md5sum  [kernel.kallsyms]      [k] memcpy
     0.37%         gzip  gzip                   [.] treat_file.2267
     0.37%      swapper  [kernel.kallsyms]      [k] mwait_idle
     0.28%           dd  [kernel.kallsyms]      [k] system_call
     0.28%  flush-253:0  [kernel.kallsyms]      [k] _raw_spin_lock
     0.25%         gzip  gzip                   [.] compress_block.2644.2190
     0.22%  flush-253:0  [kernel.kallsyms]      [k] ext4_mark_iloc_dirty
     0.22%          tar  [kernel.kallsyms]      [k] __ext4_get_inode_loc
     0.22%          tar  [kernel.kallsyms]      [k] _raw_spin_lock
     0.21%          tar  [kernel.kallsyms]      [k] mark_page_accessed
     0.20%          tar  [kernel.kallsyms]      [k] __find_get_block
     0.20%          tar  tar                    [.] contains_dot_dot

So that's great, but I still don't want mke2fs to set a stripe and
stride of 1, because that's silly - no code improvement in the
allocator is ever going to be able to use that information.

> Thanks,
> -Eric

Thank you!
-Z.T.
