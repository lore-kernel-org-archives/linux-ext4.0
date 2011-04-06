From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Wed, 06 Apr 2011 10:00:40 -0700
Message-ID: <4D9C9C38.2070008@redhat.com>
References: <4D9A17F8.4000406@redhat.com> <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca> <4D9B45AB.8000208@redhat.com> <4D9B49A6.7000709@redhat.com> <4D9B95DE.6050408@redhat.com> <BANLkTi=wnyvf2T5KDo5NQkjLw4aTHPUz9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab1DFRAq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Apr 2011 13:00:46 -0400
In-Reply-To: <BANLkTi=wnyvf2T5KDo5NQkjLw4aTHPUz9w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/5/11 11:51 PM, Zeev Tarantov wrote:
> On Wed, Apr 6, 2011 at 01:21, Eric Sandeen <sandeen@redhat.com> wrote:
>> Zeev, if you'd like to test that patch above with your profiling, that'd be awesome.
> 
> My wall-clock timings are strange and I disregard them.
> On a desktop with X turned off and perf recording system-wide, I trust
> the profile to show everything.

Agreed, the wallclock time was just a very coarse sanity check while off at a conference :)

> In the no-stride case, I don't think you've made it any worse.

it shouldn't even go down this path so I hope not ;)

> In the stripe=stride=1, it went from:
> 
> [ perf record: Woken up 13 times to write data ]
> [ perf record: Captured and wrote 3.163 MB perf.data (~138211 samples) ]
> # Events: 14K cycles
> #
> # Overhead         Command          Shared Object
>              Symbol
> # ........  ..............  .....................
> .......................................
> #
>     13.08%            gzip  gzip                   [.] zip
>     12.65%     flush-253:0  [kernel.kallsyms]      [k] ext4_mb_scan_aligned

...

> to:
> 
> [ perf record: Woken up 12 times to write data ]
> [ perf record: Captured and wrote 3.091 MB perf.data (~135042 samples) ]
> # Events: 13K cycles
> #
> # Overhead      Command          Shared Object
>         Symbol
> # ........  ...........  .....................
> .....................................
> #
>     15.10%         gzip  gzip                   [.] zip
>     14.70%         gzip  gzip                   [.] treat_file.part.4.2264
>     11.10%  flush-253:0  [csnappy_compress]     [k] snappy_compress_fragment
>      6.12%       md5sum  md5sum                 [.] digest_file.isra.2.2089
...
>      0.23%             tar  [kernel.kallsyms]      [k] ext4_mb_scan_aligned
...

> So that's great, but I still don't want mke2fs to set a stripe and
> stride of 1, because that's silly - no code improvement in the
> allocator is ever going to be able to use that information.

I totally agree, and I'm sure the mkfs patch will go in as well.

Thanks for the verification of the kernel patch, too.

It should help a bit for sane stripe-sizes, too, with less impact as the stripe size gets bigger.

Thanks,
-Eric

>> Thanks,
>> -Eric
> 
> Thank you!
> -Z.T.

