From: Ying Han <yinghan@google.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Thu, 2 Apr 2009 17:13:13 -0700
Message-ID: <604427e00904021713j8b8101dk1cd5154790790193@mail.gmail.com>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <20090324173511.GJ23439@duck.suse.cz>
	 <604427e00904011536i6332a239pe21786cc4c8b3025@mail.gmail.com>
	 <200904022224.31060.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, "Martin J. Bligh" <mbligh@mbligh.org>,
	linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
	Alex Khesin <alexk@google.com>,
	Mike Waychison <mikew@google.com>,
	Rohit Seth <rohitseth@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:46344 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbZDCANT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 20:13:19 -0400
In-Reply-To: <200904022224.31060.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 2, 2009 at 4:24 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 02 April 2009 09:36:13 Ying Han wrote:
>> Hi Jan:
>>     I feel that the problem you saw is kind of differnt than mine. As
>> you mentioned that you saw the PageError() message, which i don't see
>> it on my system. I tried you patch(based on 2.6.21) on my system and
>> it runs ok for 2 days, Still, since i don't see the same error message
>> as you saw, i am not convineced this is the root cause at least for
>> our problem. I am still looking into it.
>>     So, are you seeing the PageError() every time the problem happened?
>
> So I asked if you could test with my workaround of taking truncate_mutex
> at the start of ext2_get_blocks, and report back. I never heard of any
> response after that.

I applied the change and still get the same issue, unless i didn't do
the right thing, here
is the patch i applied, which put the truncate_mutex at the beginning
of ext2_get_blocks.

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 384fc0d..94cf773 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -586,10 +586,13 @@ static int ext2_get_blocks(struct inode *inode,
 	int count = 0;
 	ext2_fsblk_t first_block = 0;

+	mutex_lock(&ei->truncate_mutex);
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);

-	if (depth == 0)
+	if (depth == 0) {
+		mutex_unlock(&ei->truncate_mutex);
 		return (err);
+	}
 reread:
 	partial = ext2_get_branch(inode, depth, offsets, chain, &err);

@@ -625,7 +628,7 @@ reread:
 	if (!create || err == -EIO)
 		goto cleanup;

-	mutex_lock(&ei->truncate_mutex);

 	/*
 	 * Okay, we need to do block allocation.  Lazily initialize the block
@@ -651,7 +654,7 @@ reread:
 				offsets + (partial - chain), partial);

 	if (err) {
-		mutex_unlock(&ei->truncate_mutex);
 		goto cleanup;
 	}

@@ -662,13 +665,13 @@ reread:
 		err = ext2_clear_xip_target (inode,
 			le32_to_cpu(chain[depth-1].key));
 		if (err) {
-			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
 		}
 	}

 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
-	mutex_unlock(&ei->truncate_mutex);
 	set_buffer_new(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
@@ -678,6 +681,7 @@ got_it:
 	/* Clean up and exit */
 	partial = chain + depth - 1;	/* the whole chain */
 cleanup:
+	mutex_unlock(&ei->truncate_mutex);
 	while (partial > chain) {
 		brelse(partial->bh);
 		partial--;

--Ying

>
> To reiterate: I was able to reproduce a problem with ext2 (I was testing
> on brd to get IO rates high enough to reproduce it quite frequently).
> I think I narrowed the problem down to block allocation or inode block
> tree corruption because I was unable to reproduce it with that hack in
> place.
>
>
