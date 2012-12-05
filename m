From: Tao Ma <tm@tao.ma>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Wed, 05 Dec 2012 22:02:15 +0800
Message-ID: <50BF53E7.7010307@tao.ma>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com> <50BE16EC.6060501@tao.ma> <50BF25E9.3090807@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, wuqixuan@gmail.com
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:53646 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750803Ab2LFANS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 19:13:18 -0500
In-Reply-To: <50BF25E9.3090807@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/05/2012 06:46 PM, Li Zefan wrote:
>>>>> We highly doubt it's hardware failures with this frequency in mind, so
>>>>> we're wondering regarding to this issue if there's some ext3 bug-fix
>>>>> having merged into mainline but not in our old kernel?
>>>>
>>>> Absolutely there are.  There have been 87 changes just to namei.c since 2.6.16.
>>>> You could look through git logs to see if anything looks applicable.
>>>>
>>>> You might try:
>>>>
>>>> ef2b02d3e617cb0400eedf2668f86215e1b0e6af ext34: ensure do_split leaves enough free space in both blocks
>>>
>>> I've been asked to investigate this issue. Thanks for the reply!
>>>
>>> I found this fix while searching for similar bug reports, but I don't think it
>>> worths trying as we don't use dir_index feature.
>>>
>>> I've collected some logs in different machines, and the error was always
>>> triggered in ext3_readdir:
>>>
>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9650541: rec_len is smaller than minimal - offset=3960, inode=0, rec_len=0, name_len=0
>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #11124783: rec_len is smaller than minimal - offset=4072, inode=0, rec_len=0, name_len=0
>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
>>> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
>>>
>>> The last two errors happened on the same machine, and the same inode! One
>>> happened in 11/22 (I was told they had run fsck later on), and one in 12/01.
>> So now this directory has been fscked to be right? You can try by just
> 
> right.
> 
>> ls this directory and check whether there are any errors in dmesg.
>>
> 
> no error at all.
OK, so now it is fixed by e2fsck. hmm, is there any stress inode
creation/deletion in this dir? 2.6.16 is too older although I am not
sure whether this is a bug or not.
> 
>> Having said that, as this error happens 2 times for the same inode,
>> maybe there is a kernel bug. At least as Ted said in another mail, the
>> end of this buffer head seems to be cleared. So I guess next time when
>> you see this error, please do:
>> 1. use debugfs to find the disk layout for this dir
>> 2. read the blocks from the block device directly
>> 3. check whether the end of a block(from offset to the end) is zeroed.
>> 4. If yes, I guess there should be a kernel bug and we can go on to
>> investigate the code.
>>
> 
> This may give us different output with that by dumping dir via debugfs?
> If so I'll try next time.
In step 2, I mean dd out these blocks, decode and read them by
yourselves to check whether there are zeroes.

Thanks
Tao
> 
> Seeing from the output dumpped via debugfs in one machine, more than
> harf of the dir block is all zero, but the offset is near 4K. I also
> checked several other machines, no difference.


Thanks
Tao

