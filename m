From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: truncate block allocated on a failed ext3_write_begin
Date: Thu, 28 Aug 2008 12:56:28 -0500
Message-ID: <48B6E6CC.7030704@redhat.com>
References: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbYH1SOA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 14:14:00 -0400
In-Reply-To: <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> For blocksize < pagesize we need to remove blocks that
> got allocte in block_wirte_begin if we fail with ENOSPC
> for later blocks. block_write_begin internally does
> this if it allocated page locally. This make sure
> we don't have blocks outisde inode.i_size during
> ENOSPC

I think this is good; here's an easy testcase:

# dd if=/dev/zero of=fsfile bs=1k count=2048
# mkfs.ext3 -F fsfile
# mkdir mnt
# mount -o loop fsfile mnt/
# dd if=/dev/zero of=mnt/1kfile bs=1k count=1
# cd mnt/
# dd if=/dev/zero of=bigfile bs=4k
# cd ..
# umount mnt
# e2fsck -f fsfile
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 13, i_size is 974848, should be 976896.  Fix<y>?
...

can you test with that, unless you already have a testcase you've used?

Assuming it fixes it (it should) you can add:

Acked-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext3/inode.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ebfec4d..f8424ad 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1186,6 +1186,13 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
>  		ext3_journal_stop(handle);
>  		unlock_page(page);
>  		page_cache_release(page);
> +		/*
> +		 * block_write_begin may have instantiated a few blocks
> +		 * outside i_size.  Trim these off again. Don't need
> +		 * i_size_read because we hold i_mutex.
> +		 */
> +		if (pos + len > inode->i_size)
> +			vmtruncate(inode, inode->i_size);
>  	}
>  	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;

