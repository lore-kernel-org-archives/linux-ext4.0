Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A37405C20;
	Sun, 17 May 2026 04:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778991549; cv=none; b=scil4BvBr7M1UkE7EBkeYqoFI7jRrqJJj4hyXKeZLLJQFxLgRo9dHOQukr05Ygmi634wtkGTfwp7WSSyIbP7f2/6waUiBs21aWk3beMhgXmGmVhcrHug/fB6Bm+bWDtsBYm4fGvKC3glL+VCOz8J/VDGq1TFGpi16nMrdw47jf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778991549; c=relaxed/simple;
	bh=PKiX7TvV5FDEd/JOe6jxczPE3hpoLrn2zUTSjwTY/sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OT1VmCI6f5af8lLJORvAbtduditG68FNG9Re1g5DDKsf1GrvsZmEvvYHZ3VDVK7ZEIEtQTeQCqMVW0ZzePJgZB1O3/Ts3Jbuj445RvB8f6rCO4HnnlkwcO0cqIUPwwbvYx4FAvmCYLYOZi3HKAn74lrG04xVHrRhP0i06TJBTLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UkRM6+sg; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UkRM6+sg"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778991535; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OSqeOOUOQ+VkyTH+cZdlWetnvyhe0cxE+rJFx9fBDbM=;
	b=UkRM6+sgqNNCpJyRB9CF6S188edA79G+tvJSVIiXVC5HlhdEvoGosDUo49OcH3P1FevFbfe/kTGBb7LErvpqmYIcO5hDWjOUyHjZQlkpaqK7I+gg6fzJHCfzKc8OgvO5MCwiI0GbDVd6sEUnvrVJCY708eQEbIivkHUc5aXivbU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X311wvF_1778991534;
Received: from 30.170.87.193(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X311wvF_1778991534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 17 May 2026 12:18:55 +0800
Message-ID: <10c17d97-e6c9-4bb7-94a8-f4ed8fcad910@linux.alibaba.com>
Date: Sun, 17 May 2026 12:18:53 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/17] lib/crc: add crc32c_flip_range() for
 incremental CRC update
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-crypto@vger.kernel.org,
 ardb@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
 <20260508121539.4174601-2-libaokun@linux.alibaba.com>
 <20260514035248.GA2816@sol>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260514035248.GA2816@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Eric,
Thanks for the feedback!


在 2026/5/14 11:52, Eric Biggers 写道:
> On Fri, May 08, 2026 at 08:15:23PM +0800, Baokun Li wrote:
>> When a contiguous range of bits in a buffer is flipped, the CRC32c
>> checksum can be updated incrementally without re-scanning the entire
>> buffer, by exploiting the linearity of CRCs over GF(2):
>>
>>   New_CRC = Old_CRC ^ CRC(flip_mask << trailing_bits)
>>
>> Introduce crc32c_flip_range() which computes this delta using
>> precomputed GF(2) shift matrices and nibble-indexed lookup tables.
>> The implementation decomposes nbits and trailing_bits into
>> power-of-2 components and combines them via the CRC concatenation
>> property:
>>
>>   CRC(A || B) = shift(CRC(A), len(B)) ^ CRC(B)
>>
>> This gives O(log N) complexity with only ~9.8KB of static tables
>> (fits in L1 cache).  The current maximum supported buffer size is
>> 64KB (INCR_MAX_ORDER = 19, i.e. 2^19 bits = 524288 bits = 64KB).
> It will be a little while before I can do a full review of this, but
> just a high-level comment: "only ~9.8KB of static tables (fits in L1
> cache)" isn't ideal.  Large tables tend to microbenchmark well, then
> have worse real-world performance due to lots of other things contending
> for the L1 cache.


You're right, and that's exactly the trap I fell into when picking
the initial size.  I went with the variant that had the best kunit
microbenchmark while still fitting in a typical L1 -- the
nibble-indexed (4-bit) tables.  I've now re-measured all three
candidate table sizes:

=== crc32c_flip_range benchmark (ns, speedup vs full) ===
bitmap  full  1bit(2.5KB)  2bit(4.9KB)  4bit(9.8KB)
1024      46   165 (0.3x)    82 (0.6x)    48 (1.0x)
2048      88   180 (0.5x)    88 (1.0x)    53 (1.7x)
4096     181   194 (0.9x)    98 (1.8x)    58 (3.1x)
8192     358   207 (1.7x)   104 (3.4x)    63 (5.7x)
16384    707   222 (3.2x)   112 (6.3x)   68 (10.4x)
32768   1424   234 (6.1x)  121 (11.8x)   73 (19.5x)
65536   2846  248 (11.5x)  129 (22.1x)   79 (36.0x)

One thing worth mentioning: the upcoming crc32c_splice() API reuses
the same GF(2) shift tables for byte-granular CRC updates (extent
blocks, dir blocks, etc.).  It's being posted as a separate series
because the ext4 integration is more involved, but roughly:

  u32 crc32c_splice(const void *buf, u32 buflen, u32 old_crc,
                    u32 old_region_crc, u32 offset, u32 len)
  {
      u32 new_region_crc, delta, trail_bits;

      [...]
      new_region_crc = crc32c(0, (const u8 *)buf + offset, len);
      delta = old_region_crc ^ new_region_crc;

      if (!delta)
          return old_crc;

      trail_bits = (buflen - offset - len) * 8;
      delta = gf2_shift_crc(delta, trail_bits);

      return old_crc ^ delta;
  }

The splice kunit numbers, for completeness:

=== crc32c_splice benchmark (ns, speedup vs full) ===
blk_regio  full  splice(1bit)  splice(2bit)  splice(4bit)
1024_12      46      8 (5.8x)      9 (5.1x)      9 (5.1x)
1024_32      46     15 (3.1x)     14 (3.3x)     15 (3.1x)
1024_64      46     20 (2.3x)     19 (2.4x)     20 (2.3x)
1024_128     46     30 (1.5x)     31 (1.5x)     30 (1.5x)
1024_264     46     53 (0.9x)     53 (0.9x)     53 (0.9x)
                         
2048_12      88     8 (11.0x)     8 (11.0x)     8 (11.0x)
2048_32      88     15 (5.9x)     13 (6.8x)     15 (5.9x)
2048_64      89     20 (4.5x)     20 (4.5x)     20 (4.5x)
2048_128     89     31 (2.9x)     30 (3.0x)     30 (3.0x)
2048_264     88     53 (1.7x)     53 (1.7x)     53 (1.7x)
                         
4096_12     181     9 (20.1x)     7 (25.9x)     9 (20.1x)
4096_32     181    14 (12.9x)    15 (12.1x)    15 (12.1x)
4096_64     181     20 (9.1x)     20 (9.1x)     19 (9.5x)
4096_128    181     31 (5.8x)     31 (5.8x)     30 (6.0x)
4096_264    182     54 (3.4x)     53 (3.4x)     54 (3.4x)
                         
8192_12     358     9 (39.8x)     8 (44.8x)    10 (35.8x)
8192_32     358    15 (23.9x)    15 (23.9x)    15 (23.9x)
8192_64     358    21 (17.0x)    20 (17.9x)    21 (17.0x)
8192_128    358    32 (11.2x)    31 (11.5x)    31 (11.5x)
8192_264    358     54 (6.6x)     53 (6.8x)     53 (6.8x)
                         
16384_12    707    10 (70.7x)     8 (88.4x)     8 (88.4x)
16384_32    706    15 (47.1x)    15 (47.1x)    15 (47.1x)
16384_64    706    21 (33.6x)    19 (37.2x)    19 (37.2x)
16384_128   707    30 (23.6x)    31 (22.8x)    30 (23.6x)
16384_264   707    54 (13.1x)    53 (13.3x)    53 (13.3x)
                         
32768_12   1422   10 (142.2x)    9 (158.0x)    9 (158.0x)
32768_32   1422    15 (94.8x)    15 (94.8x)    15 (94.8x)
32768_64   1422    20 (71.1x)    19 (74.8x)    20 (71.1x)
32768_128  1422    31 (45.9x)    31 (45.9x)    31 (45.9x)
32768_264  1422    53 (26.8x)    53 (26.8x)    54 (26.3x)
                         
65536_12   2841   10 (284.1x)    9 (315.7x)    8 (355.1x)
65536_32   2840   14 (202.9x)   15 (189.3x)   14 (202.9x)
65536_64   2840   21 (135.2x)   19 (149.5x)   20 (142.0x)
65536_128  2845    30 (94.8x)    31 (91.8x)    31 (91.8x)
65536_264  2841    53 (53.6x)    53 (53.6x)    53 (53.6x)

But, as you point out, what really matters is the real-world impact
once the tables are competing for L1 with everything else.  I tested
all three table sizes on an ext4 fio workload (single-process
sequential fallocate of 64K extents) across a range of filesystem
block sizes.  Results below, with both +flip_range alone and
+flip_range+splice applied:

=== default mkfs, single-process (GB/s) ===
config  base  raw-bit-flip  raw-bit-splice   2-bit-flip  2-bit-splice 
 4-bit-flip  4-bit-splice
S_1k    15.4   15.3(-0.6%)     15.3(-0.6%)  15.1(-1.9%)   15.8(+2.6%) 
15.0(-2.6%)   15.5(+0.6%)
S_2k    17.6   17.7(+0.6%)     17.9(+1.7%)  17.6(+0.0%)   18.3(+4.0%) 
17.2(-2.3%)   18.6(+5.7%)
S_4k    16.9   17.0(+0.6%)    18.6(+10.1%)  17.4(+3.0%)   18.4(+8.9%) 
17.3(+2.4%)  18.7(+10.7%)
S_8k    15.8   16.3(+3.2%)    18.1(+14.6%)  16.6(+5.1%)  18.3(+15.8%) 
16.4(+3.8%)  17.8(+12.7%)
S_16k   12.5   13.1(+4.8%)    15.4(+23.2%)  13.0(+4.0%)  15.5(+24.0%) 
12.9(+3.2%)  15.6(+24.8%)
S_32k   8.93   9.37(+4.9%)    12.5(+40.0%)  9.10(+1.9%)  13.1(+46.7%) 
9.07(+1.6%)  12.5(+40.0%)
S_64k   8.17   8.43(+3.2%)    14.3(+75.0%)  8.64(+5.8%)  14.6(+78.7%) 
8.39(+2.7%)  14.8(+81.2%)

So the larger tables do measure a bit faster, but the gain over 2-bit
is about 3% while the .rodata footprint doubles.  All three variants
land within run-to-run noise on the real workload, which matches your
prediction exactly.

Based on this I'd lean toward the 2-bit (4.9 KB) variant for v2 as
the better trade-off.  Would you prefer that, or the smaller 1-bit
(2.5 KB) version?  The ext4 numbers say either is fine; 2-bit just
keeps a little more headroom on the microbench in case other
consumers show up later.


> Another consideration is that basically every Linux kernel has
> CONFIG_CRC32 enabled, regardless of whether they would actually find
> this new functionality useful.

Agreed.  As large-block hardware becomes more common I expect other
filesystems beyond ext4 to hit the same large-buffer CRC overhead, so
I deliberately put this in lib/crc as a general-purpose API rather
than burying it inside ext4.  But you're right that it shouldn't be
unconditionally compiled in.  For v2 I'll add CONFIG_CRC32_INCR,
selected by consumers (initially just ext4), so kernels that don't
need it pay zero .text/.rodata cost.

> I'm not necessarily saying this should be its own option, especially if
> it's useful for ext4 even in the non-LBS case.  But I do think it would
> be nice if it could be a bit smaller and more memory-optimized.

The non-LBS case does see some benefit, but it's modest -- the
incremental update mostly matters once group-descriptor-size CRCs
become large.  The good news is that the regression on small-block
configs is essentially zero (see the S_1k / S_2k rows above), so I
left it unconditionally enabled in the current series to keep things
simple.

If there's concern about that, I'm happy to either gate it on a
sysfs/mount-option knob, or restrict it to LBS-only paths in ext4.

>
> Anyway, I'll look into the algorithm more when I have time.
>
Thanks again for taking the time on this -- the current series is
still rough around the edges and I'd appreciate any further feedback
once you get to a deeper review.


Cheers,
Baokun

