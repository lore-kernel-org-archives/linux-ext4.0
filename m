From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix ext4_bmap to flush the data to the disk with
	delalloc
Date: Wed, 18 Jun 2008 15:26:25 -0700
Message-ID: <1213827985.27507.98.camel@BVR-FS.beaverton.ibm.com>
References: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37580 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYFRW0A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2008 18:26:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5IMPwao011528
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 18:25:58 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5IMPvRB176434
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 16:25:57 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5IMPreo013686
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 16:25:57 -0600
In-Reply-To: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-06-18 at 23:22 +0530, Aneesh Kumar K.V wrote:
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
> +

I would use filemap_write_and_wait(), it is essentially the same as
above two functions, but with a little extra checking.

Mingming
>  	if (EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
>  		/*
>  		 * This is a REALLY heavyweight approach, but the use of

