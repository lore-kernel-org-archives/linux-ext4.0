From: Li Zefan <lizefan@huawei.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Wed, 5 Dec 2012 18:43:03 +0800
Message-ID: <50BF2537.6070809@huawei.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com> <20121204150928.GF29083@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<wuqixuan@huawei.com>, <wuqixuan@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:45526 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2LEKnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 05:43:45 -0500
In-Reply-To: <20121204150928.GF29083@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012/12/4 23:09, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 09:54:05PM +0800, Li Zefan wrote:
>>
>> I've collected some logs in different machines, and the error was always
>> triggered in ext3_readdir:
>>
>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9650541: rec_len is smaller than minimal - offset=3960, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #11124783: rec_len is smaller than minimal - offset=4072, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
> 
> This looks like the last part of the inode was zapped.  It might be

I don't think so. See below...

> worth adding a kernel patch which dumps out the entire directory block
> as a hex dump when this triggers --- and then compare it to what you
> get if you dump the directory back out after the machine reboot.  That
> might given you a hint if something is corrupting the directory block
> in memory.  (especially if you set the remount read-only option).
> 
>> The last two errors happened on the same machine, and the same inode! One
>> happened in 11/22 (I was told they had run fsck later on), and one in 12/01.
> 
> If it's always the same inode, you might want to correlate based on
> the pathname.  Is there any commonality accross multiple machines in
> terms of the directory name, and what application(s) might be touching
> that directory?
> 

I found this in one log:

Nov 14 05:26:55 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
Nov 14 13:42:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
Nov 16 17:29:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
Nov 23 19:42:44 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0

Happend 4 times, the same inode, different offsets. Another log showed the
same pattern.

They said they ran fsck everytime this happened. Many machines got this problem,
but they remember most of the time fsck didn't report error.(*)

I've checked the pathname, and they all points to log dirs. There're 2 kinds
of log dirs with different loggers, but seems work similarly.

Except one bug report, all others point to exactly the same log dir.

There're two processes that will touch this dir. One is a monitor, it will
delete old logs if they occupy too much space, but normally this shouldn't
happen.

Another is the logger. When it wants to log sth, it scans the directory, if
there're more than 100 log files, it will delete the oldest one. After writting
to the current log file, if the file is larger than 8M, this file will be
renamed as a backup log. I haven't read the code yet. But sounds pretty
simple, right?

The length of the file name is 25. There were 35 logs dating from 2012/11/02
to 2012/11/23, and no pending deleted files. Thus the remaining ~2.8K of the
dir block is never used, so I don't think something zeroed it because it
has always been zero.

This log dir is new in this version, while the other one also exists in
old verison, with less IO.

(*) They have machines in different spots. In another spot, 5 out of ~30
machines met this problem after upgrading, and fsck reported errors in
all of them. However there were just a few errors, and they didn't seem to
relate to the directory, which means the directory seems intact. Adding
that the fs was created nearly 1 years ago and ever fscked, those errors
might have nothing to do with this bug?

btw, the version of e2fsprogsis: e2fsck 1.38 (30-Jun-2005)

Regards
Li Zefan

