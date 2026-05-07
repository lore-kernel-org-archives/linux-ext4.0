Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA5E39A7F4
	for <linux-ext4@vger.kernel.org>; Thu,  7 May 2026 08:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778143873; cv=none; b=kL9kRMdv0r+Vlv8BAoubR1ZpsLjq6eRxI4jwqeVC7y9UMcoikGG4tu2jV4tdSlecHL8yaKSJ0ekCiueAkRJUfCsF1DhxHIknaSsvhCqJxg291FXpeyUzkhFppRLwJu25udiG3YdlIHUdsNrQUutlp8bNbwFDaHT40lQamjsM720=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778143873; c=relaxed/simple;
	bh=cAQVoJnAydtUKtF74BY44/TuVaeWsQEy7/X29KzESCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkuGDpxXUemJgiyd95FEr87aCe0jk3AKlaFUhEDN876mzbRVsZPEyc2qjyt4+TwMBCD3vQBV6IC7Dm/HFgOWKtO0aA18OUiDkQPPrFEjOAlFnjWkFZZaPusGD4GPJG4924PO/NgICdG9jObFLWHykFbyi36YBkba1v2vXftGSis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Z2PC4KZM; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Z2PC4KZM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778143862; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=I70Fq5k37lefnnORP2ItWeeCvMsO6kgyDskbsVCv5Uo=;
	b=Z2PC4KZM1SVhTnRNYc7BSV4ZWYcPoc5g+vTyzM35lPXPZFBh3ATc4CU3smSgbXihv8Czflo6Y2wvBemWc8awrzUK+IA1d+YW0y0ErWKkr9/WP5xjDjbsawl6Lc2CUj2dyV9UR3FZkb0e9pK2LUut7QNei83Pts+3IRq+tMF3hxA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X2TxetP_1778143860;
Received: from 30.221.147.97(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2TxetP_1778143860 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 May 2026 16:51:01 +0800
Message-ID: <65ebc7df-3172-4995-afbc-bb9771b169c1@linux.alibaba.com>
Date: Thu, 7 May 2026 16:51:00 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: enable mballoc kunit tests for blocksize >
 PAGE_SIZE
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <20260506075900.3649944-1-libaokun@linux.alibaba.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260506075900.3649944-1-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Please ignore this patch.

During review, Sashiko noticed a potential out-of-bounds write when
CONFIG_TRANSPARENT_HUGEPAGE is disabled.

This has been fixed in v2 by adding a CONFIG_TRANSPARENT_HUGEPAGE check:

v2:
https://patch.msgid.link/20260507083754.1646636-1-libaokun@linux.alibaba.com


Regards,
Baokun

在 2026/5/6 15:59, Baokun Li 写道:
> With Large Block Size (LBS) support, ext4 can now use block sizes larger
> than PAGE_SIZE. The mballoc kunit tests previously skipped three test
> cases (test_mb_mark_used, test_mb_free_blocks, test_mb_mark_used_cost)
> under this configuration because the buddy cache inode's folio mapping
> order was never initialized in the test harness.
>
> The real mount path configures s_min_folio_order and s_max_folio_order
> in ext4_fill_super(), which allows ext4_set_inode_mapping_order() to
> set up the correct folio order for the buddy cache inode. The kunit
> test bypasses ext4_fill_super(), so the mapping order stayed at zero
> and __filemap_get_folio() allocated order-0 folios too small for LBS.
>
> Initialize s_min_folio_order and s_max_folio_order in mbt_init_sb_layout()
> to mirror ext4_fill_super() behavior, enabling properly sized folio
> allocations and removing the three blocksize > PAGE_SIZE skips.
>
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> ---
>  fs/ext4/mballoc-test.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index 90ed505fa4b1..04bc9f773d63 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -206,6 +206,8 @@ static void mbt_init_sb_layout(struct super_block *sb,
>  	sbi->s_desc_per_block_bits =
>  		sb->s_blocksize_bits - (fls(layout->desc_size) - 1);
>  	sbi->s_desc_per_block = 1 << sbi->s_desc_per_block_bits;
> +	sbi->s_min_folio_order = get_order(sb->s_blocksize);
> +	sbi->s_max_folio_order = sbi->s_min_folio_order;
>  
>  	es->s_first_data_block = cpu_to_le32(0);
>  	es->s_blocks_count_lo = cpu_to_le32(layout->blocks_per_group *
> @@ -791,10 +793,6 @@ static void test_mb_mark_used(struct kunit *test)
>  	struct test_range ranges[TEST_RANGE_COUNT];
>  	int i;
>  
> -	/* buddy cache assumes that each page contains at least one block */
> -	if (sb->s_blocksize > PAGE_SIZE)
> -		kunit_skip(test, "blocksize exceeds pagesize");
> -
>  	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
>  	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
> @@ -858,10 +856,6 @@ static void test_mb_free_blocks(struct kunit *test)
>  	int i;
>  	struct test_range ranges[TEST_RANGE_COUNT];
>  
> -	/* buddy cache assumes that each page contains at least one block */
> -	if (sb->s_blocksize > PAGE_SIZE)
> -		kunit_skip(test, "blocksize exceeds pagesize");
> -
>  	bitmap = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bitmap);
>  	buddy = kunit_kzalloc(test, sb->s_blocksize, GFP_KERNEL);
> @@ -905,10 +899,6 @@ static void test_mb_mark_used_cost(struct kunit *test)
>  	int i, j;
>  	unsigned long start, end, all = 0;
>  
> -	/* buddy cache assumes that each page contains at least one block */
> -	if (sb->s_blocksize > PAGE_SIZE)
> -		kunit_skip(test, "blocksize exceeds pagesize");
> -
>  	ret = ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
>  	KUNIT_ASSERT_EQ(test, ret, 0);
>  


