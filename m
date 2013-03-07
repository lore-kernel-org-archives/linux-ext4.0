From: Jan Kara <jack@suse.cz>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Thu, 7 Mar 2013 11:48:54 +0100
Message-ID: <20130307104854.GB6723@quack.suse.cz>
References: <51385177.9030904@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab3CGKs5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 05:48:57 -0500
Content-Disposition: inline
In-Reply-To: <51385177.9030904@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 07-03-13 17:36:07, Kazuya Mio wrote:
> I found the performance problem that ext3 direct I/O sends large number of bio
> unnecessarily when buffer_head is set BH_Boundary flag.
> 
> When we read/write a file sequentially, we will read/write not only
> the data blocks but also the indirect blocks that may not be physically
> adjacent to the data blocks. So ext3 sets BG_Boundary flag to submit
> the previous I/O before reading/writing an indirect block.
> 
> However, in the case of direct I/O, the size of buffer_head
> could be more than the blocksize. dio_send_cur_page() checks BH_Boundary flag
> and then calls submit_bio() without calling dio_bio_add_page().
> As a result, submit_bio() is called every one page and cause of high CPU usage.
  Yes, you are right that this is a bug. Thank you for reporting it!

> The following patch fixes this problem only for ext3. At least ext2/3/4
> don't need BH_Boundary flag for direct I/O because submit_bio() will be called
> when the offset of buffer_head is discontinuous about the previous one.
> 
> ---
> @@ -926,7 +926,8 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
>     set_buffer_new(bh_result);
>  got_it:
>     map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
> -   if (count > blocks_to_boundary)
> +   /* set bourdary flag for buffered I/O */
> +   if (maxblocks == 1 && count > blocks_to_boundary)
>         set_buffer_boundary(bh_result);
>     err = count;
>     /* Clean up and exit */
> ---
  But I'm afraid your fix isn't quite correct. Because as I read the code
we will accumulate the bio, then read indirect block from get_more_blocks()
and only after that we find out bio won't be contiguous so we would submit
that. But the desired sequence is like:
  * accumulate the bio
  * find out it will not be contiguous so submit it
  * get_more_blocks() - submits read

I think the proper fix should be in fs/direct-io.c:
...
-		sdio->boundary = buffer_boundary(map_bh);
+		if (sdio->blocks_available == this_chunk_blocks)
+			sdio->boundary = buffer_boundary(map_bh);
...

Then we properly mark bio should be submitted only if we are mapping last
part of the mapped extent from the filesystem. Can you give this change a
try (full patch with changelog attached)?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--mYCpIKhGyMATD0i+
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-direct-io-Fix-boundary-block-handling.patch"

>From c45bc949f7b42ed25f40869ff79664a47bd0979f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 7 Mar 2013 11:41:58 +0100
Subject: [PATCH] direct-io: Fix boundary block handling

When we read/write a file sequentially, we will read/write not only the
data blocks but also the indirect blocks that may not be physically
adjacent to the data blocks. So filesystems sets BG_Boundary flag to
submit the previous I/O before reading/writing an indirect block.

However generic direct IO code mishandles buffer_boundary() flag, sets
sdio->boundary before each submit_page_section() call which results in
sending only one page bios as underlying code thinks this page is the
last in the contiguous extent. So fix the problem by setting
sdio->boundary only if the current page is really the last one in the
mapped extent.

Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index f853263..e666854 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -969,7 +969,8 @@ do_holes:
 			this_chunk_bytes = this_chunk_blocks << blkbits;
 			BUG_ON(this_chunk_bytes == 0);
 
-			sdio->boundary = buffer_boundary(map_bh);
+			if (sdio->blocks_available == this_chunk_blocks)
+				sdio->boundary = buffer_boundary(map_bh);
 			ret = submit_page_section(dio, sdio, page,
 						  offset_in_page,
 						  this_chunk_bytes,
-- 
1.7.1


--mYCpIKhGyMATD0i+--
