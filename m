From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix ext4_bmap to flush the data to the disk with
 delalloc
Date: Wed, 18 Jun 2008 13:03:32 -0500
Message-ID: <48594DF4.3060000@redhat.com>
References: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbYFRSXl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2008 14:23:41 -0400
In-Reply-To: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> With delalloc we don't do block allocation in the write_begin/write_end.
> So when using bmap we first need to flush data to the disk so that blocks
> get allocated and then call generic_block_bmap.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7035621..cfeb869 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1833,6 +1833,17 @@ sector_t ext4_bmap(struct address_space *mapping, sector_t block)
>  	journal_t *journal;
>  	int err;
>  
> +	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> +			test_opt(inode->i_sb, DELALLOC)) {
> +		/*
> +		 * With delalloc we want to sync the file
> +		 * so that we can make sure we allocate
> +		 * blocks for file
> +		 */
> +		filemap_fdatawrite(mapping);
> +		filemap_fdatawait(mapping);
> +	}

This seems fine.

I wonder, does it make any sense at all to only do the flushing if the
block we wish to map is actually in a delalloc state at the moment?

-Eric

> +
>  	if (EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
>  		/*
>  		 * This is a REALLY heavyweight approach, but the use of

