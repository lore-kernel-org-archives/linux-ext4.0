Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFB2C282CE
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 12:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A7C20863
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 12:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbfBLMUy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:20:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbfBLMUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 07:20:54 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1E9455CDFBBEFF5AA300;
        Tue, 12 Feb 2019 20:20:51 +0800 (CST)
Received: from [127.0.0.1] (10.177.244.145) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Tue, 12 Feb 2019
 20:20:43 +0800
Subject: Re: [PATCH v4 1/4] jbd2: make sure dirty flag is cleared while
 revorking a buffer which belongs to older transaction
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
References: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
 <1548830980-29482-2-git-send-email-yi.zhang@huawei.com>
 <20190211042433.GE23000@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <bb69d5d1-662f-7653-0dfe-91e0c763c9e3@huawei.com>
Date:   Tue, 12 Feb 2019 20:20:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190211042433.GE23000@mit.edu>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.244.145]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019/2/11 12:24, Theodore Y. Ts'o Wrote:
> On Wed, Jan 30, 2019 at 02:49:37PM +0800, zhangyi (F) wrote:
>> Now, we capture a data corruption problem on ext4 while we're truncating
>> an extent index block. Imaging that if we are revoking a buffer which
>> has been journaled by the committing transaction, the buffer's jbddirty
>> flag will not be cleared in jbd2_journal_forget(), so the commit code
>> will set the buffer dirty flag again after refile the buffer.
>>
>> fsx                               kjournald2
>>                                   jbd2_journal_commit_transaction
>> jbd2_journal_revoke                commit phase 1~5...
>>  jbd2_journal_forget
>>    belongs to older transaction    commit phase 6
>>    jbddirty not clear               __jbd2_journal_refile_buffer
>>                                      __jbd2_journal_unfile_buffer
>>                                       test_clear_buffer_jbddirty
>>                                        mark_buffer_dirty
>>
>> Finally, if the freed extent index block was allocated again as data
>> block by some other files, it may corrupt the file data after writing
>> cached pages later, such as during unmount time. (In general,
>> clean_bdev_aliases() related helpers should be invoked after
>> re-allocation to prevent the above corruption, but unfortunately we
>> missed it when zeroout the head of extra extent blocks in
>> ext4_ext_handle_unwritten_extents()).
>>
>> This patch mark buffer as freed and set j_next_transaction to the new
>> transaction when it already belongs to the committing transaction in
>> jbd2_journal_forget(), so that commit code knows it should clear dirty
>> bits when it is done with the buffer.
>>
>> This problem can be reproduced by xfstests generic/455 easily with
>> seeds (3246 3247 3248 3249).
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Cc: stable@vger.kernel.org
> 
> Thanks, applied.
> 
> By the way, I wasn't able to easily reproduce the problem using the
> given seeds.  Out of curiosity, what sort test system were you using?
> (e.g., how many CPU's, how much memory, what kind of storage device,
> etc.)

Yes, I was also not able to reproduce the problem quite easily, because
it depends on block allocation logic. So in order to increase the
probability, I choice a relatively small prartition(5GB).

I reprocude this problem on a x86_64 kvm virtual machine which have 16
cores, 16GB memory and two 5GB virtio block devices(base on ssd RIAD).

Thanks,
Yi.

