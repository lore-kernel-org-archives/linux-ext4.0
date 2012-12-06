From: Li Zefan <lizefan@huawei.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Thu, 6 Dec 2012 09:13:45 +0800
Message-ID: <50BFF149.6080007@huawei.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com> <20121204150928.GF29083@thunk.org> <50BF2537.6070809@huawei.com> <50BF597D.3040704@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<wuqixuan@huawei.com>, <wuqixuan@gmail.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:56811 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2LFBOH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 20:14:07 -0500
In-Reply-To: <50BF597D.3040704@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> I found this in one log:
>>
>> Nov 14 05:26:55 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
>> Nov 14 13:42:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
>> Nov 16 17:29:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
>> Nov 23 19:42:44 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
>>
>> Happend 4 times, the same inode, different offsets. Another log showed the
>> same pattern.
>>
>> They said they ran fsck everytime this happened. Many machines got this problem,
>> but they remember most of the time fsck didn't report error.(*)
>>
>> I've checked the pathname, and they all points to log dirs. There're 2 kinds
>> of log dirs with different loggers, but seems work similarly.
>>
>> Except one bug report, all others point to exactly the same log dir.
>>
>> There're two processes that will touch this dir. One is a monitor, it will
>> delete old logs if they occupy too much space, but normally this shouldn't
>> happen.
>>
>> Another is the logger. When it wants to log sth, it scans the directory, if
>> there're more than 100 log files, it will delete the oldest one. After writting
>> to the current log file, if the file is larger than 8M, this file will be
>> renamed as a backup log. I haven't read the code yet. But sounds pretty
>> simple, right?
>>
>> The length of the file name is 25. There were 35 logs dating from 2012/11/02
>> to 2012/11/23, and no pending deleted files. Thus the remaining ~2.8K of the
>> dir block is never used, so I don't think something zeroed it because it
>> has always been zero.
> Only 35 files? So there should be no rename. And the only possible

Yes, there can be. The curren log will be renamed when it reaches 8M, and then
a new log is created as the current log.

> action we do to this dir is "create a new log file", right? Then, I
> really don't think ext3 will error in such a simple test case. :(
> 
>>
>> This log dir is new in this version, while the other one also exists in
>> old verison, with less IO.
> You mean the kernel version? Sorry, but what do you want to tell us here?
> 

The versions of the apps. One of the differences between them is the log system,
and the old apps won't trigger this ext3 error.

