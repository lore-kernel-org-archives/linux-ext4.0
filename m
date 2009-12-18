From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Fri, 18 Dec 2009 17:19:46 +0530
Message-ID: <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46949 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZLRLtw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 06:49:52 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id nBIMnojW008619
	for <linux-ext4@vger.kernel.org>; Sat, 19 Dec 2009 09:49:50 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBIBnoMb1765628
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 22:49:51 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBIBnodo025719
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 22:49:50 +1100
Content-Disposition: inline
In-Reply-To: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2009 at 09:28:28AM -0800, Curt Wohlgemuth wrote:
> This fixes a bug in which new blocks returned from an extent created with
> ext4_ext_zeroout() can have dirty metadata still associated with them.
> 
> 	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
> 
> This is for the problem I reported on 23 Nov ("Bug in extent zeroout: blocks
> not marked as new").  I'm not seeing the corruption with this fix that I was
> seeing without it.
> 
> diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
> --- orig/fs/ext4/extents.c	2009-12-09 15:09:25.000000000 -0800
> +++ new/fs/ext4/extents.c	2009-12-09 15:09:37.000000000 -0800
> @@ -2474,9 +2474,21 @@ static int ext4_ext_zeroout(struct inode
>  		submit_bio(WRITE, bio);
>  		wait_for_completion(&event);
> 
> -		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> +		/* On success, we need to insure all metadata associated
> +		 * with each of these blocks is unmapped. */
> +		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
> +			sector_t block = ee_pblock;
> +
>  			ret = 0;
> -		else {
> +			done = 0;
> +			while (done < len) {
> +				unmap_underlying_metadata(inode->i_sb->s_bdev,
> +							  block);
> +
> +				done++;
> +				block++;
> +			}
> +		} else {
>  			ret = -EIO;
>  			break;
>  		}

a) We are zeroing out 'done' blocks but you are unmapping 'len' blocks ?
b) We are already doing a unmap in mpage_da_map_blocks so i guess
   what you want is to unmap the extra block allocated
c) ee_pblock is in 512 byte units so the block number is wrong.

how about the patch below ?

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3a7928f..f9a735f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3023,6 +3023,14 @@ out:
 	return err;
 }
 
+static void unmap_underlying_metadata_blocks(struct block_device *bdev,
+			sector_t block, int count)
+{
+	int i;
+	for (i = 0; i < count; i++)
+                unmap_underlying_metadata(bdev, block + i);
+}
+
 static int
 ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock, unsigned int max_blocks,
@@ -3098,6 +3106,18 @@ out:
 	} else
 		allocated = ret;
 	set_buffer_new(bh_result);
+	/*
+	 * if we allocated more blocks than requested
+	 * we need to make sure we unmap the extra block
+	 * allocated. The actual needed block will get
+	 * unmapped later when we find the buffer_head marked
+	 * new.
+	 */
+	if (allocated > max_blocks) {
+		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
+					newblock + max_blocks,
+					allocated - max_blocks);
+	}
 map_out:
 	set_buffer_mapped(bh_result);
 out1:


