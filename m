Return-Path: <SRS0=ORgn=PU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:60824 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfALJcb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 12 Jan 2019 04:32:31 -0500
Subject: Re: [PATCH] jbd2: set freed flag while revoking a buffer which
 belongs to older transaction
To: Eryu Guan <guaneryu@gmail.com>
References: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
 <20190112073957.GE2713@desktop>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <jack@suse.cz>, <miaoxie@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <6604f73f-15f8-688d-a361-19503ffa9cf0@huawei.com>
Date: Sat, 12 Jan 2019 17:32:21 +0800
MIME-Version: 1.0
In-Reply-To: <20190112073957.GE2713@desktop>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2019/1/12 15:39, Eryu Guan Wrote:
> On Thu, Jan 10, 2019 at 02:12:02PM +0800, zhangyi (F) wrote:
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
>> block by some other files, it may corrupt the file data when writing
>> cached pages later, such as during umount time.
>>
>> This patch mark buffer as freed when it already belongs to the
>> committing transaction in jbd2_journal_forget(), so that commit code
>> knows it should clear dirty bits when it is done with the buffer.
>>
>> This problem can be reproduced by xfstests generic/455 easily with
>> seeds (3246 3247 3248 3249).
> 
> Would you please capture the fsx ops sequences that could reproduce the
> problem and replay it in a targeted regression test, like what
> generic/{499,511} do? Thanks!
> 

Yes, I will do it. But this problem is timing dependent, so I am afraid
this targeted regression test cannot always reproduce it (not even
generic/455 with above seeds).

BTW, we only test and capture this problem on ext4, I am not sure other
file systems have the same problem or not. So better to categorize this
test to tests/ext4 group?

Thanks,
Yi.
