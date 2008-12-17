From: "Kalpak Shah" <kalpak.shah@gmail.com>
Subject: Re: [PATCH 2/2] Large EAs
Date: Wed, 17 Dec 2008 11:40:02 +0530
Message-ID: <460220570812162210j784b10b4x9b8187ec1d7f0f0c@mail.gmail.com>
References: <1226954173.3972.70.camel@localhost>
	 <20081126044138.GD1410@mit.edu>
	 <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
	 <20081126065439.GA27490@mit.edu>
	 <20081126214929.GZ3186@webber.adilger.int>
	 <20081127003555.GD14101@mit.edu> <1228300707.3121.71.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Andreas Dilger" <adilger@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Mingming Cao" <cmm@us.ibm.com>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:38296 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYLQGKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 01:10:03 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3615082wfd.4
        for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2008 22:10:02 -0800 (PST)
In-Reply-To: <1228300707.3121.71.camel@localhost>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 3, 2008 at 4:08 PM, Kalpak Shah <Kalpak.Shah@sun.com> wrote:
> Since we need to make sure that inodes are not used very frequently for
> storing EAs, the following design was discussed on the ext4 concall:
>
> xattrs of size blocksize/2 < ea_size <= blocksize are stored by
> referencing the block number directly from the ext4_xattr_entry (using
> some unique combination of bits to encode that this is referencing a
> block instead of an inode, and also finding space to store 48-bit block
> numbers) and then ea_size > blocksize is referenced directly by an
> inode.
>
> During discussion Andreas suggested another idea using which we can
> avoid the need to point at blocks from the ext4_xattr_entry:
>
> Use mballoc to try and find up to 64kB of contiguous blocks to store
> smaller xattrs. Looking at the ext4_xattr_header it has an h_blocks
> field which we can use to indicate the number of blocks in a row that
> are allocated for this inode's xattrs.
>
> The ext4_xattr_entry has a 16-bit block offset that can be used to
> point anywhere within a 64kB block.  This not only allows many more
> small xattrs to be stored efficiently, but also mid-sized xattrs (<=
> blocksize) can be handled efficiently because the data will be packed
> into the single group of blocks.  It also avoids the need to reference
> block numbers from the ext4_xattr_entry directly, which is ugly.
>
> Comments?

Hi Ted,

Did you get a chance to think about this? It would be great if you can
let me know which design is more preferable to you, so I can go ahead
with the implementation. I understand that including this work in ext4
isn't a priority right now, but it would be great if we can register a
feature flag and also what all the flag will include (EA inodes, EA
entries pointing to blocks or larger no of EA blocks).

Thanks,
Kalpak

>
> Thanks,
> Kalpak
>
> On Wed, 2008-11-26 at 19:35 -0500, Theodore Tso wrote:
>> On Wed, Nov 26, 2008 at 02:49:29PM -0700, Andreas Dilger wrote:
>> >
>> > One benefit I think is that at least the orphaned EA inode can be
>> > cleaned up instead of lingering in the middle of the shared EA tree.
>> >
>> > Another benefit of having separate EAs is that it makes it tractable to
>> > modify very large EAs.  Otherwise, if there are a number of large
>> > EAs shared in a single tree they would all have to be modified in order
>> > to store a larger value for an EA in the middle of the tree.
>>
>> I guess I didn't make myself clear.  I was *not* suggesting that we
>> share EA's in one inode, or in one extent tree.  Instead, what I
>> suggested was that instead of having a pointer to an inode, if the
>> value of the EA is less than half the blocksize, it is stored in the
>> EA block.  If it is between 50% and 100% of the blocksize, instead of
>> pointing at inode, we point to a block.  If it is greater than a
>> blocksize, we point at a block containing an EA tree.  (Which means
>> for a large EA the average space overhead is 6k --- 4k for the extent
>> block, plus 2k for the fragmentation cost).
>>
>> So this scheme very much uses separate EA's, and does not pack all of
>> the EA's into a single tree.  It is deliberately kept simple precisely
>> because like you I don't think it's worth it to optimize EA's.  On the
>> other hand, running out of inodes is a big problem, and dynamic inodes
>> is far more complicated an issue, especially if we don't have 64-bit
>> inode support in the kernel and in userspace, and we need to worry
>> about locality issues and how dynamic inodes work with online
>> resizing.
>>
>> The tradeoff is that my scheme doesn't burn an inode for each large
>> EA, but for EA's greater than a blocksize, we chew an extra block's
>> worth of overhead.  Personally, I think it's a worthwhile tradeoff ---
>>
>>                                            - Ted
>
>
