From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [RFC PATCH] ext4: validate number of meta clusters in group
Date: Mon, 11 Jul 2016 22:30:21 +0200
Message-ID: <578401DD.1050601@oracle.com>
References: <57766AE1.1040508@oracle.com>
 <20160702074903.GA4914@birch.djwong.org> <577EB740.10502@oracle.com>
 <20160711025153.GO26097@thunk.org> <5783EA91.30402@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5783EA91.30402@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/11/2016 08:50 PM, Vegard Nossum wrote:
> On 07/11/2016 04:51 AM, Theodore Ts'o wrote:
>> On Thu, Jul 07, 2016 at 10:10:40PM +0200, Vegard Nossum wrote:
>>>
>>> I ran into a second problem (this time it was num_clusters_in_group()
>>> returning a bogus value) with the same symptoms (random memory
>>> corruptions), the new attached patch fixes both problems by checking the
>>> values at mount time.
>>
>> Can you give me a dumpe2fs -h of a file system that is causing
>> num_clusters_in_group() to be bogus?
>>
>> I want to make sure I'm checking that correct base values, insteda of
>> doing a brute force loop over all of the block groups and calling
>> ext4_num_clusters_in_group() and ext4_num_base_meta_clusters() for all
>> block groups.
>>
>> Thanks!!
>
> It's sbi->s_es->s_reserved_gdt_blocks:

Durrr, no, it's not, I just realised you asked about
num_clusters_in_group() and not num_base_meta_clusters().

So I did the same thing for that and I tracked it down to
s_blocks_count_{lo,hi} both being 0, causing num_clusters_in_group() to
effectively return 0 - ext4_group_first_block_no(sb, block_group).

But dumpe2fs shows block count to be 16384, so I was a bit puzzled. I
set a breakpoint on s_blocks_count_lo and indeed it's being corrupted:

Hardware watchpoint 2: ((struct ext4_super_block *) 
0x61e2c400)->s_blocks_count_lo

Old value = 16384
New value = 0
0x00000000602d9d59 in memset ()
(gdb) bt
#0  0x00000000602d9d59 in memset ()
#1  0x000000006010e944 in ext4_init_block_bitmap (...) at 
fs/ext4/balloc.c:215
#2  ext4_read_block_bitmap_nowait (...) at fs/ext4/balloc.c:455

Curiously enough, that's this memset() in the same function:

         memset(bh->b_data, 0, sb->s_blocksize);

Checking with some debug printks, it indeed seems like bh->b_data points
to the struct ext4_super_block (!):

  &EXT4_SB(sb)->s_es->s_blocks_count_lo = 0000000063a3c404
  bh->b_data = 0000000063a3c400
  bh->b_size = 400

Well, you can disregard my patch for sure. I'm not sure how the bitmap
we're supposed to initialise ends up pointing to the ext4_super_block
though.


Vegard
