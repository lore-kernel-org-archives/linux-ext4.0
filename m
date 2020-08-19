Return-Path: <SRS0=5xRJ=B5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF86C433DF
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 02:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D12F72075E
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 02:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHSCDH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:03:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49106 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726469AbgHSCDH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Aug 2020 22:03:07 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9C69371AAA2A73DE009C;
        Wed, 19 Aug 2020 10:03:05 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.226) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 10:02:57 +0800
Subject: Re: [PATCH] jbd2: remove useless variable chksum_seen in do_one_pass
To:     "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <linfeilong@huawei.com>
References: <20200811022128.32690-1-luoshijie1@huawei.com>
 <20200818104826.GA1902@quack2.suse.cz> <20200818191459.GC162457@mit.edu>
From:   Shijie Luo <luoshijie1@huawei.com>
Message-ID: <d4c6a1f4-e270-e803-d5a4-a9aa004ed33a@huawei.com>
Date:   Wed, 19 Aug 2020 10:02:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200818191459.GC162457@mit.edu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.179.226]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi, Ted. Thanks for your reply, I think this one is perfect.

On 2020/8/19 3:14, Theodore Y. Ts'o wrote:
> I wonder if this is even cleaner?  What do folks think?
>
>    	    	    	 - Ted
>
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index 2ed278f0dced..4373abbfd19a 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -690,14 +690,11 @@ static int do_one_pass(journal_t *journal,
>   			 * number. */
>   			if (pass == PASS_SCAN &&
>   			    jbd2_has_feature_checksum(journal)) {
> -				int chksum_err, chksum_seen;
>   				struct commit_header *cbh =
>   					(struct commit_header *)bh->b_data;
>   				unsigned found_chksum =
>   					be32_to_cpu(cbh->h_chksum[0]);
>   
> -				chksum_err = chksum_seen = 0;
> -
>   				if (info->end_transaction) {
>   					journal->j_failed_commit =
>   						info->end_transaction;
> @@ -705,42 +702,23 @@ static int do_one_pass(journal_t *journal,
>   					break;
>   				}
>   
> -				if (crc32_sum == found_chksum &&
> -				    cbh->h_chksum_type == JBD2_CRC32_CHKSUM &&
> -				    cbh->h_chksum_size ==
> -						JBD2_CRC32_CHKSUM_SIZE)
> -				       chksum_seen = 1;
> -				else if (!(cbh->h_chksum_type == 0 &&
> -					     cbh->h_chksum_size == 0 &&
> -					     found_chksum == 0 &&
> -					     !chksum_seen))
> -				/*
> -				 * If fs is mounted using an old kernel and then
> -				 * kernel with journal_chksum is used then we
> -				 * get a situation where the journal flag has
> -				 * checksum flag set but checksums are not
> -				 * present i.e chksum = 0, in the individual
> -				 * commit blocks.
> -				 * Hence to avoid checksum failures, in this
> -				 * situation, this extra check is added.
> -				 */
> -						chksum_err = 1;
> -
> -				if (chksum_err) {
> -					info->end_transaction = next_commit_ID;
> -
> -					if (!jbd2_has_feature_async_commit(journal)) {
> -						journal->j_failed_commit =
> -							next_commit_ID;
> -						brelse(bh);
> -						break;
> -					}
> -				}
> +                                /* Neither checksum match nor unused? */
> +				if (!((crc32_sum == found_chksum &&
> +				       cbh->h_chksum_type ==
> +						JBD2_CRC32_CHKSUM &&
> +				       cbh->h_chksum_size ==
> +						JBD2_CRC32_CHKSUM_SIZE) ||
> +				      (cbh->h_chksum_type == 0 &&
> +				       cbh->h_chksum_size == 0 &&
> +				       found_chksum == 0)))
> +					goto chksum_error;
> +
>   				crc32_sum = ~0;
>   			}
>   			if (pass == PASS_SCAN &&
>   			    !jbd2_commit_block_csum_verify(journal,
>   							   bh->b_data)) {
> +			chksum_error:
>   				info->end_transaction = next_commit_ID;
>   
>   				if (!jbd2_has_feature_async_commit(journal)) {
>
> .
>

