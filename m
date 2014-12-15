From: alex chen <alex.chen@huawei.com>
Subject: Re: A doubt on journal_async_commit option
Date: Mon, 15 Dec 2014 11:47:46 +0800
Message-ID: <548E59E2.3080001@huawei.com>
References: <548A8534.1050606@huawei.com> <20141212145443.GB17783@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, <linux-ext4@vger.kernel.org>,
	Joseph Qi <joseph.qi@huawei.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:50772 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLODsH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Dec 2014 22:48:07 -0500
In-Reply-To: <20141212145443.GB17783@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/12/12 22:54, Theodore Ts'o wrote:
> On Fri, Dec 12, 2014 at 02:03:32PM +0800, alex chen wrote:
>> This commit 0e3d2a6313(ext4: Fix async commit mode to be safe by using
>> a barrier) show that using journal_async_commit feature has a 50%
>> performance improvement. But I tested in SUSE Linux Enterprise Server
>> 11 SP3(linux kernel 3.0.93) and Red Hat Enterprise linux 6.4(linux
>> kernel 2.6.32), the result show this feature has no performance
>> improvement.
>> My test command:
>> mount /dev/sdb /mnt/sdb
>> ./fs_mark  -d  /mnt/sdb/  -s  10240  -n  1000
>> umount
>>
>> mount /dev/sdb /mnt/sdb -o journal_async_commit
>> ./fs_mark  -d  /mnt/sdb/  -s  10240  -n  1000
>> umount
>>
>> My test result:
>> FSUse%        Count         Size    Files/sec     App Overhead
>>      6         1000        10240         42.1            10671
>> vs.
>> -o journal_async_commit
>> FSUse%        Count         Size    Files/sec     App Overhead
>>      6         1000        10240         63.9            10625
> 
> Um, the files per second went up from 42.1 to 63.9 --- that's a 50%
> improvement, yes?
> 
> 							- Ted
Yes, I understand it. Thank you!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

