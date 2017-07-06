From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH v2 1/2] ext4, project: expand inode extra size if
 possible
Date: Thu, 6 Jul 2017 07:32:52 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEFCA597E74@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <20170704074210.77918-1-wshilong@ddn.com>
 <987151C3-9E9D-4ACD-84BB-B9DC33C08822@dilger.ca>,<768966ae-93fc-e648-5604-505a6a7c8e25@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, "Li Xi" <lixi@ddn.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Shuichi Ihara <sihara@ddn.com>
To: "miaoxie@huawei.com" <miaoxie@huawei.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:16098 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbdGFHcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Jul 2017 03:32:54 -0400
In-Reply-To: <768966ae-93fc-e648-5604-505a6a7c8e25@huawei.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


________________________________________
From: Miao Xie [miaoxie@huawei.com]
Sent: Thursday, July 06, 2017 11:51
To: Andreas Dilger; Wang Shilong
Cc: linux-ext4; Theodore Ts'o; Li Xi; zhangyi (F); Wang Shilong; Shuichi Ihara
Subject: Re: [PATCH v2 1/2] ext4, project: expand inode extra size if possible

Sorry, I reply late.

on 2017/7/6 at 0:31, Andreas Dilger wrote:
>>
>> +    if (need_expand) {
>> +            err = ext4_expand_extra_isize(inode,
>> +                                  EXT4_SB(sb)->s_want_extra_isize,
>> +                                  iloc, handle);
>> +            if (err)
>> +                    goto out_stop;
>> +    }
>> +

I found ext4_expand_extra_isize just tried to expand extra isize,
it would give up and return 0 if someone was holding attr lock.
so though it return 0, extra isize may not be expanded successfully.

---->yup, you are right, good point.

So ...

How about the following patches?

---->patches looks good for me, thanks for better fix and cleanup.

Thanks,
Shilong
