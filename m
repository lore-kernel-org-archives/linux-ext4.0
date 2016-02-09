From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Latent undefined behaviour in fs/ext4/mballoc.c (seen in
 v4.5-rc3)
Date: Tue, 9 Feb 2016 11:04:05 +0000
Message-ID: <20160209110404.GA19840@leverpostej>
References: <20160208144543.GA12536@leverpostej>
 <212F046F-A69E-4C8E-9EDF-A27EB744B26B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	aryabinin@virtuozzo.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <212F046F-A69E-4C8E-9EDF-A27EB744B26B@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 08, 2016 at 01:56:00PM -0700, Andreas Dilger wrote:
> On Feb 8, 2016, at 7:45 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > Hi,
> > 
> > While trying UBSAN on arm64, I hit a couple of splats at boot in the
> > ext4 mballoc code [1] (duplicated below), on v4.5-rc3. In both cases a
> > dynamically-computed shift amount underflows before it is applied,
> > leading to a too-large shift in one case and a negative shift in the
> > other.
> > 
> > The code in question seems largely unchanged since 2008 judging by git
> > blame, and I didn't spot any relevant changes in linux-next today
> > (next-20160208), so I assume I'm the first to report this.
> 
> Are you running with an uncommon configuration (e.g. 64KB PAGE_SIZE or
> blocksize > 8192)?  That might trigger problems in this code.

Most unusual is CONFIG_UBSAN_SANITIZE_ALL, which is what detected the
problem. As far as I can tell, the issue exists regardless. I'm using
GCC 5.1; I don't know if older GCCs had the relevant sanitizer checks.

I have 4KB pages, 4KB block size, 512B physical block size (judging by
blockdev --getbsd and blockdev --getpbsz).

Hopefully the (fat-trimmed) context below makes the issue clearer,
unless I've misunderstood something?

> > [    3.804750] ================================================================================
> > [    3.813176] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:2612:15
> > [    3.819431] shift exponent 4294967295 is too large for 32-bit type 'int'

> > Which corresponds to the following loop:
> > 
> > 2606         i = 1;
> > 2607         offset = 0;
> > 2608         max = sb->s_blocksize << 2;
> > 2609         do {
> > 2610                 sbi->s_mb_offsets[i] = offset;
> > 2611                 sbi->s_mb_maxs[i] = max;
> > 2612                 offset += 1 << (sb->s_blocksize_bits - i);
> > 2613                 max = max >> 1;
> > 2614                 i++;
> > 2615         } while (i <= sb->s_blocksize_bits + 1);
> > 
> > The loop condition permits an iteration where i == sb->s_blocksize_bits + 1, as
> > sb->s_blocksize_bits is an unsigned char and i is an unsigned, the result is an
> > unsigned underflow value (4294967295). This leads us to try to left shift 1 by
> > an insanely large value.

The second case below is less clear cut, as I'm not sure if the early
return is intended to protect us.

> > [    5.574596] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:11
> > [    5.580851] shift exponent -1 is negative

> > Which corresponds to:
> > 
> > 1259 static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
> > 1260 {
> > 1261         int order = 1;
> > 1262         void *bb;
> > 1263
> > 1264         BUG_ON(e4b->bd_bitmap == e4b->bd_buddy);
> > 1265         BUG_ON(block >= (1 << (e4b->bd_blkbits + 3)));
> > 1266
> > 1267         bb = e4b->bd_buddy;
> > 1268         while (order <= e4b->bd_blkbits + 1) {
> > 1269                 block = block >> 1;
> > 1270                 if (!mb_test_bit(block, bb)) {
> > 1271                         /* this block is part of buddy of order 'order' */
> > 1272                         return order;
> > 1273                 }
> > 1274                 bb += 1 << (e4b->bd_blkbits - order);
> > 1275                 order++;
> > 1276         }
> > 1277         return 0;
> > 1278 }
> > 
> > We allow an iteration when order == e4b->bd_blkbits + 1 and so we calculate a
> > shift amount of -1.
> > 
> > Any idea of what should be done in these cases?
> > 
> > Thanks,
> > Mark.
> > 
> > [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/405825.html
> 
> Cheers, Andreas

Thanks,
Mark.
