From: Li Zefan <lizefan@huawei.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Thu, 6 Dec 2012 09:17:34 +0800
Message-ID: <50BFF22E.6070502@huawei.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com> <50BE16EC.6060501@tao.ma> <50BF25E9.3090807@huawei.com> <50BF53E7.7010307@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<wuqixuan@huawei.com>, <wuqixuan@gmail.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:58202 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2LFBRt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 20:17:49 -0500
In-Reply-To: <50BF53E7.7010307@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012/12/5 22:02, Tao Ma wrote:
> On 12/05/2012 06:46 PM, Li Zefan wrote:
>>>>>> We highly doubt it's hardware failures with this frequency in mind, so
>>>>>> we're wondering regarding to this issue if there's some ext3 bug-fix
>>>>>> having merged into mainline but not in our old kernel?
>>>>>
>>>>> Absolutely there are.  There have been 87 changes just to namei.c since 2.6.16.
>>>>> You could look through git logs to see if anything looks applicable.
>>>>>
>>>>> You might try:
>>>>>
>>>>> ef2b02d3e617cb0400eedf2668f86215e1b0e6af ext34: ensure do_split leaves enough free space in both blocks
>>>>
>>>> I've been asked to investigate this issue. Thanks for the reply!
>>>>
>>>> I found this fix while searching for similar bug reports, but I don't think it
>>>> worths trying as we don't use dir_index feature.
>>>>
>>>> I've collected some logs in different machines, and the error was always
>>>> triggered in ext3_readdir:
>>>>
>>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
>>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9650541: rec_len is smaller than minimal - offset=3960, inode=0, rec_len=0, name_len=0
>>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #11124783: rec_len is smaller than minimal - offset=4072, inode=0, rec_len=0, name_len=0
>>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
>>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
>>>>
>>>> The last two errors happened on the same machine, and the same inode! One
>>>> happened in 11/22 (I was told they had run fsck later on), and one in 12/01.
>>> So now this directory has been fscked to be right? You can try by just
>>
>> right.
>>
>>> ls this directory and check whether there are any errors in dmesg.
>>>
>>
>> no error at all.
> OK, so now it is fixed by e2fsck. hmm, is there any stress inode

I'm inclined to believe the on-disk dir didn't get corrupted, and so fsck
found no errors.

> creation/deletion in this dir? 2.6.16 is too older although I am not
> sure whether this is a bug or not.

I don't think there're frequent file create/delete/rename ops in the log dir.

