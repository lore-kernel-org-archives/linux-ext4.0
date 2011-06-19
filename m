From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Sun, 19 Jun 2011 15:55:47 -0400
Message-ID: <BANLkTi=hYUsAejN7J_QEnvsA-jOfoTP0PA@mail.gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51523 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab1FST4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jun 2011 15:56:18 -0400
Received: by bwz15 with SMTP id 15so1787015bwz.19
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jun 2011 12:56:17 -0700 (PDT)
In-Reply-To: <4DF8522F.2020304@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/15 Kazuya Mio <k-mio@sx.jp.nec.com>:
> This patch adds get_fragment_score() to libe2p. get_fragment_score() returns
> the fragmentation score. It shows the percentage of extents whose size is
> smaller than the input argument "threshold".
>
> However, there are some cases that cannot be merged into a next extent.
> The following extents are excepted from the calculation of fragmentation score:
> - The extent whose initialize status is different from the next extent
> - There is a hole between the extent and its next extent
> - The extent is a tail
>
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---

Kazuya,

If you're are going to stick with a percentage based approach I agree
with special casing the tail of the file or the tail of each
block_group in a sparse file.

But I think you should also special case the head extent of a block_group.

More clearly, whatever special treatment that is afforded to the
tail_extent of a block_group, should also be afforded to head_extent.

Maybe something like this for sparse files:

M_total=0
N_total=0
For (each block group) {
   M = extents in block group below threshold
   N = extents in block group above threshold

   if first_extent is below threshold  {  --M; }  # don't count it as
below threshold
   if last_extent is below threshold  {  --M; }  # don't count it as
below threshold

   M_total +=M
   N_totatl += N

   block_group_fragmentation_score = M / (N+M)
}
file_fragmentation_score = M_total / (N_total + M_total)

===> overall e4defrag design feedback

e4defrag makes the decision to defrag sparse files at the full file
level last I looked and I believe it still does.

I think it should treat each non-sparse file and each block_group of a
sparse file separately as a target for defragmentation.

The patch you are submitting just embeds the "file" defragmentation
methodology further into the code.  It very much seems to me that the
e4defrag code and scoring needs to work at the block_group size at the
largest.

That is for sparse files it should "score" a block_group at a time at
most.  And then it should compare the target's block_group layout vs.
the donor files block_group layout.

Once it is decided to defragment a block_group, then I think it should
fallocate the largest available extent (that may require a kernel
patch).

If that newly allocated extent is bigger than the first extent in the
block_group, then call into the kernel to swap out the target blocks
for the donor blocks.  Then move to the next target extent and repeat.

For a large file, making the overall defrag choice at the block_group
level just seems right, but for actually replacing target extents with
donor extents, I really think that needs to be decided one extent at a
time as I describe above.

After all, what is the value taking a block group with a 100 full
extents followed by two partial extents and moving all of that data
around in order to defrag it.  Only the last 2 extents need to be
consolidated.

Using the approach I described above, the code would quickly bypass
the first 100 full extents and then just defrag the last 2 partial
extents.

Greg
